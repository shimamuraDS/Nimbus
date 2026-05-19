#ifndef SETTINGSVIEWMODEL_H
#define SETTINGSVIEWMODEL_H

#include <QObject>
#include <QStringList>
#include "../service/LocationService.h"

namespace ViewModel {

class SettingsViewModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool isAutoLocation READ isAutoLocation NOTIFY settingsChanged)
    Q_PROPERTY(QString manualCityName READ manualCityName NOTIFY settingsChanged)
    Q_PROPERTY(QStringList alertTimeList READ alertTimeList NOTIFY alertTimeListChanged)

public:
    explicit SettingsViewModel(Service::LocationService* locationService, QObject* parent = nullptr);

    bool isAutoLocation() const;
    QString manualCityName() const;
    QStringList alertTimeList() const;

    Q_INVOKABLE void setAutoLocation(bool isAuto);
    Q_INVOKABLE void setManualCity(int adcode, const QString& name);
    Q_INVOKABLE void addAlertTime(const QString& time);
    Q_INVOKABLE void removeAlertTime(const QString& time);
    Q_INVOKABLE void updateAlertTime(const QString& oldTime, const QString& newTime);

signals:
    void settingsChanged();
    void alertTimeListChanged();

private:
    Service::LocationService* m_locationService;
};

} // namespace ViewModel

#endif // SETTINGSVIEWMODEL_H
