#include "SettingsViewModel.h"
#include "../util/Config.h"

namespace ViewModel {

SettingsViewModel::SettingsViewModel(Service::LocationService* locationService,
                                     QObject* parent)
    : QObject(parent), m_locationService(locationService) {}

bool SettingsViewModel::isAutoStart() const {
    return Util::Config::getInstance().isAutoStart();
}

void SettingsViewModel::setAutoStart(bool autoStart) {
    Util::Config::getInstance().setAutoStart(autoStart);
    emit settingsChanged();
}

bool SettingsViewModel::isAutoLocation() const {
    return Util::Config::getInstance().isAutoLocation();
}

QString SettingsViewModel::manualCityName() const {
    return Util::Config::getInstance().getManualCityName();
}

QStringList SettingsViewModel::alertTimeList() const {
    return Util::Config::getInstance().getAlertTimes();
}

void SettingsViewModel::setAutoLocation(bool isAuto) {
    if (isAutoLocation() == isAuto) return;

    auto& config = Util::Config::getInstance();
    if (isAuto) {
        m_locationService->switchToAuto();
    } else {
        // Only switch mode setting — don't trigger weather refresh.
        // Weather will refresh when the user selects a city from CitySelector.
        config.setAutoLocation(false);
    }
    emit settingsChanged();
}

void SettingsViewModel::setManualCity(int adcode, const QString& name) {
    m_locationService->switchToManual(adcode, name);
    emit settingsChanged();
}

void SettingsViewModel::addAlertTime(const QString& time) {
    Util::Config::getInstance().addAlertTime(time);
    emit alertTimeListChanged();
}

void SettingsViewModel::removeAlertTime(const QString& time) {
    Util::Config::getInstance().removeAlertTime(time);
    emit alertTimeListChanged();
}

void SettingsViewModel::updateAlertTime(const QString& oldTime, const QString& newTime) {
    Util::Config::getInstance().updateAlertTime(oldTime, newTime);
    emit alertTimeListChanged();
}

QStringList SettingsViewModel::alertAdvanceList() const {
    return Util::Config::getInstance().getAlertAdvanceMinutes();
}

void SettingsViewModel::setAdvanceMinutes(const QString& alertTime, int minutes) {
    Util::Config::getInstance().setAdvanceMinutesFor(alertTime, minutes);
    emit alertTimeListChanged();
}

int SettingsViewModel::getAdvanceMinutesFor(const QString& alertTime) {
    return Util::Config::getInstance().getAdvanceMinutesFor(alertTime);
}

} // namespace ViewModel
