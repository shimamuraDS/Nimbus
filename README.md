# Nimbus

[![Qt](https://img.shields.io/badge/Qt-6.8-41CD52?logo=qt)](https://www.qt.io/)
[![C++](https://img.shields.io/badge/C%2B%2B-17-00599C?logo=c%2B%2B)](https://isocpp.org/)
[![CMake](https://img.shields.io/badge/CMake-3.16%2B-064F8C?logo=cmake)](https://cmake.org/)
[![Platform](https://img.shields.io/badge/Platform-Windows-0078D6?logo=windows)](https://www.microsoft.com/windows)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

## 项目介绍

Nimbus 是一款 Windows 桌面天气提醒应用，长期静默驻留于系统托盘，支持开机自启动。提供当日逐小时天气时间线、未来 7 天及过去 7 天的早晚天气、气温与湿度展示。采用双重预警触发机制（腾讯位置服务逐小时预报 + 官方实时灾害预警），在用户设定时间点通过 Windows 原生通知弹窗进行提醒。

界面采用深色赛博朋克风格，电光青/珊瑚/紫罗兰三色强调，玻璃态卡片叠加在暗色渐变背景上，配合方向感知的页面过渡动画 (300ms OutQuint 缓动)。

## 版本

| 版本 | CMake 选项 | 通知方式 | 安装包 |
|------|-----------|---------|--------|
| **Standard** | `-DWITH_LLM=OFF` | 固定中文模板 | `Nimbus_Standard.msi` |
| **AI** | `-DWITH_LLM=ON` | LLM 自然语言 + 模板降级 | `Nimbus_AI.msi` |

详见 [Releases](https://github.com/shimamuraDS/Nimbus/releases)。

## 技术栈

- **语言**: C++17, QML
- **框架**: Qt 6.8 LTS (Core, Gui, Qml, Quick, Network, Widgets)
- **构建**: CMake 3.16+, Ninja, MinGW 13.1
- **服务**: 腾讯位置服务 WebService API
- **打包**: WiX Toolset v7 (MSI)

## 快速开始

### 1. 配置 API 密钥

首次启动后在 **设置 → API 设置** 面板中填入腾讯位置服务开发者密钥，采用 Windows DPAPI 加密存储。

### 2. 编译

```bash
# 标准版
cmake -DWITH_LLM=OFF -DCMAKE_BUILD_TYPE=Release -B build-standard
cmake --build build-standard

# AI 版
cmake -DWITH_LLM=ON -DCMAKE_BUILD_TYPE=Release -B build-ai
cmake --build build-ai
```

### 3. 测试

```bash
ctest --output-on-failure
```

### 4. 打包

```bash
windeployqt --qmldir ../qml --release ./Nimbus.exe
# 首次需安装 WixUI 扩展: wix extension add WixToolset.UI.wixext/7.0.0
python scripts/generate_wxs.py deploy/standard scripts/Nimbus_Standard.wxs \
    --name "Nimbus Standard" --upgrade-code <GUID>
wix build -ext WixToolset.UI.wixext \
    -o scripts/Installer/Nimbus_Standard.msi scripts/Nimbus_Standard.wxs
```

## 项目文档

| 文档 | 说明 |
|------|------|
| [架构设计](docs/architecture.md) | 系统架构、分层设计、组件详设、构建部署 |
| [需求规格](docs/requirements.md) | 功能需求、非功能需求、UI 交互流程、视觉规范 |
| [API 接口](docs/api-design.md) | 腾讯位置服务 API 参考 |
| [开发指南](docs/dev-guide.md) | MVVM 架构、编码规范、如何添加新功能 |
| [用户手册](docs/user-guide.md) | 安装使用、设置配置、常见问题 |
| [LLM 告警设计](docs/llm-alert-design.md) | LLM 集成架构、双版本方案、安全存储 |
| [TimePicker 设计](docs/timepicker-design.md) | 时间选择弹窗组件详设 |

## 许可证

[MIT](LICENSE)
