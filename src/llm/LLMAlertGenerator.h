#ifndef LLMALERTGENERATOR_H
#define LLMALERTGENERATOR_H

#include <QObject>
#include <QJsonArray>
#include <QJsonObject>
#include <QString>
#include <functional>

namespace LLM {

class LLMAlertGenerator : public QObject {
    Q_OBJECT
public:
    explicit LLMAlertGenerator(QObject* parent = nullptr);

    // 构建 prompt 并调用 LLM，异步回调返回提醒文本
    void generateAlert(const QJsonArray& hourlyData,
                       const QString& currentWeather,
                       int advanceMinutes,
                       std::function<void(const QString&)> callback);
};

} // namespace LLM

#endif // LLMALERTGENERATOR_H
