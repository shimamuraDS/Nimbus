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

    QStringList alertTimes = Util::Config::getInstance().getAlertTimes();
    if (!alertTimes.contains(currentTime)) return;

    m_lastAlertTime = currentTime;

    auto& cache = Data::WeatherCacheManager::getInstance();

    // 第一层：官方预警命中
    QJsonArray alarms = cache.getCurrentAlarms();
    if (!alarms.isEmpty()) {
        QJsonObject alarm = alarms.first().toObject();
        QString title = alarm["title"].toString();
        QString content = alarm["pub_content"].toString();

        NotificationManager::getInstance().showWeatherAlert(title, content);
        return;
    }

    // 第二层：未来3小时内逐小时恶劣天气命中
    QJsonArray hourlyData = cache.getHourlyData();
    for (int i = 0; i < hourlyData.size(); ++i) {
        QJsonObject hourObj = hourlyData[i].toObject();
        QString hourStr = hourObj["hour"].toString();

        QDateTime dt = Util::TimeUtil::parseTencentHour(hourStr);

        if (Util::TimeUtil::isWithinFutureHours(dt, 3)) {
            QJsonObject info = hourObj["info"].toObject();
            QString weatherDesc = info["weather"].toString();

            if (Util::WeatherCode::isSevereWeather(weatherDesc)) {
                QString title = QString::fromUtf8("极端天气提醒：未来数小时将有") + weatherDesc;
                QString content = QString::fromUtf8("预计在 ") + hourStr.mid(11, 5)
                    + QString::fromUtf8(" 左右将出现") + weatherDesc
                    + QString::fromUtf8("，请提前做好防范。");

                NotificationManager::getInstance().showWeatherAlert(title, content);
                return;
            }
        }
    }
}

} // namespace Service
