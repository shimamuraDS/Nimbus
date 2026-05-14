#ifndef WEATHERSERVICE_H
#define WEATHERSERVICE_H

#include <QObject>
#include "../network/TencentApiClient.h"

namespace Service {

class WeatherService : public QObject {
    Q_OBJECT
public:
    explicit WeatherService(QObject* parent = nullptr);

    void refreshWeatherData(int adcode);

signals:
    void weatherDataUpdated();
    void networkError(const QString& message);

private:
    Network::TencentApiClient* m_apiClient;
};

} // namespace Service

#endif // WEATHERSERVICE_H
