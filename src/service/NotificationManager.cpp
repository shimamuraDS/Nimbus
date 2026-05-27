#include "NotificationManager.h"
#include <QIcon>
#include <QApplication>

namespace Service {

NotificationManager& NotificationManager::getInstance() {
    static NotificationManager instance;
    return instance;
}

NotificationManager::NotificationManager() {
    m_trayIcon = new QSystemTrayIcon(this);
    m_trayIcon->setIcon(QIcon(QCoreApplication::applicationDirPath() + "/Nimbus.ico"));
    m_trayIcon->setToolTip("Nimbus");

    m_trayMenu = new QMenu();
    QAction* showAction = m_trayMenu->addAction(QString::fromUtf8("显示窗口"));
    QAction* quitAction = m_trayMenu->addAction(QString::fromUtf8("退出"));

    connect(showAction, &QAction::triggered, this, &NotificationManager::showWindowRequested);
    connect(quitAction, &QAction::triggered, this, &NotificationManager::quitRequested);

    m_trayIcon->setContextMenu(m_trayMenu);
    m_trayIcon->show();
}

QSystemTrayIcon* NotificationManager::getTrayIcon() const {
    return m_trayIcon;
}

void NotificationManager::showWeatherAlert(const QString& title, const QString& content) {
    if (m_trayIcon && m_trayIcon->isVisible()) {
        m_trayIcon->showMessage(title, content, QSystemTrayIcon::Warning, 10000);
    }
}

} // namespace Service
