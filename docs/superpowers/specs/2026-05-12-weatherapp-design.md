# 天气提醒应用 - 设计规格文档

## 一、项目概述

*   **项目名称**：WeatherApp
*   **技术栈**：C++17/20, Qt 6.5 LTS (QML + C++), CMake 构建系统
*   **运行平台**：Windows 桌面端 (系统托盘驻留应用)
*   **核心功能概述**：
    1.  **天气查看**：展示当日早晚、过去7天早晚、未来7天早晚的天气情况（天气、气温、湿度）。
    2.  **智能定位**：支持基于 IP 的自动定位及手动城市选择双轨机制。
    3.  **异常天气预警**：基于最新的逐小时预报及官方预警数据，在用户设定的时间点触发 Windows 原生弹窗提醒。
    4.  **隐式运行**：界面常驻系统托盘，窗口大小不超过屏幕面积的 1/12。

---

## 二、项目目录结构

```text
WeatherApp/
├── CMakeLists.txt              # 核心构建脚本
├── config.ini                  # 本地配置文件 (存储 API Key，避免硬编码)
├── idea.md                     # 原始需求文档
├── README.md
├── docs/
│   ├── api-design.md           # 接口文档
│   ├── dev-guide.md            # 开发文档
│   ├── requirements.md         # 需求说明
│   └── user-guide.md           # 使用说明
├── src/                        # C++ 源代码
│   ├── main.cpp                # 应用程序入口
│   ├── data/
│   │   └── WeatherCacheManager.h/.cpp  # JSON 本地缓存管理 (逐小时hourly_data)
│   ├── service/
│   │   ├── WeatherService.h/.cpp       # 天气数据获取与处理
│   │   ├── LocationService.h/.cpp      # 定位服务(IP自动+手动)
│   │   ├── AlertService.h/.cpp         # 异常天气检测与提醒调度
│   │   └── NotificationManager.h/.cpp  # 封装 Windows 弹窗提醒系统
│   ├── viewmodel/
│   │   ├── WeatherViewModel.h/.cpp     # QML 与 C++ 的数据桥梁
│   │   ├── SettingsViewModel.h/.cpp    # 设置数据绑定
│   │   └── TrayViewModel.h/.cpp        # 托盘与通知管理
│   ├── network/
│   │   ├── HttpClient.h/.cpp           # QNetworkAccessManager封装
│   │   └── TencentApiClient.h/.cpp     # 腾讯LBS API调用
│   └── util/
│       ├── Config.h/.cpp               # QSettings + config.ini配置管理
│       ├── WeatherCode.h/.cpp          # 天气代码映射(图标/描述)
│       └── TimeUtil.h/.cpp             # 时间处理工具
├── qml/                        # UI 层代码
│   ├── MainWindow.qml          # 主窗口容器 (StackView 路由 + 过渡动画)
│   ├── views/
│   │   ├── TodayView.qml       # 当日天气界面
│   │   ├── PastView.qml        # 过去7天天气界面
│   │   ├── FutureView.qml      # 未来7天天气界面
│   │   └── SettingsView.qml    # 设置与提醒时间配置界面
│   └── components/
│       ├── Theme.qml           # 全局深色玻璃态视觉主题定义
│       ├── Toolbar.qml         # 顶部导航工具栏(透明融入背景)
│       ├── WeatherCard.qml     # 天气卡片(早晚,玻璃态+阴影)
│       ├── NavigationButton.qml# 圆形导航按钮(hover+缩放动画)
│       ├── TimePicker.qml      # 深色风格时间选择器
│       └── CitySelector.qml    # 城市选择器(98个城市)
├── resources/
│   ├── resources.qrc           # Qt资源文件
│   ├── app.rc                  # Windows资源(图标等)
│   └── icons/                  # PNG图标
├── tests/                      # 单元与集成测试
│   ├── CMakeLists.txt
│   ├── tst_HourlyMerge.cpp
│   ├── tst_AlertCondition.cpp
│   └── tst_HttpService.cpp
└── scripts/                    # 打包与部署脚本
    └── setup.iss               # Inno Setup 安装包脚本
```

---

## 三、API接口设计

### 0. 密钥配置与管理

*   **安全策略**：废除硬编码，应用启动时由 `QSettings` 读取根目录 `config.ini` 中的 `[API]/DeveloperKey` 字段进行接口鉴权。

### 1. 腾讯IP定位API

*   **请求URL**：`GET https://apis.map.qq.com/ws/location/v1/ip`
*   **请求参数**：传入开发密钥 `key`。自动模式下缺省 `ip` 参数获取当前端 IP。
*   **返回字段映射**：提取 `result.ad_info.city` 与 `result.ad_info.adcode`。

### 2. 腾讯天气API (多维度组合调用)

为了满足业务需求，后台统一周期性拉取以下三个维度的数据：

**A. 逐小时天气 (构建1小时粒度数据网)**
*   **参数**：`type=hours`（未来24小时天气预报，起始时间为当前时间的前一个小时）。
*   **解析**：提取 `result.forecast_hours[0].infos` 数组，解析每个对象的 `hour` (如 2026-05-13 13:00:00) 和 `info` 节点下的 `weather` (天气描述)、`temperature` (温度)、`wind_direction` (风向)、`wind_power` (风力)。

**B. 实时与预警天气 (高优异常触发)**
*   **参数**：`type=now&added_fields=alarm`。
*   **解析**：提取 `result.realtime[0].alarms` 数组用于高优先级官方预警通知。

**C. 未来多日预报 (常规7天渲染)**
*   **参数**：`type=future&get_md=1` (当天加未来6天，共7天数据)。
*   **解析**：提取 `result.forecast[0].infos` 数组，解析 `day` 和 `night` 节点。

### 3. 异常天气判断标准

*   **高优触发**：`result.alarms` 数组非空，直接判定为异常预警天气。
*   **兜底触发**：遍历 `hourly_data` 中未来3小时内的逐小时预报，若 `weather` 字段包含"雷阵雨伴有冰雹"、"暴雨"、"大暴雨"、"特大暴雨"、"冻雨"、"沙尘暴"、"强沙尘暴"等极端关键字，判定为异常。

---

## 四、数据模型设计

### 1. JSON缓存文件结构 (`hourly_data` 核心机制)

充分利用 `type=hours` 接口，将获取的逐小时预报以小时为单位滚动存入本地缓存，形成连续的时间序列。过去7天的天气也从该序列中按每日早(08:00)/晚(20:00)进行聚合截取。

```json
{
  "adcode": 130681,
  "last_fetch_time": "2026-05-12T16:00:00",
  "hourly_data": [
    {
      "hour": "2026-05-11 08:00",
      "info": {
        "weather": "晴",
        "temperature": 25,
        "wind_direction": "东北风",
        "wind_power": "1-2级"
      }
    }
  ],
  "future_forecast": [
    {
      "date": "2026-05-12",
      "day": {"weather": "晴", "temperature": 26, "humidity": 40},
      "night": {"weather": "多云", "temperature": 19, "humidity": 55}
    }
  ],
  "current_alarms": []
}
```

*注：每次 `type=hours` 请求成功后，根据 `hour` 时间戳去重并合并至 `hourly_data`，同时清理超过7天的历史记录。*

### 2. QSettings 键值设计

*   `Location/IsAuto` (bool)：自动定位开启状态。
*   `Location/ManualAdcode` (int) / `Location/ManualCityName` (QString)：手动选择的城市信息。
*   `Alerts/Times` (QStringList)：提醒时间点列表。

### 3. C++数据结构定义

```cpp
// 小时级天气记录 — 直接以 QJsonObject 存储于 hourly_data 数组，格式见 JSON 缓存结构

// 日常早晚天气记录封装 (定义于 WeatherCacheManager.h)
struct DailyWeather {
    QString date;
    QString dayWeather;
    int dayTemp;
    int dayHumidity;
    QString nightWeather;
    int nightTemp;
    int nightHumidity;
};

// 预警信息 — 直接以 QJsonArray 存储，通过 alarms API 获取
```

---

## 五、组件详细设计

### 1. C++类职责与接口

*   **`HttpClient` (网络层)**：封装 `QNetworkAccessManager`，处理所有HTTP请求与JSON基础解析。
*   **`TencentApiClient` (网络层)**：继承/使用 HttpClient，提供 `fetchLocation()`、`fetchAllWeatherInfo()`（内部并发调用 hours, future, now 接口合并结果）。
*   **`WeatherService` (业务层)**：天气数据获取与处理，协调 API 调用和缓存更新。
*   **`LocationService` (业务层)**：管理自动/手动定位逻辑。
*   **`AlertService` (业务层)**：异常天气检测、定时调度、提醒触发。基于本地缓存判定（不再直接发起网络请求）。
*   **`WeatherCacheManager` (数据层)**：负责 JSON `hourly_data` 队列的维护，提供 `getPastSevenDays()` 方法（在 `hourly_data` 中筛选过去7天 08:00 和 20:00 的节点作为早晚天气）。
*   **`WeatherViewModel` (ViewModel层)**：
    *   **Q_PROPERTY**：暴露 `currentCity`, `todayWeather`, `pastWeatherList`, `futureWeatherList`, `alertTimeList` 供 UI 绑定。
    *   **Q_INVOKABLE**：供界面调用的交互接口，如 `switchLocationMode()`, `addAlertTime(QString time)`, `removeAlertTime(QString time)`。
*   **`SettingsViewModel` (ViewModel层)**：设置数据绑定，管理定位模式和提醒时间。
*   **`TrayViewModel` (ViewModel层)**：托盘图标与通知窗口管理。
*   **`NotificationManager` (服务层)**：封装 `QSystemTrayIcon` 或 WinRT API 发送系统通知。
*   **`Config` (工具层)**：QSettings + config.ini 配置读写封装。

### 2. QML组件树与明确的交互状态机

*   **`MainWindow`**：无边框窗口，宽乘高严格控制在 `< (Screen.width * Screen.height) / 12` 范围内。关联 `SystemTrayIcon` 实现驻留运行。
*   **`Toolbar`**：位于上方，最右方设置按键与 ViewModel 状态绑定，在设置页与主页之间切换图标样式（设置/返回）。
*   **`StackView` (页面导航)**：
    *   `TodayView`：中心渲染 `todayWeather` 绑定的早晚数据。左侧按键 Push 到 `PastView`，右侧按键 Push 到 `FutureView`。
    *   `PastView`：渲染 `pastWeatherList` 列表，标题"过去 7 天"，暖金色卡片（`isPast: true`），右侧按键 Pop 返回主页。卡片水平居中，两侧对称间距。
    *   `FutureView`：渲染 `futureWeatherList` 列表，标题"未来 7 天"，冷蓝色卡片（默认），左侧按键 Pop 返回主页。卡片水平居中，两侧对称间距。
    *   `SettingsView`（定位切换与提醒管理）：
        *   **状态 A（自动定位中）**：
            *   UI 展示：`自动定位：【当前城市名】` + 超链接样式的 `定位不准？` 按钮（蓝色下划线，仅此部分可点击）。
            *   交互行为：点击 `定位不准？` 切换至手动模式，显示城市下拉框。
        *   **状态 B（手动定位中）**：
            *   UI 展示：`选择城市：` 标签 + 城市下拉框（内置 98 个全国城市）+ `返回自动定位` 链接。
            *   交互行为：用户从下拉框选择城市后天气立即更新。点击 `返回自动定位` 恢复 IP 定位。
        *   时间管理：绑定 `alertTimeList`。常驻"添加时间点"按钮；添加后，每项尾部附带红色"删除"按钮。
*   **`WeatherCard`**：天气卡片组件，显示早晚天气、气温、湿度。通过 `isPast` 属性切换暖金（过去）与冷蓝（未来）背景色变体。
*   **`NavigationButton`**：导航按钮组件（左/右箭头）。
*   **`TimePicker`**：时间选择器组件。
*   **`CitySelector`**：城市选择器组件。

### 3. 信号槽连接设计

*   **视图驱动**：`StackView` 加载或定时器触发时，调用 `ViewModel::requestData()` → `TencentApiClient` 发送 GET 请求 → 收到响应 `weatherDataReady()` → ViewModel 更新 `Q_PROPERTY` → 触发 QML 端数据变化。
*   **托盘交互**：连接 `SystemTrayIcon::activated` 信号，根据 `QSystemTrayIcon::ActivationReason` 判定左键点击，控制主窗口 `setVisible(true)` 并计算坐标停靠于屏幕右下角任务栏上方。
*   **定位切换**：`SettingsViewModel::switchLocationMode()` 触发 → `LocationService` 切换模式 → 更新 `Q_PROPERTY` → QML 自动刷新定位显示。
*   **提醒调度**：`AlertService` 内部 `QTimer` → 时间匹配 → 读取本地缓存 `hourly_data` 和 `current_alarms` 判定异常 → `NotificationManager::showAlert`。

---

## 六、异常天气提醒设计

### 1. 统一数据刷新周期（避免过度轮询）

*   **策略**：天气数据在应用启动与定位变更时统一拉取最新数据（含 `hours`, `now`, `future`），将最新预警存入内存和 JSON 缓存。

### 2. 基于逐小时数据的双重检查策略

前端运行轻量级每分钟 `QTimer` 对比当前时间与配置中的提醒时间列表（`Alerts/Times`）：

*   当系统时间匹配设定的提醒时间时，直接从**本地缓存**中读取数据进行双重判定：
    1.  **官方预警命中**：缓存中 `current_alarms` 数组非空（来源于最近一次 `type=now&added_fields=alarm` 请求）。
    2.  **逐小时恶劣天气命中**：遍历 `hourly_data` 中**未来 3 小时内**的逐小时预报。若其 `weather` 字段包含"暴雨"、"冰雹"、"沙尘暴"、"冻雨"等极端关键字，判定为异常。

### 3. Windows原生通知格式

由 `NotificationManager` 生成弹窗：

*   **通知标题**：若为预警命中，则展示预警名称（如"北京市海淀区发布大雾黄色预警"）。若为逐小时命中，则展示"极端天气提醒：未来数小时将有大暴雨"。
*   **通知内容**：预警发布内容或逐小时防范指南。

---

## 七、CMake构建配置

### 1. 完整 CMakeLists.txt

```cmake
cmake_minimum_required(VERSION 3.16)
project(WeatherApp VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Gui Qml Quick Network Widgets)

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

qt_add_qml_module(WeatherApp URI "WeatherApp" VERSION 1.0
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

target_link_libraries(WeatherApp PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::Network
    Qt6::Widgets
)

enable_testing()
add_subdirectory(tests)
```

### 2. 依赖库说明

*   `Qt6::Network` — HTTPS 证书与接口通信
*   `Qt6::Widgets` — `QSystemTrayIcon` 系统托盘支持

---

## 八、测试策略

### 1. 单元测试（QtTest）

*   `tst_HourlyMerge`：测试 `WeatherCacheManager` 能否正确将新请求的逐小时数据去重并追加合并至 `hourly_data` 缓存中，同时验证去重逻辑（同时间点数据覆盖更新）。
*   `tst_AlertCondition`：输入预设恶劣天气的 `hourly_data` 模拟数据，断言在目标提醒时间时是否能正确拦截到"未来3小时内的暴雪"并触发警报。
*   `tst_HttpService`：Mock `QNetworkAccessManager` 返回本地 JSON，验证天气、定位数据的解析是否正确映射到 C++ 结构体。

### 2. QML集成测试

*   验证 SettingsPage 在点击 `[定位不准？]` 后，组件是否发生状态流转，且配置属性发生变更。
*   验证左、右切换按键触发后，`StackView.currentItem` 是否正确变为对应页面。

### 3. 测试用例列表

1.  **自动定位成功流**：网络畅通时，应用获取 IP → 请求 `adcode` → 加载当地天气 → 渲染视图全流程是否通畅。
2.  **断网/弱网容灾容错**：断网状态启动，是否能正常加载本地 JSON 缓存展示，并给予界面提示。
3.  **时间命中触发提醒**：将系统时间调整为设定时间前一分钟，等待至整点，验证 `AlertService` 被正确唤起。
4.  **手动切换定位**：验证从自动定位切换到手动选择城市后，天气数据是否正确刷新。

---

## 九、打包部署方案

### 1. windeployqt 配置

```bat
windeployqt --qmldir ../qml --release ./WeatherApp.exe
```

### 2. Inno Setup 安装包脚本 (`setup.iss`)

```pascal
[Setup]
AppName=WeatherApp
AppVersion=1.0
DefaultDirName={pf}\WeatherApp
OutputDir=.\Installer
OutputBaseFilename=WeatherApp_Setup

[Files]
Source: "..\build-release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\WeatherApp"; Filename: "{app}\WeatherApp.exe"
Name: "{commondesktop}\WeatherApp"; Filename: "{app}\WeatherApp.exe"

[Registry]
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run";
ValueType: string; ValueName: "WeatherApp"; ValueData: "{app}\WeatherApp.exe -hidden"

[UninstallDelete]
Type: files; Name: "{localappdata}\WeatherApp\weather_cache.json"
Type: files; Name: "{localappdata}\EnterpriseCorp\WeatherApp\weather_cache.json"
```

### 3. 开机自启与卸载清理

*   **静默自启**：安装时将应用路径写入注册表 `HKCU\Software\Microsoft\Windows\CurrentVersion\Run`。
*   **彻底卸载**：卸载时清理用户目录下的 `weather_cache.json` 与 `QSettings` 注册表残留项。
