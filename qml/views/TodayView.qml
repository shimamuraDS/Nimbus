import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root

    Theme { id: theme }

    objectName: "TodayView"

    function currentHourStr() {
        var now = new Date()
        var hh = now.getHours().toString().padStart(2, '0')
        return hh + ":00"
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: theme.spacingMedium
        spacing: 0

        NavigationButton {
            direction: "left"
            onClicked: {
                mainWindow.navGoingLeft = true
                stackView.push(pastViewComponent)
            }
        }

        Flickable {
            id: flick
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: row.width
            contentHeight: height
            clip: true
            interactive: contentWidth > width

            Row {
                id: row
                anchors.verticalCenter: parent.verticalCenter
                spacing: theme.spacingSmall
                x: Math.max(0, (flick.width - row.width) / 2)

                Repeater {
                    model: typeof weatherViewModel !== "undefined" ? weatherViewModel.hourlyList : []

                    delegate: HourlyCard {
                        time: modelData.time || "--:--"
                        weather: modelData.weather || "--"
                        temperature: modelData.temperature || 0
                        isNow: modelData.time === root.currentHourStr()
                    }
                }
            }
        }

        NavigationButton {
            direction: "right"
            onClicked: {
                mainWindow.navGoingLeft = false
                stackView.push(futureViewComponent)
            }
        }
    }
}
