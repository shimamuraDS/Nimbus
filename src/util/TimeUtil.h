#ifndef TIMEUTIL_H
#define TIMEUTIL_H

#include <QString>
#include <QDateTime>

namespace Util {

class TimeUtil {
public:
    static QString getCurrentTimeHHmm();
    static bool isTimeToAlert(const QString& targetTimeHHmm);
    static QDateTime parseTencentHour(const QString& tencentTimeStr);
    static QString formatToHourlyString(const QDateTime& dt);
    static bool isWithinFutureHours(const QDateTime& targetTime, int hours);
};

} // namespace Util

#endif // TIMEUTIL_H
