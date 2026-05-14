#include <QtQml/qqmlprivate.h>
#include <QtCore/qdir.h>
#include <QtCore/qurl.h>
#include <QtCore/qhash.h>
#include <QtCore/qstring.h>

namespace QmlCacheGeneratedCode {
namespace _0x5f_WeatherApp_qml_MainWindow_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_WeatherApp_qml_components_Toolbar_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_WeatherApp_qml_components_WeatherCard_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_WeatherApp_qml_components_NavigationButton_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_WeatherApp_qml_components_TimePicker_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_WeatherApp_qml_components_CitySelector_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_WeatherApp_qml_views_TodayView_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_WeatherApp_qml_views_PastView_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_WeatherApp_qml_views_FutureView_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_WeatherApp_qml_views_SettingsView_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}

}
namespace {
struct Registry {
    Registry();
    ~Registry();
    QHash<QString, const QQmlPrivate::CachedQmlUnit*> resourcePathToCachedUnit;
    static const QQmlPrivate::CachedQmlUnit *lookupCachedUnit(const QUrl &url);
};

Q_GLOBAL_STATIC(Registry, unitRegistry)


Registry::Registry() {
    resourcePathToCachedUnit.insert(QStringLiteral("/WeatherApp/qml/MainWindow.qml"), &QmlCacheGeneratedCode::_0x5f_WeatherApp_qml_MainWindow_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/WeatherApp/qml/components/Toolbar.qml"), &QmlCacheGeneratedCode::_0x5f_WeatherApp_qml_components_Toolbar_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/WeatherApp/qml/components/WeatherCard.qml"), &QmlCacheGeneratedCode::_0x5f_WeatherApp_qml_components_WeatherCard_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/WeatherApp/qml/components/NavigationButton.qml"), &QmlCacheGeneratedCode::_0x5f_WeatherApp_qml_components_NavigationButton_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/WeatherApp/qml/components/TimePicker.qml"), &QmlCacheGeneratedCode::_0x5f_WeatherApp_qml_components_TimePicker_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/WeatherApp/qml/components/CitySelector.qml"), &QmlCacheGeneratedCode::_0x5f_WeatherApp_qml_components_CitySelector_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/WeatherApp/qml/views/TodayView.qml"), &QmlCacheGeneratedCode::_0x5f_WeatherApp_qml_views_TodayView_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/WeatherApp/qml/views/PastView.qml"), &QmlCacheGeneratedCode::_0x5f_WeatherApp_qml_views_PastView_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/WeatherApp/qml/views/FutureView.qml"), &QmlCacheGeneratedCode::_0x5f_WeatherApp_qml_views_FutureView_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/WeatherApp/qml/views/SettingsView.qml"), &QmlCacheGeneratedCode::_0x5f_WeatherApp_qml_views_SettingsView_qml::unit);
    QQmlPrivate::RegisterQmlUnitCacheHook registration;
    registration.structVersion = 0;
    registration.lookupCachedQmlUnit = &lookupCachedUnit;
    QQmlPrivate::qmlregister(QQmlPrivate::QmlUnitCacheHookRegistration, &registration);
}

Registry::~Registry() {
    QQmlPrivate::qmlunregister(QQmlPrivate::QmlUnitCacheHookRegistration, quintptr(&lookupCachedUnit));
}

const QQmlPrivate::CachedQmlUnit *Registry::lookupCachedUnit(const QUrl &url) {
    if (url.scheme() != QLatin1String("qrc"))
        return nullptr;
    QString resourcePath = QDir::cleanPath(url.path());
    if (resourcePath.isEmpty())
        return nullptr;
    if (!resourcePath.startsWith(QLatin1Char('/')))
        resourcePath.prepend(QLatin1Char('/'));
    return unitRegistry()->resourcePathToCachedUnit.value(resourcePath, nullptr);
}
}
int QT_MANGLE_NAMESPACE(qInitResources_qmlcache_WeatherApp)() {
    ::unitRegistry();
    return 1;
}
Q_CONSTRUCTOR_FUNCTION(QT_MANGLE_NAMESPACE(qInitResources_qmlcache_WeatherApp))
int QT_MANGLE_NAMESPACE(qCleanupResources_qmlcache_WeatherApp)() {
    return 1;
}
