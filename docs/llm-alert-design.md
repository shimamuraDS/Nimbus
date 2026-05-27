# LLM 天气提醒 — 双版本架构设计

## 概述

在天气提醒触发时，使用大模型（LLM）分析天气数据并生成自然语言提醒内容，替代当前 `AlertService` 中的固定话术模板。采用 CMake 编译时条件方案，同一代码库维护"标准版"（无 LLM）和"AI 版"（含 LLM），一次构建输出两个独立安装包。

## 1. CMake 构建开关

```cmake
option(WITH_LLM "Build with LLM-powered weather alerts" OFF)

if(WITH_LLM)
    add_compile_definitions(WITH_LLM)
    set(LLM_SRCS
        src/llm/LLMClient.cpp
        src/llm/LLMAlertGenerator.cpp
    )
endif()

set(APP_SRCS ... ${LLM_SRCS})
```

AI 版专有 QML 文件（`LLMSettingsPane.qml`）通过 `list(APPEND)` 条件加入 `qt_add_qml_module` 的 `QML_FILES`。

**构建命令：**
```
cmake -DWITH_LLM=ON  -B build-ai
cmake -DWITH_LLM=OFF -B build-standard
```

## 2. C++ 架构

### LLM 配置（整合到现有 `Config` 单例）

LLM 配置方法通过 `#ifdef WITH_LLM` 条件编译到 `Util::Config` 中，无需额外类。

`QSettings` 中 `LLM/` 组：
```
LLM/Enabled   = false
LLM/ApiUrl    = "https://api.deepseek.com"
LLM/ApiKey    = ""           (DPAPI 加密存储)
LLM/ModelName = "deepseek-v4-pro"
```

支持的 DeepSeek 预设模型：`deepseek-v4-flash`、`deepseek-v4-pro`、`deepseek-chat`、`deepseek-reasoner`。自定义模式下可填写任意 OpenAI 兼容 API 地址和模型名。

天气 API Key 在 **设置 → API 设置** 中填写，存储于 QSettings `API/WeatherKey`，采用 DPAPI 加密。

### 新增模块 `src/llm/`

| 文件 | 职责 |
|------|------|
| `LLMClient.h/.cpp` | HTTP POST `/chat/completions`，OpenAI 兼容格式，含 DeepSeek thinking/reasoning_effort 支持，10 秒超时 |
| `LLMAlertGenerator.h/.cpp` | 天气 JSON → prompt → 调用 LLMClient → 回调返回文本 |

### API Key 安全存储

LLM API Key 使用 Windows DPAPI 加密：
- `LoadLibrary("crypt32.dll")` + `GetProcAddress` 动态加载，无需链接 crypt32
- `CryptProtectData()` 加密后 Base64 存入 `QSettings`
- `CryptUnprotectData()` 读取时解密
- 加密绑定当前用户，不可跨用户或跨机器解密
- DPAPI 加载失败时回退 Base64 存储（罕见情况）

### AlertService 改动

```cpp
void AlertService::checkAlerts() {
    // Tier 1: 官方预警 — 不变

    // Tier 2: 逐小时天气检查
    // 收集 segments、构建 fallback lambda

#ifdef WITH_LLM
    if (Config::getInstance().isLLMEnabled()) {
        auto* gen = new LLMAlertGenerator(this);
        gen->generateAlert(hourlyData, currentWeather, durationMin,
            [this, fallback, gen](const QString& text) {
                showNotification(text.isEmpty() ? fallback() : text);
                gen->deleteLater();
            });
        return;
    }
#endif
    showNotification(fallback());  // 标准版路径
}
```

### SettingsViewModel 扩展

| 属性 | 条件 | 说明 |
|------|------|------|
| `weatherApiKey` | 全局 | 天气 API Key，UI 可编辑 |
| `llmEnabled` | WITH_LLM | AI 功能开关 |
| `llmApiUrl` | WITH_LLM | LLM API 地址 |
| `llmApiKey` | WITH_LLM | LLM API Key |
| `llmModelName` | WITH_LLM | 模型名称 |
| `llmTestResult` | WITH_LLM | 连接测试结果（连接中/成功/失败） |
| `testLLMConnection()` | WITH_LLM | 异步测试连接，回调更新 llmTestResult |

## 3. QML 层

### APISettingsPane.qml

可折叠的"API 设置"区域（默认收起），展开后包含：

- **天气 API**：Cyan 圆点标签 + 帮助图标（?，hover 显示"如何获取？"，点击跳转腾讯位置服务控制台获取密钥）+ API Key 密码输入框
- **AI 天气提醒**（Loader 加载 `LLMSettingsPane.qml`）：Coral 圆点标签 + 启用开关 + 模型选择 + URL/Key/Model 输入 + 测试连接按钮

API Key 更新后自动触发天气数据刷新（`SettingsViewModel::weatherApiKeyChanged` → `WeatherViewModel::requestData`）。
两个子区域左对齐（`theme.spacingLarge` margin），格式一致。

### LLMSettingsPane.qml

仅 AI 版本编译打包，标准版 Loader 静默失败。包含：

- **模型选择**（ComboBox）：DeepSeek / 自定义，切换时自动填充对应预设
- **API 地址**（可编辑 ComboBox）：DeepSeek 模式下提供 `https://api.deepseek.com`、`https://api.deepseek.com/anthropic` 预设，也可手动输入
- **API Key**（密码输入框）
- **模型名称**（可编辑 ComboBox）：DeepSeek 模式下提供 `deepseek-v4-flash`、`deepseek-v4-pro`、`deepseek-chat`、`deepseek-reasoner` 预设，也可手动输入
- **帮助图标**（?）：hover 显示"如何获取？"，点击跳转 DeepSeek API Keys 页面
- 自定义模式：API 地址和模型名称清空，仅允许手动输入
- 测试连接按钮（结果实时显示在按钮右侧）

### SettingsView.qml 布局

从上到下：开机自启动 → API 设置（可折叠）→ 分割线 → 提醒时间列表 → 添加按钮

## 4. 提醒生成流程

```
AlertService 60s 定时器
  → 到达提醒时间点 → 取天气数据

  ┌─ WITH_LLM=OFF ────────────────
  │  固定话术 → NotificationManager
  │
  └─ WITH_LLM=ON ─────────────────
      用户未启用 → 固定话术
      用户启用 →
          LLMAlertGenerator::generateAlert()
            → LLMClient::chat() ─10s─→ 成功 → LLM 文本
              ↓ 失败                     ↓
              固定话术（降级）    NotificationManager
```

## 5. 发布

| 构建配置 | 产物 | 二进制大小 |
|----------|------|-----------|
| `-DWITH_LLM=OFF` | 标准版 | ~32 MB |
| `-DWITH_LLM=ON` | AI 版 | ~35 MB |

版本号相同，同一提交产出，避免分支分叉。AI 版在未启用 LLM 时无额外运行时开销。

## 6. 文件清单

### 新增文件

| 文件 | 条件 |
|------|------|
| `src/llm/LLMClient.h` | WITH_LLM=ON |
| `src/llm/LLMClient.cpp` | WITH_LLM=ON |
| `src/llm/LLMAlertGenerator.h` | WITH_LLM=ON |
| `src/llm/LLMAlertGenerator.cpp` | WITH_LLM=ON |
| `qml/components/LLMSettingsPane.qml` | WITH_LLM=ON |
| `qml/components/APISettingsPane.qml` | 全局 |

### 修改文件

| 文件 | 改动 |
|------|------|
| `CMakeLists.txt` | `option(WITH_LLM)` + 条件源文件 + 条件 QML 文件 |
| `src/util/Config.h/.cpp` | `#ifdef WITH_LLM` LLM 配置方法 + `weatherApiKey` + XOR 混淆 |
| `src/service/AlertService.cpp` | `#ifdef WITH_LLM` LLM 路径 + 降级 fallback |
| `src/viewmodel/SettingsViewModel.h/.cpp` | `weatherApiKey` + `#ifdef WITH_LLM` LLM 属性 + `testLLMConnection` |
| `qml/views/SettingsView.qml` | APISettingsPane 替代旧 LLM Loader |
