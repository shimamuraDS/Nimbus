import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dialog {
    id: root

    Theme { id: theme }

    title: qsTr("选择提醒时间")
    modal: true
    anchors.centerIn: parent
    standardButtons: Dialog.Ok | Dialog.Cancel

    signal timeSelected(string timeHHmm)

    background: Rectangle {
        radius: theme.radiusMedium
        color: "#252536"
        border.color: theme.cardBorder
        border.width: 1
    }

    header: Text {
        text: root.title
        font: theme.subtitleFont
        color: theme.primaryText
        leftPadding: theme.spacingLarge
        topPadding: theme.spacingMedium
        bottomPadding: theme.spacingSmall
    }

    contentItem: RowLayout {
        spacing: theme.spacingSmall

        SpinBox {
            id: hourBox
            from: 0; to: 23; value: 8
            font: theme.bodyFont
            contentItem: TextInput {
                text: hourBox.value.toString().padStart(2, '0')
                font: theme.bodyFont
                color: theme.primaryText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                readOnly: true
            }
            background: Rectangle {
                radius: theme.radiusSmall
                color: theme.cardBg
                border.color: theme.cardBorder
            }
        }
        Text {
            text: ":"
            font.pixelSize: 22
            font.bold: true
            color: theme.primaryText
        }
        SpinBox {
            id: minBox
            from: 0; to: 59; value: 0
            font: theme.bodyFont
            contentItem: TextInput {
                text: minBox.value.toString().padStart(2, '0')
                font: theme.bodyFont
                color: theme.primaryText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                readOnly: true
            }
            background: Rectangle {
                radius: theme.radiusSmall
                color: theme.cardBg
                border.color: theme.cardBorder
            }
        }
    }

    onAccepted: {
        let hh = hourBox.value.toString().padStart(2, '0')
        let mm = minBox.value.toString().padStart(2, '0')
        root.timeSelected(hh + ":" + mm)
    }
}
