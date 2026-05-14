/****************************************************************************
** Meta object code from reading C++ file 'WeatherViewModel.h'
**
** Created by: The Qt Meta Object Compiler version 68 (Qt 6.8.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../src/viewmodel/WeatherViewModel.h"
#include <QtNetwork/QSslError>
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'WeatherViewModel.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 68
#error "This file was generated using the moc from 6.8.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN9ViewModel16WeatherViewModelE_t {};
} // unnamed namespace


#ifdef QT_MOC_HAS_STRINGDATA
static constexpr auto qt_meta_stringdata_ZN9ViewModel16WeatherViewModelE = QtMocHelpers::stringData(
    "ViewModel::WeatherViewModel",
    "currentCityChanged",
    "",
    "weatherDataChanged",
    "alertTimeListChanged",
    "locationModeChanged",
    "isLoadingChanged",
    "isOfflineChanged",
    "onLocationChanged",
    "adcode",
    "cityName",
    "onWeatherDataUpdated",
    "requestData",
    "switchLocationMode",
    "addAlertTime",
    "time",
    "removeAlertTime",
    "currentCity",
    "todayWeather",
    "QVariantMap",
    "pastWeatherList",
    "QVariantList",
    "futureWeatherList",
    "alertTimeList",
    "isAutoLocation",
    "isLoading",
    "isOffline"
);
#else  // !QT_MOC_HAS_STRINGDATA
#error "qtmochelpers.h not found or too old."
#endif // !QT_MOC_HAS_STRINGDATA

Q_CONSTINIT static const uint qt_meta_data_ZN9ViewModel16WeatherViewModelE[] = {

 // content:
      12,       // revision
       0,       // classname
       0,    0, // classinfo
      12,   14, // methods
       8,  106, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       6,       // signalCount

 // signals: name, argc, parameters, tag, flags, initial metatype offsets
       1,    0,   86,    2, 0x06,    9 /* Public */,
       3,    0,   87,    2, 0x06,   10 /* Public */,
       4,    0,   88,    2, 0x06,   11 /* Public */,
       5,    0,   89,    2, 0x06,   12 /* Public */,
       6,    0,   90,    2, 0x06,   13 /* Public */,
       7,    0,   91,    2, 0x06,   14 /* Public */,

 // slots: name, argc, parameters, tag, flags, initial metatype offsets
       8,    2,   92,    2, 0x08,   15 /* Private */,
      11,    0,   97,    2, 0x08,   18 /* Private */,

 // methods: name, argc, parameters, tag, flags, initial metatype offsets
      12,    0,   98,    2, 0x02,   19 /* Public */,
      13,    0,   99,    2, 0x02,   20 /* Public */,
      14,    1,  100,    2, 0x02,   21 /* Public */,
      16,    1,  103,    2, 0x02,   23 /* Public */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,

 // slots: parameters
    QMetaType::Void, QMetaType::Int, QMetaType::QString,    9,   10,
    QMetaType::Void,

 // methods: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString,   15,
    QMetaType::Void, QMetaType::QString,   15,

 // properties: name, type, flags, notifyId, revision
      17, QMetaType::QString, 0x00015001, uint(0), 0,
      18, 0x80000000 | 19, 0x00015009, uint(1), 0,
      20, 0x80000000 | 21, 0x00015009, uint(1), 0,
      22, 0x80000000 | 21, 0x00015009, uint(1), 0,
      23, QMetaType::QStringList, 0x00015001, uint(2), 0,
      24, QMetaType::Bool, 0x00015001, uint(3), 0,
      25, QMetaType::Bool, 0x00015001, uint(4), 0,
      26, QMetaType::Bool, 0x00015001, uint(5), 0,

       0        // eod
};

Q_CONSTINIT const QMetaObject ViewModel::WeatherViewModel::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_ZN9ViewModel16WeatherViewModelE.offsetsAndSizes,
    qt_meta_data_ZN9ViewModel16WeatherViewModelE,
    qt_static_metacall,
    nullptr,
    qt_incomplete_metaTypeArray<qt_meta_tag_ZN9ViewModel16WeatherViewModelE_t,
        // property 'currentCity'
        QtPrivate::TypeAndForceComplete<QString, std::true_type>,
        // property 'todayWeather'
        QtPrivate::TypeAndForceComplete<QVariantMap, std::true_type>,
        // property 'pastWeatherList'
        QtPrivate::TypeAndForceComplete<QVariantList, std::true_type>,
        // property 'futureWeatherList'
        QtPrivate::TypeAndForceComplete<QVariantList, std::true_type>,
        // property 'alertTimeList'
        QtPrivate::TypeAndForceComplete<QStringList, std::true_type>,
        // property 'isAutoLocation'
        QtPrivate::TypeAndForceComplete<bool, std::true_type>,
        // property 'isLoading'
        QtPrivate::TypeAndForceComplete<bool, std::true_type>,
        // property 'isOffline'
        QtPrivate::TypeAndForceComplete<bool, std::true_type>,
        // Q_OBJECT / Q_GADGET
        QtPrivate::TypeAndForceComplete<WeatherViewModel, std::true_type>,
        // method 'currentCityChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'weatherDataChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'alertTimeListChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'locationModeChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'isLoadingChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'isOfflineChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'onLocationChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        // method 'onWeatherDataUpdated'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'requestData'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'switchLocationMode'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'addAlertTime'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        // method 'removeAlertTime'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>
    >,
    nullptr
} };

void ViewModel::WeatherViewModel::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<WeatherViewModel *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->currentCityChanged(); break;
        case 1: _t->weatherDataChanged(); break;
        case 2: _t->alertTimeListChanged(); break;
        case 3: _t->locationModeChanged(); break;
        case 4: _t->isLoadingChanged(); break;
        case 5: _t->isOfflineChanged(); break;
        case 6: _t->onLocationChanged((*reinterpret_cast< std::add_pointer_t<int>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[2]))); break;
        case 7: _t->onWeatherDataUpdated(); break;
        case 8: _t->requestData(); break;
        case 9: _t->switchLocationMode(); break;
        case 10: _t->addAlertTime((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 11: _t->removeAlertTime((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _q_method_type = void (WeatherViewModel::*)();
            if (_q_method_type _q_method = &WeatherViewModel::currentCityChanged; *reinterpret_cast<_q_method_type *>(_a[1]) == _q_method) {
                *result = 0;
                return;
            }
        }
        {
            using _q_method_type = void (WeatherViewModel::*)();
            if (_q_method_type _q_method = &WeatherViewModel::weatherDataChanged; *reinterpret_cast<_q_method_type *>(_a[1]) == _q_method) {
                *result = 1;
                return;
            }
        }
        {
            using _q_method_type = void (WeatherViewModel::*)();
            if (_q_method_type _q_method = &WeatherViewModel::alertTimeListChanged; *reinterpret_cast<_q_method_type *>(_a[1]) == _q_method) {
                *result = 2;
                return;
            }
        }
        {
            using _q_method_type = void (WeatherViewModel::*)();
            if (_q_method_type _q_method = &WeatherViewModel::locationModeChanged; *reinterpret_cast<_q_method_type *>(_a[1]) == _q_method) {
                *result = 3;
                return;
            }
        }
        {
            using _q_method_type = void (WeatherViewModel::*)();
            if (_q_method_type _q_method = &WeatherViewModel::isLoadingChanged; *reinterpret_cast<_q_method_type *>(_a[1]) == _q_method) {
                *result = 4;
                return;
            }
        }
        {
            using _q_method_type = void (WeatherViewModel::*)();
            if (_q_method_type _q_method = &WeatherViewModel::isOfflineChanged; *reinterpret_cast<_q_method_type *>(_a[1]) == _q_method) {
                *result = 5;
                return;
            }
        }
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QString*>(_v) = _t->currentCity(); break;
        case 1: *reinterpret_cast< QVariantMap*>(_v) = _t->todayWeather(); break;
        case 2: *reinterpret_cast< QVariantList*>(_v) = _t->pastWeatherList(); break;
        case 3: *reinterpret_cast< QVariantList*>(_v) = _t->futureWeatherList(); break;
        case 4: *reinterpret_cast< QStringList*>(_v) = _t->alertTimeList(); break;
        case 5: *reinterpret_cast< bool*>(_v) = _t->isAutoLocation(); break;
        case 6: *reinterpret_cast< bool*>(_v) = _t->isLoading(); break;
        case 7: *reinterpret_cast< bool*>(_v) = _t->isOffline(); break;
        default: break;
        }
    }
}

const QMetaObject *ViewModel::WeatherViewModel::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *ViewModel::WeatherViewModel::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_ZN9ViewModel16WeatherViewModelE.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int ViewModel::WeatherViewModel::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 12)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 12;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 12)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 12;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 8;
    }
    return _id;
}

// SIGNAL 0
void ViewModel::WeatherViewModel::currentCityChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void ViewModel::WeatherViewModel::weatherDataChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void ViewModel::WeatherViewModel::alertTimeListChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void ViewModel::WeatherViewModel::locationModeChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void ViewModel::WeatherViewModel::isLoadingChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void ViewModel::WeatherViewModel::isOfflineChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 5, nullptr);
}
QT_WARNING_POP
