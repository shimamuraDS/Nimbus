#include "WeatherCacheManager.h"
#include "../util/TimeUtil.h"
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QJsonDocument>
#include <QDateTime>
#include <QDebug>

namespace Data {

WeatherCacheManager& WeatherCacheManager::getInstance() {
    static WeatherCacheManager instance;
    return instance;
}

WeatherCacheManager::WeatherCacheManager() {
    QString dataDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    QDir dir;
    if (!dir.exists(dataDir)) {
        dir.mkpath(dataDir);
    }
    m_cacheFilePath = dataDir + "/weather_cache.json";
    loadCache();
}

void WeatherCacheManager::loadCache() {
    QFile file(m_cacheFilePath);
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QByteArray data = file.readAll();
        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (!doc.isNull() && doc.isObject()) {
            m_cacheData = doc.object();
            cleanExpiredData();
            return;
        }
    }
    m_cacheData = QJsonObject();
    m_cacheData["hourly_data"] = QJsonArray();
    m_cacheData["future_forecast"] = QJsonArray();
    m_cacheData["current_alarms"] = QJsonArray();
}

void WeatherCacheManager::saveCache() {
    QFile file(m_cacheFilePath);
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QJsonDocument doc(m_cacheData);
        file.write(doc.toJson());
        file.close();
    }
}

void WeatherCacheManager::cleanExpiredData() {
    QJsonArray hourlyData = m_cacheData["hourly_data"].toArray();
    QJsonArray validData;
    QDateTime now = QDateTime::currentDateTime();

    for (int i = 0; i < hourlyData.size(); ++i) {
        QJsonObject hourObj = hourlyData[i].toObject();
        QString hourStr = hourObj["hour"].toString();
        QDateTime dt = Util::TimeUtil::parseTencentHour(hourStr);
        if (dt.isValid() && dt.daysTo(now) <= 7) {
            validData.append(hourObj);
        }
    }

    m_cacheData["hourly_data"] = validData;
    saveCache();
}

void WeatherCacheManager::appendHourlyData(const QJsonArray& forecastHoursInfos) {
    QJsonArray hourlyData = m_cacheData["hourly_data"].toArray();

    QHash<QString, int> existingHours;
    for (int i = 0; i < hourlyData.size(); ++i) {
        existingHours.insert(hourlyData[i].toObject()["hour"].toString(), i);
    }

    for (int i = 0; i < forecastHoursInfos.size(); ++i) {
        QJsonObject hourItem = forecastHoursInfos[i].toObject();
        QString hourStr = hourItem["hour"].toString();

        QDateTime dt = Util::TimeUtil::parseTencentHour(hourStr);
        QString standardizedHour = Util::TimeUtil::formatToHourlyString(dt);
        hourItem["hour"] = standardizedHour;

        if (existingHours.contains(standardizedHour)) {
            hourlyData[existingHours[standardizedHour]] = hourItem;
        } else {
            hourlyData.append(hourItem);
            existingHours.insert(standardizedHour, hourlyData.size() - 1);
        }
    }

    m_cacheData["hourly_data"] = hourlyData;
    cleanExpiredData();
}

void WeatherCacheManager::updateFutureForecast(const QJsonArray& futureInfos) {
    m_cacheData["future_forecast"] = futureInfos;
    saveCache();
}

void WeatherCacheManager::updateCurrentAlarms(const QJsonArray& alarms) {
    m_cacheData["current_alarms"] = alarms;
    saveCache();
}

QList<DailyWeather> WeatherCacheManager::getPastSevenDays() {
    QList<DailyWeather> resultList;
    QJsonArray hourlyData = m_cacheData["hourly_data"].toArray();
    QDateTime today = QDateTime::currentDateTime();

    QHash<QString, QJsonObject> hourMap;
    for (int i = 0; i < hourlyData.size(); ++i) {
        QJsonObject obj = hourlyData[i].toObject();
        hourMap.insert(obj["hour"].toString(), obj);
    }

    for (int i = 1; i <= 7; ++i) {
        QDateTime targetDay = today.addDays(-i);
        QString dateStr = targetDay.toString("yyyy-MM-dd");

        QString morningKey = dateStr + " 08:00";
        QString nightKey = dateStr + " 20:00";

        DailyWeather daily;
        daily.date = dateStr;

        if (hourMap.contains(morningKey)) {
            QJsonObject hourObj = hourMap[morningKey];
            QJsonObject info = hourObj["info"].toObject();
            daily.dayWeather = info["weather"].toString();
            daily.dayTemp = info["temperature"].toInt();
        } else {
            daily.dayWeather = QString::fromUtf8("暂无");
        }

        if (hourMap.contains(nightKey)) {
            QJsonObject hourObj = hourMap[nightKey];
            QJsonObject info = hourObj["info"].toObject();
            daily.nightWeather = info["weather"].toString();
            daily.nightTemp = info["temperature"].toInt();
        } else {
            daily.nightWeather = QString::fromUtf8("暂无");
        }

        resultList.prepend(daily);
    }
    return resultList;
}

QList<DailyWeather> WeatherCacheManager::getFutureForecast() {
    QList<DailyWeather> resultList;
    QJsonArray futureInfos = m_cacheData["future_forecast"].toArray();

    for (int i = 0; i < futureInfos.size(); ++i) {
        QJsonObject dayObj = futureInfos[i].toObject();
        DailyWeather daily;
        daily.date = dayObj["date"].toString();

        QJsonObject dayInfo = dayObj["day"].toObject();
        daily.dayWeather = dayInfo["weather"].toString();
        daily.dayTemp = dayInfo["temperature"].toInt();
        daily.dayHumidity = dayInfo["humidity"].toInt();

        QJsonObject nightInfo = dayObj["night"].toObject();
        daily.nightWeather = nightInfo["weather"].toString();
        daily.nightTemp = nightInfo["temperature"].toInt();
        daily.nightHumidity = nightInfo["humidity"].toInt();

        resultList.append(daily);
    }
    return resultList;
}

QJsonArray WeatherCacheManager::getCurrentAlarms() {
    return m_cacheData["current_alarms"].toArray();
}

QJsonArray WeatherCacheManager::getHourlyData() const {
    return m_cacheData["hourly_data"].toArray();
}

} // namespace Data
