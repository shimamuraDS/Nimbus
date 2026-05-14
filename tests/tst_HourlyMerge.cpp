#include <QtTest>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QFile>
#include <QStandardPaths>
#include <QDir>
#include "data/WeatherCacheManager.h"

class tst_HourlyMerge : public QObject {
    Q_OBJECT

private slots:
    void testAppendAndDedup() {
        auto& cache = Data::WeatherCacheManager::getInstance();

        // 构造模拟逐小时数据
        QJsonArray hoursInfos;
        QJsonObject hour1;
        hour1["hour"] = "2026-05-12 08:00";
        hour1["weather"] = QString::fromUtf8("晴");
        hour1["temperature"] = 25;
        hour1["wind_direction"] = QString::fromUtf8("东北风");
        hour1["wind_power"] = "1-2";
        hoursInfos.append(hour1);

        QJsonObject hour2;
        hour2["hour"] = "2026-05-12 09:00";
        hour2["weather"] = QString::fromUtf8("多云");
        hour2["temperature"] = 27;
        hour2["wind_direction"] = QString::fromUtf8("东风");
        hour2["wind_power"] = "2-3";
        hoursInfos.append(hour2);

        cache.appendHourlyData(hoursInfos);

        // 检查数据已写入
        QJsonArray result = cache.getHourlyData();
        QVERIFY(result.size() >= 2);

        // 测试去重：再次追加相同时间的数据（温度变化）
        QJsonArray updatedHours;
        QJsonObject updatedHour1;
        updatedHour1["hour"] = "2026-05-12 08:00";
        updatedHour1["weather"] = QString::fromUtf8("晴");
        updatedHour1["temperature"] = 28;
        updatedHour1["wind_direction"] = QString::fromUtf8("东北风");
        updatedHour1["wind_power"] = "1-2";
        updatedHours.append(updatedHour1);

        cache.appendHourlyData(updatedHours);

        // 08:00的温度应被更新为28
        QJsonArray afterResult = cache.getHourlyData();
        bool found = false;
        for (int i = 0; i < afterResult.size(); ++i) {
            QJsonObject obj = afterResult[i].toObject();
            if (obj["hour"].toString() == "2026-05-12 08:00") {
                QCOMPARE(obj["temperature"].toInt(), 28);
                found = true;
            }
        }
        QVERIFY(found);
    }
};

QTEST_MAIN(tst_HourlyMerge)
#include "tst_HourlyMerge.moc"
