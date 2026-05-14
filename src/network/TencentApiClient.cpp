#include "TencentApiClient.h"
#include "../util/Config.h"
#include <QUrlQuery>
#include <QDebug>

namespace Network {

TencentApiClient::TencentApiClient(QObject* parent) : HttpClient(parent) {}

QString TencentApiClient::getBaseUrl() const {
    return "https://apis.map.qq.com";
}

void TencentApiClient::fetchLocation() {
    QUrl url(getBaseUrl() + "/ws/location/v1/ip");
    QUrlQuery query;
    query.addQueryItem("key", Util::Config::getInstance().getTencentApiKey());
    url.setQuery(query);

    sendGetRequest(url, [this](const QJsonObject& root) {
        QJsonObject result = root["result"].toObject();
        QJsonObject adInfo = result["ad_info"].toObject();

        int adcode = adInfo["adcode"].toInt();
        QString city = adInfo["city"].toString();

        emit locationFetched(adcode, city);
    }, [this](const QString& err) {
        emit apiErrorOccurred("Location API", err);
    });
}

void TencentApiClient::fetchAllWeatherInfo(int adcode) {
    QString apiKey = Util::Config::getInstance().getTencentApiKey();
    QString weatherUrl = getBaseUrl() + "/ws/weather/v1/";

    // 1. 未来24小时逐小时预报 (type=hours)
    {
        QUrl hoursUrl(weatherUrl);
        QUrlQuery hoursQuery;
        hoursQuery.addQueryItem("key", apiKey);
        hoursQuery.addQueryItem("adcode", QString::number(adcode));
        hoursQuery.addQueryItem("type", "hours");
        hoursUrl.setQuery(hoursQuery);

        sendGetRequest(hoursUrl, [this](const QJsonObject& root) {
            QJsonObject result = root["result"].toObject();
            QJsonArray forecastHoursArr = result["forecast_hours"].toArray();
            QJsonArray hoursInfos;
            if (!forecastHoursArr.isEmpty()) {
                hoursInfos = forecastHoursArr[0].toObject()["infos"].toArray();
            }
            emit hoursWeatherFetched(hoursInfos);
        }, [this](const QString& err) {
            emit apiErrorOccurred("Weather-Hours API", err);
        });
    }

    // 2. 未来7天预报 (type=future, get_md=1)
    {
        QUrl futureUrl(weatherUrl);
        QUrlQuery futureQuery;
        futureQuery.addQueryItem("key", apiKey);
        futureQuery.addQueryItem("adcode", QString::number(adcode));
        futureQuery.addQueryItem("type", "future");
        futureQuery.addQueryItem("get_md", "1");
        futureUrl.setQuery(futureQuery);

        sendGetRequest(futureUrl, [this](const QJsonObject& root) {
            QJsonObject result = root["result"].toObject();
            QJsonArray forecastArr = result["forecast"].toArray();
            QJsonArray futureInfos;
            if (!forecastArr.isEmpty()) {
                futureInfos = forecastArr[0].toObject()["infos"].toArray();
            }
            emit futureWeatherFetched(futureInfos);
        }, [this](const QString& err) {
            emit apiErrorOccurred("Weather-Future API", err);
        });
    }

    // 3. 当前天气与预警 (type=now, added_fields=alarm)
    {
        QUrl nowUrl(weatherUrl);
        QUrlQuery nowQuery;
        nowQuery.addQueryItem("key", apiKey);
        nowQuery.addQueryItem("adcode", QString::number(adcode));
        nowQuery.addQueryItem("type", "now");
        nowQuery.addQueryItem("added_fields", "alarm");
        nowUrl.setQuery(nowQuery);

        sendGetRequest(nowUrl, [this](const QJsonObject& root) {
            QJsonObject result = root["result"].toObject();
            QJsonArray realtimeArr = result["realtime"].toArray();
            QJsonArray alarms;
            if (!realtimeArr.isEmpty()) {
                alarms = realtimeArr[0].toObject()["alarms"].toArray();
            }
            emit alarmsFetched(alarms);
        }, [this](const QString& err) {
            emit apiErrorOccurred("Weather-Now(Alarm) API", err);
        });
    }
}

} // namespace Network
