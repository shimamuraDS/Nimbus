import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    Layout.fillWidth: true
    implicitHeight: llmLayout.implicitHeight + theme.spacingLarge

    Theme { id: theme }

    ColumnLayout {
        id: llmLayout
        anchors.fill: parent
        anchors.margins: theme.spacingLarge
        spacing: theme.spacingMedium

        // Section label
        RowLayout {
            spacing: theme.spacingTiny
            Rectangle { width: 8; height: 8; radius: 4; color: theme.accentWarm }
            Text {
                text: qsTr("AI Nimbus")
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
                    id: aiHelpArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: Qt.openUrlExternally("https://platform.deepseek.com/api_keys")
                }
                ToolTip {
                    text: qsTr("如何获取？")
                    visible: aiHelpArea.containsMouse
                    delay: 500
                }
            }
        }

        // Enable toggle
        RowLayout {
            Layout.fillWidth: true
            spacing: theme.spacingSmall
            Text {
                text: qsTr("启用 AI 生成提醒")
                font: theme.bodyFont
                color: theme.primaryText
                Layout.alignment: Qt.AlignVCenter
            }
            Item { Layout.fillWidth: true }
            Switch {
                id: llmToggle
                checked: typeof settingsViewModel !== "undefined" && settingsViewModel.llmEnabled
                onToggled: {
                    if (typeof settingsViewModel !== "undefined")
                        settingsViewModel.llmEnabled = checked
                }

                indicator: Rectangle {
                    implicitWidth: 42; implicitHeight: 22; radius: 11
                    color: llmToggle.checked ? theme.accentWarm : theme.cardBg
                    border.color: llmToggle.checked ? theme.accentWarm : theme.cardBorder
                    border.width: 1
                    Behavior on color { ColorAnimation { duration: 180 } }
                    Behavior on border.color { ColorAnimation { duration: 180 } }

                    Rectangle {
                        x: llmToggle.checked ? parent.width - width - 2 : 2
                        y: (parent.height - height) / 2
                        width: 18; height: 18; radius: 9
                        color: "#ffffff"
                        Behavior on x { NumberAnimation { duration: 180; easing.type: Easing.InOutQuad } }
                    }
                }
            }
        }

        // Settings fields (visible only when enabled)
        ColumnLayout {
            Layout.fillWidth: true
            spacing: theme.spacingSmall
            visible: llmToggle.checked
            opacity: llmToggle.checked ? 1 : 0

            // API URL
            Text {
                text: qsTr("API 地址")
                font: theme.captionFont
                color: theme.secondaryText
            }
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 34
                radius: theme.radiusSmall
                color: theme.cardBg
                border.color: apiUrlInput.activeFocus ? theme.accentWarm : theme.cardBorder
                border.width: 1

                TextInput {
                    id: apiUrlInput
                    anchors.fill: parent
                    anchors.margins: 8
                    text: typeof settingsViewModel !== "undefined" ? settingsViewModel.llmApiUrl : ""
                    font: theme.bodyFont
                    color: theme.primaryText
                    verticalAlignment: Text.AlignVCenter
                    onEditingFinished: {
                        if (typeof settingsViewModel !== "undefined")
                            settingsViewModel.llmApiUrl = text
                    }
                }
            }

            // API Key
            Text {
                text: qsTr("API Key")
                font: theme.captionFont
                color: theme.secondaryText
            }
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 34
                radius: theme.radiusSmall
                color: theme.cardBg
                border.color: apiKeyInput.activeFocus ? theme.accentWarm : theme.cardBorder
                border.width: 1

                TextInput {
                    id: apiKeyInput
                    anchors.fill: parent
                    anchors.margins: 8
                    text: typeof settingsViewModel !== "undefined" ? settingsViewModel.llmApiKey : ""
                    font: theme.bodyFont
                    color: theme.primaryText
                    echoMode: TextInput.Password
                    passwordCharacter: "•"
                    verticalAlignment: Text.AlignVCenter
                    onEditingFinished: {
                        if (typeof settingsViewModel !== "undefined")
                            settingsViewModel.llmApiKey = text
                    }
                }
            }

            // Model name
            Text {
                text: qsTr("模型名称")
                font: theme.captionFont
                color: theme.secondaryText
            }
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 34
                radius: theme.radiusSmall
                color: theme.cardBg
                border.color: modelInput.activeFocus ? theme.accentWarm : theme.cardBorder
                border.width: 1

                TextInput {
                    id: modelInput
                    anchors.fill: parent
                    anchors.margins: 8
                    text: typeof settingsViewModel !== "undefined" ? settingsViewModel.llmModelName : "deepseek-v4-pro"
                    font: theme.bodyFont
                    color: theme.primaryText
                    verticalAlignment: Text.AlignVCenter
                    onEditingFinished: {
                        if (typeof settingsViewModel !== "undefined")
                            settingsViewModel.llmModelName = text
                    }
                }
            }

            // Test connection
            RowLayout {
                Layout.topMargin: 2
                spacing: theme.spacingSmall

                Button {
                    id: testBtn
                    text: qsTr("测试连接")
                    font: theme.captionFont
                    flat: true
                    implicitHeight: 30

                    contentItem: Text {
                        text: testBtn.text
                        font: theme.captionFont
                        color: theme.accentWarm
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        radius: theme.radiusSmall
                        color: testBtn.pressed ? theme.cardBgHover : (testBtn.hovered ? theme.cardBgHover : theme.cardBg)
                        border.color: testBtn.hovered ? theme.cardBorderHover : theme.cardBorder
                        border.width: 1
                        Behavior on color { ColorAnimation { duration: 120 } }
                    }

                    onClicked: {
                        if (typeof settingsViewModel !== "undefined")
                            settingsViewModel.testLLMConnection()
                    }
                }

                Text {
                    id: testResult
                    text: typeof settingsViewModel !== "undefined" ? settingsViewModel.llmTestResult : ""
                    font: theme.captionFont
                    color: text === qsTr("连接成功") ? theme.successText :
                           (text === qsTr("连接失败") ? theme.dangerText : theme.secondaryText)
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }
    }
}
