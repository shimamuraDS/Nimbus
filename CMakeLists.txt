cmake_minimum_required(VERSION 3.16)
project(WeatherApp VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# 查找所需依赖：Widgets用于系统托盘，Network用于腾讯API请求
find_package(Qt6 6.5 REQUIRED COMPONENTS Core Gui Qml Quick Network Widgets)

# 预定义各个阶段的源文件变量
set(TOOL_SRCS
    src/util/Config.cpp
    src/util/TimeUtil.cpp
    src/util/WeatherCode.cpp
)
set(DATA_SRCS
    src/data/WeatherCacheManager.cpp
)
set(NET_SRCS
    src/network/HttpClient.cpp
    src/network/TencentApiClient.cpp
)
set(SERVICE_SRCS
    src/service/WeatherService.cpp
    src/service/LocationService.cpp
    src/service/AlertService.cpp
    src/service/NotificationManager.cpp
)
set(VM_SRCS
    src/viewmodel/WeatherViewModel.cpp
    src/viewmodel/SettingsViewModel.cpp
    src/viewmodel/TrayViewModel.cpp
)

set(APP_SRCS
    src/main.cpp
    ${TOOL_SRCS}
    ${DATA_SRCS}
    ${NET_SRCS}
    ${SERVICE_SRCS}
    ${VM_SRCS}
    resources/resources.qrc
)

# 使用 WIN32 属性隐藏 Windows 默认的控制台黑框
add_executable(WeatherApp WIN32 ${APP_SRCS})

# 注册 QML 模块
qt_add_qml_module(WeatherApp
    URI "WeatherApp"
    VERSION 1.0
    QML_FILES
        qml/MainWindow.qml
        qml/components/Theme.qml
        qml/components/Toolbar.qml
        qml/components/WeatherCard.qml
        qml/components/NavigationButton.qml
        qml/components/TimePicker.qml
        qml/components/CitySelector.qml
        qml/views/TodayView.qml
        qml/views/PastView.qml
        qml/views/FutureView.qml
        qml/views/SettingsView.qml
)

# 链接核心库
target_link_libraries(WeatherApp PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::Network
    Qt6::Widgets
)

# 添加测试子目录
enable_testing()
add_subdirectory(tests)
