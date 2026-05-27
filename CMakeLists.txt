cmake_minimum_required(VERSION 3.16)
project(Nimbus VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# 查找所需依赖：Widgets用于系统托盘，Network用于腾讯API请求
find_package(Qt6 6.5 REQUIRED COMPONENTS Core Gui Qml Quick Network Widgets)

# LLM 功能开关：默认关闭，cmake -DWITH_LLM=ON 开启
option(WITH_LLM "Build with LLM-powered weather alerts" OFF)

# 预定义各个阶段的源文件变量
set(TOOL_SRCS
    src/util/Config.cpp
    src/util/TimeUtil.cpp
    src/util/WeatherCode.cpp
    src/util/ScreenHelper.cpp
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

if(WITH_LLM)
    add_compile_definitions(WITH_LLM)
    set(LLM_SRCS
        src/llm/LLMClient.cpp
        src/llm/LLMAlertGenerator.cpp
    )
endif()

set(APP_SRCS
    src/main.cpp
    ${TOOL_SRCS}
    ${DATA_SRCS}
    ${NET_SRCS}
    ${SERVICE_SRCS}
    ${VM_SRCS}
    ${LLM_SRCS}
    resources/resources.qrc
)

# 使用 WIN32 属性隐藏 Windows 默认的控制台黑框
add_executable(Nimbus WIN32 ${APP_SRCS})

# 注册 QML 模块
set(WEATHER_APP_QML_FILES
    qml/MainWindow.qml
    qml/components/Theme.qml
    qml/components/TimePickerDialog.qml
    qml/components/Toolbar.qml
    qml/components/WeatherCard.qml
    qml/components/HourlyCard.qml
    qml/components/NavigationButton.qml
    qml/components/CitySelector.qml
    qml/components/TimeComboBox.qml
    qml/components/APISettingsPane.qml
    qml/views/TodayView.qml
    qml/views/PastView.qml
    qml/views/FutureView.qml
    qml/views/SettingsView.qml
)

if(WITH_LLM)
    list(APPEND WEATHER_APP_QML_FILES qml/components/LLMSettingsPane.qml)
endif()

qt_add_qml_module(Nimbus
    URI "Nimbus"
    VERSION 1.0
    QML_FILES ${WEATHER_APP_QML_FILES}
)

# 链接核心库
target_link_libraries(Nimbus PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::Network
    Qt6::Widgets
)

# Windows: link Shell32 for SHAppBarMessage (DPAPI loaded dynamically at runtime)
if(WIN32)
    target_link_libraries(Nimbus PRIVATE Shell32)
endif()

# 添加测试子目录
enable_testing()
add_subdirectory(tests)
