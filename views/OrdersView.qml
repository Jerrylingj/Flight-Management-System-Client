import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15
import NetworkHandler 1.0
import "../components"

// 【√】第一步：获取当前用户的订单
// 【 】第二步：将基本的订单卡片列表展示出来
// 【 】第三步：点击“查看按钮”弹出弹窗
// 【 】第四步：点击“退改签”显示界面，点击“检票二维码”显示弹窗
// 【 】第五步：出发到达城市 + 时间段复合筛选
// 【 】第六步：“退改签”界面和相应功能
// 【 】第七步：整体美化

FluScrollablePage {
    id: ordersViewPage
    title: qsTr("全部订单")
    // background: Rectangle { radius: 5 }

    property var orderData : []
    property var filteredOrderData : []

    // 创建 NetworkHandler 实例
    NetworkHandler {
        id: networkHandler
        onRequestSuccess: function(responseData) {
            console.log("进入onRequestSuccess函数");

            // 检查responseData是否为空
            if (!responseData || !responseData.data || responseData.data.length === 0) {
                console.log("返回数据为空");
                orderData = []; // 确保 orderData 为空数组
                return;
            }

            var jsonString = JSON.stringify(responseData);
            console.log("请求成功，返回数据：", jsonString); // 打印 JSON 字符串

            var tempOrderData = responseData.data.map(function(order) {
                /*** 初始化数据 ***/
                // 订单界面需要怎么初始化吗？
                return order;
            });

            // 检查处理后的 orderData 是否为空
            if (tempOrderData.length === 0) {
                console.log("处理后的 orderData 为空");
                return;
            }

            orderData = tempOrderData; // 初始化时显示所有航班数据
        }
        onRequestFailed: function(errorMessage) {
            console.log("请求失败：", errorMessage); // 打印失败的错误信息
            orderData = []; // 在请求失败时，确保 orderData 为空数组，避免渲染问题
        }
    }

    // 调用网络请求
    function fetchOrderData() {
        var url = "/api/orders"; // 获取当前用户所有订单的api
        console.log("发送当前用户订单信息请求，URL = ", url);
        console.log("token: ", userInfo.myToken)
        console.log(networkHandler.POST)
        networkHandler.request(url, NetworkHandler.POST, {}, userInfo.myToken);
    }

    // 在页面初始化时调用 fetchFlightData 获取航班数据
    Component.onCompleted: {
        fetchOrderData();  // 页面加载完毕后调用 fetchFlightData 方法获取数据
    }


    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 80
        padding: 10

        RowLayout{

            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }

            // FluText{
            //     text: qsTr("hourFormat=FluTimePickerType.H")
            // }

            FluTextBox {
                id: departureInput
                placeholderText: qsTr("请输入起点")
                Layout.preferredWidth: 150
            }

            FluTextBox {
                id: destinationInput
                placeholderText: qsTr("请输入终点")
                Layout.preferredWidth: 150
            }

            FluDatePicker {
                id: datePicker
                Layout.preferredWidth: 180
            }

            FluProgressButton {
                id: queryButton
                text: "查询"
                onClicked:{
                    console.log("点击查询按钮")
                }
            }
        }
    }

    Repeater {
        model: orderData.length > 0 ? orderData : []  // 如果 OrderData 为空，避免空数组导致的问题
        width: parent.width

        OrderInfoCard {
            width: parent.width
            height: 80
            orderId: modelData.orderId
            userId: modelData.userId
            flightId: modelData.flightId
            totalChangeCount: modelData.totalChangeCount
            paymentStatus: modelData.paymentStatus
            flightNumber: modelData.flightNumber
            airlineCompany: modelData.airlineCompany
            price: modelData.price
            flightStatus: modelData.flightStatus
            departure: modelData.departure
            destination: modelData.destination
            departureTime: modelData.departureTime
            arrivalTime: modelData.arrivalTime
            departureAirport: modelData.departureAirport
            arrivalAirport: modelData.arrivalAirport
            checkInStartTime: modelData.checkInStartTime
            checkInEndTime: modelData.checkInEndTime

            onOrderUpdated: {
                console.log("收到 orderUpdated 信号，刷新订单数据");
                fetchOrderData();
            }
        }
    }
}
