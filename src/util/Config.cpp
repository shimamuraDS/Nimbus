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

void Config::addAlertTime(const QString& time) {
    QStringList times = getAlertTimes();
    if (!times.contains(time)) {
        times.append(time);
        times.sort();
        setAlertTimes(times);
    }
}

void Config::removeAlertTime(const QString& time) {
    QStringList times = getAlertTimes();
    if (times.removeAll(time) > 0) {
        setAlertTimes(times);
    }
}

void Config::updateAlertTime(const QString& oldTime, const QString& newTime) {
    QStringList times = getAlertTimes();
    int idx = times.indexOf(oldTime);
    if (idx >= 0 && oldTime != newTime && !times.contains(newTime)) {
        times[idx] = newTime;
        times.sort();
        setAlertTimes(times);
    }
}

} // namespace Util
