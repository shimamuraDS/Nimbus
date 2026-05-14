import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    width: 220
    height: 160
    radius: 10
    color: "#ffffff"
    border.color: "#dddddd"

    property string date: qsTr("未知日期")
    property string dayWeather: "--"
    property int dayTemp: 0
    property int dayHumidity: 0
    property string nightWeather: "--"
    property int nightTemp: 0
    property int nightHumidity: 0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5

        Text {
            text: date
            font.pixelSize: 16
            font.bold: true
            color: "#2c3e50"
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle { height: 1; color: "#ecf0f1"; Layout.fillWidth: true }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // 早间天气
            ColumnLayout {
                Layout.alignment: Qt.AlignVCenter
                spacing: 3
                Text { text: qsTr("早: ") + dayWeather; font.pixelSize: 14; color: "#2c3e50" }
                Text { text: dayTemp + "°C"; font.pixelSize: 16; font.bold: true; color: "#e67e22" }
                Text { text: qsTr("湿度: ") + dayHumidity + "%"; font.pixelSize: 12; color: "#7f8c8d" }
            }

            Item { Layout.fillWidth: true }

            // 晚间天气
            ColumnLayout {
                Layout.alignment: Qt.AlignVCenter
                spacing: 3
                Text { text: qsTr("晚: ") + nightWeather; font.pixelSize: 14; color: "#2c3e50" }
                Text { text: nightTemp + "°C"; font.pixelSize: 16; font.bold: true; color: "#2980b9" }
                Text { text: qsTr("湿度: ") + nightHumidity + "%"; font.pixelSize: 12; color: "#7f8c8d" }
            }
        }
    }
}
