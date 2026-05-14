import QtQuick
import QtQuick.Controls

Button {
    id: control
    property string direction: "left"

    width: 40
    height: 40
    text: direction === "left" ? "<" : ">"
    font.pixelSize: 20
    font.bold: true

    contentItem: Text {
        text: control.text
        font: control.font
        color: "#2c3e50"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        radius: 20
        color: control.hovered ? "#bdc3c7" : "#ecf0f1"
        border.color: "#bdc3c7"
    }
}
