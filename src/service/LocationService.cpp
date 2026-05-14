#include "LocationService.h"
#include "../util/Config.h"
#include <QDebug>

namespace Service {

LocationService::LocationService(QObject* parent) : QObject(parent) {
    m_apiClient = new Network::TencentApiClient(this);

    connect(m_apiClient, &Network::TencentApiClient::locationFetched,
            this, [this](int adcode, const QString& city) {
        emit locationChanged(adcode, city);
    });

    connect(m_apiClient, &Network::TencentApiClient::apiErrorOccurred,
            this, [this](const QString& apiType, const QString& errorMessage) {
        if (apiType.contains("Location")) {
            qWarning() << "[LocationService] Auto-location failed:" << errorMessage
                       << "- falling back to manual location";
            auto& config = Util::Config::getInstance();
            emit locationChanged(config.getManualAdcode(), config.getManualCityName());
        }
    });
}

void LocationService::initLocation() {
    auto& config = Util::Config::getInstance();
    if (config.isAutoLocation()) {
        m_apiClient->fetchLocation();
    } else {
        emit locationChanged(config.getManualAdcode(), config.getManualCityName());
    }
}

void LocationService::switchToManual(int adcode, const QString& cityName) {
    auto& config = Util::Config::getInstance();
    config.setAutoLocation(false);
    config.setManualAdcode(adcode);
    config.setManualCityName(cityName);

    emit locationChanged(adcode, cityName);
}

void LocationService::switchToAuto() {
    auto& config = Util::Config::getInstance();
    config.setAutoLocation(true);

    m_apiClient->fetchLocation();
}

} // namespace Service
