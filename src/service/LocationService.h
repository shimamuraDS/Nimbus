#ifndef LOCATIONSERVICE_H
#define LOCATIONSERVICE_H

#include <QObject>
#include "../network/TencentApiClient.h"

namespace Service {

class LocationService : public QObject {
    Q_OBJECT
public:
    explicit LocationService(QObject* parent = nullptr);

    void initLocation();
    void switchToManual(int adcode, const QString& cityName);
    void switchToAuto();

signals:
    void locationChanged(int adcode, const QString& cityName);

private:
    Network::TencentApiClient* m_apiClient;
};

} // namespace Service

#endif // LOCATIONSERVICE_H
