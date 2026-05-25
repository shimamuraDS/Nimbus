import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root

    Theme { id: theme }

    objectName: "TodayView"

    property bool initialCentered: false

    function centerOnCurrentHour() {
        if (initialCentered) return
        if (typeof weatherViewModel === "undefined") return
        var models = weatherViewModel.hourlyList
        if (!models || models.length === 0) return
        if (row.width <= 0) return
        // Only center when row has overflowed (row.x is stable at 0)
        // or all cards fit (no centering needed, handled by Row's x binding)
        if (row.width <= flick.width) {
            flick.contentX = 0
            initialCentered = true
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
        if (targetIndex < 0) return
        var cardW = 80 + theme.spacingSmall
        var cardCenter = targetIndex * cardW + 40
        var targetX = cardCenter - flick.width / 2
        var maxX = row.width - flick.width
        flick.contentX = Math.max(0, Math.min(targetX, maxX))
        initialCentered = true
    }

    Timer {
        id: centerTimer
        interval: 100
        repeat: false
        onTriggered: centerOnCurrentHour()
    }

    Component.onCompleted: centerTimer.start()

    Connections {
        target: typeof weatherViewModel !== "undefined" ? weatherViewModel : null
        function onHourlyDataChanged() {
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
            contentWidth: row.width
            contentHeight: height
            clip: true
            interactive: contentWidth > width

            Row {
                id: row
                anchors.verticalCenter: parent.verticalCenter
                spacing: theme.spacingSmall
                x: Math.max(0, (flick.width - row.width) / 2)

                onWidthChanged: {
                    if (width > 0) centerTimer.restart()
                }

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
