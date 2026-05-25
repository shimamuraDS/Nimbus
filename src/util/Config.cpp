#include "Config.h"
#include <QCoreApplication>
#include <QDir>
#include <QFile>

namespace Util {

Config& Config::getInstance() {
    static Config instance;
    return instance;
}

Config::Config() {
    QString iniPath = QCoreApplication::applicationDirPath()
                      + QDir::separator() + "config.ini";

    // Search parent directories for config.ini (handles debug build subdirectories)
    if (!QFile::exists(iniPath)) {
        QDir dir = QCoreApplication::applicationDirPath();
        for (int i = 0; i < 5 && !QFile::exists(dir.filePath("config.ini")); ++i) {
            if (!dir.cdUp()) break;
        }
        QString found = dir.filePath("config.ini");
        if (QFile::exists(found)) {
            iniPath = found;
        }
    }

    m_iniSettings = std::make_unique<QSettings>(iniPath, QSettings::IniFormat);
    m_userSettings = std::make_unique<QSettings>();

    setAutoStart(isAutoStart());
}

QString Config::getTencentApiKey() const {
    return m_iniSettings->value("API/DeveloperKey", "").toString();
}

bool Config::isAutoLocation() const {
    return m_userSettings->value("Location/IsAuto", true).toBool();
}

void Config::setAutoLocation(bool autoLoc) {
    m_userSettings->setValue("Location/IsAuto", autoLoc);
}

int Config::getManualAdcode() const {
    return m_userSettings->value("Location/ManualAdcode", 110000).toInt();
}

void Config::setManualAdcode(int adcode) {
    m_userSettings->setValue("Location/ManualAdcode", adcode);
}

QString Config::getManualCityName() const {
    return m_userSettings->value("Location/ManualCityName", QString::fromUtf8("北京市")).toString();
}

bool Config::isAutoStart() const {
    return m_userSettings->value("General/AutoStart", true).toBool();
}

void Config::setAutoStart(bool autoStart) {
    m_userSettings->setValue("General/AutoStart", autoStart);

    QSettings reg("HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run",
                  QSettings::NativeFormat);
    if (autoStart) {
        QString appPath = QDir::toNativeSeparators(QCoreApplication::applicationFilePath());
        reg.setValue("WeatherApp", appPath);
    } else {
        reg.remove("WeatherApp");
    }
}

void Config::setManualCityName(const QString& cityName) {
    m_userSettings->setValue("Location/ManualCityName", cityName);
}

QStringList Config::getAlertTimes() const {
    return m_userSettings->value("Alerts/Times", QStringList()).toStringList();
}

void Config::setAlertTimes(const QStringList& times) {
    m_userSettings->setValue("Alerts/Times", times);
}

QStringList Config::getAlertAdvanceMinutes() const {
    return m_userSettings->value("Alerts/AdvanceMinutes", QStringList()).toStringList();
}

void Config::setAlertAdvanceMinutes(const QStringList& minutes) {
    m_userSettings->setValue("Alerts/AdvanceMinutes", minutes);
}

int Config::getAdvanceMinutesFor(const QString& alertTime) const {
    QStringList times = getAlertTimes();
    QStringList advances = getAlertAdvanceMinutes();
    int idx = times.indexOf(alertTime);
    if (idx >= 0 && idx < advances.size()) {
        return advances[idx].toInt();
    }
    return 0;
}

void Config::setAdvanceMinutesFor(const QString& alertTime, int minutes) {
    QStringList times = getAlertTimes();
    QStringList advances = getAlertAdvanceMinutes();
    int idx = times.indexOf(alertTime);
    if (idx >= 0) {
        if (advances.size() != times.size()) {
            advances.clear();
            for (int i = 0; i < times.size(); ++i) advances.append("0");
        }
        advances[idx] = QString::number(minutes);
        setAlertAdvanceMinutes(advances);
    }
}

void Config::sortAlertsTogether(QStringList& times, QStringList& advances) {
    QList<QPair<QString, QString>> pairs;
    for (int i = 0; i < times.size(); ++i) {
        pairs.append({times[i], i < advances.size() ? advances[i] : "0"});
    }
    std::sort(pairs.begin(), pairs.end(), [](const auto& a, const auto& b) {
        return a.first < b.first;
    });
    times.clear();
    advances.clear();
    for (const auto& p : pairs) {
        times.append(p.first);
        advances.append(p.second);
    }
}

void Config::addAlertTime(const QString& time) {
    QStringList times = getAlertTimes();
    if (!times.contains(time)) {
        QStringList advances = getAlertAdvanceMinutes();
        times.append(time);
        advances.append("0");
        sortAlertsTogether(times, advances);
        setAlertTimes(times);
        setAlertAdvanceMinutes(advances);
    }
}

void Config::removeAlertTime(const QString& time) {
    QStringList times = getAlertTimes();
    QStringList advances = getAlertAdvanceMinutes();
    int idx = times.indexOf(time);
    if (idx >= 0) {
        times.removeAt(idx);
        if (idx < advances.size()) advances.removeAt(idx);
        setAlertTimes(times);
        setAlertAdvanceMinutes(advances);
    }
}

void Config::updateAlertTime(const QString& oldTime, const QString& newTime) {
    QStringList times = getAlertTimes();
    QStringList advances = getAlertAdvanceMinutes();
    int idx = times.indexOf(oldTime);
    if (idx >= 0 && oldTime != newTime && !times.contains(newTime)) {
        if (advances.size() != times.size()) {
            advances.clear();
            for (int i = 0; i < times.size(); ++i) advances.append("0");
        }
        times[idx] = newTime;
        sortAlertsTogether(times, advances);
        setAlertTimes(times);
        setAlertAdvanceMinutes(advances);
    }
}

} // namespace Util
