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

    // 尺寸: 宽为屏幕1/4, 高为屏幕1/3 (面积=1/12)
    width: Screen.desktopAvailableWidth / 4
    height: Screen.desktopAvailableHeight / 3

    // 定位在屏幕右下角
    x: Screen.desktopAvailableWidth - width - 10
    y: Screen.desktopAvailableHeight - height - 10

    visible: typeof trayViewModel !== "undefined" ? trayViewModel.windowVisible : true
    color: "#ecf0f1"

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

    // 页面组件定义
    Component { id: todayViewComponent; TodayView { objectName: "TodayView" } }
    Component { id: pastViewComponent; PastView { objectName: "PastView" } }
    Component { id: futureViewComponent; FutureView { objectName: "FutureView" } }
    Component { id: settingsViewComponent; SettingsView { objectName: "SettingsView" } }

    Component.onCompleted: {
        if (typeof weatherViewModel !== "undefined") {
            weatherViewModel.requestData()
        }
    }

    // SystemTrayIcon via Qt.labs.platform
    Connections {
        target: typeof trayIcon !== "undefined" ? trayIcon : null
        enabled: typeof trayIcon !== "undefined"
        function onActivated(reason) {
            if (typeof trayViewModel !== "undefined") {
                trayViewModel.toggleWindow()
            }
        }
    }
}
