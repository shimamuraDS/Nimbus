# TimePickerDialog 弹窗设计需求

## 背景

这是一个 Windows 桌面天气应用的设置页面，用户可以在其中添加/修改天气提醒时间。之前的版本使用页面内嵌的 ComboBox 控件进行编辑，现已改为弹窗模式，但弹窗的外观设计不够美观，需要重新设计。

## 当前代码

弹窗由两个文件组成：

- `TimePickerDialog.qml` — 弹窗主体，包含布局、卡片分区、按钮和业务逻辑
- `TimeComboBox.qml` — 主题化的下拉选择器组件，替代 Qt 原生 SpinBox

### TimePickerDialog.qml (`qml/components/TimePickerDialog.qml`)

```qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: root

    property string dialogTitle: qsTr("添加提醒")
    property string initialTime: "07:00"
    property int initialAdvanceMinutes: 0

    signal saved(string time, int advanceMinutes)

    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    parent: Overlay.overlay
    anchors.centerIn: parent
    width: 380
    padding: 0

    Theme { id: theme }

    onOpened: {
        var parts = initialTime.split(":")
        if (parts.length === 2) {
            hourCombo.currentIndex = parseInt(parts[0])
            minCombo.currentIndex = parseInt(parts[1])
        }
        advHourCombo.currentIndex = Math.floor(initialAdvanceMinutes / 60)
        advMinCombo.currentIndex = initialAdvanceMinutes % 60
    }

    Overlay.modal: Rectangle {
        color: "#80000000"
        Behavior on opacity { NumberAnimation { duration: 200 } }
    }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200; easing.type: Easing.OutQuad }
        NumberAnimation { property: "scale"; from: 0.92; to: 1; duration: 200; easing.type: Easing.OutQuad }
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 150; easing.type: Easing.InQuad }
        NumberAnimation { property: "scale"; from: 1; to: 0.92; duration: 150; easing.type: Easing.InQuad }
    }

    background: Rectangle {
        radius: theme.radiusLarge
        color: "#1a1a38"
        border.color: theme.cardBorderHover
        border.width: 1

        // 顶部 Cyan 发光渐变
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * 0.4
            radius: theme.radiusLarge
            gradient: Gradient {
                GradientStop { position: 0.0; color: theme.glowCyan }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        // 外圈发光环
        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            radius: theme.radiusLarge + 2
            color: "transparent"
            border.color: theme.glowCyan
            border.width: 1
            opacity: 0.4
        }
    }

    contentItem: ColumnLayout {
        spacing: theme.spacingMedium
        // 标题 → 时间卡片 → 时长卡片 → 按钮
        ...

        // 提醒时间卡片（Cyan 主题色）
        Rectangle { ... 内含 hourCombo / minCombo 两个 TimeComboBox ... }

        // 提前监测时长卡片（Purple 主题色）
        Rectangle { ... 内含 advHourCombo / advMinCombo 两个 TimeComboBox ... }

        // 底部按钮：取消（透明）+ 保存（Cyan 渐变+发光环）
        ...
    }
}
```

### TimeComboBox.qml (`qml/components/TimeComboBox.qml`)

```qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ComboBox {
    id: combo

    property color accentColor: "#00f0ff"

    implicitWidth: 72
    implicitHeight: 36
    textRole: "text"
    wheelEnabled: true

    Theme { id: theme }

    displayText: currentIndex.toString().padStart(2, '0')

    contentItem: Text { ... }     // 居中两位数字显示
    background: Rectangle { ... } // 玻璃态背景+hover/聚焦边框
    indicator: Text { text: "▾" } // 弹出时翻转180°
    popup: Popup { ... }          // 暗色下拉面板，最大260px高，带滚动条
    delegate: ItemDelegate { ... } // 高亮当前项（accentColor文字）
}
```

使用方式：`model: 24`（小时，0-23）或 `model: 60`（分钟，0-59），数值自动生成。

## 主题系统 (Theme.qml)

```qml
import QtQuick

QtObject {
    // ── Color palette (dark glassmorphism) ──
    property color windowGradientTop: "#111124"
    property color windowGradientBottom: "#06060c"
    
    // Glass card backgrounds (frosted glass)
    property color cardBg: "#0affffff"
    property color cardBgHover: "#18ffffff"
    property color cardBorder: "#12ffffff"
    property color cardBorderHover: "#28ffffff"
    
    // Accents
    property color accent: "#00f0ff"        // Electric Cyan
    property color accentWarm: "#ff7b90"    // Sunset Coral
    property color accentSecondary: "#a78bfa" // Pastel Purple
    
    // Glowing borders
    property color glowCyan: "#3000f0ff"
    property color glowCoral: "#30ff7b90"
    
    // Typography colors
    property color primaryText: "#f8fafc"
    property color secondaryText: "#cbd5e1"
    property color mutedText: "#64748b"
    
    // System statuses
    property color dangerBg: "#25f87171"
    property color dangerText: "#f87171"
    property color successBg: "#254ade80"
    property color successText: "#4ade80"
    
    property color divider: "#10ffffff"

    // ── Spacing ──
    property int spacingTiny: 5
    property int spacingSmall: 10
    property int spacingMedium: 16
    property int spacingLarge: 24

    // ── Radii (Modern, softer corners) ──
    property int radiusSmall: 8
    property int radiusMedium: 14
    property int radiusLarge: 20

    // ── Fonts (Microsoft YaHei optimized for readability) ──
    property string defaultFamily: "Microsoft YaHei"
    property font titleFont: Qt.font({ family: defaultFamily, pointSize: 18, weight: Font.Bold })
    property font subtitleFont: Qt.font({ family: defaultFamily, pointSize: 13, weight: Font.DemiBold })
    property font bodyFont: Qt.font({ family: defaultFamily, pointSize: 11, weight: Font.Normal })
    property font captionFont: Qt.font({ family: defaultFamily, pointSize: 10, weight: Font.Normal })
}
```

## 调用方式 (SettingsView.qml 中的使用)

```qml
// 添加模式 —— 点击"添加提醒"按钮
onClicked: {
    root.editingOldTime = ""
    timePickerDialog.dialogTitle = qsTr("添加提醒")
    timePickerDialog.initialTime = "07:00"
    timePickerDialog.initialAdvanceMinutes = 0
    timePickerDialog.open()
}

// 修改模式 —— 点击列表中某项的"修改"按钮
onClicked: {
    root.editingOldTime = modelData
    timePickerDialog.dialogTitle = qsTr("修改提醒")
    timePickerDialog.initialTime = modelData
    var advList = settingsViewModel.alertAdvanceList
    timePickerDialog.initialAdvanceMinutes = index < advList.length ? parseInt(advList[index]) : 0
    timePickerDialog.open()
}

// 保存回调
TimePickerDialog {
    id: timePickerDialog
    onSaved: (time, advMin) => {
        if (root.editingOldTime !== "") {
            settingsViewModel.updateAlertTime(root.editingOldTime, time)
        } else {
            settingsViewModel.addAlertTime(time)
        }
        settingsViewModel.setAdvanceMinutes(time, advMin)
        root.editingOldTime = ""
    }
}
```

## 功能需求

1. **双模式**：添加新提醒和修改已有提醒共用同一个弹窗
2. **时间选择**：用户选择提醒触发的时间（HH:mm 格式，24小时制）
3. **时长选择**：用户选择提前多久开始监测天气（0-23小时 + 0-59分钟），0 表示不提前
4. **标题切换**：添加模式显示"添加提醒"，修改模式显示"修改提醒"
5. **修改回填**：修改模式下，弹窗打开时自动填入当前的提醒时间和时长
6. **保存回调**：点击保存后，通过 `saved` 信号将数据传回父组件处理
7. **关闭方式**：ESC 键、点击遮罩层、点击取消按钮均可关闭

## 存在问题

当前弹窗已通过 NotebookLM 辅助完成了视觉重设计，主要改进包括：
- 用 TimeComboBox 下拉选择器替代了 Qt Quick 默认的 SpinBox 控件
- 将"提醒时间"和"提前监测时长"划分为两个独立的卡片式区域
- 背景增加了顶部 Cyan 发光渐变和外圈 glow ring
- 保存按钮使用 Cyan 渐变背景+外发光环，与取消按钮形成清晰的主次层级

已知待优化点：
- TimeComboBox 的下拉面板可进一步添加搜索/过滤功能（时间值较多时）
- 可考虑在弹窗顶部添加时钟图标增强视觉识别

## 设计要求

已完成的设计改进：
1. 与应用暗色玻璃态主题风格统一
2. 利用主题色（Electric Cyan #00f0ff、Pastel Purple #a78bfa）区分时间/时长两个功能区域
3. 保持 QML/Qt Quick 技术栈（仅使用 Rectangle、Text、ComboBox 等基础组件）
4. 弹窗居中显示、模态遮罩、进出缩放动画
5. 背景添加渐变发光和外圈 glow ring
6. 使用自定义 TimeComboBox 替代 SpinBox，提供下拉选择体验
7. 保存按钮使用渐变+发光环突出主操作层级
