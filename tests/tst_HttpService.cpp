#include <QtTest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QFile>
#include "network/HttpClient.h"
#include "network/TencentApiClient.h"
#include "util/Config.h"

// Mock response JSONs (matching Tencent LBS API format)
static const char* MOCK_LOCATION_RESPONSE = R"({
    "status": 0,
    "message": "OK",
    "result": {
        "ad_info": {
            "adcode": 440300,
            "city": "深圳市"
        }
    }
})";

static const char* MOCK_HOURS_RESPONSE = R"({
    "status": 0,
    "result": {
        "forecast_hours": {
            "infos": [
                {
                    "hour": "2026-05-12 08:00",
                    "info": {
                        "weather": "多云",
                        "temperature": 26,
                        "wind_direction": "东南风",
                        "wind_power": "2-3级"
                    }
                }
            ]
        }
    }
})";

static const char* MOCK_FUTURE_RESPONSE = R"({
    "status": 0,
    "result": {
        "forecast": {
            "infos": [
                {
                    "date": "2026-05-12",
                    "day": {"weather": "晴", "temperature": 28, "humidity": 45},
                    "night": {"weather": "多云", "temperature": 20, "humidity": 60}
                }
            ]
        }
    }
})";

static const char* MOCK_NOW_ALARM_RESPONSE = R"({
    "status": 0,
    "result": {
        "alarms": [
            {
                "title": "深圳市发布暴雨黄色预警",
                "pub_content": "预计未来6小时将出现暴雨",
                "level_name": "黄色",
                "type_name": "暴雨"
            }
        ]
    }
})";

class tst_HttpService : public QObject {
    Q_OBJECT

private slots:
    void testLocationResponseParsing() {
        QJsonDocument doc = QJsonDocument::fromJson(MOCK_LOCATION_RESPONSE);
        QVERIFY(!doc.isNull());
        QJsonObject root = doc.object();
        QCOMPARE(root["status"].toInt(), 0);

        QJsonObject result = root["result"].toObject();
        QJsonObject adInfo = result["ad_info"].toObject();
        QCOMPARE(adInfo["adcode"].toInt(), 440300);
        QCOMPARE(adInfo["city"].toString(), QString::fromUtf8("深圳市"));
    }

    void testHoursResponseParsing() {
        QJsonDocument doc = QJsonDocument::fromJson(MOCK_HOURS_RESPONSE);
        QVERIFY(!doc.isNull());

        QJsonObject root = doc.object();
        QJsonArray infos = root["result"].toObject()["forecast_hours"]
                           .toObject()["infos"].toArray();
        QVERIFY(!infos.isEmpty());

        QJsonObject hour = infos[0].toObject();
        QCOMPARE(hour["hour"].toString(), QString("2026-05-12 08:00"));
        QCOMPARE(hour["info"].toObject()["weather"].toString(), QString::fromUtf8("多云"));
        QCOMPARE(hour["info"].toObject()["temperature"].toInt(), 26);
    }

    void testFutureResponseParsing() {
        QJsonDocument doc = QJsonDocument::fromJson(MOCK_FUTURE_RESPONSE);
        QVERIFY(!doc.isNull());

        QJsonArray infos = doc.object()["result"].toObject()["forecast"]
                           .toObject()["infos"].toArray();
        QVERIFY(!infos.isEmpty());

        QJsonObject day = infos[0].toObject();
        QCOMPARE(day["date"].toString(), QString("2026-05-12"));
        QCOMPARE(day["day"].toObject()["weather"].toString(), QString::fromUtf8("晴"));
        QCOMPARE(day["day"].toObject()["temperature"].toInt(), 28);
        QCOMPARE(day["night"].toObject()["temperature"].toInt(), 20);
    }

    void testAlarmParsing() {
        QJsonDocument doc = QJsonDocument::fromJson(MOCK_NOW_ALARM_RESPONSE);
        QVERIFY(!doc.isNull());

        QJsonArray alarms = doc.object()["result"].toObject()["alarms"].toArray();
        QVERIFY(!alarms.isEmpty());

        QJsonObject alarm = alarms[0].toObject();
        QVERIFY(alarm["title"].toString().contains(QString::fromUtf8("暴雨")));
        QVERIFY(!alarm["pub_content"].toString().isEmpty());
        QCOMPARE(alarm["level_name"].toString(), QString::fromUtf8("黄色"));
    }

    void testApiKeyExists() {
        QString key = Util::Config::getInstance().getTencentApiKey();
        QVERIFY(!key.isEmpty());
        QVERIFY(key.length() > 10);
    }
};

QTEST_MAIN(tst_HttpService)
#include "tst_HttpService.moc"
