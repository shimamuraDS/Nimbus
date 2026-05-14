#ifndef HTTPCLIENT_H
#define HTTPCLIENT_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonObject>
#include <functional>

namespace Network {

class HttpClient : public QObject {
    Q_OBJECT
public:
    explicit HttpClient(QObject* parent = nullptr);
    virtual ~HttpClient();

protected:
    void sendGetRequest(const QUrl& url,
                        std::function<void(const QJsonObject&)> onSuccess,
                        std::function<void(const QString&)> onError);

private:
    QNetworkAccessManager* m_manager;
};

} // namespace Network

#endif // HTTPCLIENT_H
