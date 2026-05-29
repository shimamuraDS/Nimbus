#ifndef SETTINGSVIEWMODEL_H
#define SETTINGSVIEWMODEL_H

#include <QObject>
#include <QStringList>
#include "../service/LocationService.h"

namespace ViewModel {

class SettingsViewModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool isAutoLocation READ isAutoLocation NOTIFY settingsChanged)
    Q_PROPERTY(QString manualCityName READ manualCityName NOTIFY settingsChanged)
    Q_PROPERTY(QStringList alertTimeList READ alertTimeList NOTIFY alertTimeListChanged)
    Q_PROPERTY(QStringList alertAdvanceList READ alertAdvanceList NOTIFY alertTimeListChanged)
    Q_PROPERTY(bool isAutoStart READ isAutoStart NOTIFY settingsChanged)
    Q_PROPERTY(QString weatherApiKey READ weatherApiKey WRITE setWeatherApiKey NOTIFY settingsChanged)
    Q_PROPERTY(bool updateAvailable READ isUpdateAvailable NOTIFY updateInfoChanged)
    Q_PROPERTY(QString latestVersion READ latestVersion NOTIFY updateInfoChanged)

public:
    explicit SettingsViewModel(Service::LocationService* locationService, QObject* parent = nullptr);

    bool isAutoLocation() const;
    QString manualCityName() const;
    bool isAutoStart() const;
    QString weatherApiKey() const;
    void setWeatherApiKey(const QString& key);
    QStringList alertTimeList() const;
    QStringList alertAdvanceList() const;

    Q_INVOKABLE void setAutoStart(bool autoStart);
    Q_INVOKABLE void setAutoLocation(bool isAuto);
    Q_INVOKABLE void setManualCity(int adcode, const QString& name);
    Q_INVOKABLE void addAlertTime(const QString& time);
    Q_INVOKABLE void removeAlertTime(const QString& time);
    Q_INVOKABLE void updateAlertTime(const QString& oldTime, const QString& newTime);
    Q_INVOKABLE void setAdvanceMinutes(const QString& alertTime, int minutes);
    Q_INVOKABLE int getAdvanceMinutesFor(const QString& alertTime);
    Q_INVOKABLE void checkForUpdates();
    Q_INVOKABLE void openReleasePage();

    bool isUpdateAvailable() const { return m_updateAvailable; }
    QString latestVersion() const { return m_latestVersion; }

#ifdef WITH_LLM
    Q_PROPERTY(bool llmEnabled READ isLLMEnabled WRITE setLLMEnabled NOTIFY llmSettingsChanged)
    Q_PROPERTY(QString llmApiUrl READ llmApiUrl WRITE setLLMApiUrl NOTIFY llmSettingsChanged)
    Q_PROPERTY(QString llmApiKey READ llmApiKey WRITE setLLMApiKey NOTIFY llmSettingsChanged)
    Q_PROPERTY(QString llmModelName READ llmModelName WRITE setLLMModelName NOTIFY llmSettingsChanged)

    bool isLLMEnabled() const;
    void setLLMEnabled(bool enabled);
    QString llmApiUrl() const;
    void setLLMApiUrl(const QString& url);
    QString llmApiKey() const;
    void setLLMApiKey(const QString& key);
    QString llmModelName() const;
    void setLLMModelName(const QString& model);

    Q_PROPERTY(QString llmTestResult READ llmTestResult NOTIFY llmTestResultChanged)

    Q_INVOKABLE void testLLMConnection();

    QString llmTestResult() const { return m_llmTestResult; }
    void setLLMTestResult(const QString& r) { if (r != m_llmTestResult) { m_llmTestResult = r; emit llmTestResultChanged(); } }
#endif

signals:
    void settingsChanged();
    void alertTimeListChanged();
    void weatherApiKeyChanged();
    void updateInfoChanged();
#ifdef WITH_LLM
    void llmSettingsChanged();
    void llmTestResultChanged();
#endif

private:
    Service::LocationService* m_locationService;
    bool m_updateAvailable = false;
    QString m_latestVersion;
    QString m_releaseUrl;
#ifdef WITH_LLM
    QString m_llmTestResult;
#endif
};

} // namespace ViewModel

#endif // SETTINGSVIEWMODEL_H
