import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root

    Theme { id: theme }

    objectName: "PastView"

    property bool _scrolled: false
    property int _retries: 0

    function scrollToEnd() {
        if (_scrolled) return
        if (flick.width <= 0 || row.width <= 0) return
        if (row.width <= flick.width) {
            // All cards fit — no scrolling needed
            _scrolled = true
            scrollToEndTimer.stop()
            return
        }
        flick.contentX = flick.contentWidth - flick.width
        _scrolled = true
        scrollToEndTimer.stop()
    }

    Timer {
        id: scrollToEndTimer
        interval: 16
        repeat: true
        onTriggered: {
            root._retries++
            if (root._retries > 60) {
                stop()
                return
            }
            scrollToEnd()
        }
    }

    Component.onCompleted: {
        _retries = 0
        scrollToEndTimer.start()
    }

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
                y: Math.max(0, (parent.height - 210) * 0.35)
                width: parent.width
                height: 210

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
                    contentWidth: Math.max(row.width + row.x + 10, width)
                    contentHeight: 200
                    clip: true
                    interactive: contentWidth > width

                    Row {
                        id: row
                        spacing: theme.spacingSmall
                        x: Math.max(5, (flick.width - row.width) / 2)
                        y: 5

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
