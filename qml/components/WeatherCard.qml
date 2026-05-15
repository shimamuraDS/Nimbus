import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    Theme { id: theme }

    width: 220
    height: 160
    radius: theme.radiusMedium
    color: theme.cardBg
    border.color: theme.cardBorder
    border.width: 1

    property string date: qsTr("未知日期")
    property string dayWeather: "--"
    property int dayTemp: 0
    property int dayHumidity: 0
    property string nightWeather: "--"
    property int nightTemp: 0
    property int nightHumidity: 0

    // ── Shadow (offset dark rectangle beneath the card) ──
    Rectangle {
        anchors.fill: parent
        anchors.leftMargin: 2
        anchors.topMargin: 3
        radius: parent.radius
        color: "#18000000"
        z: -1
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: theme.spacingMedium
        spacing: theme.spacingSmall

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
                Text { text: qsTr("早: ") + dayWeather; font: theme.bodyFont; color: theme.secondaryText }
                Text { text: dayTemp + "°C"; font: theme.titleFont; color: theme.accentWarm }
                Text { text: qsTr("湿度: ") + dayHumidity + "%"; font: theme.captionFont; color: theme.mutedText }
            }

            Item { Layout.fillWidth: true }

            ColumnLayout {
                Layout.alignment: Qt.AlignVCenter
                spacing: theme.spacingTiny
                Text { text: qsTr("晚: ") + nightWeather; font: theme.bodyFont; color: theme.secondaryText }
                Text { text: nightTemp + "°C"; font: theme.titleFont; color: theme.accent }
                Text { text: qsTr("湿度: ") + nightHumidity + "%"; font: theme.captionFont; color: theme.mutedText }
            }
        }
    }
}
