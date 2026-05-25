import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root

    Theme { id: theme }

    objectName: "TodayView"

    property bool initialCentered: false
    property int _centerRetries: 0

    function centerOnCurrentHour() {
        if (initialCentered) return
        if (typeof weatherViewModel === "undefined") return
        var models = weatherViewModel.hourlyList
        if (!models || models.length === 0) return
        // Both flick and row must have valid layout dimensions
        if (row.implicitWidth <= 0 || flick.width <= 0) return

        var totalW = row.implicitWidth
        // All cards fit on screen — no scrolling needed
        if (totalW <= flick.width) {
            flick.contentX = 0
            initialCentered = true
            centerTimer.stop()
            return
        }

        var currentHour = currentHourStr()
        var targetIndex = -1
        for (var i = 0; i < models.length; i++) {
            if (models[i].time === currentHour) {
                targetIndex = i
                break
            }
        }
        if (targetIndex < 0) {
            // Current hour not found in data — stop retrying
            initialCentered = true
            centerTimer.stop()
            return
        }
        // Each card is 80px wide; Row spacing sits between cards.
        var cardW = 80 + row.spacing
        var cardCenter = targetIndex * cardW + 40
        var targetX = cardCenter - flick.width / 2
        var maxX = totalW - flick.width
        var finalX = Math.max(0, Math.min(targetX, maxX))
        flick.contentX = finalX
        initialCentered = true
        centerTimer.stop()
    }

    Timer {
        id: centerTimer
        interval: 50
        repeat: true
        onTriggered: {
            root._centerRetries++
            if (root._centerRetries > 60) {
                stop()
                return
            }
            centerOnCurrentHour()
        }
    }

    Component.onCompleted: {
        _centerRetries = 0
        centerTimer.start()
    }

    Connections {
        target: typeof weatherViewModel !== "undefined" ? weatherViewModel : null
        function onHourlyDataChanged() {
            initialCentered = false
            _centerRetries = 0
            centerTimer.restart()
        }
    }

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
                mainWindow.navIsSettings = false
                mainWindow.navGoingLeft = true
                stackView.push(pastViewComponent)
            }
        }

        Flickable {
            id: flick
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: theme.spacingSmall
            Layout.rightMargin: theme.spacingSmall
            contentWidth: Math.max(row.implicitWidth, width)
            contentHeight: height
            clip: true
            interactive: row.implicitWidth > width

            Row {
                id: row
                anchors.verticalCenter: parent.verticalCenter
                spacing: theme.spacingSmall
                // Center row when all cards fit; otherwise anchor to left for scrolling
                x: implicitWidth <= flick.width ? (flick.width - implicitWidth) / 2 : 0

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
                mainWindow.navIsSettings = false
                mainWindow.navGoingLeft = false
                stackView.push(futureViewComponent)
            }
        }
    }
}

