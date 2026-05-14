import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root
    objectName: "TodayView"

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
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.fillHeight: true

            date: {
                if (typeof weatherViewModel !== "undefined" && weatherViewModel.todayWeather)
                    return weatherViewModel.todayWeather.date || qsTr("获取中...")
                return qsTr("获取中...")
            }

            Connections {
                target: typeof weatherViewModel !== "undefined" ? weatherViewModel : null
                enabled: typeof weatherViewModel !== "undefined"
                function onWeatherDataChanged() {
                    var tw = weatherViewModel.todayWeather
                    if (tw) {
                        parent.date = tw.date || qsTr("获取中...")
                        parent.dayWeather = tw.dayWeather || "--"
                        parent.dayTemp = tw.dayTemp || 0
                        parent.dayHumidity = tw.dayHumidity || 0
                        parent.nightWeather = tw.nightWeather || "--"
                        parent.nightTemp = tw.nightTemp || 0
                        parent.nightHumidity = tw.nightHumidity || 0
                    }
                }
            }
        }

        NavigationButton {
            direction: "right"
            onClicked: {
                if (stackView) stackView.push(futureViewComponent)
            }
        }
    }
}
