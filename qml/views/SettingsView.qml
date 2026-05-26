import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root

    Theme { id: theme }

    objectName: "SettingsView"

    property string editingOldTime: ""
    function formatAdvanceText(minutes) {
        if (minutes <= 0) return ""
        var h = Math.floor(minutes / 60)
        var m = minutes % 60
        if (h > 0 && m > 0) return qsTr("未来") + h + qsTr("小时") + m + qsTr("分钟")
        if (h > 0) return qsTr("未来") + h + qsTr("小时")
        return qsTr("未来") + m + qsTr("分钟")
    }

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

            // ── API settings (collapsible) ──
            APISettingsPane {
                Layout.fillWidth: true
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.divider
            }

            // ── Alert time list ──
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

                            Text {
                                visible: advText.text !== ""
                                text: {
                                    var advList = typeof settingsViewModel !== "undefined" ? settingsViewModel.alertAdvanceList : []
                                    return formatAdvanceText(index < advList.length ? parseInt(advList[index]) : 0)
                                }
                                id: advText
                                font: theme.captionFont
                                color: theme.accentSecondary
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
                                    root.editingOldTime = modelData
                                    timePickerDialog.dialogTitle = qsTr("修改提醒")
                                    timePickerDialog.initialTime = modelData
                                    var advList = typeof settingsViewModel !== "undefined" ? settingsViewModel.alertAdvanceList : []
                                    timePickerDialog.initialAdvanceMinutes = index < advList.length ? parseInt(advList[index]) : 0
                                    timePickerDialog.open()
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

            // ── Add button ──
            Button {
                id: addBtn
                text: qsTr("添加提醒")
                font: theme.bodyFont
                flat: true
                implicitWidth: 120
                implicitHeight: 36
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: theme.spacingSmall

                contentItem: Text {
                    text: addBtn.text
                    font: theme.bodyFont
                    color: theme.accent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    radius: theme.radiusSmall
                    color: addBtn.pressed ? theme.cardBgHover : (addBtn.hovered ? theme.cardBgHover : theme.cardBg)
                    border.color: addBtn.pressed ? theme.accent : (addBtn.hovered ? theme.cardBorderHover : theme.cardBorder)
                    border.width: 1
                    Behavior on color { ColorAnimation { duration: 150 } }
                    Behavior on border.color { ColorAnimation { duration: 150 } }
                }

                onClicked: {
                    root.editingOldTime = ""
                    timePickerDialog.dialogTitle = qsTr("添加提醒")
                    timePickerDialog.initialTime = "07:00"
                    timePickerDialog.initialAdvanceMinutes = 0
                    timePickerDialog.open()
                }
            }

            // ── Time picker dialog ──
            TimePickerDialog {
                id: timePickerDialog
                onSaved: (time, advMin) => {
                    if (typeof settingsViewModel === "undefined") return
                    if (root.editingOldTime !== "") {
                        settingsViewModel.updateAlertTime(root.editingOldTime, time)
                    } else {
                        settingsViewModel.addAlertTime(time)
                    }
                    settingsViewModel.setAdvanceMinutes(time, advMin)
                    root.editingOldTime = ""
                }
            }
        }
    }
}
