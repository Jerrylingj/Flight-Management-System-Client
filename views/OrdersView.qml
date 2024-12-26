import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15
import NetworkHandler 1.0
import "../components"

FluContentPage {
    id: ordersView
    title: qsTr("全部订单")
    // background: Rectangle { radius: 5 }

    property var orderData : []
    property var filteredData : []

    // 创建 NetworkHandler 实例
    NetworkHandler {
        id: networkHandler
        onRequestSuccess: function(responseData) {
            console.log("进入onRequestSuccess函数");

            // 检查responseData是否为空
            if (!responseData || !responseData.data) {
                console.log("返回数据为空");
                orderData = []; // 确保 orderData 为空数组
                return;
            }

            // 检查data是否为数组
            if (!Array.isArray(responseData.data)) {
                console.log("返回的data不是数组");
                orderData = []; // 确保 orderData 为空数组
                return;
            }

            var jsonString = JSON.stringify(responseData);
            // console.log("请求成功，返回数据：", jsonString); // 打印 JSON 字符串

            orderData = responseData.data.map(function(order) {
                /*** 初始化数据 ***/
                return order;
            });

            filterOrders();
        }
        onRequestFailed: function(errorMessage) {
            console.log("请求失败：", errorMessage); // 打印失败的错误信息
            orderData = []; // 在请求失败时，确保 orderData 为空数组，避免渲染问题
            filteredDate = orderData;
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

    // 在页面初始化时调用 fetchorderData 获取航班数据
    Component.onCompleted: {
        fetchOrderData();  // 页面加载完毕后调用 fetchorderData 方法获取数据
    }

    function filterOrders(){
        var departureCity = filterBar.departureCity;
        var arrivalCity = filterBar.arrivalCity;
        var startDate = filterBar.startDate;
        var endDate = filterBar.endDate;
        // console.log(departureCity + " " + arrivalCity);
        // console.log(startDate + " " + endDate);

        // 过滤航班数据
        filteredData = orderData.filter(function(order) {
            var matchesDeparture = departureCity ? (departureCity === "全部" || order.departure === departureCity) : true;
            var matchesArrival = arrivalCity ? (arrivalCity === "全部" || order.destination === arrivalCity) : true;
            var matchesStartDate = startDate ? (new Date(order.departureTime).setHours(0, 0, 0, 0) >= new Date(startDate).setHours(0, 0, 0, 0)) : true;
            var matchesEndDate = endDate ? (new Date(order.departureTime).setHours(23, 59, 59, 999) <= new Date(endDate).setHours(23, 59, 59, 999)) : true;

            return matchesDeparture && matchesArrival && matchesStartDate && matchesEndDate;
        });
    }

    ColumnLayout{
        anchors.fill: parent
        Layout.fillWidth: true
        Layout.preferredHeight: 80
        spacing: 16

        FilterBar{
            id: filterBar
            onExecuteFliter: {
                filterOrders();
            }
        }

        Flickable{
            id: flickableContainer
            y: filterBar.height
            height: parent.height - filterBar.height - 90
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout{
                id: columnLayout
                width: parent.width
                spacing: 10

                Repeater {
                    model: filteredData.length > 0 ? filteredData : []  // 如果 OrderData 为空，避免空数组导致的问题
                    width: parent.width

                    OrderInfoCard {
                        width: parent.width
                        height: 150
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
                            // console.log("收到 orderUpdated 信号，刷新订单数据");
                            fetchOrderData();
                        }
                    }
                }
            }

            contentHeight: columnLayout.height
        }

    }


}
