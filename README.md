<p align="center">
  <img src="resources/app.ico" width="80" alt="Nimbus" />
</p>

<h1 align="center">Nimbus</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Qt-6.8-41CD52?logo=qt&style=flat-square" alt="Qt" />
  <img src="https://img.shields.io/badge/C++-17-00599C?logo=c%2B%2B&style=flat-square" alt="C++" />
  <img src="https://img.shields.io/badge/CMake-3.16%2B-064F8C?logo=cmake&style=flat-square" alt="CMake" />
  <img src="https://img.shields.io/badge/Platform-Windows-0078D6?logo=windows&style=flat-square" alt="Windows" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="MIT" />
</p>

<p align="center">Windows 桌面天气提醒应用 — 系统托盘驻留 · 双重预警 · 深色赛博朋克 UI</p>

---

## 功能特性

- **逐小时时间线** — 当日 24 小时天气横向滚动，当前小时青色高亮
- **7 天回溯与预报** — 过去 7 天（珊瑚色）与未来 7 天（青色）早晚天气卡片，玻璃态悬停动画
- **双重预警机制** — 腾讯官方灾害预警 + 逐小时天气分析，同一天气事件不重复提醒
- **定时提醒** — 用户自定义多个提醒时间点 + 提前监测时长，任意天气类型均可触发
- **LLM 智能通知**（AI 版） — DeepSeek 大模型生成自然语言提醒，失败自动降级为固定模板
- **智能定位** — IP 自动定位（市级精度）+ 手动 98 城市选择器，adcode 自动归一化
- **系统托盘驻留** — 开机自启、静默运行、点击唤出，窗口面积 ≤ 屏幕 1/12
- **安全存储** — Windows DPAPI 加密保护 API 密钥，绑定当前用户
- **自定义安装** — MSI 安装向导支持自定义路径

---

## 版本

| | Standard | AI |
|---|----------|----|
| **CMake** | `-DWITH_LLM=OFF` | `-DWITH_LLM=ON` |
| **通知方式** | 固定中文模板 | LLM 自然语言 + 模板降级 |
| **安装包** | `Nimbus_Standard.msi` | `Nimbus_AI.msi` |
| **免安装包** | `Nimbus-v1.0.0-Standard.zip` | `Nimbus-v1.0.0-AI.zip` |

> AI 版在未启用 LLM 时无额外运行时开销，两个版本共享同一版本号与代码库。

📦 [下载最新版本](https://github.com/shimamuraDS/Nimbus/releases)

---

## 技术栈

| 层级 | 技术 |
|------|------|
| 语言 | C++17 · QML |
| 框架 | Qt 6.8 LTS (Core / Gui / Qml / Quick / Network / Widgets) |
| 构建 | CMake 3.16+ · Ninja · MinGW 13.1 |
| 架构 | MVVM + 三层服务架构 (Service / Network / Data) |
| 服务 | 腾讯位置服务 WebService API · DeepSeek API |
| 打包 | WiX Toolset v7 (MSI + 自定义路径) |
| 测试 | QtTest + CTest |
| 安全 | Windows DPAPI (crypt32.dll 动态加载) |

---

## 快速开始

### 前置条件

- Qt 6.8+ (MinGW 64-bit)
- CMake 3.16+
- WiX Toolset v7（仅打包需要）

### 1. 编译

```bash
# 标准版
cmake -DWITH_LLM=OFF -DCMAKE_BUILD_TYPE=Release -B build-standard
cmake --build build-standard

# AI 版
cmake -DWITH_LLM=ON -DCMAKE_BUILD_TYPE=Release -B build-ai
cmake --build build-ai
```

### 2. 测试

```bash
ctest --test-dir build-standard --output-on-failure
```

### 3. 打包

```bash
# 部署 Qt 依赖
windeployqt --qmldir ./qml --release ./Nimbus.exe

# 生成 WiX 源文件
python scripts/generate_wxs.py deploy/standard scripts/Nimbus_Standard.wxs \
    --name "Nimbus Standard" --upgrade-code <GUID>

# 编译 MSI
wix extension add WixToolset.UI.wixext
wix build -ext WixToolset.UI.wixext \
    -o scripts/Installer/Nimbus_Standard.msi scripts/Nimbus_Standard.wxs
```

### 4. 配置

首次启动后在 **设置 → API 设置** 中填入腾讯位置服务密钥（DPAPI 加密存储），数据自动刷新。

---

## 项目架构

```
View (QML)  ──→  ViewModel (C++)  ──→  Service  ──→  Network (Tencent API)
                                        │
                                   Data (JSON Cache)
                                        │
                                   Util (Config / DPAPI / Screen)
```

| 层 | 目录 | 说明 |
|----|------|------|
| View | [`qml/`](qml/) | 声明式 UI — 4 页面 + 11 可复用组件 |
| ViewModel | [`src/viewmodel/`](src/viewmodel/) | Q_PROPERTY 数据绑定，Q_INVOKABLE 交互接口 |
| Service | [`src/service/`](src/service/) | 天气获取 · 定位切换 · 告警检测 · 通知发送 |
| Network | [`src/network/`](src/network/) | 腾讯 LBS API — 3 种天气接口 + IP 定位 |
| Data | [`src/data/`](src/data/) | 1 小时粒度 JSON 滚动缓存，去重合并 |
| Util | [`src/util/`](src/util/) | 配置管理 · 时间工具 · 天气代码映射 · 屏幕几何 |
| LLM | [`src/llm/`](src/llm/) | AI 版专有 — OpenAI 兼容客户端 + 提醒生成器 |

---

## 文档

| 文档 | 说明 |
|------|------|
| [架构设计](docs/architecture.md) | 系统架构 · 分层设计 · 组件详设 · 构建部署 |
| [需求规格](docs/requirements.md) | 功能需求 · 非功能需求 · UI 交互 · 视觉规范 |
| [API 接口](docs/api-design.md) | 腾讯位置服务 API 参考 |
| [开发指南](docs/dev-guide.md) | MVVM 架构 · 编码规范 · 新功能配方 |
| [用户手册](docs/user-guide.md) | 安装使用 · 设置配置 · FAQ |
| [LLM 告警设计](docs/llm-alert-design.md) | LLM 集成架构 · 双版本方案 · 安全存储 |
| [TimePicker 设计](docs/timepicker-design.md) | 时间选择弹窗组件详设 |

---

## 许可证

[MIT](LICENSE) © Nimbus
