<p align="center">
  <picture>
    <img src="docs/images/logo.png" width="96" alt="Nimbus Logo" />
  </picture>
</p>

<h1 align="center">Nimbus</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Qt-6.8-41CD52?logo=qt&style=flat-square" alt="Qt" />
  <img src="https://img.shields.io/badge/C++-17-00599C?logo=c%2B%2B&style=flat-square" alt="C++" />
  <img src="https://img.shields.io/badge/CMake-3.16%2B-064F8C?logo=cmake&style=flat-square" alt="CMake" />
  <img src="https://img.shields.io/badge/Platform-Windows-0078D6?logo=windows&style=flat-square" alt="Windows" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="MIT" />
  <img src="https://img.shields.io/badge/Release-v1.0.0-00f0ff?style=flat-square" alt="Release" />
</p>

<p align="center"><strong>Windows 桌面天气提醒应用</strong><br/>系统托盘驻留 · 双重预警 · 深色赛博朋克 · LLM 智能通知</p>

---

## 功能预览

<p align="center">
  <picture>
    <img src="docs/images/screenshot-today.png" width="45%" alt="今日天气" />
    <img src="docs/images/screenshot-future.png" width="45%" alt="未来7天" />
  </picture>
  <br/>
  <sub><b>当日逐小时时间线（左）</b> — 24 小时横向滚动，当前小时青色高亮 · <b>未来 7 天预报（右）</b> — 电光青玻璃态卡片，早晚天气/气温/湿度</sub>
</p>

<p align="center">
  <picture>
    <img src="docs/images/screenshot-past.png" width="45%" alt="过去7天" />
    <img src="docs/images/screenshot-alerm.png" width="45%" alt="设置提醒" />
  </picture>
  <br/>
  <sub><b>过去 7 天回溯（左）</b> — 日落珊瑚暖色卡片，基于本地逐小时缓存自动归档 · <b>提醒设置（右）</b> — 自定义时间点 + 提前监测时长，支持修改和删除</sub>
</p>

<p align="center">
  <picture>
    <img src="docs/images/screenshot-standard.png" width="45%" alt="标准版" />
    <img src="docs/images/screenshot-ai.png" width="45%" alt="AI版" />
  </picture>
  <br/>
  <sub><b>标准版（左）</b> — 固定中文模板通知，轻量无额外依赖 · <b>AI 版（右）</b> — DeepSeek 大模型自然语言提醒，API Key DPAPI 加密存储，支持模型选择与连接测试</sub>
</p>

- **逐小时时间线** — 当日 24 小时横向滚动，当前小时青色高亮
- **7 天回溯与预报** — 过去 7 天（日落珊瑚）与未来 7 天（电光青）早晚天气卡片
- **双重预警机制** — 腾讯官方灾害预警 + 逐小时天气智能分析，避免重复提醒
- **定时提醒** — 自定义时间点 + 提前监测时长，全部天气类型可触发
- **LLM 智能通知**（AI 版） — DeepSeek 大模型生成自然语言提醒，失败降级为固定模板
- **智能定位** — IP 自动定位 + 98 城市手动选择，adcode 市级精度归一化
- **系统托盘驻留** — 开机自启、静默运行、点击唤出，窗口 ≤ 屏幕 1/12 面积
- **安全存储** — Windows DPAPI 加密 API 密钥，绑定当前用户不可跨机器解密
- **自定义安装** — WixUI MSI 向导，支持 Browse 选择目标目录

---

## 版本

| | Standard | AI |
|---|----------|----|
| **CMake** | `-DWITH_LLM=OFF` | `-DWITH_LLM=ON` |
| **通知方式** | 固定中文模板 | LLM 自然语言 + 模板降级 |
| **安装包** | `Nimbus_Standard.msi` | `Nimbus_AI.msi` |
| **免安装包** | `Nimbus-v1.0.0-Standard.zip` | `Nimbus-v1.0.0-AI.zip` |

> 同一代码库，同一版本号，一次构建产出两个独立安装包。AI 版在未启用 LLM 时无额外运行时开销。

📦 **[下载最新版本](https://github.com/shimamuraDS/Nimbus/releases)**

---

## 技术栈

| 层级 | 技术 | 说明 |
|------|------|------|
| 语言 | C++17 · QML | 声明式 UI + 原生性能 |
| 框架 | Qt 6.8 LTS | Core / Gui / Qml / Quick / Network / Widgets |
| 构建 | CMake 3.16+ · Ninja · MinGW 13.1 | 跨平台构建系统 |
| 架构 | MVVM + 三层服务 | View → ViewModel → Service → Network / Data |
| 服务 | 腾讯 LBS API · DeepSeek API | 天气数据 + LLM 推理 |
| 打包 | WiX Toolset v7 | MSI 安装包，支持自定义路径 |
| 测试 | QtTest + CTest | 单元测试 + 集成测试 |
| 安全 | Windows DPAPI | crypt32.dll 动态加载，密钥绑定用户 |

---

## 项目架构

```
┌─────────────────────────────────────────────────────┐
│                    QML View Layer                     │
│   MainWindow · TodayView · PastView · FutureView     │
│   SettingsView · 11 可复用组件 (Theme, Cards, etc.)    │
├─────────────────────────────────────────────────────┤
│                ViewModel Layer (C++)                  │
│   WeatherViewModel · SettingsViewModel · TrayVM      │
├─────────────────────────────────────────────────────┤
│                  Service Layer                        │
│   Weather · Location · Alert · Notification          │
├───────────────────┬─────────────────────────────────┤
│   Network Layer    │        Data / Util Layer         │
│   Tencent LBS API  │  Cache Manager · DPAPI · Config  │
│   (3 weather APIs) │  TimeUtil · WeatherCode · Screen │
├───────────────────┴─────────────────────────────────┤
│               LLM Module (AI build only)              │
│        LLMClient (OpenAI compat) · LLMAlertGenerator  │
└─────────────────────────────────────────────────────┘
```

---

## 快速开始

### 环境要求

| 工具 | 版本 | 用途 |
|------|------|------|
| Qt | 6.8+ (MinGW 64-bit) | 编译运行 |
| CMake | 3.16+ | 构建系统 |
| Ninja | 任意 | 构建加速 |
| WiX Toolset | v7 | MSI 打包 |

### 编译

```bash
# 标准版（固定模板通知）
cmake -DWITH_LLM=OFF -DCMAKE_BUILD_TYPE=Release -B build-standard
cmake --build build-standard

# AI 版（LLM 智能通知）
cmake -DWITH_LLM=ON -DCMAKE_BUILD_TYPE=Release -B build-ai
cmake --build build-ai
```

### 测试

```bash
ctest --test-dir build-standard --output-on-failure
```

### 打包

```bash
# 部署 Qt 运行时
windeployqt --qmldir ./qml --release ./Nimbus.exe

# 生成 WiX 源文件
python scripts/generate_wxs.py deploy/standard scripts/Nimbus_Standard.wxs \
    --name "Nimbus Standard" --upgrade-code <GUID>

# 编译 MSI 安装包
wix extension add WixToolset.UI.wixext
wix build -ext WixToolset.UI.wixext \
    -o scripts/Installer/Nimbus_Standard.msi scripts/Nimbus_Standard.wxs
```

### 配置

首次启动后进入 **设置 → API 设置**，填入腾讯位置服务密钥（DPAPI 加密存储），天气数据自动刷新。

---

## 文档

| 文档 | 内容 |
|------|------|
| [架构设计](docs/architecture.md) | 系统架构 · 分层设计 · 组件详设 · 构建部署 |
| [需求规格](docs/requirements.md) | 功能需求 · 非功能需求 · UI 交互 · 视觉规范 |
| [API 接口](docs/api-design.md) | 腾讯位置服务 WebService API 参考 |
| [开发指南](docs/dev-guide.md) | MVVM 架构 · 编码规范 · 新功能添加流程 |
| [用户手册](docs/user-guide.md) | 安装使用 · 设置配置 · 常见问题 |
| [LLM 告警设计](docs/llm-alert-design.md) | LLM 集成 · 双版本方案 · 安全存储 · 降级策略 |
| [TimePicker 设计](docs/timepicker-design.md) | 时间选择弹窗组件详设与交互规范 |

---

## 许可证

[MIT](LICENSE) © Nimbus
