#include "WeatherCode.h"

namespace Util {


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
    return !weatherStr.contains(QString::fromUtf8("晴"))
        && !weatherStr.contains(QString::fromUtf8("多云"));
}

} // namespace Util
