import QtQuick
import QtQuick.Controls

Button {
    id: control

    Theme { id: theme }

    property string direction: "left"

    width: 42
    height: 42

    contentItem: Text {
        text: control.direction === "left" ? "◀" : "▶"
        font.pixelSize: 18
        color: control.pressed ? theme.accent : theme.primaryText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        radius: 21
        color: control.hovered ? theme.cardBg : "transparent"
        border.color: control.hovered ? theme.cardBorder : "transparent"
        border.width: 1

        scale: control.pressed ? 0.88 : 1.0

        Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutQuad } }
        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on border.color { ColorAnimation { duration: 150 } }
    }
}
