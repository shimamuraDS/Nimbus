# Changelog

## v1.0.0 (2026-05-27)

### Added
- 当日逐小时天气时间线 (横向滑动，当前小时高亮)
- 过去 7 天 / 未来 7 天早晚天气卡片 (暖珊瑚/冷青色变体)
- IP 自动定位 + 手动 98 城市选择器
- 天气异常提醒 (双重判定：官方预警 + 逐小时分析)
- 定时提醒模式 (用户可配置多个提醒时间点 + 提前监测时长)
- LLM 增强通知 (AI 版本，OpenAI 兼容 API，模板降级)
- 模型选择器 (DeepSeek 预设 / 自定义)，可编辑 ComboBox + 下拉预设组合
- API 密钥帮助图标 (hover 提示 + 点击跳转申请页面)
- 密钥更新后自动触发天气数据刷新
- 系统托盘驻留 + 开机自启
- 深色赛博朋克视觉主题 (电光青/珊瑚/紫罗兰三色强调，玻璃态卡片)
- 方向感知页面过渡动画 (300ms OutQuint 缓动)
- Windows DPAPI 安全存储 (API Key)
- 双版本构建系统 (CMake `WITH_LLM` 开关)
- WiX MSI 安装包 + 免安装 ZIP 包

### Tech
- C++17 + Qt 6.8 LTS (QML)
- CMake 3.16+ + Ninja + MinGW 13.1
- 腾讯位置服务 WebService API + DeepSeek API
- QtTest + CTest 单元测试
