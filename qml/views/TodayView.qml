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
        if (row.implicitWidth <= 0 || flick.width <= 0) return

        var totalW = row.implicitWidth
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
            initialCentered = true
            centerTimer.stop()
            return
        }
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

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: theme.spacingMedium
        spacing: theme.spacingSmall

        Text {
            text: qsTr("今日天气")
            font: theme.titleFont
            color: theme.accentSecondary
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

                NavigationButton {
                    id: leftBtn
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    direction: "left"
                    onClicked: {
                        mainWindow.navIsSettings = false
                        mainWindow.navGoingLeft = true
                        stackView.push(pastViewComponent)
                    }
                }

                NavigationButton {
                    id: rightBtn
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    direction: "right"
                    onClicked: {
                        mainWindow.navIsSettings = false
                        mainWindow.navGoingLeft = false
                        stackView.push(futureViewComponent)
                    }
                }

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
                    contentWidth: Math.max(row.implicitWidth, width)
                    contentHeight: 200
                    clip: true
                    interactive: row.implicitWidth > width

                    Row {
                        id: row
                        spacing: theme.spacingSmall
                        x: implicitWidth <= flick.width ? (flick.width - implicitWidth) / 2 : 5
                        y: 15

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
            }
        }
    }
}
