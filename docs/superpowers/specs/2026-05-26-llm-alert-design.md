# LLM 天气提醒 — 双版本架构设计

## 概述

在天气提醒触发时，使用大模型（LLM）分析天气数据并生成自然语言提醒内容，替代当前 `AlertService` 中的固定话术模板。采用 CMake 编译时条件方案，同一代码库维护"标准版"（无 LLM）和"AI 版"（含 LLM），一次构建输出两个独立安装包。

## 1. CMake 构建开关

```cmake
option(WITH_LLM "Build with LLM-powered weather alerts" OFF)

if(WITH_LLM)
    add_compile_definitions(WITH_LLM)
    set(LLM_SRCS
        src/llm/LLMConfig.cpp
        src/llm/LLMClient.cpp
        src/llm/LLMAlertGenerator.cpp
    )
endif()

set(APP_SRCS ... ${LLM_SRCS})
```

- `WITH_LLM=ON` 时定义 C++ 预处理器宏 `WITH_LLM`，并编译 `src/llm/` 下的源文件
- `WITH_LLM=OFF` 时不编译任何 LLM 相关代码，标准版二进制零冗余
- AI 版专有的 QML 文件（`LLMSettingsPane.qml`）仅在 `WITH_LLM=ON` 时加入 `qt_add_qml_module` 的 `QML_FILES`

**构建命令：**
```
cmake -DWITH_LLM=ON  -B build-ai
cmake -DWITH_LLM=OFF -B build-standard
```

## 2. C++ 架构

### 新增模块 `src/llm/`

| 文件 | 职责 |
|------|------|
| `LLMConfig.h/.cpp` | LLM 配置读写：API URL、Key、Model、Enabled 开关 |
| `LLMClient.h/.cpp` | HTTP 客户端，发送 OpenAI 兼容 `/chat/completions` 请求 |
| `LLMAlertGenerator.h/.cpp` | 构建天气→prompt→调用 LLMClient→解析响应文本 |

### LLMConfig

在 `QSettings` 中新增 `LLM/` 组：

```
LLM/ApiUrl    = "https://api.openai.com/v1"
LLM/ApiKey    = ""           (DPAPI 加密存储)
LLM/ModelName = "gpt-4o-mini"
LLM/Enabled   = false
```

用户可在设置界面修改。`WITH_LLM=OFF` 时整个类不存在。

### LLMClient

基于现有 `Network::HttpClient` 模式：POST 请求到 `{ApiUrl}/chat/completions`，OpenAI 兼容格式的 JSON body，接收流式或非流式响应，提取 `choices[0].message.content`。支持配置自定义 API 地址（OpenAI / DeepSeek / 通义千问 / 本地 Ollama 等任意兼容接口）。

超时时间：10 秒。

### LLMAlertGenerator

接收天气数据（`QVariantMap`：当前天气、温度、湿度、风速、未来数小时逐小时预报），构造中文 prompt，包含：
- 当前天气状况摘要
- 未来数小时预报数据（JSON 格式）
- 生成要求（简洁、实用、中文、含建议）

调用 `LLMClient::chat()` 并返回清理后的文本。

### AlertService 改动

```cpp
void AlertService::checkAlerts() {
    // ... 时间判断逻辑不变 ...

#ifdef WITH_LLM
    if (LLMConfig::getInstance().isEnabled()) {
        QString text = LLMAlertGenerator::generateAlert(weatherData, advanceMinutes);
        if (text.isEmpty()) {
            // 降级：API 失败或超时，回退固定话术
            text = buildFallbackAlert(weatherData);
        }
        showNotification(text);
    } else {
        showNotification(buildFallbackAlert(weatherData));
    }
#else
    showNotification(buildFallbackAlert(weatherData));  // 当前逻辑不变
#endif
}
```

降级策略：LLM API 调用失败（网络错误、超时、配额不足等），自动回退到固定话术提醒，确保提醒不丢失。

## 3. QML 层

### LLMSettingsPane.qml

仅 AI 版本编译打包。包含：

- LLM 功能启用/关闭开关
- API 地址输入框（默认 `https://api.openai.com/v1`）
- API Key 输入框（密码模式，密文显示）
- 模型名称输入框
- "测试连接"按钮

### SettingsView.qml 集成

使用 `Loader` 动态加载，标准版文件不存在时静默失败：

```qml
Loader {
    Layout.fillWidth: true
    source: "LLMSettingsPane.qml"
}
```

### C++ ViewModel 扩展

`SettingsViewModel` 中 `#ifdef WITH_LLM` 条件下新增：

```cpp
#ifdef WITH_LLM
    Q_INVOKABLE void testLLMConnection();
    Q_PROPERTY(QString llmApiUrl ...)
    Q_PROPERTY(QString llmApiKey ...)
    Q_PROPERTY(QString llmModelName ...)
    Q_PROPERTY(bool llmEnabled ...)
#endif
```

QML 中用 `typeof` 做防御检查：`typeof settingsViewModel.llmEnabled !== "undefined"`。

## 4. 提醒生成流程

```
AlertService 60s 定时器
  → 到达提醒时间点
  → WeatherCacheManager 取天气数据

  ┌─ WITH_LLM=OFF ────────────────────────
  │  固定话术模板 → NotificationManager
  │
  └─ WITH_LLM=ON ─────────────────────────
      用户未启用 LLM → 固定话术模板
      用户启用了 LLM →
          LLMAlertGenerator::generateAlert()
            → LLMClient::chat()  ─10s超时─→ 成功 → 自然语言文本
              ↓ 失败                           ↓
              固定话术（降级）           NotificationManager
```

## 5. API Key 安全存储

使用 Windows DPAPI 加密 API Key：

- `CryptProtectData()` 加密后写入 `QSettings`
- `CryptUnprotectData()` 读取时解密
- 仅当前用户在当前机器上可解密
- `WITH_LLM=OFF` 时不编译加密相关代码

代码量约 50-80 行，无需额外依赖。

## 6. 发布

CI 一次构建两个包：

| 构建配置 | 产物 | 包名 |
|----------|------|------|
| `-DWITH_LLM=OFF` | 标准版 | `WeatherApp_Setup_v1.x.exe` |
| `-DWITH_LLM=ON` | AI 版 | `WeatherApp_AI_Setup_v1.x.exe` |

版本号相同，同一提交产出，避免分支分叉。

## 7. 文件清单

### 新增文件

| 文件 | 条件 |
|------|------|
| `src/llm/LLMConfig.h` | WITH_LLM=ON |
| `src/llm/LLMConfig.cpp` | WITH_LLM=ON |
| `src/llm/LLMClient.h` | WITH_LLM=ON |
| `src/llm/LLMClient.cpp` | WITH_LLM=ON |
| `src/llm/LLMAlertGenerator.h` | WITH_LLM=ON |
| `src/llm/LLMAlertGenerator.cpp` | WITH_LLM=ON |
| `qml/components/LLMSettingsPane.qml` | WITH_LLM=ON |

### 修改文件

| 文件 | 改动 |
|------|------|
| `CMakeLists.txt` | 新增 `option(WITH_LLM)`、条件源文件、条件 QML 文件 |
| `src/service/AlertService.cpp` | `#ifdef WITH_LLM` 分支，LLM 路径+降级逻辑 |
| `src/viewmodel/SettingsViewModel.h/.cpp` | `#ifdef WITH_LLM` 新增 LLM 配置属性和方法 |
| `qml/views/SettingsView.qml` | 新增 `Loader` 加载 `LLMSettingsPane` |
| `src/main.cpp` | `WITH_LLM=ON` 时初始化 LLMConfig（如有需要） |
