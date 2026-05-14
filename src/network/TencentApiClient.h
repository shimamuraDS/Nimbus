#ifndef TENCENTAPICLIENT_H
#define TENCENTAPICLIENT_H

#include "HttpClient.h"
#include <QJsonArray>

namespace Network {

class TencentApiClient : public HttpClient {
    Q_OBJECT
public:
    explicit TencentApiClient(QObject* parent = nullptr);

    void fetchLocation();
    void fetchAllWeatherInfo(int adcode);

signals:
    void locationFetched(int adcode, const QString& city);
    void hoursWeatherFetched(const QJsonArray& hoursInfos);
    void futureWeatherFetched(const QJsonArray& futureInfos);
    void alarmsFetched(const QJsonArray& alarms);
    void apiErrorOccurred(const QString& apiType, const QString& errorMessage);

private:
    QString getBaseUrl() const;
};

} // namespace Network

#endif // TENCENTAPICLIENT_H
