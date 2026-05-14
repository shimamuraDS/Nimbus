import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root
    objectName: "TodayView"

    function vm() {
        return (typeof weatherViewModel !== "undefined") ? weatherViewModel : null
    }
    function hasTodayData() {
        var vm = root.vm()
        if (!vm) return false
        var tw = vm.todayWeather
        return tw && tw.date && tw.date !== ""
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 15

        NavigationButton {
            direction: "left"
            onClicked: {
                if (stackView) stackView.push(pastViewComponent)
            }
        }

        WeatherCard {
            id: card
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.fillHeight: true

            date: hasTodayData() ? root.vm().todayWeather.date : (root.vm() && root.vm().isLoading ? qsTr("获取中...") : qsTr("暂无数据"))
            dayWeather: hasTodayData() ? (root.vm().todayWeather.dayWeather || "--") : "--"
            dayTemp: hasTodayData() ? (root.vm().todayWeather.dayTemp || 0) : 0
            dayHumidity: hasTodayData() ? (root.vm().todayWeather.dayHumidity || 0) : 0
            nightWeather: hasTodayData() ? (root.vm().todayWeather.nightWeather || "--") : "--"
            nightTemp: hasTodayData() ? (root.vm().todayWeather.nightTemp || 0) : 0
            nightHumidity: hasTodayData() ? (root.vm().todayWeather.nightHumidity || 0) : 0
        }

        NavigationButton {
            direction: "right"
            onClicked: {
                if (stackView) stackView.push(futureViewComponent)
            }
        }
    }
}
