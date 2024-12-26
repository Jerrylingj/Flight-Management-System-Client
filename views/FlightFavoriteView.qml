import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15
import NetworkHandler 1.0
import "../components"

FluContentPage {
    id: flightFavoriteView
    title: "我的收藏"

    property var flightData: []   // 所有航班数据
    property var filteredData: [] // 筛选后的航班数据

    // 创建 NetworkHandler 实例
    NetworkHandler {
        id: networkHandler
        onRequestSuccess: function(responseData) {
            try {
                if (responseData.success && responseData.favorites) {
                    console.log(JSON.stringify(responseData));
                    flightData = responseData.favorites.map(function(flight) {
                        /*** 初始化数据 ***/
                        flight.isBooked = false;  // 初始化是否预订状态
                        flight.isFaved = true;    // 标记为已收藏
                        return flight;
                    });

                    filteredData = flightData; // 初始化filteredData
                } else {
                    // console.warn("返回数据格式错误或 success 为 false");
                    flightData = [];
                    filteredData = [];
                }
            } catch (error) {
                // console.error("解析返回数据时发生错误：", error);
                flightData = [];
                filteredData = [];
            }
        }
        onRequestFailed: function(errorMessage) {
            // console.log("请求失败：", errorMessage); // 打印失败的错误信息
            flightData = [];
            filteredData = [];
        }
    }

    // 查询收藏信息
    function fetchFavoriteFlights() {
        var url = "/api/favorites"; // 收藏信息 API URL
        console.log("发送收藏航班信息请求，URL:", url);
        console.log("token: ", userInfo.myToken)
        networkHandler.request(url, NetworkHandler.POST, {}, userInfo.myToken);
    }

    // 获取收藏信息
    Component.onCompleted: {
        fetchFavoriteFlights();
    }

    // 筛选函数
    function filterFlights() {
        var departureCity = filterBar.departureCity;
        var arrivalCity = filterBar.arrivalCity;
        var startDate = filterBar.startDate;
        var endDate = filterBar.endDate;
        console.log(departureCity + " " + arrivalCity);
        console.log(startDate + " " + endDate);

        // 过滤航班数据
        filteredData = flightData.filter(function(flight) {
            var matchesDeparture = departureCity ? (departureCity === "全部" || flight.departureCity === departureCity) : true;
            var matchesArrival = arrivalCity ? (arrivalCity === "全部" || flight.arrivalCity === arrivalCity) : true;
            var matchesStartDate = startDate ? (new Date(flight.departureTime).setHours(0, 0, 0, 0) >= new Date(startDate).setHours(0, 0, 0, 0)) : true;
            var matchesEndDate = endDate ? (new Date(flight.departureTime).setHours(23, 59, 59, 999) <= new Date(endDate).setHours(23, 59, 59, 999)) : true;

            return matchesDeparture && matchesArrival && matchesStartDate && matchesEndDate;
        });
    }

    ColumnLayout {
        anchors.fill: parent
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 16

        FilterBar{
            id: filterBar
            onExecuteFliter: {
                filterFlights()
            }

        }

        Flickable {
            y: filterPanel.height
            height: parent.height - filterPanel.height - 90
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                id: columnLayout
                width: parent.width
                spacing: 10

                Repeater {
                    model: filteredData  // 使用筛选后的数据
                    width: parent.width

                    FlightFavoriteCard {
                        width: parent.width
                        height: 80 // 确保 FlightInfoCard 有固定高度
                        flightId: modelData.flightId
                        flightNumber: modelData.flightNumber
                        departureTime: modelData.departureTime
                        arrivalTime: modelData.arrivalTime
                        departureCity: modelData.departureCity
                        arrivalCity: modelData.arrivalCity
                        departureAirport: modelData.departureAirport
                        arrivalAirport: modelData.arrivalAirport
                        price: modelData.price
                        airlineCompany: modelData.airlineCompany
                        status: modelData.status
                        isBooked: modelData.isBooked
                        isFaved: modelData.isFaved
                    }
                }
            }

            contentHeight: columnLayout.height
        }
    }
}
