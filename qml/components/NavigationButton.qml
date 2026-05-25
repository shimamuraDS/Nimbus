import QtQuick
import QtQuick.Controls

Button {
    id: control

    Theme { id: theme }

    property string direction: "left"

    width: 36
    height: 36

    contentItem: Text {
        text: control.direction === "left" ? "‹" : "›"
        font.pixelSize: 24
        font.bold: true
        color: control.pressed ? theme.accent : (control.hovered ? "#ffffff" : theme.secondaryText)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        topPadding: -3
        leftPadding: control.direction === "left" ? -1 : 1
        
        Behavior on color { ColorAnimation { duration: 150 } }
    }

    background: Rectangle {
        radius: 18
        color: control.pressed ? theme.cardBgHover : (control.hovered ? theme.cardBgHover : theme.cardBg)
        border.color: control.pressed ? theme.accent : (control.hovered ? theme.cardBorderHover : theme.cardBorder)
        border.width: 1

        scale: control.pressed ? 0.9 : (control.hovered ? 1.08 : 1.0)

        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on border.color { ColorAnimation { duration: 150 } }
    }
}
