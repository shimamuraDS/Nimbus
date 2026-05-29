#ifndef GITHUBRELEASECLIENT_H
#define GITHUBRELEASECLIENT_H

#include <QObject>
#include <QNetworkAccessManager>

namespace Network {

class GitHubReleaseClient : public QObject {
    Q_OBJECT
public:
    explicit GitHubReleaseClient(QObject* parent = nullptr);

    void checkLatestRelease(const QString& repoOwner, const QString& repoName);

signals:
    void releaseInfoFetched(const QString& tagName, const QString& htmlUrl);
    void errorOccurred(const QString& message);

private:
    QNetworkAccessManager* m_manager;
};

} // namespace Network

#endif // GITHUBRELEASECLIENT_H
