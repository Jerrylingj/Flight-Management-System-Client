import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import NetworkHandler 1.0

FluFrame {
    id: orderInfoCard
    radius: 10
    Layout.fillWidth: true
    Layout.preferredHeight: 100
    padding: 10

    property int  orderId;
    property int userId;
    property int flightId;
    property int totalChangeCount;
    property bool paymentStatus;

    property string flightNumber;
    property string airlineCompany;
    property double price;
    property string flightStatus;

    property string departure;
    property string destination;
    property string departureTime;
    property string arrivalTime;
    property string departureAirport;
    property string arrivalAirport;

    property string checkInStartTime;
    property string checkInEndTime;


    property string currentTimeValue: Qt.formatTime(new Date(), "HH:mm");

    signal orderUpdated()

    QtObject {
        id: rebookingFlightInfo
        // Store all flights in a single array (or use a ListModel if preferred)
        property var flightList: []

        // Optional: track selected index or items
        property int selectedIndex: -1

        // Update the entire list at once
        function setFlights(flights) {
            flightList = flights
        }
    }

    NetworkHandler {
        id: searchHandler
        onRequestSuccess: function (responseData) {
            console.log("获取可供改签的航班成功:", JSON.stringify(responseData))
            if(responseData.success) {
                if(responseData.data && responseData.data.length) {
                    rebookingFlightInfo.setFlights(responseData.data)
                    rebookingDialog.open()
                } else {
                    rebookingFailDialog.open()
                }
            } else {
                console.error("错误信息:", responseData.message)
                showError(qsTr("获取航班信息失败"), 5000)
            }
        }
        onRequestFailed: function (errorMessage) {
            console.error("请求失败:", errorMessage)
        }
    }

    // 函数:创建订单
    // function createOrder(flightId){
    // }

    // 函数:支付订单
    function payOrder(){
        var url = "/api/orders/pay";
        console.log("发送支付订单信息请求,URL = ", url);
        console.log("token: ", userInfo.myToken)
        console.log(orderHandler.POST)
        var payload = {
            orderId : orderId
        }

        orderHandler.request(url, NetworkHandler.POST, payload, userInfo.myToken);
        // 如果成功,应当扣除用户余额
        // 如果成功,应当改变前端订单信息
    }

    // 函数:删除订单
    function deleteOrder(){
        var url = "/api/orders/delete";
        console.log("发送删除订单信息请求,URL = ", url);
        console.log("token: ", userInfo.myToken)
        console.log(orderHandler.POST)
        var payload = {
            orderId : orderId
        }

        orderHandler.request(url, NetworkHandler.POST, payload, userInfo.myToken);
        // 如果成功,应当返还用户余额
        // 如果成功,应当改变前端订单信息
    }

    // 函数:退签订单
    function unpayOrder(){
        var url = "/api/orders/unpay";
        console.log("发送退签订单信息请求,URL = ", url);
        console.log("token: ", userInfo.myToken)
        console.log(orderHandler.POST)
        var payload = {
            orderId : orderId
        }

        orderHandler.request(url, NetworkHandler.POST, payload, userInfo.myToken);
        // 如果成功,应当返还用户余额
        // 如果成功,应当改变前端订单信息
    }

    // 函数:改签订单
    function rebookOrder(otherFlightId){
        var url = "/api/orders/rebook";
        console.log("发送改签订单信息请求,URL = ", url);
        console.log("token: ", userInfo.myToken)
        // console.log(orderHandler.POST)
        var payload = {
            orderId: orderId,
            flightId: otherFlightId
        }
        orderHandler.request(url, NetworkHandler.POST, payload, userInfo.myToken);
    }

    // 函数:获取下一条同样出发地的航班
    function getNearestFlight(){
        var url = "/api/flights/next"
        console.log("发送查找下一条同样行程的航班的请求，URL = ", url);
        console.log("token: ", userInfo.myToken);
        // console.log(orderHandler.GET)
        var payload = {
            flightId : flightId
        }
        searchHandler.request(url, NetworkHandler.POST, payload, userInfo.myToken);
    }

    // 订单接口的 NetworkHandler 实例，处理支付、退签和改签的请求
    NetworkHandler {
        id: orderHandler

        onRequestSuccess: function (responseData) {
            console.log("订单操作请求成功，返回数据：", JSON.stringify(responseData));

            if (responseData.success) {
                console.log("订单操作成功");
                showSuccess(qsTr("操作成功！"), 3000, qsTr("感谢您对云途公司的信赖！"))
                // 触发信号，通知父组件刷新数据
                orderUpdated();
                userInfo.updateUserInfo();

            } else {
                console.error("订单操作失败，错误信息：", responseData.message);
                showError(qsTr("操作失败"), 5000, qsTr("↙请点击左下角\"客服\"询问"))
            }
        }

        onRequestFailed: function (errorMessage) {
            console.error("订单请求失败：", errorMessage);
        }
    }

    

    // 改签失败弹窗
    FluContentDialog{
        id : rebookingFailDialog
        title: qsTr("非常抱歉")
        message: qsTr("目前没有从" + departure + "到"+ destination + "的航班，您可以选择退签，我们将会全款返回"+price+"奶龙币");
        buttonFlags: FluContentDialogType.PositiveButton
        positiveText : qsTr("确定")
        onPositiveClicked:{
            showSuccess(qsTr("祝您旅途愉快！"))
        }
    }

    // 改签弹窗
    FluContentDialog {
        id: rebookingDialog
        title: qsTr("您希望改签至哪一个航班？")
        message: qsTr("请点击对应的卡片")
        width: 600
    
        // 选中航班的flightId，null表示未选中任何航班
        property var selectedFlightId: null

            // 处理改签航班信息卡片选择的函数
        function handleFlightSelection(flightId = null) {
            rebookingDialog.selectedFlightId = flightId;
            rebookingFlightInfo.flightList = rebookingFlightInfo.flightList; // Trigger Repeater refresh
        }

        // 定义一个JavaScript函数来处理信号
        function handleFlightSelectionSignal(flightId) {
            handleFlightSelection(flightId);
        }
    
        contentDelegate: Component {
            Item {
                implicitWidth: parent.width
                implicitHeight: 420
    
                Flickable {
                    id: rebookingFlickable
                    width: parent.width
                    height: parent.height
                    clip: true
                    contentWidth: parent.width
                    contentHeight: rebookingColumnLayout.height
                    property int selectedFlightId: -1;
    
                    ColumnLayout {
                        id: rebookingColumnLayout
                        width: parent.width
                        spacing: 10
                        
    
                        Repeater {
                            id: rebookingRepeater
                            model: rebookingFlightInfo.flightList

                            RebookFlightInfoCard {
                                width: parent.width
                                height: 80
                                flightId: modelData.flightId
                                flightNumber: modelData.flightNumber
                                departureTime: modelData.departureTime
                                arrivalTime: modelData.arrivalTime
                                departureAirport: modelData.departureAirport
                                arrivalAirport: modelData.arrivalAirport
                                price: modelData.price
                                airlineCompany: modelData.airlineCompany
                                status: modelData.status
                                currentSelectedFlightId: rebookingFlickable.selectedFlightId

                                onCardSelected: {
                                    if (rebookingFlickable.selectedFlightId === flightId) {
                                        rebookingFlickable.selectedFlightId = -1  // 取消选择
                                    } else {
                                        rebookingFlickable.selectedFlightId = flightId  // 选择当前卡片
                                    }
                                }

                                onCardDeselected: {
                                    rebookingFlickable.selectedFlightId = -1  // 取消选择
                                }
                            }
                        }
                    }

                    // 监听 selectedFlightId 的变化
                    onSelectedFlightIdChanged: {
                        showInfo(
                            "选择已变更",
                            4000,
                            selectedFlightId === -1
                                ? "当前未选择"
                                : "当前选择航班编号为 " + selectedFlightId + " 的航班"
                        )
                    }
                }
            }
        }
    
        negativeText: qsTr("取消")
        onNegativeClicked: {
            showWarning("操作已取消", 4000);
        }
    
        positiveText: qsTr("确认改签")
        onPositiveClickListener: () => {
            if (selectedFlightId === null) {
                console.log("未选择任何卡片，改签操作不执行")
            } else {
                showSuccess("将改签至第" + selectedFlightId + "个航班")
                showSuccess("改签成功", 4000, "祝您旅途愉快！")
            }
        }
    }
    


    // 整个Card
    RowLayout{
        // Card的左半边（信息部分）
        ColumnLayout{
            // 主要信息展示栏
            RowLayout{
                // 航空公司 Logo 和航班信息
                ColumnLayout{
                    Layout.preferredWidth: 150
                    spacing: 5

                    FluRectangle {
                        color: "#409EFF"
                        radius: [10, 10, 10, 10]
                        height: 32
                        width : 100
                        FluText {
                            text: flightNumber // 航班号
                            font.pixelSize: 18
                            font.bold: true
                            color: "white"
                            anchors.centerIn: parent
                        }
                    }

                    FluText {
                        text: airlineCompany // 航空公司名称
                        font.pixelSize: 12
                    }


                }

                ColumnLayout{
                    Layout.fillWidth: true

                    FluText {
                        text: formatTime(departureTime) // 起飞时间
                        font.pixelSize: 24
                        font.bold: true
                    }

                    FluText {
                        text: departureAirport // 起点机场
                        font.pixelSize: 12
                    }
                }

                FluText {
                    width: 50
                    text: "→"
                    font.bold: true
                }

                ColumnLayout {
                    Layout.fillWidth: true

                    FluText {
                        id: arrival
                        text: formatTime(arrivalTime) // 到达时间
                        font.pixelSize: 24
                        font.bold: true
                    }
                    FluText {
                        text: arrivalAirport // 终点机场
                        font.pixelSize: 12
                    }
                }

                // 价格和状态
                ColumnLayout {
                    Layout.preferredWidth: orderInfoCard.width / 6
                    spacing: 5

                    FluText {
                        text: qsTr("￥") + price.toFixed(2) // 动态绑定价格
                        font.pixelSize: 18
                        font.bold: true
                        color: "#F39C12"
                    }

                    Rectangle {
                        id: statusBadge
                        Layout.alignment: Qt.AlignHCenter
                        width: 80
                        height: 24
                        radius: 5
                        color: flightStatus === "On Time" ? "#27AE60" : (status === "Delayed" ? "#F39C12" : "#C0392B")

                        FluText {
                            anchors.centerIn: parent
                            text: flightStatus
                            color: "white"
                            font.pixelSize: 14
                            font.bold: true
                        }
                    }
                }
            }


            
            Timer {
                id: checkInTimer
                interval: 1000
                running: true
                repeat: true

                function formatTimeDiff(diffMillis) {
                    var totalSec = Math.floor(diffMillis / 1000)
                    var h = Math.floor(totalSec / 3600)
                    var m = Math.floor((totalSec % 3600) / 60)
                    var s = totalSec % 60
                    return (h < 10 ? "0"+h : h) + ":" + (m < 10 ? "0"+m : m) + ":" + (s < 10 ? "0"+s : s)
                }

                onTriggered: {
                    var now = new Date()
                    var start = new Date(checkInStartTime)
                    var end = new Date(checkInEndTime)
                    if (now < start) {
                        checkInCountdown.color = FluTheme.dark ? "#90EE90" : "#006400" // 浅绿色 : 深绿色
                        checkInCountdown.text = "检票开始剩余：" + formatTimeDiff(start - now)
                    } else if (now >= start && now < end) {
                        checkInCountdown.color = "#FFA500" // 橙色
                        checkInCountdown.text = "检票结束剩余：" + formatTimeDiff(end - now)
                    } else {
                        checkInCountdown.color = FluTheme.dark ? "#FF7F7F" : "#FF0000" // 浅红色 : 红色
                        checkInCountdown.text = paymentStatus ? "检票已结束，您可以退改签" : "检票已结束，您可以取消支付"
                    }
                }
            }

            FluText {
                id: checkInCountdown
                font.pixelSize: 20
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }


        }

        // Card的右半边（按钮部分）
        ColumnLayout{
            // 显示二维码和支付/退改签按钮
            Layout.preferredWidth: orderInfoCard.width / 6

            // 登机二维码按钮
            FluToggleButton {
                text: checked ? qsTr("登机二维码") : qsTr("取消支付")
                Layout.preferredWidth: 100
                checked: paymentStatus
                // onClicked: {
                //    qRCodeDialog.open()
                // }

                // 是否取消支付弹窗
                FluContentDialog{
                    id : deleteOrNot
                    title: qsTr("请确认操作")
                    message: qsTr("确定删除订单？")
                    positiveText: qsTr("取消")
                    onPositiveClicked: {
                        showWarning("已取消操作", 3000);
                    }
                    negativeText: qsTr("确认删除")
                    onNegativeClicked: {
                        deleteOrder();
                    }
                }

                // 登机二维码弹窗
                FluContentDialog{
                    id: qRCodeDialog
                    title: qsTr("登机二维码")
                    message: qsTr("提反高诈意识，请勿描扫陌生二维码")
                    contentDelegate: Component{
                        Item{
                            implicitWidth: parent.width
                            implicitHeight: 300
                            anchors.alignWhenCentered: parent.Center
                            FluQRCode{
                                anchors.fill: parent
                                color:"black"
                                text:"https://www.bilibili.com/video/BV1uT4y1P7CX/?share_source=copy_web"
                                size:200
                            }
                        }
                    }
                    buttonFlags: FluContentDialogType.PositiveButton
                    positiveText: qsTr("完成")
                    onPositiveClicked: {
                        showSuccess(qsTr("祝您旅途愉快！"), 3000)
                    }
                }

                onClicked: {
                    if(!checked){
                        checked = !checked;
                        qRCodeDialog.open();
                    }else{
                        checked = !checked;
                        deleteOrNot.open()
                    }
                }
            }


            // 支付/退改签按钮
            FluToggleButton {
                id: payOrRebookButton
                text: checked ? qsTr("退改签") : qsTr("立即支付")
                Layout.preferredWidth: 100
                checked: paymentStatus
                disabled: new Date() > new Date(checkInEndTime) && !paymentStatus
                normalColor: {
                    if(!checked){
                        return "#F3CF2A"
                    }else{
                        return FluTheme.dark ? "#FA98EB" : "#E13EE1"
                    }
                }
                hoverColor: {
                    // if(!checked){
                        return FluTheme.dark ? Qt.darker(normalColor,1.1) : Qt.lighter(normalColor,1.1)
                    // }else{
                    //     return FluTheme.dark ? Qt.rgba(68/255,68/255,68/255,1) : Qt.rgba(246/255,246/255,246/255,1)
                    // }
                }
                disableColor: {
                    return FluTheme.dark ? "#FFFFE0" : "#FFFFE0"
                }

                // 选择弹窗
                FluContentDialog{
                    id:selectionDialog
                    title: qsTr("您希望如何操作？")
                    message: qsTr("请选择退签或改签")
                    negativeText: qsTr("退签")
                    buttonFlags: FluContentDialogType.NeutralButton | FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton

                    onNegativeClicked:{
                        
                        unpayOrder();
                    }
                    positiveText: qsTr("改签")
                    onPositiveClicked:{
                        getNearestFlight();
                    }
                    neutralText: qsTr("取消操作")
                    onNeutralClicked: {
                        showWarning(qsTr("操作已取消"), 3000)
                        }
                    }

                // 需要充值弹窗
                FluContentDialog{
                    id: rechargeReminder
                    title: qsTr("温馨提示：奶龙币不足")
                    message: qsTr("您需要先充值奶龙币")
                    positiveText: qsTr("去充值")

                    RechargeEntry{
                        id: rechargeInOrder
                    }

                    onPositiveClicked:{
                        rechargeInOrder.open();
                    }

                    negativeText: qsTr("取消")
                    onNegativeClicked: {
                        showWarning("已取消购票", 3000, "您真的不看看我们的充值界面吗？")
                    }
                }

                // 支付弹窗
                FluContentDialog {
                    id: paymentDialog
                    title: qsTr("支付")
                    message: qsTr("将使用奶龙币支付")
                    buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton

                    // 为弹窗添加内边距
                    // contentMargins: Qt.point(20, 20) // 左右上下各20像素

                    contentDelegate: Component {
                        ColumnLayout { // 使用 ColumnLayout 来垂直排列子项
                            Layout.alignment: Qt.AlignHCenter // 设置水平居中对齐
                            spacing: 15 // 行间距设为15像素

                            RowLayout{
                                Layout.alignment: Qt.AlignHCenter // 确保单个文本居中
                                spacing: 5 // 如果需要的话，也可以设置内部组件的间距
                                FluText {
                                    text: "您当前资产为"
                                    Layout.alignment: Qt.AlignHCenter // 确保单个文本居中
                                    Layout.topMargin: 10 // 上边距设为10像素
                                    Layout.bottomMargin: 10 // 下边距设为10像素
                                }
                                FluText {
                                    color: "#F3CF2A"
                                    font.bold: true
                                    text: userInfo.myMoney + "奶龙币"
                                    font.pixelSize: 26
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: 10
                                    Layout.bottomMargin: 10
                                }
                            }

                            RowLayout{
                                Layout.alignment: Qt.AlignHCenter // 确保单个文本居中
                                FluText {
                                    text: "购票将消耗您"
                                    // font.pixelSize: 26
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: 10 // 上边距设为10像素
                                    Layout.bottomMargin: 10 // 下边距设为10像素
                                }
                                FluText {
                                    color: "red"
                                    font.bold: true
                                    text: price + "奶龙币"
                                    font.pixelSize: 26
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: 10 // 上边距设为10像素
                                    Layout.bottomMargin: 10 // 下边距设为10像素
                                }
                            }

                            RowLayout{
                                Layout.alignment: Qt.AlignHCenter // 确保单个文本居中
                                FluText {
                                    text: "您的余额将是"
                                    // font.pixelSize: 18
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: 10 // 上边距设为10像素
                                    Layout.bottomMargin: 10 // 下边距设为10像素
                                }
                                FluText {
                                    color: "green"
                                    font.bold: true
                                    text: (userInfo.myMoney - price) + "奶龙币"
                                    font.pixelSize: 26
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: 10 // 上边距设为10像素
                                    Layout.bottomMargin: 10 // 下边距设为10像素
                                }
                            }

                            FluText {
                                text: "确定执行支付操作吗？"
                                font.pixelSize: 18
                                font.bold: true
                                font.italic: true
                                Layout.alignment: Qt.AlignHCenter
                                Layout.topMargin: 10 // 上边距设为10像素
                                Layout.bottomMargin: 10 // 下边距设为10像素
                            }
                        }
                    }
                    negativeText: qsTr("狠心拒绝")
                    onNegativeClicked: {
                        showWarning(qsTr("已取消支付"), 3000, qsTr("您真的不考虑考虑吗？"))
                    }

                    positiveText: qsTr("大方支付")
                    onPositiveClicked: {
                        // showSuccess(qsTr("感谢您的信赖！"))
                        payOrder();
                        // 这段代码应该在后端返回成功信息之后,在networdHandler里面执行
                        // payOrRebookButton.checked = !payOrRebookButton.checked;
                        // paymentStatus = !paymentStatus;
                        // userInfo.myMoney = userInfo.myMoney - price;
                    }
                }

                onClicked: {
                    if(!checked){
                        checked = !checked;
                        selectionDialog.open();
                    }else{
                        checked = !checked;
                        if(userInfo.myMoney > price){
                            paymentDialog.open();
                        }else{
                            rechargeReminder.open();
                        }

                    }
                }
            }
        }
    }

    // 函数：格式化时间为 "hh:mm" 格式
    function formatTime(timeString) {
        var date = new Date(timeString);  // 使用 JavaScript 内置的 Date 对象解析时间字符串
        var hours = date.getHours();  // 获取小时
        var minutes = date.getMinutes();  // 获取分钟

        // 保证小时和分钟都是两位数格式
        return (hours < 10 ? '0' + hours : hours) + ":" + (minutes < 10 ? '0' + minutes : minutes);
    }
}
