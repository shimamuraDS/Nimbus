import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ComboBox {
    id: combo

    property color accentColor: "#00f0ff"

    implicitWidth: 72
    implicitHeight: 36
    textRole: "text"
    wheelEnabled: true

    Theme { id: theme }

    displayText: currentIndex.toString().padStart(2, '0')

    contentItem: Text {
        text: combo.displayText
        font: Qt.font({ family: theme.defaultFamily, pointSize: 16, weight: Font.DemiBold })
        color: theme.primaryText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        radius: theme.radiusSmall
        color: combo.pressed ? theme.cardBgHover : (combo.hovered ? theme.cardBgHover : theme.cardBg)
        border.color: combo.activeFocus ? combo.accentColor :
                      (combo.hovered ? theme.cardBorderHover : theme.cardBorder)
        border.width: 1
        Behavior on color { ColorAnimation { duration: 120 } }
        Behavior on border.color { ColorAnimation { duration: 120 } }
    }

    indicator: Text {
        x: combo.width - width - 10
        y: (combo.height - height) / 2
        text: "▾"
        font.pixelSize: 10
        color: combo.accentColor
        rotation: combo.popup.visible ? 180 : 0
        Behavior on rotation { NumberAnimation { duration: 150 } }
    }

    popup: Popup {
        y: combo.height + 4
        width: Math.max(combo.width, 90)
        implicitHeight: contentItem.implicitHeight
        padding: 4

        contentItem: ListView {
            clip: true
            implicitHeight: Math.min(contentHeight, 260)
            model: combo.popup.visible ? combo.delegateModel : null
            currentIndex: combo.currentIndex
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
        }

        background: Rectangle {
            radius: theme.radiusSmall
            color: "#1e1e42"
            border.color: theme.cardBorderHover
            border.width: 1
        }
    }

    delegate: ItemDelegate {
        width: combo.popup.width - 8
        implicitHeight: 32
        anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined

        contentItem: Text {
            text: modelData.toString().padStart(2, '0')
            font: theme.bodyFont
            color: highlighted ? combo.accentColor : theme.primaryText
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {
            radius: theme.radiusSmall - 2
            color: highlighted ? theme.cardBgHover : "transparent"
        }

        highlighted: ListView.isCurrentItem || hovered
    }
}
