import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root

    Theme { id: theme }

    objectName: "PastView"

    RowLayout {
        anchors.fill: parent
        anchors.margins: theme.spacingMedium
        spacing: theme.spacingMedium

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: ListView.Horizontal
            spacing: theme.spacingSmall
            clip: true
            model: typeof weatherViewModel !== "undefined" ? weatherViewModel.pastWeatherList : []

            delegate: WeatherCard {
                width: 200
                height: 150
                date: modelData.date || ""
                dayWeather: modelData.dayWeather || "--"
                dayTemp: modelData.dayTemp || 0
                nightWeather: modelData.nightWeather || "--"
                nightTemp: modelData.nightTemp || 0
            }
        }

        NavigationButton {
            direction: "right"
            onClicked: {
                mainWindow.navGoingLeft = true
                stackView.pop()
            }
        }
    }
}
