import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: control
    implicitWidth: 90
    implicitHeight: 28

    Theme { id: theme }

    signal citySelected(int adcode, string cityName)

    property string selectedCity: ""
    property int _selectedProvinceIndex: 0

    // ── Province / City data ──
    readonly property var provinceData: [
        { name: "直辖市", cities: [
            { name: "北京", adcode: 110000 },
            { name: "天津", adcode: 120000 },
            { name: "上海", adcode: 310000 },
            { name: "重庆", adcode: 500000 }
        ]},
        { name: "河北", cities: [
            { name: "石家庄", adcode: 130100 },
            { name: "唐山", adcode: 130200 },
            { name: "保定", adcode: 130600 },
            { name: "廊坊", adcode: 131000 }
        ]},
        { name: "山西", cities: [
            { name: "太原", adcode: 140100 },
            { name: "大同", adcode: 140200 }
        ]},
        { name: "内蒙古", cities: [
            { name: "呼和浩特", adcode: 150100 },
            { name: "包头", adcode: 150200 },
            { name: "鄂尔多斯", adcode: 150600 }
        ]},
        { name: "辽宁", cities: [
            { name: "沈阳", adcode: 210100 },
            { name: "大连", adcode: 210200 },
            { name: "鞍山", adcode: 210300 }
        ]},
        { name: "吉林", cities: [
            { name: "长春", adcode: 220100 },
            { name: "吉林", adcode: 220200 }
        ]},
        { name: "黑龙江", cities: [
            { name: "哈尔滨", adcode: 230100 },
            { name: "齐齐哈尔", adcode: 230200 },
            { name: "大庆", adcode: 230600 }
        ]},
        { name: "江苏", cities: [
            { name: "南京", adcode: 320100 },
            { name: "苏州", adcode: 320500 },
            { name: "无锡", adcode: 320200 },
            { name: "常州", adcode: 320400 },
            { name: "南通", adcode: 320600 },
            { name: "徐州", adcode: 320300 },
            { name: "扬州", adcode: 321000 }
        ]},
        { name: "浙江", cities: [
            { name: "杭州", adcode: 330100 },
            { name: "宁波", adcode: 330200 },
            { name: "温州", adcode: 330300 },
            { name: "嘉兴", adcode: 330400 },
            { name: "金华", adcode: 330700 },
            { name: "绍兴", adcode: 330600 }
        ]},
        { name: "安徽", cities: [
            { name: "合肥", adcode: 340100 },
            { name: "芜湖", adcode: 340200 }
        ]},
        { name: "福建", cities: [
            { name: "福州", adcode: 350100 },
            { name: "厦门", adcode: 350200 },
            { name: "泉州", adcode: 350500 }
        ]},
        { name: "江西", cities: [
            { name: "南昌", adcode: 360100 },
            { name: "赣州", adcode: 360700 }
        ]},
        { name: "山东", cities: [
            { name: "济南", adcode: 370100 },
            { name: "青岛", adcode: 370200 },
            { name: "烟台", adcode: 370600 },
            { name: "潍坊", adcode: 370700 },
            { name: "临沂", adcode: 371300 },
            { name: "淄博", adcode: 370300 }
        ]},
        { name: "河南", cities: [
            { name: "郑州", adcode: 410100 },
            { name: "洛阳", adcode: 410300 },
            { name: "开封", adcode: 410200 },
            { name: "南阳", adcode: 411300 }
        ]},
        { name: "湖北", cities: [
            { name: "武汉", adcode: 420100 },
            { name: "宜昌", adcode: 420500 },
            { name: "襄阳", adcode: 420600 }
        ]},
        { name: "湖南", cities: [
            { name: "长沙", adcode: 430100 },
            { name: "株洲", adcode: 430200 },
            { name: "岳阳", adcode: 430600 }
        ]},
        { name: "广东", cities: [
            { name: "广州", adcode: 440100 },
            { name: "深圳", adcode: 440300 },
            { name: "珠海", adcode: 440400 },
            { name: "东莞", adcode: 441900 },
            { name: "佛山", adcode: 440600 },
            { name: "惠州", adcode: 441300 },
            { name: "中山", adcode: 442000 },
            { name: "汕头", adcode: 440500 }
        ]},
        { name: "广西", cities: [
            { name: "南宁", adcode: 450100 },
            { name: "桂林", adcode: 450300 },
            { name: "柳州", adcode: 450200 }
        ]},
        { name: "海南", cities: [
            { name: "海口", adcode: 460100 },
            { name: "三亚", adcode: 460200 }
        ]},
        { name: "四川", cities: [
            { name: "成都", adcode: 510100 },
            { name: "绵阳", adcode: 510700 },
            { name: "宜宾", adcode: 511500 }
        ]},
        { name: "贵州", cities: [
            { name: "贵阳", adcode: 520100 },
            { name: "遵义", adcode: 520300 }
        ]},
        { name: "云南", cities: [
            { name: "昆明", adcode: 530100 },
            { name: "大理", adcode: 532901 },
            { name: "丽江", adcode: 530700 }
        ]},
        { name: "西藏", cities: [
            { name: "拉萨", adcode: 540100 }
        ]},
        { name: "陕西", cities: [
            { name: "西安", adcode: 610100 },
            { name: "咸阳", adcode: 610400 }
        ]},
        { name: "甘肃", cities: [
            { name: "兰州", adcode: 620100 }
        ]},
        { name: "青海", cities: [
            { name: "西宁", adcode: 630100 }
        ]},
        { name: "宁夏", cities: [
            { name: "银川", adcode: 640100 }
        ]},
        { name: "新疆", cities: [
            { name: "乌鲁木齐", adcode: 650100 }
        ]},
        { name: "港澳台", cities: [
            { name: "香港", adcode: 810000 },
            { name: "澳门", adcode: 820000 },
            { name: "台北", adcode: 710100 }
        ]}
    ]

    // ── Trigger button ──
    Rectangle {
        id: triggerBtn
        anchors.fill: parent
        radius: theme.radiusSmall
        color: triggerArea.containsMouse ? theme.cardBgHover : theme.cardBg
        border.color: popup.visible ? theme.accent : (triggerArea.containsMouse ? theme.cardBorderHover : theme.cardBorder)
        border.width: 1

        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on border.color { ColorAnimation { duration: 150 } }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 6
            spacing: 2

            Text {
                text: selectedCity || "选择城市"
                font: theme.captionFont
                color: selectedCity ? theme.primaryText : theme.mutedText
                Layout.fillWidth: true
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                text: "▾"
                font.pixelSize: 11
                color: popup.visible ? theme.accent : theme.secondaryText
                transformOrigin: Item.Center
                rotation: popup.visible ? 180 : 0
                Behavior on rotation { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
                Behavior on color { ColorAnimation { duration: 150 } }
            }
        }

        MouseArea {
            id: triggerArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (popup.visible) popup.close()
                else popup.open()
            }
        }
    }

    // ── Two-column popup ──
    Popup {
        id: popup
        x: 0
        y: control.height + 4
        width: 280
        height: 260
        padding: 0
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        enter: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 180; easing.type: Easing.OutQuad }
                NumberAnimation { property: "y"; from: control.height - 4; to: control.height + 4; duration: 180; easing.type: Easing.OutQuad }
            }
        }
        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 120; easing.type: Easing.InQuad }
        }

        background: Rectangle {
            radius: theme.radiusMedium
            color: "#16162a"
            border.color: theme.cardBorderHover
            border.width: 1
        }

        contentItem: RowLayout {
            spacing: 0

            // ── Left: Province list ──
            ListView {
                id: provinceList
                Layout.preferredWidth: 90
                Layout.fillHeight: true
                Layout.topMargin: 6
                Layout.bottomMargin: 6
                clip: true
                model: provinceData
                currentIndex: _selectedProvinceIndex
                boundsBehavior: Flickable.StopAtBounds

                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

                delegate: Item {
                    width: provinceList.width
                    height: 30

                    Rectangle {
                        anchors.fill: parent
                        anchors.leftMargin: 4
                        anchors.rightMargin: 2
                        radius: 6
                        color: index === _selectedProvinceIndex
                               ? theme.glowCyan
                               : (provArea.containsMouse ? theme.cardBgHover : "transparent")
                        Behavior on color { ColorAnimation { duration: 120 } }

                        Text {
                            anchors.centerIn: parent
                            text: modelData.name
                            font: theme.captionFont
                            color: index === _selectedProvinceIndex ? theme.accent : theme.primaryText
                            Behavior on color { ColorAnimation { duration: 120 } }
                        }

                        MouseArea {
                            id: provArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                _selectedProvinceIndex = index
                            }
                        }
                    }
                }
            }

            // ── Divider ──
            Rectangle {
                Layout.fillHeight: true
                Layout.topMargin: 8
                Layout.bottomMargin: 8
                width: 1
                color: theme.divider
            }

            // ── Right: City list ──
            ListView {
                id: cityList
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.topMargin: 6
                Layout.bottomMargin: 6
                clip: true
                model: provinceData[_selectedProvinceIndex] ? provinceData[_selectedProvinceIndex].cities : []
                boundsBehavior: Flickable.StopAtBounds

                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

                delegate: Item {
                    width: cityList.width
                    height: 30

                    Rectangle {
                        anchors.fill: parent
                        anchors.leftMargin: 2
                        anchors.rightMargin: 4
                        radius: 6
                        color: cityArea.containsMouse ? theme.cardBgHover : "transparent"
                        Behavior on color { ColorAnimation { duration: 120 } }

                        Text {
                            anchors.centerIn: parent
                            text: modelData.name
                            font: theme.captionFont
                            color: cityArea.containsMouse ? theme.accent : theme.primaryText
                            Behavior on color { ColorAnimation { duration: 120 } }
                        }

                        MouseArea {
                            id: cityArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                selectedCity = modelData.name
                                popup.close()
                                citySelected(modelData.adcode, modelData.name)
                            }
                        }
                    }
                }
            }
        }
    }
}
