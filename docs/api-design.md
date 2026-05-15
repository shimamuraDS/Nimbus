# API 接口设计文档

本项目所有地理位置与天气数据均由**腾讯位置服务 WebService API** 提供。

## 1. 腾讯 IP 定位 API

*   **接口说明**：通过终端设备 IP 地址获取其当前所在地理位置，最高精确到区/县。
*   **请求 URL**：`GET https://apis.map.qq.com/ws/location/v1/ip`
*   **请求参数**：
    *   `key` (必填): 开发密钥。
    *   `ip` (选填): 缺省时自动使用请求端的 IP。
*   **核心返回字段映射**：
    *   `status`: 状态码（0 为正常）。
    *   `result.ad_info.city`: 用于 UI 界面展示的所在市名称。
    *   `result.ad_info.adcode`: 行政区划代码，作为后续所有天气 API 的核心查询参数。
*   **adcode 归一化处理**：
    由于 IP 定位可能返回区县级 adcode（如 440305），程序在获取后自动归一化到市级精度：
    - 直辖市（北京 11/天津 12/上海 31/重庆 50）：`110101` → `110000`
    - 其他城市：`440305` → `440300`

## 2. 腾讯天气查询 API (多维并发调用)

*   **接口说明**：通过行政区划编码，查询对应城市的实时天气、逐小时预报及多日未来预报。
*   **基础 URL**：`GET https://apis.map.qq.com/ws/weather/v1/`

### 2.1 获取未来多日预报 (用于渲染主页与未来页)

*   **请求参数**：`key`, `adcode`, `type=future`, `get_md=1` (获取当天加未来 6 天，共 7 天)。
*   **核心返回字段**：解析 `result.forecast[0].infos` 数组。
    *   `date`: 日期。
    *   `day` (白天) / `night` (夜晚): 分别包含 `weather` (天气描述)、`temperature` (温度)、`humidity` (湿度)。

### 2.2 获取未来 24 小时预报 (用于构建历史缓存库及恶劣天气兜底)

*   **请求参数**：`key`, `adcode`, `type=hours` (未来 24 小时天气预报，起始时间为当前时间的前一个小时)。
*   **核心返回字段**：解析 `result.forecast_hours[0].infos` 数组。
    *   `hour`: 预报时间戳（如 `2025-09-26 18:05`）。
    *   `info`: 包含 `weather` (天气描述)、`temperature` (温度)、`wind_direction` (风向)、`wind_power` (风力)。
    *   项目按 1 小时粒度去重并提取每天 08:00 (早) 和 20:00 (晚) 用于追溯过去 7 天记录。

### 2.3 获取实时灾害预警 (用于高优弹窗触发)

*   **请求参数**：`key`, `adcode`, `type=now`, `added_fields=alarm` (附加预警信息)。
*   **核心返回字段**：解析 `result.realtime[0].alarms` 数组。
    *   `title`: 预警名称（如"北京市海淀区发布大雾黄色预警"）。
    *   `pub_content`: 预警发布详情。

## 3. 异常天气判断标准

*   **高优触发**：`result.realtime[0].alarms` 数组非空，直接判定为异常预警天气。
*   **兜底触发**：遍历 `hourly_data` 中未来 3 小时内的逐小时预报，若 `weather` 字段包含"暴雨"、"冰雹"、"沙尘暴"、"冻雨"等极端关键字，判定为异常。

## 4. 手动城市列表

手动定位模式内置 98 个城市，覆盖所有省份/直辖市/自治区/特别行政区，使用中国标准行政区划代码（adcode）。详见 `qml/components/CitySelector.qml` 中的 ListModel。
