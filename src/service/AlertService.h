#ifndef ALERTSERVICE_H
#define ALERTSERVICE_H

#include <QObject>
#include <QTimer>
#include <QString>

namespace Service {

class AlertService : public QObject {
    Q_OBJECT
public:
    explicit AlertService(QObject* parent = nullptr);
    void startMonitoring();

private slots:
    void checkAlerts();

private:
    QTimer* m_timer;
    QString m_lastAlertTime;
};

} // namespace Service

#endif // ALERTSERVICE_H
