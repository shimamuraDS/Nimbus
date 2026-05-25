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
    QStringList advanceMinutes = config.getAlertAdvanceMinutes();

    // Build trigger times: alert_time - advance_minutes
    // Find the alert time whose trigger matches current time
    QString matchedAlertTime;
    int matchedAdvanceMinutes = 0;

    for (int i = 0; i < alertTimes.size(); ++i) {
        int advance = (i < advanceMinutes.size()) ? advanceMinutes[i].toInt() : 0;
        QTime alertTime = QTime::fromString(alertTimes[i], "HH:mm");
        QTime triggerTime = alertTime.addSecs(-advance * 60);
        if (triggerTime.toString("HH:mm") == currentTime) {
            matchedAlertTime = alertTimes[i];
            matchedAdvanceMinutes = advance;
            break;
        }
    }

    // Fallback: direct match (advance = 0)
    if (matchedAlertTime.isEmpty() && alertTimes.contains(currentTime)) {
        matchedAlertTime = currentTime;
        matchedAdvanceMinutes = 0;
    }

    if (matchedAlertTime.isEmpty()) return;

    m_lastAlertTime = currentTime;

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

    // Tier 2: check weather at alert time (currentTime + advanceMinutes into future)
    int futureHours = qMax(1, (matchedAdvanceMinutes + 59) / 60);
    for (int i = 0; i < hourlyData.size(); ++i) {
        QJsonObject hourObj = hourlyData[i].toObject();
        QString hourStr = hourObj["hour"].toString();

        QDateTime dt = Util::TimeUtil::parseTencentHour(hourStr);

        if (Util::TimeUtil::isWithinFutureHours(dt, futureHours)) {
            QJsonObject info = hourObj["info"].toObject();
            QString weatherDesc = info["weather"].toString();

            if (Util::WeatherCode::isSevereWeather(weatherDesc)) {
                QString title;
                QString content;
                if (matchedAdvanceMinutes > 0) {
                    int advH = matchedAdvanceMinutes / 60;
                    int advM = matchedAdvanceMinutes % 60;
                    QString advanceStr;
                    if (advH > 0 && advM > 0)
                        advanceStr = QString::number(advH) + QString::fromUtf8("小时") + QString::number(advM) + QString::fromUtf8("分钟");
                    else if (advH > 0)
                        advanceStr = QString::number(advH) + QString::fromUtf8("小时");
                    else
                        advanceStr = QString::number(advM) + QString::fromUtf8("分钟");

                    title = advanceStr + QString::fromUtf8("后将有") + weatherDesc;
                    content = QString::fromUtf8("当前天气：") + currentWeather
                        + QString::fromUtf8("\n提醒时间 ") + matchedAlertTime
                        + QString::fromUtf8("（") + advanceStr + QString::fromUtf8("后）")
                        + QString::fromUtf8(" 预计将出现") + weatherDesc
                        + QString::fromUtf8("，请提前做好防范。");
                } else {
                    title = QString::fromUtf8("天气提醒：未来1小时将有") + weatherDesc;
                    content = QString::fromUtf8("当前天气：") + currentWeather
                        + QString::fromUtf8("\n预计 ") + hourStr.mid(11, 5)
                        + QString::fromUtf8(" 左右将出现") + weatherDesc
                        + QString::fromUtf8("，请提前做好防范。");
                }

                NotificationManager::getInstance().showWeatherAlert(title, content);
                return;
            }
        }
    }
}

} // namespace Service
