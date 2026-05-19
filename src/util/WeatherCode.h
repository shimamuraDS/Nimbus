#ifndef WEATHERCODE_H
#define WEATHERCODE_H

#include <QString>
#include <QStringList>

namespace Util {

class WeatherCode {
public:
    static QString getIconByWeather(const QString& weatherStr);
    static bool isSevereWeather(const QString& weatherStr);
};

} // namespace Util

#endif // WEATHERCODE_H
