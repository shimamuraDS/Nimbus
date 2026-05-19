import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    Theme { id: theme }

    height: toolbarLayout.height
    color: "transparent"

    property bool isSettingsPage: false

    signal settingsClicked()
    signal backClicked()

    ColumnLayout {
        id: toolbarLayout
        width: parent.width
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: theme.spacingLarge
            Layout.rightMargin: theme.spacingMedium
            Layout.preferredHeight: 44

            Text {
                text: qsTr("天气提醒助手")
                font: theme.titleFont
                color: theme.primaryText
                Layout.alignment: Qt.AlignVCenter
            }

            Item { Layout.fillWidth: true }

            Button {
                id: actionBtn
                text: root.isSettingsPage ? qsTr("返回") : qsTr("设置")
                font: theme.bodyFont
                flat: true

                contentItem: Text {
                    text: actionBtn.text
                    font: actionBtn.font
                    color: theme.primaryText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    radius: theme.radiusSmall
                    color: actionBtn.hovered ? theme.cardBgHover : "transparent"
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                onClicked: {
                    if (root.isSettingsPage) {
                        root.backClicked()
                    } else {
                        root.settingsClicked()
                    }
                }
            }

            Button {
                id: minimizeBtn
                text: qsTr("−")
                font: theme.titleFont
                flat: true
                Layout.preferredWidth: 36
                Layout.preferredHeight: 28

                contentItem: Text {
                    text: minimizeBtn.text
                    font: minimizeBtn.font
                    color: theme.primaryText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    radius: theme.radiusSmall
                    color: minimizeBtn.hovered ? theme.cardBgHover : "transparent"
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                onClicked: {
                    if (typeof trayViewModel !== "undefined") {
                        trayViewModel.hideWindow()
                    }
                }
            }
        }

        // ── Offline warning banner ──
        Rectangle {
            Layout.fillWidth: true
            height: visible ? 24 : 0
            color: theme.dangerBg
            visible: typeof weatherViewModel !== "undefined" && weatherViewModel.isOffline

            Behavior on height { NumberAnimation { duration: 200 } }

            Text {
                anchors.centerIn: parent
                text: qsTr("⚠ 网络连接异常，正在显示缓存数据")
                font: theme.captionFont
                color: theme.primaryText
            }
        }
    }
}
