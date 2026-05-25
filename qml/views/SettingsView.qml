import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root

    Theme { id: theme }

    objectName: "SettingsView"

    // 生成小时选项 00 ~ 23
    function generateHourOptions() {
        var options = []
        for (var h = 0; h < 24; h++) {
            options.push(h.toString().padStart(2, '0'))
        }
        return options
    }

    // 生成分钟选项 00 ~ 59
    function generateMinuteOptions() {
        var options = []
        for (var m = 0; m < 60; m++) {
            options.push(m.toString().padStart(2, '0'))
        }
        return options
    }

    // 获取当前选中的时间字符串 HH:mm
    function selectedTime() {
        return hourCombo.currentText + ":" + minCombo.currentText
    }

    // 修改状态
    property int modifyingIndex: -1
    property string modifyingOldTime: ""

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: settingsLayout.implicitHeight + theme.spacingLarge * 2
        clip: true
        
        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }

        ColumnLayout {
            id: settingsLayout
            width: parent.width - theme.spacingLarge * 2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: theme.spacingLarge
            spacing: theme.spacingMedium

            // ── 0. Auto-start setting ──
            RowLayout {
                Layout.fillWidth: true
                spacing: theme.spacingSmall

                Text {
                    text: qsTr("开机自启动")
                    font: theme.bodyFont
                    color: theme.primaryText
                    Layout.alignment: Qt.AlignVCenter
                }

                Item { Layout.fillWidth: true }

                Switch {
                    id: autoStartSwitch
                    checked: typeof settingsViewModel !== "undefined" ? settingsViewModel.isAutoStart : true
                    onToggled: {
                        if (typeof settingsViewModel !== "undefined") {
                            settingsViewModel.setAutoStart(checked)
                        }
                    }

                    indicator: Rectangle {
                        implicitWidth: 42
                        implicitHeight: 22
                        radius: 11
                        color: autoStartSwitch.checked ? theme.accent : theme.cardBg
                        border.color: autoStartSwitch.checked ? theme.accent : theme.cardBorder
                        border.width: 1

                        Behavior on color { ColorAnimation { duration: 180 } }
                        Behavior on border.color { ColorAnimation { duration: 180 } }

                        Rectangle {
                            x: autoStartSwitch.checked ? parent.width - width - 2 : 2
                            y: (parent.height - height) / 2
                            width: 18
                            height: 18
                            radius: 9
                            color: "#ffffff"

                            Behavior on x { NumberAnimation { duration: 180; easing.type: Easing.InOutQuad } }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.divider
            }

            // ── 1. Location settings ──
            RowLayout {
                Layout.fillWidth: true
                spacing: theme.spacingSmall

                // ── Auto-location mode ──
                Text {
                    visible: typeof settingsViewModel !== "undefined" && settingsViewModel.isAutoLocation
                    text: typeof settingsViewModel !== "undefined"
                        ? qsTr("自动定位：【") + (typeof weatherViewModel !== "undefined" ? weatherViewModel.currentCity : "") + qsTr("】")
                        : ""
                    font: theme.bodyFont
                    color: theme.primaryText
                }

                Text {
                    visible: typeof settingsViewModel !== "undefined" && settingsViewModel.isAutoLocation
                    text: qsTr("定位不准？")
                    font {
                        family: theme.bodyFont.family
                        pointSize: theme.bodyFont.pointSize
                        weight: theme.bodyFont.weight
                        underline: !locLinkArea.containsMouse
                    }
                    color: locLinkArea.containsMouse ? theme.accent : theme.accentWarm
                    Behavior on color { ColorAnimation { duration: 120 } }

                    MouseArea {
                        id: locLinkArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (typeof settingsViewModel !== "undefined") {
                                settingsViewModel.setAutoLocation(false)
                            }
                        }
                    }
                }

                // ── Manual mode ──
                Text {
                    visible: typeof settingsViewModel !== "undefined" && !settingsViewModel.isAutoLocation
                    text: qsTr("选择城市：")
                    font: theme.bodyFont
                    color: theme.primaryText
                }

                CitySelector {
                    visible: typeof settingsViewModel !== "undefined" && !settingsViewModel.isAutoLocation
                    onCitySelected: function(adcode, name) {
                        if (typeof settingsViewModel !== "undefined") {
                            settingsViewModel.setManualCity(adcode, name)
                        }
                    }
                }

                Text {
                    visible: typeof settingsViewModel !== "undefined" && !settingsViewModel.isAutoLocation
                    text: qsTr("返回自动定位")
                    font {
                        family: theme.bodyFont.family
                        pointSize: theme.bodyFont.pointSize
                        weight: theme.bodyFont.weight
                        underline: !autoLocLinkArea.containsMouse
                    }
                    color: autoLocLinkArea.containsMouse ? theme.accent : theme.accentWarm
                    Behavior on color { ColorAnimation { duration: 120 } }

                    MouseArea {
                        id: autoLocLinkArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (typeof settingsViewModel !== "undefined") {
                                settingsViewModel.setAutoLocation(true)
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.divider
            }

            // ── 2. Alert time list ──
            Text {
                text: qsTr("设置提醒时间：")
                font: theme.subtitleFont
                color: theme.primaryText
            }

            ColumnLayout {
                id: alertTimesColumn
                Layout.fillWidth: true
                spacing: theme.spacingTiny

                Repeater {
                    model: typeof settingsViewModel !== "undefined" ? settingsViewModel.alertTimeList : []

                    delegate: Rectangle {
                        id: alertItemCard
                        Layout.fillWidth: true
                        height: 38
                        radius: theme.radiusSmall
                        color: hoverArea.containsMouse ? theme.cardBgHover : theme.cardBg
                        border.color: hoverArea.containsMouse ? theme.cardBorderHover : theme.cardBorder
                        border.width: 1
                        
                        Behavior on color { ColorAnimation { duration: 150 } }
                        Behavior on border.color { ColorAnimation { duration: 150 } }
                        
                        MouseArea {
                            id: hoverArea
                            anchors.fill: parent
                            hoverEnabled: true
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: theme.spacingSmall
                            anchors.rightMargin: theme.spacingSmall

                            Text {
                                text: modelData
                                font: theme.bodyFont
                                color: theme.primaryText
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Item { Layout.fillWidth: true }

                            Button {
                                id: editBtn
                                font: theme.captionFont
                                flat: true
                                Layout.preferredHeight: 26

                                contentItem: Text {
                                    text: qsTr("修改")
                                    font: editBtn.font
                                    color: theme.accent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                background: Rectangle {
                                    radius: theme.radiusSmall - 2
                                    color: editBtn.pressed ? theme.cardBgHover : (editBtn.hovered ? theme.cardBg : "transparent")
                                    border.color: editBtn.hovered ? theme.cardBorder : "transparent"
                                    border.width: 1
                                    Behavior on color { ColorAnimation { duration: 120 } }
                                }

                                onClicked: {
                                    root.modifyingIndex = index
                                    root.modifyingOldTime = modelData
                                    var parts = modelData.split(":")
                                    if (parts.length === 2) {
                                        hourCombo.currentIndex = hourCombo.model.indexOf(parts[0])
                                        minCombo.currentIndex = minCombo.model.indexOf(parts[1])
                                    }
                                }
                            }

                            Button {
                                id: deleteBtn
                                font: theme.captionFont
                                flat: true
                                Layout.preferredHeight: 26

                                contentItem: Text {
                                    text: qsTr("删除")
                                    font: deleteBtn.font
                                    color: theme.dangerText
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                background: Rectangle {
                                    radius: theme.radiusSmall - 2
                                    color: deleteBtn.pressed ? theme.cardBgHover : (deleteBtn.hovered ? theme.cardBg : "transparent")
                                    border.color: deleteBtn.hovered ? theme.cardBorder : "transparent"
                                    border.width: 1
                                    Behavior on color { ColorAnimation { duration: 120 } }
                                }

                                onClicked: {
                                    if (typeof settingsViewModel !== "undefined") {
                                        settingsViewModel.removeAlertTime(modelData)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // ── Add / Modify section ──
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: theme.spacingSmall
                Layout.topMargin: theme.spacingSmall

                ComboBox {
                    id: hourCombo
                    model: generateHourOptions()
                    font: theme.bodyFont
                    flat: true
                    implicitWidth: 72
                    implicitHeight: 32

                    contentItem: Text {
                        text: hourCombo.currentText
                        font: theme.bodyFont
                        color: theme.primaryText
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        radius: theme.radiusSmall
                        color: hourCombo.hovered ? theme.cardBgHover : theme.cardBg
                        border.color: hourCombo.pressed ? theme.accent : (hourCombo.hovered ? theme.cardBorderHover : theme.cardBorder)
                        border.width: 1
                        Behavior on color { ColorAnimation { duration: 150 } }
                        Behavior on border.color { ColorAnimation { duration: 150 } }
                    }

                    popup: Popup {
                        y: hourCombo.height + 4
                        width: hourCombo.width
                        implicitHeight: Math.min(contentItem.implicitHeight + 8, 200)
                        padding: 4

                        enter: Transition {
                            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 180; easing.type: Easing.OutQuad }
                            NumberAnimation { property: "y"; from: hourCombo.height - 4; to: hourCombo.height + 4; duration: 180; easing.type: Easing.OutQuad }
                        }

                        contentItem: ListView {
                            clip: true
                            implicitHeight: Math.min(contentHeight, 200)
                            model: hourCombo.popup.visible ? hourCombo.delegateModel : null
                            currentIndex: hourCombo.highlightedIndex
                            ScrollIndicator.vertical: ScrollIndicator {}
                        }

                        background: Rectangle {
                            radius: theme.radiusMedium
                            color: "#16162a"
                            border.color: theme.cardBorderHover
                            border.width: 1
                        }
                    }

                    delegate: ItemDelegate {
                        id: hourDel
                        width: hourCombo.width
                        height: 28
                        
                        contentItem: Text {
                            text: modelData
                            font: theme.bodyFont
                            color: hourDel.hovered ? theme.accent : theme.primaryText
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        background: Rectangle {
                            color: hourDel.hovered ? theme.cardBgHover : "transparent"
                            Behavior on color { ColorAnimation { duration: 120 } }
                        }
                    }
                }

                Text {
                    text: ":"
                    font.pixelSize: 18
                    font.bold: true
                    color: theme.primaryText
                }

                ComboBox {
                    id: minCombo
                    model: generateMinuteOptions()
                    font: theme.bodyFont
                    flat: true
                    implicitWidth: 72
                    implicitHeight: 32
                    currentIndex: 0

                    contentItem: Text {
                        text: minCombo.currentText
                        font: theme.bodyFont
                        color: theme.primaryText
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        radius: theme.radiusSmall
                        color: minCombo.hovered ? theme.cardBgHover : theme.cardBg
                        border.color: minCombo.pressed ? theme.accent : (minCombo.hovered ? theme.cardBorderHover : theme.cardBorder)
                        border.width: 1
                        Behavior on color { ColorAnimation { duration: 150 } }
                        Behavior on border.color { ColorAnimation { duration: 150 } }
                    }

                    popup: Popup {
                        y: minCombo.height + 4
                        width: minCombo.width
                        implicitHeight: Math.min(contentItem.implicitHeight + 8, 200)
                        padding: 4

                        enter: Transition {
                            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 180; easing.type: Easing.OutQuad }
                            NumberAnimation { property: "y"; from: minCombo.height - 4; to: minCombo.height + 4; duration: 180; easing.type: Easing.OutQuad }
                        }

                        contentItem: ListView {
                            clip: true
                            implicitHeight: Math.min(contentHeight, 200)
                            model: minCombo.popup.visible ? minCombo.delegateModel : null
                            currentIndex: minCombo.highlightedIndex
                            ScrollIndicator.vertical: ScrollIndicator {}
                        }

                        background: Rectangle {
                            radius: theme.radiusMedium
                            color: "#16162a"
                            border.color: theme.cardBorderHover
                            border.width: 1
                        }
                    }

                    delegate: ItemDelegate {
                        id: minDel
                        width: minCombo.width
                        height: 28
                        
                        contentItem: Text {
                            text: modelData
                            font: theme.bodyFont
                            color: minDel.hovered ? theme.accent : theme.primaryText
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        background: Rectangle {
                            color: minDel.hovered ? theme.cardBgHover : "transparent"
                            Behavior on color { ColorAnimation { duration: 120 } }
                        }
                    }
                }

                Button {
                    id: addModifyBtn
                    text: root.modifyingIndex >= 0 ? qsTr("保存") : qsTr("添加")
                    font: theme.bodyFont
                    flat: true
                    implicitHeight: 32

                    contentItem: Text {
                        text: addModifyBtn.text
                        font: theme.bodyFont
                        color: theme.accent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 12
                        rightPadding: 12
                    }

                    background: Rectangle {
                        radius: theme.radiusSmall
                        color: addModifyBtn.pressed ? theme.cardBgHover : (addModifyBtn.hovered ? theme.cardBgHover : theme.cardBg)
                        border.color: addModifyBtn.pressed ? theme.accent : (addModifyBtn.hovered ? theme.cardBorderHover : theme.cardBorder)
                        border.width: 1
                        Behavior on color { ColorAnimation { duration: 150 } }
                        Behavior on border.color { ColorAnimation { duration: 150 } }
                    }

                    onClicked: {
                        if (typeof settingsViewModel === "undefined") return

                        var newTime = root.selectedTime()
                        if (root.modifyingIndex >= 0) {
                            settingsViewModel.updateAlertTime(root.modifyingOldTime, newTime)
                            root.modifyingIndex = -1
                        } else {
                            settingsViewModel.addAlertTime(newTime)
                        }
                    }
                }

                Button {
                    id: cancelBtn
                    visible: root.modifyingIndex >= 0
                    text: qsTr("取消")
                    font: theme.bodyFont
                    flat: true
                    implicitHeight: 32

                    contentItem: Text {
                        text: cancelBtn.text
                        font: theme.bodyFont
                        color: theme.secondaryText
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 12
                        rightPadding: 12
                    }

                    background: Rectangle {
                        radius: theme.radiusSmall
                        color: cancelBtn.pressed ? theme.cardBgHover : (cancelBtn.hovered ? theme.cardBg : "transparent")
                        border.color: cancelBtn.hovered ? theme.cardBorder : "transparent"
                        border.width: 1
                        Behavior on color { ColorAnimation { duration: 150 } }
                        Behavior on border.color { ColorAnimation { duration: 150 } }
                    }

                    onClicked: root.modifyingIndex = -1
                }
            }
        }
    }
}
