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
    void checkDefaultAlert();

    QTimer* m_timer;
    QString m_lastAlertTime;
    QString m_lastDefaultAlertKey;
};

} // namespace Service

#endif // ALERTSERVICE_H
