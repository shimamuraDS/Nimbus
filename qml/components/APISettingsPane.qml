import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    Layout.fillWidth: true
    implicitHeight: headerRow.height + (expanded ? contentCol.implicitHeight + theme.spacingMedium : 0)

    Theme { id: theme }
    property bool expanded: false

    // ── Header ──
    MouseArea {
        id: headerRow
        width: parent.width
        height: 30
        cursorShape: Qt.PointingHandCursor
        onClicked: root.expanded = !root.expanded

        RowLayout {
            anchors.fill: parent
            spacing: theme.spacingSmall

            Rectangle { width: 8; height: 8; radius: 4; color: theme.mutedText; Layout.alignment: Qt.AlignVCenter }

            Text {
                text: qsTr("API 设置")
                font: theme.bodyFont
                color: theme.primaryText
                Layout.alignment: Qt.AlignVCenter
            }

            Item { Layout.fillWidth: true }

            Text {
                text: root.expanded ? "▾" : "▸"
                font: theme.captionFont
                color: theme.secondaryText
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }

    // ── Expanded content ──
    ColumnLayout {
        id: contentCol
        anchors.top: headerRow.bottom
        anchors.topMargin: theme.spacingMedium
        anchors.left: parent.left
        anchors.right: parent.right
        visible: expanded
        spacing: theme.spacingMedium

        // ── Weather API ──
        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: theme.spacingLarge
            Layout.rightMargin: theme.spacingLarge
            spacing: theme.spacingSmall

            RowLayout {
                spacing: theme.spacingTiny
                Rectangle { width: 8; height: 8; radius: 4; color: theme.accent }
                Text {
                    text: qsTr("天气 API")
                    font: theme.captionFont
                    color: theme.secondaryText
                }

                // Help icon
                Rectangle {
                    width: 16; height: 16; radius: 8
                    color: "transparent"
                    border.color: theme.secondaryText
                    border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "?"
                        font.pixelSize: 11
                        color: theme.secondaryText
                    }
                    MouseArea {
                        id: weatherApiHelpArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: Qt.openUrlExternally("https://lbs.qq.com/dev/console/application/mine")
                    }
                    ToolTip {
                        text: qsTr("如何获取？")
                        visible: weatherApiHelpArea.containsMouse
                        delay: 500
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 34
                radius: theme.radiusSmall
                color: theme.cardBg
                border.color: weatherKeyInput.activeFocus ? theme.accent : theme.cardBorder
                border.width: 1

                TextInput {
                    id: weatherKeyInput
                    anchors.fill: parent
                    anchors.margins: 8
                    text: typeof settingsViewModel !== "undefined" ? settingsViewModel.weatherApiKey : ""
                    font: theme.bodyFont
                    color: theme.primaryText
                    echoMode: TextInput.Password
                    passwordCharacter: "•"
                    verticalAlignment: Text.AlignVCenter
                    onEditingFinished: {
                        if (typeof settingsViewModel !== "undefined")
                            settingsViewModel.weatherApiKey = text
                    }
                }
            }
        }

        // ── LLM API (AI version only) ──
        Loader {
            id: llmLoader
            Layout.fillWidth: true
            source: "LLMSettingsPane.qml"
        }
    }
}
