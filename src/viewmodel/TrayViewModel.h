#ifndef TRAYVIEWMODEL_H
#define TRAYVIEWMODEL_H

#include <QObject>

namespace ViewModel {

class TrayViewModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool windowVisible READ windowVisible WRITE setWindowVisible NOTIFY windowVisibleChanged)

public:
    explicit TrayViewModel(QObject* parent = nullptr);

    bool windowVisible() const;
    void setWindowVisible(bool visible);

    Q_INVOKABLE void toggleWindow();
    Q_INVOKABLE void showWindow();
    Q_INVOKABLE void hideWindow();
    Q_INVOKABLE void quitApp();

signals:
    void windowVisibleChanged();

private:
    bool m_windowVisible;
};

} // namespace ViewModel

#endif // TRAYVIEWMODEL_H
