import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root

    Theme { id: theme }

    objectName: "FutureView"

    RowLayout {
        anchors.fill: parent
        anchors.margins: theme.spacingMedium
        spacing: theme.spacingMedium

        NavigationButton {
            direction: "left"
            onClicked: {
                mainWindow.navGoingLeft = false
                stackView.pop()
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: ListView.Horizontal
            spacing: theme.spacingSmall
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
