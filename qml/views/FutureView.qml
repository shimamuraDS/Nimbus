import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root

    Theme { id: theme }

    objectName: "FutureView"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: theme.spacingMedium
        spacing: theme.spacingTiny

        Text {
            text: qsTr("未来 7 天")
            font: theme.subtitleFont
            color: theme.accent
            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Item {
                id: alignedRow
                y: Math.max(0, (parent.height - 150) * 0.35)
                width: parent.width
                height: 150

                Flickable {
                    id: flick
                    anchors {
                        fill: parent
                        leftMargin: 50
                        rightMargin: 50
                    }
                    contentWidth: Math.max(row.width + row.x, width)
                    contentHeight: height
                    clip: true
                    interactive: contentWidth > width

                    Row {
                        id: row
                        spacing: theme.spacingSmall
                        x: Math.max(0, (flick.width - row.width) / 2)

                        Repeater {
                            model: typeof weatherViewModel !== "undefined" ? weatherViewModel.futureWeatherList : []

                            delegate: WeatherCard {
                                width: 200
                                height: 150
                                date: modelData.date || ""
                                dayWeather: modelData.dayWeather || "--"
                                dayTemp: modelData.dayTemp || 0
                                dayHumidity: modelData.dayHumidity || 0
                                nightWeather: modelData.nightWeather || "--"
                                nightTemp: modelData.nightTemp || 0
                                nightHumidity: modelData.nightHumidity || 0
                            }
                        }
                    }
                }

                NavigationButton {
                    id: backBtn
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    direction: "left"
                    onClicked: {
                        mainWindow.navIsSettings = false
                        mainWindow.navGoingLeft = true
                        stackView.pop()
                    }
                }
            }
        }
    }
}
