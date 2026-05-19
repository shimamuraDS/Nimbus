import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import "components"
import "views"

Window {
    id: mainWindow

    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.Tool
    title: qsTr("天气提醒")
    color: "transparent"

    property real scrX: typeof primaryScreen !== "undefined" ? primaryScreen.x : 0
    property real scrY: typeof primaryScreen !== "undefined" ? primaryScreen.y : 0
    property real scrW: typeof primaryScreen !== "undefined" ? primaryScreen.width : 1920
    property real scrH: typeof primaryScreen !== "undefined" ? primaryScreen.height : 1080

    width: scrW / 4
    height: scrH / 3
    x: scrX + scrW - width - 10
    y: scrY + scrH - height - 10

    visible: typeof trayViewModel !== "undefined" ? trayViewModel.windowVisible : false

    onVisibleChanged: {
        if (typeof trayViewModel !== "undefined") {
            trayViewModel.windowVisible = visible
        }
    }

    Component.onCompleted: {
        if (typeof weatherViewModel !== "undefined") {
            weatherViewModel.requestData()
        }
    }

    property bool navGoingLeft: false
    property bool navIsSettings: false

    Theme { id: theme }

    // ── Gradient background ──
    Rectangle {
        id: bgRect
        anchors.fill: parent
        radius: theme.radiusLarge
        clip: true
        gradient: Gradient {
            GradientStop { position: 0.0; color: theme.windowGradientTop }
            GradientStop { position: 1.0; color: theme.windowGradientBottom }
        }
        border.color: Qt.rgba(1, 1, 1, 0.06)
        border.width: 1
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Toolbar {
            Layout.fillWidth: true
            isSettingsPage: stackView.currentItem && stackView.currentItem.objectName === "SettingsView"

            onSettingsClicked: {
                mainWindow.navIsSettings = true
                stackView.push(settingsViewComponent)
            }
            onBackClicked: {
                mainWindow.navIsSettings = true
                stackView.pop()
            }
        }

        StackView {
            id: stackView
            Layout.fillWidth: true
            Layout.fillHeight: true
            initialItem: todayViewComponent
            clip: true

            pushEnter: Transition {
            ParallelAnimation {
                PropertyAnimation { property: "opacity"; from: 0; to: 1; duration: 220 }
                PropertyAnimation {
                    property: "x"
                    from: mainWindow.navIsSettings ? 0 : (mainWindow.navGoingLeft ? -40 : 40)
                    to: 0
                    duration: 220; easing.type: Easing.OutCubic
                }
                PropertyAnimation {
                    property: "y"
                    from: mainWindow.navIsSettings ? -40 : 0
                    to: 0
                    duration: 220; easing.type: Easing.OutCubic
                }
            }
        }
        pushExit: Transition {
            ParallelAnimation {
                PropertyAnimation { property: "opacity"; from: 1; to: 0; duration: 180 }
                PropertyAnimation {
                    property: "x"
                    from: 0
                    to: mainWindow.navIsSettings ? 0 : (mainWindow.navGoingLeft ? 40 : -40)
                    duration: 180; easing.type: Easing.InCubic
                }
                PropertyAnimation {
                    property: "y"
                    from: 0
                    to: mainWindow.navIsSettings ? 40 : 0
                    duration: 180; easing.type: Easing.InCubic
                }
            }
        }
        popEnter: Transition {
            ParallelAnimation {
                PropertyAnimation { property: "opacity"; from: 0; to: 1; duration: 180 }
                PropertyAnimation {
                    property: "x"
                    from: mainWindow.navIsSettings ? 0 : (mainWindow.navGoingLeft ? -40 : 40)
                    to: 0
                    duration: 180; easing.type: Easing.OutCubic
                }
                PropertyAnimation {
                    property: "y"
                    from: mainWindow.navIsSettings ? -40 : 0
                    to: 0
                    duration: 180; easing.type: Easing.OutCubic
                }
            }
        }
        popExit: Transition {
            ParallelAnimation {
                PropertyAnimation { property: "opacity"; from: 1; to: 0; duration: 220 }
                PropertyAnimation {
                    property: "x"
                    from: 0
                    to: mainWindow.navIsSettings ? 0 : (mainWindow.navGoingLeft ? -40 : 40)
                    duration: 220; easing.type: Easing.InCubic
                }
                PropertyAnimation {
                    property: "y"
                    from: 0
                    to: mainWindow.navIsSettings ? -40 : 0
                    duration: 220; easing.type: Easing.InCubic
                }
            }
        }
        }
    }

    Component { id: todayViewComponent; TodayView { objectName: "TodayView" } }
    Component { id: pastViewComponent; PastView { objectName: "PastView" } }
    Component { id: futureViewComponent; FutureView { objectName: "FutureView" } }
    Component { id: settingsViewComponent; SettingsView { objectName: "SettingsView" } }
}
