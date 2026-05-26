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

        // Top glow gradient
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

        // Subtle outer glow ring
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

        // ── Title ──
        Text {
            text: root.dialogTitle
            font: theme.subtitleFont
            color: theme.primaryText
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: theme.spacingLarge
        }

        // ── Time section card ──
        Rectangle {
            Layout.fillWidth: true
            Layout.leftMargin: theme.spacingLarge
            Layout.rightMargin: theme.spacingLarge
            Layout.topMargin: theme.spacingSmall
            height: timeSectionLayout.implicitHeight + theme.spacingLarge
            radius: theme.radiusMedium
            color: theme.cardBg
            border.color: theme.cardBorder
            border.width: 1

            ColumnLayout {
                id: timeSectionLayout
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: theme.spacingMedium
                spacing: theme.spacingSmall

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: theme.spacingTiny

                    Rectangle {
                        width: 8; height: 8; radius: 4
                        color: theme.accent
                    }
                    Text {
                        text: qsTr("提醒时间")
                        font: theme.captionFont
                        color: theme.secondaryText
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 4
                    spacing: theme.spacingSmall

                    TimeComboBox {
                        id: hourCombo
                        model: 24
                        currentIndex: 7
                        accentColor: theme.accent
                    }

                    Text {
                        text: ":"
                        font: Qt.font({ family: theme.defaultFamily, pointSize: 20, weight: Font.Bold })
                        color: theme.primaryText
                        Layout.alignment: Qt.AlignVCenter
                    }

                    TimeComboBox {
                        id: minCombo
                        model: 60
                        currentIndex: 0
                        accentColor: theme.accent
                    }
                }
            }
        }

        // ── Duration section card ──
        Rectangle {
            Layout.fillWidth: true
            Layout.leftMargin: theme.spacingLarge
            Layout.rightMargin: theme.spacingLarge
            height: durSectionLayout.implicitHeight + theme.spacingLarge
            radius: theme.radiusMedium
            color: theme.cardBg
            border.color: theme.cardBorder
            border.width: 1

            ColumnLayout {
                id: durSectionLayout
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: theme.spacingMedium
                spacing: theme.spacingSmall

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: theme.spacingTiny

                    Rectangle {
                        width: 8; height: 8; radius: 4
                        color: theme.accentSecondary
                    }
                    Text {
                        text: qsTr("提前监测时长")
                        font: theme.captionFont
                        color: theme.secondaryText
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 4
                    spacing: 4

                    TimeComboBox {
                        id: advHourCombo
                        model: 24
                        currentIndex: 0
                        accentColor: theme.accentSecondary
                    }
                    Text {
                        text: qsTr("小时")
                        font: theme.bodyFont
                        color: theme.secondaryText
                        Layout.alignment: Qt.AlignVCenter
                    }

                    TimeComboBox {
                        id: advMinCombo
                        model: 60
                        currentIndex: 0
                        accentColor: theme.accentSecondary
                    }
                    Text {
                        text: qsTr("分钟")
                        font: theme.bodyFont
                        color: theme.secondaryText
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
            }
        }

        // ── Buttons ──
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: theme.spacingSmall
            Layout.bottomMargin: theme.spacingLarge
            spacing: theme.spacingMedium

            // Cancel
            Rectangle {
                width: 110; height: 40
                radius: 20
                color: cancelArea.containsMouse ? theme.cardBgHover : "transparent"
                border.color: theme.cardBorder
                border.width: 1
                Behavior on color { ColorAnimation { duration: 120 } }

                Text {
                    anchors.centerIn: parent
                    text: qsTr("取消")
                    font: theme.bodyFont
                    color: theme.secondaryText
                }
                MouseArea {
                    id: cancelArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.close()
                }
            }

            // Save — prominent
            Rectangle {
                width: 130; height: 40
                radius: 20
                gradient: Gradient {
                    GradientStop { position: 0.0; color: theme.accent }
                    GradientStop { position: 1.0; color: Qt.darker(theme.accent, 1.3) }
                }
                border.color: theme.accent
                border.width: 1

                // Glow ring
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: -2
                    radius: 22
                    color: "transparent"
                    border.color: theme.glowCyan
                    border.width: 2
                    opacity: saveArea.containsMouse ? 1.0 : 0.5
                    Behavior on opacity { NumberAnimation { duration: 180 } }
                }

                // Press dim overlay
                Rectangle {
                    anchors.fill: parent
                    radius: 20
                    color: "black"
                    opacity: saveArea.pressed ? 0.2 : 0.0
                    Behavior on opacity { NumberAnimation { duration: 80 } }
                }

                Text {
                    anchors.centerIn: parent
                    text: qsTr("保存")
                    font: Qt.font({ family: theme.defaultFamily, pointSize: 12, weight: Font.DemiBold })
                    color: "#0d0d1a"
                }
                MouseArea {
                    id: saveArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        var time = hourCombo.currentIndex.toString().padStart(2, '0') + ":" +
                                   minCombo.currentIndex.toString().padStart(2, '0')
                        var advMin = advHourCombo.currentIndex * 60 + advMinCombo.currentIndex
                        root.saved(time, advMin)
                        root.close()
                    }
                }
            }
        }
    }
}
