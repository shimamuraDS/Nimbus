import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dialog {
    id: root
    title: qsTr("选择提醒时间")
    modal: true
    anchors.centerIn: parent
    standardButtons: Dialog.Ok | Dialog.Cancel

    signal timeSelected(string timeHHmm)

    RowLayout {
        anchors.centerIn: parent
        spacing: 10

        SpinBox {
            id: hourBox
            from: 0; to: 23; value: 8
            font.pixelSize: 16
        }
        Text { text: ":"; font.pixelSize: 20; font.bold: true }
        SpinBox {
            id: minBox
            from: 0; to: 59; value: 0
            font.pixelSize: 16
        }
    }

    onAccepted: {
        let hh = hourBox.value.toString().padStart(2, '0')
        let mm = minBox.value.toString().padStart(2, '0')
        root.timeSelected(hh + ":" + mm)
    }
}
