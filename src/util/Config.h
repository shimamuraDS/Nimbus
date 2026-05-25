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

private:
    Config();
    ~Config() = default;

    std::unique_ptr<QSettings> m_iniSettings;  // 读取 config.ini
    std::unique_ptr<QSettings> m_userSettings; // 读写用户配置
};

} // namespace Util

#endif // CONFIG_H
