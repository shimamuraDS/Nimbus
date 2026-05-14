#include "WeatherCode.h"

namespace Util {

const QStringList WeatherCode::m_severeKeywords = {
    QString::fromUtf8("冰雹"),
    QString::fromUtf8("暴雨"),
    QString::fromUtf8("大暴雨"),
    QString::fromUtf8("特大暴雨"),
    QString::fromUtf8("大到暴雨"),
    QString::fromUtf8("暴雨到大暴雨"),
    QString::fromUtf8("大暴雨到特大暴雨"),
    QString::fromUtf8("暴雪"),
    QString::fromUtf8("大到暴雪"),
    QString::fromUtf8("冻雨"),
    QString::fromUtf8("沙尘暴"),
    QString::fromUtf8("强沙尘暴"),
    QString::fromUtf8("严重霾"),
    QString::fromUtf8("特强浓雾")
};

QString WeatherCode::getIconByWeather(const QString& weatherStr) {
    const QString basePath = "qrc:/resources/icons/weather/";

    if (weatherStr.contains(QString::fromUtf8("晴"))) {
        return basePath + "sunny.png";
    } else if (weatherStr.contains(QString::fromUtf8("多云"))) {
        return basePath + "cloudy.png";
    } else if (weatherStr.contains(QString::fromUtf8("阴"))) {
        return basePath + "overcast.png";
    } else if (weatherStr.contains(QString::fromUtf8("雷阵雨"))) {
        return basePath + "thunderstorm.png";
    } else if (weatherStr.contains(QString::fromUtf8("雪"))) {
        return basePath + "snow.png";
    } else if (weatherStr.contains(QString::fromUtf8("雨"))) {
        return basePath + "rain.png";
    } else if (weatherStr.contains(QString::fromUtf8("雾")) || weatherStr.contains(QString::fromUtf8("霾"))) {
        return basePath + "fog.png";
    } else if (weatherStr.contains(QString::fromUtf8("沙")) || weatherStr.contains(QString::fromUtf8("尘"))) {
        return basePath + "sandstorm.png";
    }

    return basePath + "unknown.png";
}

bool WeatherCode::isSevereWeather(const QString& weatherStr) {
    for (const QString& keyword : m_severeKeywords) {
        if (weatherStr.contains(keyword)) {
            return true;
        }
    }
    return false;
}

} // namespace Util
