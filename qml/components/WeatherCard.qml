import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    width: 240
    height: 190
    radius: theme.radiusMedium
    
    // Glass styling based on Past/Future themes
    color: isPast 
        ? (hoverArea.containsMouse ? "#20ff7b90" : "#0fff7b90") 
        : (hoverArea.containsMouse ? "#2000f0ff" : "#0f00f0ff")
    
    border.color: isPast 
        ? (hoverArea.containsMouse ? theme.accentWarm : "#30ff7b90") 
        : (hoverArea.containsMouse ? theme.accent : "#3000f0ff")
    border.width: 1

    Theme { id: theme }

    property string date: qsTr("未知日期")
    property string dayWeather: "--"
    property int dayTemp: 0
    property int dayHumidity: 0
    property string nightWeather: "--"
    property int nightTemp: 0
    property int nightHumidity: 0
    property bool isPast: false

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

    // Hover scale effect
    scale: hoverArea.containsMouse ? 1.03 : 1.0

    Behavior on color { ColorAnimation { duration: 200 } }
    Behavior on border.color { ColorAnimation { duration: 200 } }
    Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
    }

    // ── Shadow ──
    Rectangle {
        anchors.fill: parent
        anchors.leftMargin: 2
        anchors.topMargin: hoverArea.containsMouse ? 7 : 4
        radius: parent.radius
        color: hoverArea.containsMouse ? "#2a000000" : "#14000000"
        z: -1
        
        Behavior on anchors.topMargin { NumberAnimation { duration: 200 } }
        Behavior on color { ColorAnimation { duration: 200 } }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: theme.spacingMedium
        spacing: 8

        Text {
            text: date
            font: theme.subtitleFont
            color: theme.primaryText
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle {
            height: 1
            color: theme.divider
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                Layout.alignment: Qt.AlignVCenter
                spacing: theme.spacingTiny
                
                Item {
                    width: 26
                    height: 26
                    Layout.alignment: Qt.AlignHCenter
                    
                    Image {
                        source: weatherIcon(dayWeather)
                        sourceSize.width: 26
                        sourceSize.height: 26
                        anchors.centerIn: parent
                        
                        SequentialAnimation on y {
                            running: hoverArea.containsMouse
                            loops: Animation.Infinite
                            NumberAnimation { from: 0; to: -2; duration: 1200; easing.type: Easing.InOutQuad }
                            NumberAnimation { from: -2; to: 0; duration: 1200; easing.type: Easing.InOutQuad }
                        }
                    }
                }
                
                Text { text: qsTr("早: ") + dayWeather; font: theme.captionFont; color: theme.secondaryText }
                Text { text: dayTemp + "°C"; font: theme.subtitleFont; color: theme.accentWarm }
                Text { text: qsTr("湿度: ") + dayHumidity + "%"; font: theme.captionFont; color: theme.mutedText }
            }

            Item { Layout.fillWidth: true }

            ColumnLayout {
                Layout.alignment: Qt.AlignVCenter
                spacing: theme.spacingTiny
                
                Item {
                    width: 26
                    height: 26
                    Layout.alignment: Qt.AlignHCenter
                    
                    Image {
                        source: weatherIcon(nightWeather)
                        sourceSize.width: 26
                        sourceSize.height: 26
                        anchors.centerIn: parent
                        
                        SequentialAnimation on y {
                            running: hoverArea.containsMouse
                            loops: Animation.Infinite
                            NumberAnimation { from: 0; to: -2; duration: 1200; easing.type: Easing.InOutQuad }
                            NumberAnimation { from: -2; to: 0; duration: 1200; easing.type: Easing.InOutQuad }
                        }
                    }
                }
                
                Text { text: qsTr("晚: ") + nightWeather; font: theme.captionFont; color: theme.secondaryText }
                Text { text: nightTemp + "°C"; font: theme.subtitleFont; color: theme.accent }
                Text { text: qsTr("湿度: ") + nightHumidity + "%"; font: theme.captionFont; color: theme.mutedText }
            }
        }
    }
}
