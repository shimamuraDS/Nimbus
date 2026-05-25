import QtQuick
import QtQuick.Controls

ComboBox {
    id: control
    implicitWidth: 140

    Theme { id: theme }

    textRole: "name"
    valueRole: "adcode"

    signal citySelected(int adcode, string cityName)

    model: ListModel {
        // 直辖市
        ListElement { name: "北京市"; adcode: 110000 }
        ListElement { name: "天津市"; adcode: 120000 }
        ListElement { name: "上海市"; adcode: 310000 }
        ListElement { name: "重庆市"; adcode: 500000 }
        // 河北省
        ListElement { name: "石家庄市"; adcode: 130100 }
        ListElement { name: "唐山市"; adcode: 130200 }
        ListElement { name: "保定市"; adcode: 130600 }
        ListElement { name: "廊坊市"; adcode: 131000 }
        // 山西省
        ListElement { name: "太原市"; adcode: 140100 }
        ListElement { name: "大同市"; adcode: 140200 }
        // 内蒙古
        ListElement { name: "呼和浩特市"; adcode: 150100 }
        ListElement { name: "包头市"; adcode: 150200 }
        ListElement { name: "鄂尔多斯市"; adcode: 150600 }
        // 辽宁省
        ListElement { name: "沈阳市"; adcode: 210100 }
        ListElement { name: "大连市"; adcode: 210200 }
        ListElement { name: "鞍山市"; adcode: 210300 }
        // 吉林省
        ListElement { name: "长春市"; adcode: 220100 }
        ListElement { name: "吉林市"; adcode: 220200 }
        // 黑龙江省
        ListElement { name: "哈尔滨市"; adcode: 230100 }
        ListElement { name: "齐齐哈尔市"; adcode: 230200 }
        ListElement { name: "大庆市"; adcode: 230600 }
        // 江苏省
        ListElement { name: "南京市"; adcode: 320100 }
        ListElement { name: "苏州市"; adcode: 320500 }
        ListElement { name: "无锡市"; adcode: 320200 }
        ListElement { name: "常州市"; adcode: 320400 }
        ListElement { name: "南通市"; adcode: 320600 }
        ListElement { name: "徐州市"; adcode: 320300 }
        ListElement { name: "扬州市"; adcode: 321000 }
        // 浙江省
        ListElement { name: "杭州市"; adcode: 330100 }
        ListElement { name: "宁波市"; adcode: 330200 }
        ListElement { name: "温州市"; adcode: 330300 }
        ListElement { name: "嘉兴市"; adcode: 330400 }
        ListElement { name: "金华市"; adcode: 330700 }
        ListElement { name: "绍兴市"; adcode: 330600 }
        // 安徽省
        ListElement { name: "合肥市"; adcode: 340100 }
        ListElement { name: "芜湖市"; adcode: 340200 }
        // 福建省
        ListElement { name: "福州市"; adcode: 350100 }
        ListElement { name: "厦门市"; adcode: 350200 }
        ListElement { name: "泉州市"; adcode: 350500 }
        // 江西省
        ListElement { name: "南昌市"; adcode: 360100 }
        ListElement { name: "赣州市"; adcode: 360700 }
        // 山东省
        ListElement { name: "济南市"; adcode: 370100 }
        ListElement { name: "青岛市"; adcode: 370200 }
        ListElement { name: "烟台市"; adcode: 370600 }
        ListElement { name: "潍坊市"; adcode: 370700 }
        ListElement { name: "临沂市"; adcode: 371300 }
        ListElement { name: "淄博市"; adcode: 370300 }
        // 河南省
        ListElement { name: "郑州市"; adcode: 410100 }
        ListElement { name: "洛阳市"; adcode: 410300 }
        ListElement { name: "开封市"; adcode: 410200 }
        ListElement { name: "南阳市"; adcode: 411300 }
        // 湖北省
        ListElement { name: "武汉市"; adcode: 420100 }
        ListElement { name: "宜昌市"; adcode: 420500 }
        ListElement { name: "襄阳市"; adcode: 420600 }
        // 湖南省
        ListElement { name: "长沙市"; adcode: 430100 }
        ListElement { name: "株洲市"; adcode: 430200 }
        ListElement { name: "岳阳市"; adcode: 430600 }
        // 广东省
        ListElement { name: "广州市"; adcode: 440100 }
        ListElement { name: "深圳市"; adcode: 440300 }
        ListElement { name: "珠海市"; adcode: 440400 }
        ListElement { name: "东莞市"; adcode: 441900 }
        ListElement { name: "佛山市"; adcode: 440600 }
        ListElement { name: "惠州市"; adcode: 441300 }
        ListElement { name: "中山市"; adcode: 442000 }
        ListElement { name: "汕头市"; adcode: 440500 }
        // 广西
        ListElement { name: "南宁市"; adcode: 450100 }
        ListElement { name: "桂林市"; adcode: 450300 }
        ListElement { name: "柳州市"; adcode: 450200 }
        // 海南省
        ListElement { name: "海口市"; adcode: 460100 }
        ListElement { name: "三亚市"; adcode: 460200 }
        // 四川省
        ListElement { name: "成都市"; adcode: 510100 }
        ListElement { name: "绵阳市"; adcode: 510700 }
        ListElement { name: "宜宾市"; adcode: 511500 }
        // 贵州省
        ListElement { name: "贵阳市"; adcode: 520100 }
        ListElement { name: "遵义市"; adcode: 520300 }
        // 云南省
        ListElement { name: "昆明市"; adcode: 530100 }
        ListElement { name: "大理市"; adcode: 532901 }
        ListElement { name: "丽江市"; adcode: 530700 }
        // 西藏
        ListElement { name: "拉萨市"; adcode: 540100 }
        // 陕西省
        ListElement { name: "西安市"; adcode: 610100 }
        ListElement { name: "咸阳市"; adcode: 610400 }
        // 甘肃省
        ListElement { name: "兰州市"; adcode: 620100 }
        // 青海省
        ListElement { name: "西宁市"; adcode: 630100 }
        // 宁夏
        ListElement { name: "银川市"; adcode: 640100 }
        // 新疆
        ListElement { name: "乌鲁木齐市"; adcode: 650100 }
        // 香港/澳门/台湾
        ListElement { name: "香港"; adcode: 810000 }
        ListElement { name: "澳门"; adcode: 820000 }
        ListElement { name: "台北市"; adcode: 710100 }
    }

    contentItem: Text {
        text: control.displayText
        font: theme.bodyFont
        color: theme.primaryText
        verticalAlignment: Text.AlignVCenter
        leftPadding: 12
    }

    background: Rectangle {
        radius: theme.radiusSmall
        color: control.hovered ? theme.cardBgHover : theme.cardBg
        border.color: control.pressed ? theme.accent : (control.hovered ? theme.cardBorderHover : theme.cardBorder)
        border.width: 1
        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on border.color { ColorAnimation { duration: 150 } }
    }

    indicator: Text {
        text: "▾"
        font.pixelSize: 14
        color: control.opened ? theme.accent : theme.secondaryText
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        transformOrigin: Item.Center
        rotation: control.opened ? 180 : 0
        Behavior on rotation { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
        Behavior on color { ColorAnimation { duration: 150 } }
    }

    delegate: ItemDelegate {
        id: delegateItem
        width: control.width
        height: 32
        
        contentItem: Text {
            text: model.name
            font: theme.bodyFont
            color: delegateItem.hovered ? theme.accent : theme.primaryText
            verticalAlignment: Text.AlignVCenter
            leftPadding: 12
            Behavior on color { ColorAnimation { duration: 120 } }
        }
        
        background: Rectangle {
            color: delegateItem.hovered ? theme.cardBgHover : "transparent"
            Behavior on color { ColorAnimation { duration: 120 } }
        }
    }

    popup: Popup {
        y: control.height + 4
        width: Math.max(control.width, 160)
        padding: 4
        implicitHeight: Math.min(contentItem.implicitHeight + 8, 280)

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200; easing.type: Easing.OutQuad }
            NumberAnimation { property: "y"; from: control.height - 5; to: control.height + 4; duration: 200; easing.type: Easing.OutQuad }
        }

        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 150; easing.type: Easing.OutQuad }
        }

        contentItem: ListView {
            clip: true
            implicitHeight: Math.min(contentHeight, 280)
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }
        }

        background: Rectangle {
            radius: theme.radiusMedium
            color: "#16162a"
            border.color: theme.cardBorderHover
            border.width: 1
        }
    }

    onActivated: {
        citySelected(currentValue, currentText)
    }
}
