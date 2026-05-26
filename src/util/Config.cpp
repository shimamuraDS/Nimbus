#include "Config.h"
#ifdef WITH_LLM
#include <QCryptographicHash>
#include <QSysInfo>
#endif
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
    // 优先使用用户设置，没有则回退到 config.ini
    QString userKey = m_userSettings->value("API/WeatherKey", "").toString();
    if (!userKey.isEmpty()) return userKey;
    return m_iniSettings->value("API/DeveloperKey", "").toString();
}

QString Config::getWeatherApiKey() const {
    return getTencentApiKey();
}

void Config::setWeatherApiKey(const QString& key) {
    m_userSettings->setValue("API/WeatherKey", key);
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

#ifdef WITH_LLM

QByteArray Config::obfuscateKey(const QByteArray& data) const {
    QByteArray machineId = QSysInfo::machineUniqueId();
    QByteArray hash = QCryptographicHash::hash(machineId, QCryptographicHash::Sha256);
    QByteArray result = data;
    for (int i = 0; i < result.size(); ++i)
        result[i] = result[i] ^ hash[i % hash.size()];
    return result;
}

bool Config::isLLMEnabled() const {
    return m_userSettings->value("LLM/Enabled", false).toBool();
}

void Config::setLLMEnabled(bool enabled) {
    m_userSettings->setValue("LLM/Enabled", enabled);
}

QString Config::getLLMApiUrl() const {
    return m_userSettings->value("LLM/ApiUrl", "https://api.deepseek.com").toString();
}

void Config::setLLMApiUrl(const QString& url) {
    m_userSettings->setValue("LLM/ApiUrl", url);
}

QString Config::getLLMApiKey() const {
    QByteArray obfuscated = QByteArray::fromBase64(
        m_userSettings->value("LLM/ApiKey", "").toString().toUtf8());
    if (obfuscated.isEmpty()) return QString();
    QByteArray plain = obfuscateKey(obfuscated);
    return QString::fromUtf8(plain);
}

void Config::setLLMApiKey(const QString& key) {
    if (key.isEmpty()) {
        m_userSettings->setValue("LLM/ApiKey", "");
        return;
    }
    QByteArray obfuscated = obfuscateKey(key.toUtf8());
    m_userSettings->setValue("LLM/ApiKey", QString::fromLatin1(obfuscated.toBase64()));
}

QString Config::getLLMModelName() const {
    return m_userSettings->value("LLM/ModelName", "deepseek-v4-pro").toString();
}

void Config::setLLMModelName(const QString& model) {
    m_userSettings->setValue("LLM/ModelName", model);
}

#endif

} // namespace Util
