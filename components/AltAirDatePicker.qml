import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI

// 自定义按钮组件，继承自FluButton
FluButton {
    // 属性定义
    property bool showYear: true // 是否显示年份选择
    property var current // 当前选定的日期对象
    property string yearText: qsTr("年") // 年份文本
    property string monthText: qsTr("月") // 月份文本
    property string dayText: qsTr("日") // 日文本
    property string cancelText: qsTr("清空") // 取消按钮文本
    property string okText: qsTr("确认") // 确认按钮文本

    // 信号定义
    signal accepted() // 当用户确认选择时发出信号

    id: control
    implicitHeight: 30 // 组件默认高度
    implicitWidth: 150 // 组件默认宽度

    // 组件加载完成时的初始化逻辑
    Component.onCompleted: {
        if(current){
            const now = current;
            // 根据当前文本或当前日期设置年份
            var year = text_year.text === control.yearText ? now.getFullYear() : Number(text_year.text);
            // 根据当前文本或当前日期设置月份
            var month = text_month.text === control.monthText ? now.getMonth() + 1 : Number(text_month.text);
            // 根据当前文本或当前日期设置日期
            var day = text_day.text === control.dayText ? now.getDate() : Number(text_day.text);
            text_year.text = year
            text_month.text = month
            text_day.text = day
        }else{
            current = null;
        }
    }

    // 内部项，用于管理弹出窗口状态
    Item{
        id: d
        property var window: Window.window // 引用当前窗口
        property bool cancled: false
        property bool changeFlag: true // 标记是否有更改
        property var rowData: ["","",""] // 存储年、月、日的临时数据
        visible: false // 默认不可见
    }

    // 点击按钮时显示弹出窗口
    onClicked: {
        popup.showPopup()
    }

    // 第一个分隔线，用于分隔年份和月份
    Rectangle{
        id: divider_1
        width: 1 // 分隔线宽度
        x: parent.width / 3 // 分隔线X位置
        height: parent.height - 1 // 分隔线高度
        color: control.dividerColor // 分隔线颜色
        visible: showYear // 是否可见取决于showYear属性
    }

    // 第二个分隔线，用于分隔月份和日期
    Rectangle{
        id: divider_2
        width: 1 // 分隔线宽度
        x: showYear ? parent.width * 2 / 3 : parent.width / 2 // 根据是否显示年份调整位置
        height: parent.height - 1 // 分隔线高度
        color: control.dividerColor // 分隔线颜色
    }

    // 年份文本显示
    FluText{
        id: text_year
        anchors{
            left: parent.left
            right: divider_1.left
            top: parent.top
            bottom: parent.bottom
        }
        visible: showYear // 是否可见取决于showYear属性
        verticalAlignment: Text.AlignVCenter // 垂直居中对齐
        horizontalAlignment: Text.AlignHCenter // 水平居中对齐
        text: control.yearText // 显示的文本内容
        color: control.textColor // 文本颜色
    }

    // 月份文本显示
    FluText{
        id: text_month
        anchors{
            left: showYear ? divider_1.right : parent.left
            right: divider_2.left
            top: parent.top
            bottom: parent.bottom
        }
        verticalAlignment: Text.AlignVCenter // 垂直居中对齐
        horizontalAlignment: Text.AlignHCenter // 水平居中对齐
        text: control.monthText // 显示的文本内容
        color: control.textColor // 文本颜色
    }

    // 日文本显示
    FluText{
        id: text_day
        anchors{
            left: divider_2.right
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        verticalAlignment: Text.AlignVCenter // 垂直居中对齐
        horizontalAlignment: Text.AlignHCenter // 水平居中对齐
        text: control.dayText // 显示的文本内容
        color: control.textColor // 文本颜色
    }

    // 弹出菜单，用于选择年月日
    Menu{
        id: popup
        modal: true // 模态弹出
        Overlay.modal: Item {} // 覆盖层

        // 弹入动画
        enter: Transition {
            reversible: true
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: FluTheme.animationEnabled ? 83 : 0
            }
        }

        // 弹出动画
        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: FluTheme.animationEnabled ? 83 : 0
            }
        }

        // 弹出窗口的背景
        background: Rectangle{
            radius: 5 // 圆角半径
            color: FluTheme.dark ? Qt.rgba(43/255,43/255,43/255,1) : Qt.rgba(1,1,1,1) // 背景颜色根据主题变化
            border.color: FluTheme.dark ? Qt.rgba(26/255,26/255,26/255,1) : Qt.rgba(191/255,191/255,191/255,1) // 边框颜色
            FluShadow{ // 阴影效果
                radius: 5
            }
        }

        // 弹出内容项
        contentItem: Item{
            id: container
            implicitHeight: 340 // 内容高度
            implicitWidth: 300 // 内容宽度

            // 鼠标区域，防止事件穿透
            MouseArea{
                anchors.fill: parent
            }

            // 排列布局，水平排列ListView
            RowLayout{
                id: layout_content
                spacing: 0 // 元素间距
                width: parent.width
                height: 280

                // 列表代表项的组件
                Component{
                    id: list_delegate
                    Item{
                        height: 38 // 每项高度
                        width: getListView().width // 每项宽度与所属ListView相同

                        // 获取所属的ListView
                        function getListView(){
                            if(type === 0)
                                return list_view_1
                            if(type === 1)
                                return list_view_2
                            if(type === 2)
                                return list_view_3
                        }

                        // 项的背景矩形
                        Rectangle{
                            anchors.fill: parent
                            anchors.topMargin: 2
                            anchors.bottomMargin: 2
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            color: {
                                // 当前项被选中
                                if(getListView().currentIndex === position){
                                    return item_mouse.containsMouse ? Qt.lighter(FluTheme.primaryColor, 1.1) : FluTheme.primaryColor
                                }
                                // 鼠标悬停时的颜色变化
                                if(item_mouse.containsMouse){
                                    return FluTheme.dark ? Qt.rgba(63/255,60/255,61/255,1) : Qt.rgba(237/255,237/255,242/255,1)
                                }
                                return Qt.rgba(0,0,0,0) // 默认透明
                            }
                            radius: 3 // 圆角半径

                            // 鼠标区域，用于处理点击事件
                            MouseArea{
                                id: item_mouse
                                anchors.fill: parent
                                hoverEnabled: true // 启用悬停
                                onClicked: {
                                    getListView().currentIndex = position
                                    if(type === 0){
                                        // 选择年份后更新月份和日期
                                        text_year.text = model
                                        list_view_2.model = generateMonthArray(1, 12)
                                        text_month.text = list_view_2.model[list_view_2.currentIndex]

                                        list_view_3.model = generateMonthDaysArray(list_view_1.model[list_view_1.currentIndex], list_view_2.model[list_view_2.currentIndex])
                                        text_day.text = list_view_3.model[list_view_3.currentIndex]
                                    }
                                    if(type === 1){
                                        // 选择月份后更新日期
                                        text_month.text = model
                                        list_view_3.model = generateMonthDaysArray(list_view_1.model[list_view_1.currentIndex], list_view_2.model[list_view_2.currentIndex])
                                        text_day.text = list_view_3.model[list_view_3.currentIndex]
                                    }
                                    if(type === 2){
                                        // 选择日期
                                        text_day.text = model
                                    }
                                }
                            }

                            // 显示项的文本
                            FluText{
                                text: model
                                color: {
                                    if(getListView().currentIndex === position){
                                        // 选中项的文本颜色根据主题变化
                                        if(FluTheme.dark){
                                            return Qt.rgba(0,0,0,1)
                                        } else {
                                            return Qt.rgba(1,1,1,1)
                                        }
                                    } else {
                                        // 非选中项的文本颜色根据主题变化
                                        return FluTheme.dark ? "#FFFFFF" : "#1A1A1A"
                                    }
                                }
                                anchors.centerIn: parent // 文本居中
                            }
                        }
                    }
                }

                // 年份列表视图
                ListView{
                    id: list_view_1
                    Layout.preferredWidth: 100 // 首列宽度
                    Layout.preferredHeight: parent.height - 2 // 高度
                    Layout.alignment: Qt.AlignVCenter // 垂直居中
                    boundsBehavior: Flickable.StopAtBounds // 滚动行为
                    ScrollBar.vertical: FluScrollBar {} // 自定义垂直滚动条
                    model: generateYearArray(1924, 2048) // 年份模型
                    clip: true // 裁剪内容
                    preferredHighlightBegin: 0
                    preferredHighlightEnd: 0
                    highlightMoveDuration: 0 // 高亮移动动画时长
                    visible: showYear // 是否可见取决于showYear属性
                    delegate: FluLoader{
                        property var model: modelData
                        property int type: 0 // 类型标识，0表示年份
                        property int position: index // 当前项位置
                        sourceComponent: list_delegate // 使用的委托组件
                    }
                }

                // 中间分隔线
                Rectangle{
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: parent.height
                    color: control.dividerColor // 分隔线颜色
                    visible: showYear // 是否可见取决于showYear属性
                }

                // 月份列表视图
                ListView{
                    id: list_view_2
                    Layout.preferredWidth: showYear ? 99 : 150 // 根据是否显示年份调整宽度
                    Layout.preferredHeight: parent.height - 2 // 高度
                    Layout.alignment: Qt.AlignVCenter // 垂直居中
                    clip: true // 裁剪内容
                    ScrollBar.vertical: FluScrollBar {} // 自定义垂直滚动条
                    preferredHighlightBegin: 0
                    preferredHighlightEnd: 0
                    highlightMoveDuration: 0 // 高亮移动动画时长
                    boundsBehavior: Flickable.StopAtBounds // 滚动行为
                    delegate: FluLoader{
                        property var model: modelData
                        property int type: 1 // 类型标识，1表示月份
                        property int position: index // 当前项位置
                        sourceComponent: list_delegate // 使用的委托组件
                    }
                }

                // 最后一个分隔线
                Rectangle{
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: parent.height
                    color: control.dividerColor // 分隔线颜色
                }

                // 日期列表视图
                ListView{
                    id: list_view_3
                    Layout.preferredWidth: showYear ? 99 : 150 // 根据是否显示年份调整宽度
                    Layout.preferredHeight: parent.height - 2 // 高度
                    Layout.alignment: Qt.AlignVCenter // 垂直居中
                    clip: true // 裁剪内容
                    preferredHighlightBegin: 0
                    preferredHighlightEnd: 0
                    highlightMoveDuration: 0 // 高亮移动动画时长
                    ScrollBar.vertical: FluScrollBar {} // 自定义垂直滚动条
                    boundsBehavior: Flickable.StopAtBounds // 滚动行为
                    delegate: FluLoader{
                        property var model: modelData
                        property int type: 2 // 类型标识，2表示日期
                        property int position: index // 当前项位置
                        sourceComponent: list_delegate // 使用的委托组件
                    }
                }
            }

            // 操作按钮区域（取消和确定）
            Rectangle{
                id: layout_actions
                height: 60 // 高度
                color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(243/255,243/255,243/255,1) // 背景颜色根据主题变化
                border.color: FluTheme.dark ? Qt.rgba(26/255,26/255,26/255,1) : Qt.rgba(191/255,191/255,191/255,1) // 边框颜色
                radius: 5 // 圆角半径
                anchors{
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                // 分隔线
                Item {
                    id: divider
                    width: 1
                    height: parent.height
                    anchors.centerIn: parent
                }

                // 取消按钮
                FluButton{
                    anchors{
                        left: parent.left
                        leftMargin: 20
                        rightMargin: 10
                        right: divider.left
                        verticalCenter: parent.verticalCenter
                    }
                    text: control.cancelText // 按钮文本
                    onClicked: {
                        d.cancled = true;
                        popup.close();
                        current = null;
                        control.accepted() // 发出确认信号
                    }
                }

                // 确认按钮
                FluFilledButton{
                    anchors{
                        right: parent.right
                        left: divider.right
                        rightMargin: 20
                        leftMargin: 10
                        verticalCenter: parent.verticalCenter
                    }
                    text: control.okText // 按钮文本
                    onClicked: {
                        d.changeFlag = false // 标记没有更改
                        popup.close() // 关闭弹出窗口
                        const year = text_year.text
                        const month = text_month.text
                        const day = text_day.text
                        const date = new Date()
                        date.setFullYear(parseInt(year)); // 设置年份
                        date.setMonth(parseInt(month) - 1); // 设置月份（注意：月份从0开始）
                        date.setDate(parseInt(day)); // 设置日期
                        date.setHours(0);
                        date.setMinutes(0);
                        date.setSeconds(0);
                        current = date // 更新当前日期
                        control.accepted() // 发出确认信号
                    }
                }
            }
        }

        y: 35 // 弹出窗口的Y位置

        // 显示弹出窗口的函数
        function showPopup() {
            d.changeFlag = true // 标记有更改
            d.rowData[0] = text_year.text // 保存当前年份
            d.rowData[1] = text_month.text // 保存当前月份
            d.rowData[2] = text_day.text // 保存当前日期

            const now = new Date();
            // 设置年份
            var year = text_year.text === control.yearText ? now.getFullYear() : Number(text_year.text);
            // 设置月份
            var month = text_month.text === control.monthText ? now.getMonth() + 1 : Number(text_month.text);
            // 设置日期
            var day = text_day.text === control.dayText ? now.getDate() : Number(text_day.text);

            // 更新年份列表的当前索引
            list_view_1.currentIndex = list_view_1.model.indexOf(year)
            text_year.text = year

            // 生成并更新月份列表
            list_view_2.model = generateMonthArray(1, 12)
            list_view_2.currentIndex = list_view_2.model.indexOf(month)
            text_month.text = month

            // 生成并更新日期列表
            list_view_3.model = generateMonthDaysArray(year, month)
            list_view_3.currentIndex = list_view_3.model.indexOf(day)
            text_day.text = day

            // 计算弹出窗口的位置
            var pos = control.mapToItem(null, 0, 0)
            if(d.window.height > pos.y + control.height + container.height){
                popup.y = control.height - 1
            } else if(pos.y > container.height){
                popup.y = -container.height
            } else {
                popup.y = d.window.height - (pos.y + container.height)
            }

            popup.open() // 打开弹出窗口
        }

        // 弹出窗口关闭时的处理
        onClosed: {
            if(d.cancled){
                text_year.text = control.yearText;
                text_month.text = control.monthText;
                text_day.text = control.dayText;
                d.cancled = false;
                return;
            }
            if(d.changeFlag){
                // 如果有更改标记，恢复之前的日期
                text_year.text = d.rowData[0]
                text_month.text = d.rowData[1]
                text_day.text = d.rowData[2]
            }
        }
    }

    // 生成年份数组的函数
    function generateYearArray(startYear, endYear) {
        const yearArray = [];
        for (let year = startYear; year <= endYear; year++) {
            yearArray.push(year);
        }
        return yearArray;
    }

    // 生成月份数组的函数
    function generateMonthArray(startMonth, endMonth) {
        const monthArray = [];
        for (let month = startMonth; month <= endMonth; month++) {
            monthArray.push(month);
        }
        return monthArray;
    }

    // 生成某年某月的日期数组的函数
    function generateMonthDaysArray(year, month) {
        const monthDaysArray = [];
        const lastDayOfMonth = new Date(year, month, 0).getDate(); // 获取月份的最后一天
        for (let day = 1; day <= lastDayOfMonth; day++) {
            monthDaysArray.push(day);
        }
        return monthDaysArray;
    }
}
