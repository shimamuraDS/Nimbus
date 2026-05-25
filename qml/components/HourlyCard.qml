import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    width: 80
    height: 170
    radius: theme.radiusMedium
    
    Theme { id: theme }

    property string time: "--:--"
    property string weather: "--"
    property int temperature: 0
    property bool isNow: false

    function weatherIcon(weatherStr) {
        var basePath = "qrc:/resources/icons/weather/"
        if (weatherStr.indexOf("晴") >= 0) return basePath + "sunny.png"
        if (weatherStr.indexOf("多云") >= 0) return basePath + "cloudy.png"
        if (weatherStr.indexOf("阴") >= 0) return basePath + "overcast.png"
        if (weatherStr.indexOf("雷阵雨") >= 0) return basePath + "thunderstorm.png"
        if (weatherStr.indexOf("雪") >= 0) return basePath + "snow.png"
        if (weatherStr.indexOf("雨") >= 0) return basePath + "rain.png"
        if (weatherStr.indexOf("雾") >= 0 || weatherStr.indexOf("霾") >= 0) return basePath + "fog.png"
        if (weatherStr.indexOf("沙") >= 0 || weatherStr.indexOf("尘") >= 0) return basePath + "sandstorm.png"
        return basePath + "unknown.png"
    }

    // Modern glass card background
    Gradient {
        id: nowGradient
        GradientStop { position: 0.0; color: "#2500f0ff" }
        GradientStop { position: 1.0; color: "#0600f0ff" }
    }
    
    gradient: isNow ? nowGradient : null
    color: isNow ? "transparent" : (hoverArea.containsMouse ? theme.cardBgHover : theme.cardBg)
    border.color: isNow ? theme.accent : (hoverArea.containsMouse ? theme.cardBorderHover : theme.cardBorder)
    border.width: 1

    // Hover Lift and Scale effects
    scale: isNow ? 1.05 : (hoverArea.containsMouse ? 1.03 : 1.0)
    y: hoverArea.containsMouse ? -4 : 0

    Behavior on color { ColorAnimation { duration: 180 } }
    Behavior on border.color { ColorAnimation { duration: 180 } }
    Behavior on scale { NumberAnimation { duration: 180; easing.type: Easing.OutQuad } }
    Behavior on y { NumberAnimation { duration: 180; easing.type: Easing.OutQuad } }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: theme.spacingSmall
        spacing: 6

        Text {
            text: time
            font: theme.captionFont
            color: isNow ? "#ffffff" : theme.secondaryText
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle {
            height: 1
            Layout.fillWidth: true
            color: isNow ? "#30ffffff" : theme.divider
            Layout.alignment: Qt.AlignHCenter
        }

        Image {
            id: weatherImg
            source: weatherIcon(weather)
            sourceSize.width: 28
            sourceSize.height: 28
            Layout.alignment: Qt.AlignHCenter

            transform: Translate {
                id: floatTransform
            }

            SequentialAnimation {
                id: floatAnim
                running: isNow || hoverArea.containsMouse
                loops: Animation.Infinite
                NumberAnimation { target: floatTransform; property: "y"; from: 0; to: -2; duration: 1200; easing.type: Easing.InOutQuad }
                NumberAnimation { target: floatTransform; property: "y"; from: -2; to: 0; duration: 1200; easing.type: Easing.InOutQuad }
                onStopped: floatTransform.y = 0
            }
        }

        Text {
            text: weather
            font: theme.captionFont
            color: theme.primaryText
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: temperature + "°"
            font: Qt.font({ family: theme.defaultFamily, pointSize: 16, weight: Font.Bold })
            color: isNow ? theme.accent : theme.accentWarm
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
