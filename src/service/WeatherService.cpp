#include "WeatherService.h"
#include "../data/WeatherCacheManager.h"
#include <QDebug>

namespace Service {

WeatherService::WeatherService(QObject* parent) : QObject(parent) {
    m_apiClient = new Network::TencentApiClient(this);

    auto& cache = Data::WeatherCacheManager::getInstance();

    connect(m_apiClient, &Network::TencentApiClient::hoursWeatherFetched,
            this, [&cache, this](const QJsonArray& hoursInfos) {
        qDebug() << "[WeatherService] Hours data received:" << hoursInfos.size() << "entries";
        cache.appendHourlyData(hoursInfos);
        emit weatherDataUpdated();
    });

    connect(m_apiClient, &Network::TencentApiClient::futureWeatherFetched,
            this, [&cache, this](const QJsonArray& futureInfos) {
        qDebug() << "[WeatherService] Future data received:" << futureInfos.size() << "days";
        cache.updateFutureForecast(futureInfos);
        emit weatherDataUpdated();
    });

    connect(m_apiClient, &Network::TencentApiClient::alarmsFetched,
            this, [&cache, this](const QJsonArray& alarms) {
        qDebug() << "[WeatherService] Alarms received:" << alarms.size() << "alarms";
        cache.updateCurrentAlarms(alarms);
        emit weatherDataUpdated();
    });

    connect(m_apiClient, &Network::TencentApiClient::apiErrorOccurred,
            this, [this](const QString& apiType, const QString& errorMessage) {
        qWarning() << "[WeatherService] API Failed:" << apiType << "Reason:" << errorMessage;
        emit networkError(errorMessage);
    });
}

void WeatherService::refreshWeatherData(int adcode) {
    qDebug() << "[WeatherService] Fetching weather for adcode:" << adcode;
    m_apiClient->fetchAllWeatherInfo(adcode);
}

} // namespace Service
