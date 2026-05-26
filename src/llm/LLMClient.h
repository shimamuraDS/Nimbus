#ifndef LLMCLIENT_H
#define LLMCLIENT_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QJsonObject>
#include <functional>

namespace LLM {

class LLMClient : public QObject {
    Q_OBJECT
public:
    explicit LLMClient(QObject* parent = nullptr);

    // 发送 chat completions 请求（OpenAI 兼容格式）
    // 成功时回调生成的文本，失败时回调空字符串
    void chat(const QString& apiUrl, const QString& apiKey,
              const QString& model, const QString& userMessage,
              std::function<void(const QString&)> callback,
              int timeoutMs = 10000);

private:
    QNetworkAccessManager* m_manager;
};

} // namespace LLM

#endif // LLMCLIENT_H
