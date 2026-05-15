# 开发指南

## 1. 项目结构与分层架构

项目严格遵循 **MVVM (Model-View-ViewModel)** 及经典三层服务架构：

*   **Data Layer (`src/data`)**：`WeatherCacheManager` 负责应用本地数据目录下的 1 小时粒度 JSON 缓存读写。它接收 `type=hours` 返回的逐小时数据并滚动存储，提供过去 7 天聚合读取能力。
*   **Network Layer (`src/network`)**：封装 `QNetworkAccessManager`，`TencentApiClient` 处理 IP 定位与三种天气 API 的并发抓取及 JSON 结构反序列化。
*   **Service Layer (`src/service`)**：`WeatherService`, `LocationService`, `AlertService`, `NotificationManager`，负责业务逻辑流转、Windows 原生弹窗唤起以及定时任务调度。
*   **ViewModel Layer (`src/viewmodel`)**：继承自 `QObject`，通过 `Q_PROPERTY` 暴露 `todayWeather`, `pastWeatherList` 等属性，供前端 UI 数据绑定。
*   **View Layer (`qml/`)**：分为 `components` (高复用组件，如 `WeatherCard`, `Toolbar`) 和 `views` (页面容器，如 `TodayView`, `SettingsView`)。

### 分层依赖关系

```
QML View Layer  →  ViewModel Layer  →  Service Layer  →  Network Layer
                                ↓                  ↓
                           Data Layer          Util Layer
```

## 2. 编码规范

### C++ 规范
*   使用 C++17 标准
*   启用 `explicit` 防止隐式转换
*   采用命名空间隔离（`namespace Service`, `namespace ViewModel`）
*   内存管理首选 `std::unique_ptr` 及 Qt 的对象树自动释放机制
*   单例模式用于全局服务（Config, WeatherCacheManager, NotificationManager）

### QML 规范
*   使用 QtQuick.Layouts 代替绝对定位
*   组件的对外交互需通过定义 `signal` 进行事件抛出
*   严格遵循声明式 UI 编程思想
*   所有文案使用中文，按照 idea.md 的原文

## 3. 如何添加新功能

1.  在腾讯位置服务 API 文档中查阅所需新增的参数（如增加空气质量 `added_fields=air`）。
2.  在 `TencentApiClient` 补充请求逻辑并定义新的 `signals`。
3.  在 `WeatherCacheManager` 中扩展 JSON 缓存树节点。
4.  在 `WeatherViewModel` 新增对应的 `Q_PROPERTY` 以通知 QML 引擎刷新界面。
5.  在对应的 QML 视图层绑定新属性。

## 4. 编译与调试

```bash
# Debug 构建
mkdir build-debug && cd build-debug
cmake .. -DCMAKE_BUILD_TYPE=Debug
cmake --build .

# 运行测试
ctest --output-on-failure
```
