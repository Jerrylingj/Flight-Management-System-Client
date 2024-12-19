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
    signal userUpdated()

    QtObject {
        id: rebookingFlightInfo
        property int flightId: 0
        property string flightNumber: ""
        property string departureCity: ""
        property string arrivalCity: ""
        property string departureTime: ""
        property string arrivalTime: ""
        property double price: 0.0
        property string airlineCompany: ""
        property string status: ""
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

    // 函数:退签订单
    function deleteOrder(){
        var url = "/api/orders/delete";
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
                userUpdated();

            } else {
                console.error("订单操作失败，错误信息：", responseData.message);
                showError(qsTr("操作失败"), 5000, qsTr("↙请点击左下角\"客服\"询问"))
            }
        }

        onRequestFailed: function (errorMessage) {
            console.error("订单请求失败：", errorMessage);
        }
    }

    // 处理 “获取下一条同样出发地的航班” 的 NetworkHandler
    NetworkHandler{
        id: searchHandler
        onRequestSuccess: function (responseData) {
            console.log("获取下一条同样出发地的航班成功，返回数据：", JSON.stringify(responseData));

            if (responseData.success) {
                console.log("获取下一条同样出发地的航班成功");
                if(responseData.data && responseData.data.length){
                    // 直接赋值给结构体属性
                    rebookingFlightInfo.flightId = responseData.data[0].flightId;
                    rebookingFlightInfo.flightNumber = responseData.data[0].flightNumber;
                    rebookingFlightInfo.departureCity = responseData.data[0].departureCity;
                    rebookingFlightInfo.arrivalCity = responseData.data[0].arrivalCity;
                    rebookingFlightInfo.departureTime = responseData.data[0].departureTime;
                    rebookingFlightInfo.arrivalTime = responseData.data[0].arrivalTime;
                    rebookingFlightInfo.price = responseData.data[0].price;
                    rebookingFlightInfo.airlineCompany = responseData.data[0].airlineCompany;
                    rebookingFlightInfo.status = responseData.data[0].status;
                    rebookingDialog.open();
                } else {
                    rebookingFailDialog.open();
                }
            } else {
                console.error("获取下一条同样出发地的航班失败，错误信息：", responseData.message);
                showError(qsTr("获取最新航班信息失败"), 5000, qsTr("↙请点击左下角“客服”询问"))
            }
        }

        onRequestFailed: function (errorMessage) {
            console.error("获取下一条同样出发地的航班失败：", errorMessage);
        }
    }

    // 改签失败弹窗
    FluContentDialog{
        id : rebookingFailDialog
        title: qsTr("非常抱歉")
        message: qsTr("目前没有从" + departure + "到"+ destination + "的航班");
        buttonFlags: FluContentDialogType.PositiveButton
        positiveText : qsTr("确定")
        onPositiveClicked:{
            showSuccess(qsTr("祝您旅途愉快！"))
        }
    }

    // 改签弹窗
    FluContentDialog{
        id : rebookingDialog
        title : qsTr("航班改签")
        message: qsTr("您的航班将被改签至下一个从"+departure+"到"+destination+"的航班")

        contentDelegate: Component{
            Item{
                implicitWidth: parent.width
                implicitHeight: 300
                ColumnLayout {
                    spacing: 10
                    FluText {
                        text: "航班号：" + rebookingFlightInfo.flightNumber
                    }
                    FluText {
                        text: "出发时间：" + Qt.formatDateTime(new Date(rebookingFlightInfo.departureTime), "yyyy-MM-dd hh:mm:ss")
                    }
                    FluText {
                        text: "到达时间：" + Qt.formatDateTime(new Date(rebookingFlightInfo.arrivalTime), "yyyy-MM-dd hh:mm:ss")
                    }
                    FluText {
                        text: "航空公司：" + rebookingFlightInfo.airlineCompany
                    }
                    FluText {
                        text: "航班状态：" + rebookingFlightInfo.status
                    }
                }
            }
        }

        negativeText:qsTr("取消")
        onNegativeClicked: {
            showWarning("操作已取消", 4000);
        }

        positiveText:(qsTr("确认改签"))
        onPositiveClicked:{
            console.log("即将改签为航班id为"+rebookingFlightInfo.flightId+"，航班Name为"+rebookingFlightInfo.flightNumber+"的航班");
            rebookOrder(rebookingFlightInfo.flightId);
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

                    FluText {
                        text: airlineCompany // 航空公司名称
                        font.pixelSize: 14
                    }

                    FluText {
                        text: flightNumber // 航班号
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
                        color: status === "On Time" ? "#27AE60" : (status === "Delayed" ? "#F39C12" : "#C0392B")

                        FluText {
                            anchors.centerIn: parent
                            text: status
                            color: "white"
                            font.pixelSize: 14
                            font.bold: true
                        }
                    }
                }
            }

            // 进度条
            TimeProgressBar {
                id: progressBar
                indeterminate: false
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

                // 选择弹窗
                FluContentDialog{
                    id:selectionDialog
                    title: qsTr("您希望如何操作？")
                    message: qsTr("请选择退签或改签")
                    negativeText: qsTr("退签")
                    buttonFlags: FluContentDialogType.NeutralButton | FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton

                    onNegativeClicked:{
                        deleteOrder();
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
                        showWarning(qsTr("已取消支付"), 0, qsTr("您真的不考虑考虑吗？"))
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
