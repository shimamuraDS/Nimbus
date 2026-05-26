#ifndef CONFIG_H
#define CONFIG_H

#include <QString>
#include <QStringList>
#include <QSettings>
#include <memory>


namespace Util {

class Config {
public:
    static Config& getInstance();

    Config(const Config&) = delete;
    Config& operator=(const Config&) = delete;

    // API 配置
    QString getTencentApiKey() const;
    QString getWeatherApiKey() const;
    void setWeatherApiKey(const QString& key);

    // 用户偏好设置
    bool isAutoLocation() const;
    void setAutoLocation(bool autoLoc);

    int getManualAdcode() const;
    void setManualAdcode(int adcode);

    QString getManualCityName() const;
    void setManualCityName(const QString& cityName);

    bool isAutoStart() const;
    void setAutoStart(bool autoStart);

    QStringList getAlertTimes() const;
    void setAlertTimes(const QStringList& times);
    void addAlertTime(const QString& time);
    void removeAlertTime(const QString& time);
    void updateAlertTime(const QString& oldTime, const QString& newTime);

    QStringList getAlertAdvanceMinutes() const;
    void setAlertAdvanceMinutes(const QStringList& minutes);
    int getAdvanceMinutesFor(const QString& alertTime) const;
    void setAdvanceMinutesFor(const QString& alertTime, int minutes);

#ifdef WITH_LLM
    // LLM 配置
    bool isLLMEnabled() const;
    void setLLMEnabled(bool enabled);

    QString getLLMApiUrl() const;
    void setLLMApiUrl(const QString& url);

    QString getLLMApiKey() const;
    void setLLMApiKey(const QString& key);

    QString getLLMModelName() const;
    void setLLMModelName(const QString& model);
#endif

private:
#ifdef WITH_LLM
    QByteArray obfuscateKey(const QByteArray& data) const;
#endif
    void sortAlertsTogether(QStringList& times, QStringList& advances);
    Config();
    ~Config() = default;

    std::unique_ptr<QSettings> m_iniSettings;  // 读取 config.ini
    std::unique_ptr<QSettings> m_userSettings; // 读写用户配置
};

} // namespace Util

#endif // CONFIG_H
