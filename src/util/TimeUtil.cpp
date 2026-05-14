#include "TimeUtil.h"

namespace Util {

QString TimeUtil::getCurrentTimeHHmm() {
    return QTime::currentTime().toString("HH:mm");
}

bool TimeUtil::isTimeToAlert(const QString& targetTimeHHmm) {
    return getCurrentTimeHHmm() == targetTimeHHmm;
}

QDateTime TimeUtil::parseTencentHour(const QString& tencentTimeStr) {
    // API returns format "2026-05-13 13:00:00" (with seconds)
    QDateTime dt = QDateTime::fromString(tencentTimeStr, "yyyy-MM-dd HH:mm:ss");
    if (!dt.isValid()) {
        dt = QDateTime::fromString(tencentTimeStr, "yyyy-MM-dd HH:mm");
    }
    return dt;
}

QString TimeUtil::formatToHourlyString(const QDateTime& dt) {
    QTime time = dt.time();
    QDateTime hourlyDt(dt.date(), QTime(time.hour(), 0, 0));
    return hourlyDt.toString("yyyy-MM-dd HH:00");
}

bool TimeUtil::isWithinFutureHours(const QDateTime& targetTime, int hours) {
    QDateTime now = QDateTime::currentDateTime();
    qint64 secsDiff = now.secsTo(targetTime);
    return secsDiff > 0 && secsDiff <= (hours * 3600);
}

} // namespace Util
