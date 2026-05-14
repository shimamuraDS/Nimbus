#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QSystemTrayIcon>
#include <QScreen>
#include <QVariantMap>

#include "service/WeatherService.h"
#include "service/LocationService.h"
#include "service/AlertService.h"
#include "service/NotificationManager.h"
#include "viewmodel/WeatherViewModel.h"
#include "viewmodel/SettingsViewModel.h"
#include "viewmodel/TrayViewModel.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    qputenv("QT_QUICK_CONTROLS_STYLE", "Basic");

    QApplication app(argc, argv);

    app.setOrganizationName("EnterpriseCorp");
    app.setOrganizationDomain("enterprise.com");
    app.setApplicationName("WeatherApp");

    // 确保程序关闭最后一个窗口时不退出（托盘常驻）
    QApplication::setQuitOnLastWindowClosed(false);

    // 初始化服务层
    auto* weatherService = new Service::WeatherService(&app);
    auto* locationService = new Service::LocationService(&app);
    auto* alertService = new Service::AlertService(&app);
    auto& notificationMgr = Service::NotificationManager::getInstance();

    // 初始化 ViewModel 层
    auto* weatherViewModel = new ViewModel::WeatherViewModel(weatherService, locationService, &app);
    auto* settingsViewModel = new ViewModel::SettingsViewModel(locationService, &app);
    auto* trayViewModel = new ViewModel::TrayViewModel(&app);

    // 启动预警监控
    alertService->startMonitoring();

    // 初始化 QML 引擎
    QQmlApplicationEngine engine;

    // 获取主屏幕几何信息，传给 QML 做窗口定位
    QScreen* primaryScreen = QGuiApplication::primaryScreen();
    QRect screenGeo = primaryScreen->availableGeometry();
    QVariantMap screenInfo;
    screenInfo["x"] = screenGeo.x();
    screenInfo["y"] = screenGeo.y();
    screenInfo["width"] = screenGeo.width();
    screenInfo["height"] = screenGeo.height();

    // 注册 C++ 对象为 QML 上下文属性
    engine.rootContext()->setContextProperty("weatherViewModel", weatherViewModel);
    engine.rootContext()->setContextProperty("settingsViewModel", settingsViewModel);
    engine.rootContext()->setContextProperty("trayViewModel", trayViewModel);
    engine.rootContext()->setContextProperty("trayIcon", notificationMgr.getTrayIcon());
    engine.rootContext()->setContextProperty("primaryScreen", screenInfo);

    // 托盘图标点击 → 切换窗口显示
    QObject::connect(notificationMgr.getTrayIcon(), &QSystemTrayIcon::activated,
                     trayViewModel, [trayViewModel](QSystemTrayIcon::ActivationReason reason) {
        if (reason == QSystemTrayIcon::Trigger) {
            trayViewModel->toggleWindow();
        }
    });

    // 托盘菜单：显示窗口 / 退出
    QObject::connect(&notificationMgr, &Service::NotificationManager::showWindowRequested,
                     trayViewModel, [trayViewModel]() {
        trayViewModel->showWindow();
    });
    QObject::connect(&notificationMgr, &Service::NotificationManager::quitRequested,
                     &app, &QApplication::quit);

    const QUrl url(QStringLiteral("qrc:/WeatherApp/qml/MainWindow.qml"));
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
