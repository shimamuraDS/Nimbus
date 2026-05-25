import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root

    Theme { id: theme }

    objectName: "PastView"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: theme.spacingMedium
        spacing: theme.spacingSmall

        Text {
            text: qsTr("过去 7 天")
            font: theme.titleFont
            color: theme.accentWarm
            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Item {
                id: alignedRow
                y: Math.max(0, (parent.height - 200) * 0.35)
                width: parent.width
                height: 200

                Flickable {
                    id: flick
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                        bottom: parent.bottom
                        leftMargin: 46
                        rightMargin: 46
                        topMargin: 5
                        bottomMargin: 5
                    }
                    contentWidth: Math.max(row.width + row.x, width)
                    contentHeight: 190
                    clip: true
                    interactive: contentWidth > width

                    Row {
                        id: row
                        spacing: theme.spacingSmall
                        x: Math.max(0, (flick.width - row.width) / 2)

                        Repeater {
                            model: typeof weatherViewModel !== "undefined" ? weatherViewModel.pastWeatherList : []

                            delegate: WeatherCard {
                                isPast: true
                                width: 240
                                height: 190
                                date: modelData.date || ""
                                dayWeather: modelData.dayWeather || "--"
                                dayTemp: modelData.dayTemp || 0
                                nightWeather: modelData.nightWeather || "--"
                                nightTemp: modelData.nightTemp || 0
                            }
                        }
                    }
                }

                NavigationButton {
                    id: backBtn
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    direction: "right"
                    onClicked: {
                        mainWindow.navIsSettings = false
                        mainWindow.navGoingLeft = false
                        stackView.pop()
                    }
                }
            }
        }
    }
}
