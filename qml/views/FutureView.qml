import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root
    objectName: "FutureView"

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 15

        NavigationButton {
            direction: "left"
            onClicked: {
                if (stackView) stackView.pop()
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: ListView.Horizontal
            spacing: 10
            clip: true
            model: typeof weatherViewModel !== "undefined" ? weatherViewModel.futureWeatherList : []

            delegate: WeatherCard {
                width: 200
                height: 150
                date: modelData.date || ""
                dayWeather: modelData.dayWeather || "--"
                dayTemp: modelData.dayTemp || 0
                dayHumidity: modelData.dayHumidity || 0
                nightWeather: modelData.nightWeather || "--"
                nightTemp: modelData.nightTemp || 0
                nightHumidity: modelData.nightHumidity || 0
            }
        }
    }
}
