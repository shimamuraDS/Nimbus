# WeatherApp - 天气提醒助手

## 项目介绍

WeatherApp 是一款企业级桌面天气提醒应用。该应用长期静默驻留于 Windows 任务栏系统托盘，提供当日及未来 7 天的早晚天气、气温与湿度展示；过去 7 天基于逐小时缓存，展示天气与气温。应用采用先进的双重预警触发机制，结合腾讯位置服务的逐小时预报与官方实时灾害预警，在用户设定的特定时间点通过 Windows 原生通知弹窗进行恶劣天气提醒。

## 技术栈

*   **开发语言**：C++17/20, QML, JavaScript
*   **应用框架**：Qt 6.5 LTS (Core, Gui, Qml, Quick, Network, Widgets 模块)
*   **构建系统**：CMake (最低要求版本 3.16)
*   **第三方服务**：腾讯位置服务 WebService API (天气查询 API, IP 定位 API)
*   **打包部署**：windeployqt, Inno Setup

## 快速开始

### 1. 准备工作

请在项目根目录下编辑 `config.ini` 文件，放入你在腾讯位置服务控制台申请的开发者密钥：

```ini
[API]
DeveloperKey=你的腾讯位置服务开发者密钥
```

### 2. 编译与运行

使用 Qt Creator 或命令行 CMake 构建：

```bash
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build .
```

### 3. 打包分发

Release 编译完成后，使用 Qt 部署工具提取依赖：

```bash
windeployqt --qmldir ../qml --release ./WeatherApp.exe
```

然后使用 Inno Setup 编译 `scripts/setup.iss` 生成安装包。

## 项目文档

- [API 接口文档](docs/api-design.md)
- [开发指南](docs/dev-guide.md)
- [需求说明](docs/requirements.md)
- [用户使用手册](docs/user-guide.md)
- [设计规格文档](docs/superpowers/specs/2026-05-12-weatherapp-design.md)
