#include "WeatherViewModel.h"
#include "../data/WeatherCacheManager.h"
#include "../util/Config.h"
#include <QDebug>

namespace ViewModel {

WeatherViewModel::WeatherViewModel(Service::WeatherService* weatherService,
                                   Service::LocationService* locationService,
                                   QObject* parent)
    : QObject(parent),
      m_weatherService(weatherService),
      m_locationService(locationService),
      m_isLoading(false),
      m_isOffline(false)
{
    m_currentCity = Util::Config::getInstance().getManualCityName();

    connect(m_locationService, &Service::LocationService::locationChanged,
            this, &WeatherViewModel::onLocationChanged);

    connect(m_weatherService, &Service::WeatherService::weatherDataUpdated,
            this, &WeatherViewModel::onWeatherDataUpdated);
    connect(m_weatherService, &Service::WeatherService::networkError,
            this, [this](const QString&) {
        if (!m_isOffline) {
            m_isOffline = true;
            emit isOfflineChanged();
        }
        if (m_isLoading) {
            m_isLoading = false;
            emit isLoadingChanged();
        }
    });

    loadFromCache();
}

QString WeatherViewModel::currentCity() const { return m_currentCity; }
QVariantMap WeatherViewModel::todayWeather() const { return m_todayWeather; }
QVariantList WeatherViewModel::pastWeatherList() const { return m_pastWeatherList; }
QVariantList WeatherViewModel::futureWeatherList() const { return m_futureWeatherList; }
bool WeatherViewModel::isAutoLocation() const { return Util::Config::getInstance().isAutoLocation(); }
bool WeatherViewModel::isLoading() const { return m_isLoading; }
bool WeatherViewModel::isOffline() const { return m_isOffline; }

QStringList WeatherViewModel::alertTimeList() const {
    return Util::Config::getInstance().getAlertTimes();
}

void WeatherViewModel::requestData() {
    if (m_isLoading) return;

    m_isLoading = true;
    emit isLoadingChanged();

    m_locationService->initLocation();
}

void WeatherViewModel::switchLocationMode() {
    bool isAuto = isAutoLocation();
    auto& config = Util::Config::getInstance();
    if (isAuto) {
        m_locationService->switchToManual(config.getManualAdcode(),
                                          config.getManualCityName());
    } else {
        m_locationService->switchToAuto();
    }
    emit locationModeChanged();
}

void WeatherViewModel::addAlertTime(const QString& time) {
    Util::Config::getInstance().addAlertTime(time);
    emit alertTimeListChanged();
}

void WeatherViewModel::removeAlertTime(const QString& time) {
    Util::Config::getInstance().removeAlertTime(time);
    emit alertTimeListChanged();
}

void WeatherViewModel::onLocationChanged(int adcode, const QString& cityName) {
    if (m_currentCity != cityName) {
        m_currentCity = cityName;
        emit currentCityChanged();
    }
    m_weatherService->refreshWeatherData(adcode);
}

void WeatherViewModel::onWeatherDataUpdated() {
    loadFromCache();
    m_isLoading = false;
    emit isLoadingChanged();
    if (m_isOffline) {
        m_isOffline = false;
        emit isOfflineChanged();
    }
}

void WeatherViewModel::loadFromCache() {
    auto& cache = Data::WeatherCacheManager::getInstance();

    // 先清空，如果缓存无数据则保持空状态
    m_todayWeather.clear();
    m_pastWeatherList.clear();
    m_futureWeatherList.clear();

    // 加载过去7天
    QList<Data::DailyWeather> pastList = cache.getPastSevenDays();
    for (const auto& dw : pastList) {
        QVariantMap map;
        map["date"] = dw.date;
        map["dayWeather"] = dw.dayWeather;
        map["dayTemp"] = dw.dayTemp;
        map["nightWeather"] = dw.nightWeather;
        map["nightTemp"] = dw.nightTemp;
        m_pastWeatherList.append(map);
    }

    // 加载未来7天及当日
    m_futureWeatherList.clear();
    QList<Data::DailyWeather> futureList = cache.getFutureForecast();
    for (int i = 0; i < futureList.size(); ++i) {
        const auto& dw = futureList[i];
        QVariantMap map;
        map["date"] = dw.date;
        map["dayWeather"] = dw.dayWeather;
        map["dayTemp"] = dw.dayTemp;
        map["dayHumidity"] = dw.dayHumidity;
        map["nightWeather"] = dw.nightWeather;
        map["nightTemp"] = dw.nightTemp;
        map["nightHumidity"] = dw.nightHumidity;

        m_futureWeatherList.append(map);

        if (i == 0) {
            m_todayWeather = map;
        }
    }

    emit weatherDataChanged();
}

} // namespace ViewModel
