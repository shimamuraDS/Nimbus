import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    height: toolbarLayout.height
    color: "#2c3e50"

    property bool isSettingsPage: false

    signal settingsClicked()
    signal backClicked()

    ColumnLayout {
        id: toolbarLayout
        width: parent.width
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 15
            Layout.rightMargin: 10
            Layout.preferredHeight: 40

            Text {
                text: qsTr("天气提醒助手")
                font.pixelSize: 16
                font.bold: true
                color: "#ecf0f1"
                Layout.alignment: Qt.AlignVCenter
            }

            Item { Layout.fillWidth: true }

            Button {
                id: actionBtn
                text: root.isSettingsPage ? qsTr("返回") : qsTr("设置")
                font.pixelSize: 14
                flat: true

                contentItem: Text {
                    text: actionBtn.text
                    font: actionBtn.font
                    color: "#ecf0f1"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    radius: 4
                    color: actionBtn.hovered ? "#34495e" : "transparent"
                }

                onClicked: {
                    if (root.isSettingsPage) {
                        root.backClicked()
                    } else {
                        root.settingsClicked()
                    }
                }
            }
        }

        // 离线提示横幅
        Rectangle {
            Layout.fillWidth: true
            height: visible ? 22 : 0
            color: "#e74c3c"
            visible: typeof weatherViewModel !== "undefined" && weatherViewModel.isOffline

            Text {
                anchors.centerIn: parent
                text: qsTr("⚠ 网络连接异常，正在显示缓存数据")
                font.pixelSize: 11
                color: "#ffffff"
            }
        }
    }
}
