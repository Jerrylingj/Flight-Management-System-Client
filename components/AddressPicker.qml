import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI

FluButton {
    property var provinces: ["全部", "北京", "上海", "天津", "重庆", "河北", "山西", "内蒙古", "辽宁", "吉林", "黑龙江", "江苏", "浙江", "安徽", "福建", "江西", "山东", "河南", "湖北", "湖南", "广东", "广西", "海南", "四川", "贵州", "云南", "西藏", "陕西", "甘肃", "青海", "宁夏", "新疆", "香港", "澳门", "台湾"]
    property var cities: {
        "全部": ["全部"],
        "北京": ["北京"],
        "上海": ["上海"],
        "天津": ["天津"],
        "重庆": ["重庆"],
        "河北": ["石家庄", "唐山", "秦皇岛", "邯郸", "邢台", "保定", "张家口", "承德", "沧州", "廊坊", "衡水"],
        "山西": ["太原", "大同", "阳泉", "长治", "晋城", "朔州", "晋中", "运城", "忻州", "临汾", "吕梁"],
        "内蒙古": ["呼和浩特", "包头", "乌海", "赤峰", "通辽", "鄂尔多斯", "呼伦贝尔", "巴彦淖尔", "乌兰察布", "兴安盟", "锡林郭勒盟", "阿拉善盟"],
        "辽宁": ["沈阳", "大连", "鞍山", "抚顺", "本溪", "丹东", "锦州", "营口", "阜新", "辽阳", "盘锦", "铁岭", "朝阳", "葫芦岛"],
        "吉林": ["长春", "吉林", "四平", "辽源", "通化", "白山", "松原", "白城", "延边朝鲜族自治州"],
        "黑龙江": ["哈尔滨", "齐齐哈尔", "鸡西", "鹤岗", "双鸭山", "大庆", "伊春", "佳木斯", "七台河", "牡丹江", "黑河", "绥化", "大兴安岭地区"],
        "江苏": ["南京", "无锡", "徐州", "常州", "苏州", "南通", "连云港", "淮安", "盐城", "扬州", "镇江", "泰州", "宿迁"],
        "浙江": ["杭州", "宁波", "温州", "嘉兴", "湖州", "绍兴", "金华", "衢州", "舟山", "台州", "丽水"],
        "安徽": ["合肥", "芜湖", "蚌埠", "淮南", "马鞍山", "淮北", "铜陵", "安庆", "黄山", "滁州", "阜阳", "宿州", "六安", "亳州", "池州", "宣城"],
        "福建": ["福州", "厦门", "莆田", "三明", "泉州", "漳州", "南平", "龙岩", "宁德"],
        "江西": ["南昌", "景德镇", "萍乡", "九江", "新余", "鹰潭", "赣州", "吉安", "宜春", "抚州", "上饶"],
        "山东": ["济南", "青岛", "淄博", "枣庄", "东营", "烟台", "潍坊", "济宁", "泰安", "威海", "日照", "临沂", "德州", "聊城", "滨州", "菏泽"],
        "河南": ["郑州", "开封", "洛阳", "平顶山", "安阳", "鹤壁", "新乡", "焦作", "濮阳", "许昌", "漯河", "三门峡", "南阳", "商丘", "信阳", "周口", "驻马店", "济源"],
        "湖北": ["武汉", "黄石", "十堰", "宜昌", "襄阳", "鄂州", "荆门", "孝感", "荆州", "黄冈", "咸宁", "随州", "恩施土家族苗族自治州"],
        "湖南": ["长沙", "株洲", "湘潭", "衡阳", "邵阳", "岳阳", "常德", "张家界", "益阳", "郴州", "永州", "怀化", "娄底", "湘西土家族苗族自治州"],
        "广东": ["广州", "深圳", "珠海", "汕头", "佛山", "韶关", "湛江", "肇庆", "江门", "茂名", "惠州", "梅州", "汕尾", "河源", "阳江", "清远", "东莞", "中山", "潮州", "揭阳", "云浮"],
        "广西": ["南宁", "柳州", "桂林", "梧州", "北海", "防城港", "钦州", "贵港", "玉林", "百色", "贺州", "河池", "来宾", "崇左"],
        "海南": ["海口", "三亚", "三沙", "儋州", "琼海", "文昌", "万宁", "东方", "定安县", "屯昌县", "澄迈县", "临高县", "白沙黎族自治县", "昌江黎族自治县", "乐东黎族自治县", "陵水黎族自治县", "保亭黎族苗族自治县", "琼中黎族苗族自治县"],
        "四川": ["成都", "自贡", "攀枝花", "泸州", "德阳", "绵阳", "广元", "遂宁", "内江", "乐山", "南充", "眉山", "宜宾", "广安", "达州", "雅安", "巴中", "资阳", "阿坝藏族羌族自治州", "甘孜藏族自治州", "凉山彝族自治州"],
        "贵州": ["贵阳", "六盘水", "遵义", "安顺", "毕节", "铜仁", "黔西南布依族苗族自治州", "黔东南苗族侗族自治州", "黔南布依族苗族自治州"],
        "云南": ["昆明", "曲靖", "玉溪", "保山", "昭通", "丽江", "普洱", "临沧", "楚雄彝族自治州", "红河哈尼族彝族自治州", "文山壮族苗族自治州", "西双版纳傣族自治州", "大理白族自治州", "德宏傣族景颇族自治州", "怒江傈僳族自治州", "迪庆藏族自治州"],
        "西藏": ["拉萨", "日喀则", "昌都", "林芝", "山南", "那曲", "阿里地区"],
        "陕西": ["西安", "铜川", "宝鸡", "咸阳", "渭南", "延安", "汉中", "榆林", "安康", "商洛"],
        "甘肃": ["兰州", "嘉峪关", "金昌", "白银", "天水", "武威", "张掖", "平凉", "酒泉", "庆阳", "定西", "陇南", "临夏回族自治州", "甘南藏族自治州"],
        "青海": ["西宁", "海东", "海北藏族自治州", "黄南藏族自治州", "海南藏族自治州", "果洛藏族自治州", "玉树藏族自治州", "海西蒙古族藏族自治州"],
        "宁夏": ["银川", "石嘴山", "吴忠", "固原", "中卫"],
        "新疆": ["乌鲁木齐", "克拉玛依", "吐鲁番", "哈密", "昌吉回族自治州", "博尔塔拉蒙古自治州", "巴音郭楞蒙古自治州", "阿克苏地区", "克孜勒苏柯尔克孜自治州", "喀什地区", "和田地区", "伊犁哈萨克自治州", "塔城地区", "阿勒泰地区"],
        "香港": ["香港"],
        "澳门": ["澳门"],
        "台湾": ["台北", "高雄", "台中", "台南", "新北", "桃园", "基隆", "新竹", "嘉义"]
    } // 示例城市数据
    property string selectedProvince: ""
    property string selectedCity: ""
    property string provinceText: qsTr("省份")
    property string cityText: qsTr("城市")
    property string cancelText: qsTr("取消")
    property string okText: qsTr("确定")
    signal accepted()
    id: control
    implicitHeight: 30
    implicitWidth: 180
    Component.onCompleted: {
        if(selectedProvince === "") {
            selectedProvince = provinces[0] // 默认省份
        }
        if(selectedCity === "" && cities[selectedProvince]) {
            selectedCity = cities[selectedProvince][0] // 默认省份
        }
        text_province.text = selectedProvince
        text_city.text = selectedCity
    }

    Item {
        id: d
        property var window: Window.window
        property bool changeFlag: true
        property var rowData: ["", ""]
        visible: false
    }

    onClicked: {
        popup.showPopup()
    }

    Rectangle {
        id: divider
        width: 1
        x: parent.width / 2
        height: parent.height - 1
        color: dividerColor
    }

    FluText {
        id: text_province
        anchors {
            left: parent.left
            right: divider.left
            top: parent.top
            bottom: parent.bottom
        }
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: control.provinceText
        color: control.textColor
    }

    FluText {
        id: text_city
        anchors {
            left: divider.right
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: control.cityText
        color: control.textColor
    }

    Menu {
        id: popup
        modal: true
        Overlay.modal: Item {}
        enter: Transition {
            reversible: true
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: FluTheme.animationEnabled ? 83 : 0
            }
        }
        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: FluTheme.animationEnabled ? 83 : 0
            }
        }
        background: Rectangle {
            radius: 5
            color: FluTheme.dark ? Qt.rgba(43/255, 43/255, 43/255, 1) : Qt.rgba(1, 1, 1, 1)
            border.color: FluTheme.dark ? Qt.rgba(26/255, 26/255, 26/255, 1) : Qt.rgba(191/255, 191/255, 191/255, 1)
            FluShadow {
                radius: 5
            }
        }

        contentItem: Item {
            id: container
            implicitHeight: 340
            implicitWidth: 300
            MouseArea {
                anchors.fill: parent
            }
            RowLayout {
                id: layout_content
                spacing: 0
                width: parent.width
                height: 280
                Component {
                    id: list_delegate
                    Item {
                        height: 38
                        width: getListView().width
                        function getListView() {
                            if (type === 0)
                                return list_view_1
                            if (type === 1)
                                return list_view_2
                        }
                        Rectangle {
                            anchors.fill: parent
                            anchors.topMargin: 2
                            anchors.bottomMargin: 2
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            color: {
                                if (getListView().currentIndex === position) {
                                    return item_mouse.containsMouse ? Qt.darker(FluTheme.primaryColor, 1.1) : FluTheme.primaryColor
                                }
                                if (item_mouse.containsMouse) {
                                    return FluTheme.dark ? Qt.rgba(63/255, 60/255, 61/255, 1) : Qt.rgba(237/255, 237/255, 242/255, 1)
                                }
                                return Qt.rgba(0, 0, 0, 0)
                            }
                            radius: 3
                            MouseArea {
                                id: item_mouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    getListView().currentIndex = position
                                    if (type === 0) {
                                        text_province.text = model
                                        selectedProvince = model
                                        selectedCity = cities[selectedProvince][0] // 默认选择该省的第一个城市
                                        text_city.text = selectedCity
                                    }
                                    if (type === 1) {
                                        text_city.text = model
                                        selectedCity = model
                                    }
                                }
                            }
                            FluText {
                                text: model
                                color: {
                                    if (getListView().currentIndex === position) {
                                        if (FluTheme.dark) {
                                            return Qt.rgba(0, 0, 0, 1)
                                        } else {
                                            return Qt.rgba(1, 1, 1, 1)
                                        }
                                    } else {
                                        return FluTheme.dark ? "#FFFFFF" : "#1A1A1A"
                                    }
                                }
                                anchors.centerIn: parent
                            }
                        }
                    }
                }

                ListView {
                    id: list_view_1
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: parent.height - 2
                    Layout.alignment: Qt.AlignVCenter
                    model: provinces
                    clip: true
                    ScrollBar.vertical: FluScrollBar {}
                    delegate: FluLoader {
                        property var model: modelData
                        property int type: 0
                        property int position: index
                        sourceComponent: list_delegate
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: parent.height
                    color: control.dividerColor
                }

                ListView {
                    id: list_view_2
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: parent.height - 2
                    Layout.alignment: Qt.AlignVCenter
                    model: cities[selectedProvince] || []
                    clip: true
                    ScrollBar.vertical: FluScrollBar {}
                    delegate: FluLoader {
                        property var model: modelData
                        property int type: 1
                        property int position: index
                        sourceComponent: list_delegate
                    }
                }
            }

            Rectangle {
                id: layout_actions
                height: 60
                color: FluTheme.dark ? Qt.rgba(32/255, 32/255, 32/255, 1) : Qt.rgba(243/255, 243/255, 243/255, 1)
                border.color: FluTheme.dark ? Qt.rgba(26/255, 26/255, 26/255, 1) : Qt.rgba(191/255, 191/255, 191/255, 1)
                radius: 5
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                FluButton {
                    anchors {
                        left: parent.left
                        leftMargin: 20
                        rightMargin: 10
                        verticalCenter: parent.verticalCenter
                    }
                    text: control.cancelText
                    onClicked: {
                        popup.close()
                    }
                }

                FluFilledButton {
                    anchors {
                        right: parent.right
                        rightMargin: 20
                        leftMargin: 10
                        verticalCenter: parent.verticalCenter
                    }
                    text: control.okText
                    onClicked: {
                        d.changeFlag = false
                        popup.close()
                        control.accepted()
                    }
                }
            }
        }
        y: 35

        function showPopup() {
            d.changeFlag = true
            d.rowData[0] = text_province.text
            d.rowData[1] = text_city.text

            text_province.text = selectedProvince
            text_city.text = selectedCity

            list_view_1.currentIndex = list_view_1.model.indexOf(selectedProvince)
            list_view_2.currentIndex = list_view_2.model.indexOf(selectedCity)

            var pos = control.mapToItem(null, 0, 0)
            if (d.window.height > pos.y + control.height + container.height) {
                popup.y = control.height - 1
            } else if (pos.y > container.height) {
                popup.y = -container.height
            } else {
                popup.y = d.window.height - (pos.y + container.height)
            }
            popup.open()
        }

        onClosed: {
            if (d.changeFlag) {
                text_province.text = d.rowData[0]
                text_city.text = d.rowData[1]
            }
        }
    }

    function generateArray(start, n) {
        var arr = []
        for (var i = start; i <= n; i++) {
            arr.push(i.toString().padStart(2, '0'))
        }
        return arr
    }
}
