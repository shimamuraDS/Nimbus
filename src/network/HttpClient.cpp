#include "HttpClient.h"
#include <QJsonDocument>
#include <QDebug>

namespace Network {

HttpClient::HttpClient(QObject* parent) : QObject(parent) {
    m_manager = new QNetworkAccessManager(this);
}

HttpClient::~HttpClient() {
}

void HttpClient::sendGetRequest(const QUrl& url,
                                std::function<void(const QJsonObject&)> onSuccess,
                                std::function<void(const QString&)> onError) {
    QNetworkRequest request(url);
    QNetworkReply* reply = m_manager->get(request);

    connect(reply, &QNetworkReply::finished, this, [reply, onSuccess, onError, url]() {
        reply->deleteLater();

        if (reply->error() != QNetworkReply::NoError) {
            if (onError) onError(reply->errorString());
            return;
        }

        QByteArray responseData = reply->readAll();
        qDebug() << "[HttpClient] Response from" << url.toString().left(80) << ":\n" << responseData.left(500);
        QJsonParseError parseError;
        QJsonDocument doc = QJsonDocument::fromJson(responseData, &parseError);

        if (parseError.error != QJsonParseError::NoError || !doc.isObject()) {
            if (onError) onError("JSON parsing error");
            return;
        }

        QJsonObject rootObj = doc.object();
        if (rootObj.contains("status") && rootObj["status"].toInt() != 0) {
            QString errMsg = rootObj["message"].toString();
            qWarning() << "API Error for URL:" << url << "Msg:" << errMsg;
            if (onError) onError(errMsg);
            return;
        }

        if (onSuccess) onSuccess(rootObj);
    });
}

} // namespace Network
