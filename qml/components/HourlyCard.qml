import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    width: 80
    height: 150
    radius: theme.radiusSmall
    color: isNow ? "#2589b4fa" : theme.cardBg
    border.color: isNow ? "#4089b4fa" : theme.cardBorder
    border.width: 1

    Theme { id: theme }

    property string time: "--:--"
    property string weather: "--"
    property int temperature: 0
    property bool isNow: false

    scale: isNow ? 1.05 : 1.0

    Behavior on color { ColorAnimation { duration: 200 } }
    Behavior on border.color { ColorAnimation { duration: 200 } }
    Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 8

        Text {
            text: time
            font: theme.bodyFont
            color: isNow ? "#ffffff" : theme.secondaryText
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle {
            height: 1
            width: 40
            color: isNow ? "#30ffffff" : theme.divider
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: weather
            font: theme.bodyFont
            color: theme.primaryText
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: temperature + "°"
            font: Qt.font({ family: theme.subtitleFont.family, pointSize: 18, weight: Font.Bold })
            color: isNow ? "#ffffff" : theme.accentWarm
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
