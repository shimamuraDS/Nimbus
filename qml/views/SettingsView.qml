import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root

    Theme { id: theme }

    objectName: "SettingsView"

    TimePicker {
        id: timePicker
        onTimeSelected: function(timeHHmm) {
            if (typeof settingsViewModel !== "undefined") {
                settingsViewModel.addAlertTime(timeHHmm)
            }
        }
    }

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

        // ── Add button ──
        Button {
            text: qsTr("添加时间点")
            Layout.alignment: Qt.AlignHCenter
            font: theme.bodyFont

            contentItem: Text {
                text: qsTr("添加时间点")
                font: theme.bodyFont
                color: theme.primaryText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                radius: theme.radiusSmall
                color: parent.hovered ? theme.cardBgHover : theme.cardBg
                border.color: theme.cardBorder
                Behavior on color { ColorAnimation { duration: 150 } }
            }

            onClicked: timePicker.open()
        }
    }
}
