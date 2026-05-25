#include "AlertService.h"
#include "NotificationManager.h"
#include "../util/Config.h"
#include "../util/TimeUtil.h"
#include "../util/WeatherCode.h"
#include "../data/WeatherCacheManager.h"
#include <QJsonArray>
#include <QJsonObject>
#include <QDateTime>

namespace Service {

AlertService::AlertService(QObject* parent) : QObject(parent) {
    m_timer = new QTimer(this);
    connect(m_timer, &QTimer::timeout, this, &AlertService::checkAlerts);
}

void AlertService::startMonitoring() {
    m_timer->start(60000);
}

void AlertService::checkAlerts() {
    QString currentTime = Util::TimeUtil::getCurrentTimeHHmm();

    if (currentTime == m_lastAlertTime) return;

    auto& config = Util::Config::getInstance();
    QStringList alertTimes = config.getAlertTimes();
    if (!alertTimes.contains(currentTime)) return;

    m_lastAlertTime = currentTime;

    // Get the duration window for this alert time
    QStringList durationMinutes = config.getAlertAdvanceMinutes();
    int idx = alertTimes.indexOf(currentTime);
    int durationMin = (idx >= 0 && idx < durationMinutes.size()) ? durationMinutes[idx].toInt() : 0;

    auto& cache = Data::WeatherCacheManager::getInstance();

    // Tier 1: official weather alarm
    QJsonArray alarms = cache.getCurrentAlarms();
    if (!alarms.isEmpty()) {
        QJsonObject alarm = alarms.first().toObject();
        QString title = alarm["title"].toString();
        QString content = alarm["pub_content"].toString();

        NotificationManager::getInstance().showWeatherAlert(title, content);
        return;
    }

    // Get current weather
    QJsonArray hourlyData = cache.getHourlyData();
    QString currentHourKey = QDateTime::currentDateTime().toString("yyyy-MM-dd HH:00");
    QString currentWeather;
    for (int i = 0; i < hourlyData.size(); ++i) {
        QJsonObject hourObj = hourlyData[i].toObject();
        if (hourObj["hour"].toString() == currentHourKey) {
            currentWeather = hourObj["info"].toObject()["weather"].toString();
            break;
        }
    }

    // Tier 2: check weather within the configured duration window
    // Default to 1 hour if no duration set
    int futureHours = qMax(1, (durationMin + 59) / 60);

    // Collect all severe weather segments within the window
    struct WeatherSegment {
        QString time;
        QString desc;
    };
    QList<WeatherSegment> segments;

    for (int i = 0; i < hourlyData.size(); ++i) {
        QJsonObject hourObj = hourlyData[i].toObject();
        QString hourStr = hourObj["hour"].toString();

        QDateTime dt = Util::TimeUtil::parseTencentHour(hourStr);

        if (Util::TimeUtil::isWithinFutureHours(dt, futureHours)) {
            QJsonObject info = hourObj["info"].toObject();
            QString weatherDesc = info["weather"].toString();

            if (Util::WeatherCode::isSevereWeather(weatherDesc)) {
                segments.append({hourStr.mid(11, 5), weatherDesc});
            }
        }
    }

    if (segments.isEmpty()) return;

    // Build notification
    QString title;
    QString content;
    content = QString::fromUtf8("当前天气：") + currentWeather + "\n";

    if (durationMin > 0) {
        int dH = durationMin / 60;
        int dM = durationMin % 60;
        QString durStr;
        if (dH > 0 && dM > 0)
            durStr = QString::number(dH) + QString::fromUtf8("小时") + QString::number(dM) + QString::fromUtf8("分钟");
        else if (dH > 0)
            durStr = QString::number(dH) + QString::fromUtf8("小时");
        else
            durStr = QString::number(dM) + QString::fromUtf8("分钟");

        title = QString::fromUtf8("天气提醒：未来") + durStr + QString::fromUtf8("内天气变化");

        for (const auto& seg : segments) {
            content += seg.time + QString::fromUtf8("：") + seg.desc + "\n";
        }
        content += QString::fromUtf8("请提前做好防范。");
    } else {
        // Default: just show the first match (backward compatible behavior)
        auto& seg = segments.first();
        title = QString::fromUtf8("天气提醒：未来1小时将有") + seg.desc;
        content += QString::fromUtf8("预计 ") + seg.time
            + QString::fromUtf8(" 左右将出现") + seg.desc
            + QString::fromUtf8("，请提前做好防范。");
    }

    NotificationManager::getInstance().showWeatherAlert(title, content);
}

} // namespace Service
