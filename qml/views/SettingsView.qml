import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root
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
        anchors.margins: 20
        spacing: 15

        // 1. 定位设置模块
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Text {
                id: locationText
                text: {
                    if (typeof settingsViewModel === "undefined") return ""
                    return settingsViewModel.isAutoLocation
                        ? qsTr("自动定位：【") + (typeof weatherViewModel !== "undefined" ? weatherViewModel.currentCity : "") + qsTr("】？定位不准？")
                        : qsTr("手动定位：【选择城市】手动定位")
                }
                font.pixelSize: 14
                color: "#0066cc"
                font.underline: true

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (typeof settingsViewModel !== "undefined") {
                            if (settingsViewModel.isAutoLocation) {
                                settingsViewModel.setAutoLocation(false)
                            } else {
                                settingsViewModel.setAutoLocation(true)
                            }
                        }
                    }
                }
            }

            CitySelector {
                visible: typeof settingsViewModel !== "undefined" && !settingsViewModel.isAutoLocation
                onCitySelected: function(adcode, name) {
                    if (typeof settingsViewModel !== "undefined") {
                        settingsViewModel.setManualCity(adcode, name)
                    }
                }
            }
        }

        Rectangle { height: 1; color: "#bdc3c7"; Layout.fillWidth: true }

        // 2. 提醒时间设置模块
        Text {
            text: qsTr("设置提醒时间：")
            font.pixelSize: 14
            font.bold: true
            color: "#2c3e50"
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: typeof settingsViewModel !== "undefined" ? settingsViewModel.alertTimeList : []
            spacing: 5

            delegate: RowLayout {
                width: parent ? parent.width : 200

                Text {
                    text: modelData
                    font.pixelSize: 16
                    color: "#2c3e50"
                    Layout.alignment: Qt.AlignVCenter
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: qsTr("【删除时间点】")
                    onClicked: {
                        if (typeof settingsViewModel !== "undefined") {
                            settingsViewModel.removeAlertTime(modelData)
                        }
                    }
                }
            }
        }

        // 底部常驻添加按钮
        Button {
            text: qsTr("【添加时间点】")
            Layout.alignment: Qt.AlignHCenter
            onClicked: timePicker.open()
        }
    }
}
