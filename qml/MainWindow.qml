import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import "components"
import "views"

Window {
    id: mainWindow

    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.Tool
    title: qsTr("天气提醒助手")

    // 使用 C++ 传入的主屏幕几何定位（右下角，类似系统托盘弹出窗）
    property real scrX: typeof primaryScreen !== "undefined" ? primaryScreen.x : 0
    property real scrY: typeof primaryScreen !== "undefined" ? primaryScreen.y : 0
    property real scrW: typeof primaryScreen !== "undefined" ? primaryScreen.width : 1920
    property real scrH: typeof primaryScreen !== "undefined" ? primaryScreen.height : 1080

    width: scrW / 4
    height: scrH / 3
    x: scrX + scrW - width - 10
    y: scrY + scrH - height - 10

    visible: typeof trayViewModel !== "undefined" ? trayViewModel.windowVisible : false
    color: "#ecf0f1"

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

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Toolbar {
            Layout.fillWidth: true
            isSettingsPage: stackView.currentItem && stackView.currentItem.objectName === "SettingsView"

            onSettingsClicked: stackView.push(settingsViewComponent)
            onBackClicked: stackView.pop()
        }

        StackView {
            id: stackView
            Layout.fillWidth: true
            Layout.fillHeight: true
            initialItem: todayViewComponent
            clip: true
        }
    }

    Component { id: todayViewComponent; TodayView { objectName: "TodayView" } }
    Component { id: pastViewComponent; PastView { objectName: "PastView" } }
    Component { id: futureViewComponent; FutureView { objectName: "FutureView" } }
    Component { id: settingsViewComponent; SettingsView { objectName: "SettingsView" } }
}
