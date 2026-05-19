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

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: theme.spacingLarge
        spacing: theme.spacingMedium

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
                    underline: true
                }
                color: theme.accent

                MouseArea {
                    anchors.fill: parent
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
                    underline: true
                }
                color: theme.accent

                MouseArea {
                    anchors.fill: parent
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

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: typeof settingsViewModel !== "undefined" ? settingsViewModel.alertTimeList : []
            spacing: theme.spacingTiny

            delegate: RowLayout {
                width: parent ? parent.width : 200

                Text {
                    text: modelData
                    font: theme.bodyFont
                    color: theme.primaryText
                    Layout.alignment: Qt.AlignVCenter
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: qsTr("修改")
                    font: theme.captionFont
                    flat: true

                    contentItem: Text {
                        text: qsTr("修改")
                        font: theme.captionFont
                        color: theme.accent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        radius: theme.radiusSmall
                        color: parent.hovered ? theme.cardBgHover : "transparent"
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }

                    onClicked: {
                        root.modifyingIndex = index
                        root.modifyingOldTime = modelData
                    }
                }

                Button {
                    text: qsTr("删除")
                    font: theme.captionFont
                    flat: true

                    contentItem: Text {
                        text: qsTr("删除")
                        font: theme.captionFont
                        color: theme.dangerText
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        radius: theme.radiusSmall
                        color: parent.hovered ? theme.cardBgHover : "transparent"
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }

                    onClicked: {
                        if (typeof settingsViewModel !== "undefined") {
                            settingsViewModel.removeAlertTime(modelData)
                        }
                    }
                }
            }
        }

        // ── Add / Modify section ──
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: theme.spacingSmall

            ComboBox {
                id: hourCombo
                model: generateHourOptions()
                font: theme.bodyFont
                flat: true
                implicitWidth: 80

                contentItem: Text {
                    text: hourCombo.currentText
                    font: theme.bodyFont
                    color: theme.primaryText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    radius: theme.radiusSmall
                    color: theme.cardBg
                    border.color: theme.cardBorder
                }

                popup: Popup {
                    y: hourCombo.height
                    width: hourCombo.width
                    implicitHeight: contentItem.implicitHeight
                    padding: 1

                    contentItem: ListView {
                        clip: true
                        implicitHeight: 300
                        model: hourCombo.popup.visible ? hourCombo.delegateModel : null
                        currentIndex: hourCombo.highlightedIndex
                        ScrollIndicator.vertical: ScrollIndicator {}
                    }

                    background: Rectangle {
                        radius: theme.radiusSmall
                        color: "#1e1e30"
                        border.color: theme.cardBorder
                    }
                }

                delegate: ItemDelegate {
                    width: hourCombo.width
                    contentItem: Text {
                        text: modelData
                        font: theme.bodyFont
                        color: highlighted ? theme.accent : theme.primaryText
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    highlighted: hourCombo.highlightedIndex === index
                    background: Rectangle {
                        color: highlighted ? "#2a2a45" : "transparent"
                    }
                }
            }

            Text {
                text: ":"
                font.pixelSize: 22
                font.bold: true
                color: theme.primaryText
            }

            ComboBox {
                id: minCombo
                model: generateMinuteOptions()
                font: theme.bodyFont
                flat: true
                implicitWidth: 80
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
                    color: theme.cardBg
                    border.color: theme.cardBorder
                }

                popup: Popup {
                    y: minCombo.height
                    width: minCombo.width
                    implicitHeight: contentItem.implicitHeight
                    padding: 1

                    contentItem: ListView {
                        clip: true
                        implicitHeight: 300
                        model: minCombo.popup.visible ? minCombo.delegateModel : null
                        currentIndex: minCombo.highlightedIndex
                        ScrollIndicator.vertical: ScrollIndicator {}
                    }

                    background: Rectangle {
                        radius: theme.radiusSmall
                        color: "#1e1e30"
                        border.color: theme.cardBorder
                    }
                }

                delegate: ItemDelegate {
                    width: minCombo.width
                    contentItem: Text {
                        text: modelData
                        font: theme.bodyFont
                        color: highlighted ? theme.accent : theme.primaryText
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    highlighted: minCombo.highlightedIndex === index
                    background: Rectangle {
                        color: highlighted ? "#2a2a45" : "transparent"
                    }
                }
            }

            Button {
                id: addModifyBtn
                text: root.modifyingIndex >= 0 ? qsTr("确认修改") : qsTr("添加")
                font: theme.bodyFont
                flat: true

                contentItem: Text {
                    text: addModifyBtn.text
                    font: theme.bodyFont
                    color: theme.accent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    radius: theme.radiusSmall
                    color: parent.hovered ? theme.cardBgHover : theme.cardBg
                    border.color: theme.cardBorder
                    Behavior on color { ColorAnimation { duration: 150 } }
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
                visible: root.modifyingIndex >= 0
                text: qsTr("取消")
                font: theme.bodyFont
                flat: true

                contentItem: Text {
                    text: qsTr("取消")
                    font: theme.bodyFont
                    color: theme.secondaryText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    radius: theme.radiusSmall
                    color: parent.hovered ? theme.cardBgHover : "transparent"
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                onClicked: root.modifyingIndex = -1
            }
        }
    }
}
