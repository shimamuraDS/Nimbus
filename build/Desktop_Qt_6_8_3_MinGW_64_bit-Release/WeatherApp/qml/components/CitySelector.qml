import QtQuick
import QtQuick.Controls

ComboBox {
    id: control
    textRole: "name"
    valueRole: "adcode"

    signal citySelected(int adcode, string cityName)

    model: ListModel {
        ListElement { name: "北京市"; adcode: 110000 }
        ListElement { name: "上海市"; adcode: 310000 }
        ListElement { name: "广州市"; adcode: 440100 }
        ListElement { name: "深圳市"; adcode: 440300 }
        ListElement { name: "成都市"; adcode: 510100 }
        ListElement { name: "杭州市"; adcode: 330100 }
    }

    onActivated: {
        citySelected(currentValue, currentText)
    }
}
