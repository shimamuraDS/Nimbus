#include "LLMClient.h"
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonArray>
#include <QTimer>
#include <QDebug>
#include <memory>

namespace LLM {

LLMClient::LLMClient(QObject* parent) : QObject(parent) {
    m_manager = new QNetworkAccessManager(this);
}

void LLMClient::chat(const QString& apiUrl, const QString& apiKey,
                     const QString& model, const QString& userMessage,
                     std::function<void(const QString&)> callback,
                     int timeoutMs) {
    QString endpoint = apiUrl;
    if (!endpoint.endsWith("/")) endpoint += "/";
    endpoint += "chat/completions";

    QUrl url(endpoint);
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Authorization", ("Bearer " + apiKey).toUtf8());

    QJsonObject body;
    body["model"] = model;
    body["stream"] = false;

    QJsonObject thinking;
    thinking["type"] = "enabled";
    body["thinking"] = thinking;
    body["reasoning_effort"] = "high";

    QJsonArray messages;
    QJsonObject systemMsg;
    systemMsg["role"] = "system";
    systemMsg["content"] = QString::fromUtf8(
        "你是一个简洁实用的天气助手。请用中文回复，语气友好自然，给出实用的出行建议。不要使用夸张或华丽的辞藻。");
    messages.append(systemMsg);

    QJsonObject userMsg;
    userMsg["role"] = "user";
    userMsg["content"] = userMessage;
    messages.append(userMsg);

    body["messages"] = messages;

    QByteArray bodyData = QJsonDocument(body).toJson(QJsonDocument::Compact);
    QNetworkReply* reply = m_manager->post(request, bodyData);

    auto cb = std::make_shared<std::function<void(const QString&)>>(callback);
    auto fired = std::make_shared<bool>(false);

    // 超时定时器
    QTimer* timer = new QTimer(reply);
    timer->setSingleShot(true);
    connect(timer, &QTimer::timeout, reply, [reply, cb, fired]() {
        if (*fired) return;
        *fired = true;
        qWarning() << "[LLMClient] Request timed out";
        reply->abort();
    });
    timer->start(timeoutMs);

    connect(reply, &QNetworkReply::finished, this, [reply, timer, cb, fired]() {
        if (*fired) return;
        *fired = true;
        timer->stop();
        timer->deleteLater();
        reply->deleteLater();

        if (reply->error() != QNetworkReply::NoError) {
            qWarning() << "[LLMClient] Network error:" << reply->errorString();
            if (*cb) (*cb)(QString());
            return;
        }

        QByteArray responseData = reply->readAll();
        QJsonParseError parseError;
        QJsonDocument doc = QJsonDocument::fromJson(responseData, &parseError);
        if (parseError.error != QJsonParseError::NoError) {
            qWarning() << "[LLMClient] JSON parse error:" << parseError.errorString();
            if (*cb) (*cb)(QString());
            return;
        }

        QJsonObject root = doc.object();
        QJsonArray choices = root["choices"].toArray();
        if (choices.isEmpty()) {
            qWarning() << "[LLMClient] No choices in response";
            if (*cb) (*cb)(QString());
            return;
        }

        QString content = choices[0].toObject()["message"].toObject()["content"].toString().trimmed();
        if (*cb) (*cb)(content);
    });
}

} // namespace LLM
