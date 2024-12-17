import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15
import NetworkHandler 1.0
import "../components"

FluContentPage {
    id: flightFavoriteView
    title: "我的收藏"
    // background: Rectangle { radius: 5 }

    property var flightData: []   // 所有航班数据
    property var filteredData: [] // 筛选后的航班数据

    // 创建 NetworkHandler 实例
    NetworkHandler {
        id: networkHandler
        onRequestSuccess: function(responseData) {
            try {
                // 打印整个返回数据
                var jsonString = JSON.stringify(responseData);
                console.log("请求成功，返回数据：", jsonString);

                // 验证返回结果是否成功
                if (responseData.success && responseData.favorites) {
                    flightData = responseData.favorites.map(function(flight) {
                        /*** 初始化数据 ***/
                        flight.isBooked = false;  // 初始化是否预订状态
                        flight.isFaved = true;    // 标记为已收藏
                        flight.remainingSeats = 10; // 假设每个航班有 10 个余票
                        return flight;
                    });

                    // 设置过滤后的数据为初始航班数据
                    filteredData = flightData;
                } else {
                    console.warn("返回数据格式错误或 success 为 false");
                    flightData = [];
                    filteredData = [];
                }
            } catch (error) {
                console.error("解析返回数据时发生错误：", error);
                flightData = [];
                filteredData = [];
            }
        }
        onRequestFailed: function(errorMessage) {
            console.log("请求失败：", errorMessage); // 打印失败的错误信息
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

    // 页面加载完毕后调用 fetchFavoriteFlights 方法获取收藏数据
    Component.onCompleted: {
        fetchFavoriteFlights();
    }

    // 筛选函数
    function filterFlights() {
        var departureCity = departureAddressPicker.selectedCity;
        var arrivalCity = arrivalAddressPicker.selectedCity;
        var selectedDate = datePicker.current;

        // 过滤航班数据
        filteredData = flightData.filter(function(flight) {
            var matchesDeparture = departureCity ? (departureCity === "全部" || flight.departureCity === departureCity) : true;
            var matchesArrival = arrivalCity ? (arrivalCity === "全部" || flight.arrivalCity === arrivalCity) : true;

            var flightDate = new Date(flight.departureTime);
            var matchesDate = selectedDate ? (
                flightDate.getFullYear() === selectedDate.getFullYear() &&
                flightDate.getMonth() === selectedDate.getMonth() &&
                flightDate.getDate() === selectedDate.getDate()
            ) : true;

            return matchesDeparture && matchesArrival && matchesDate;
        });
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        FluFrame{
            z: 10
            id: filterPanel
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            padding: 10
            clip: true

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 20

                AddressPicker {
                    id: departureAddressPicker
                    onAccepted: {
                        console.log("选择的省份:", selectedProvince);
                        console.log("选择的城市:", selectedCity);

                        // 触发筛选
                        filterFlights();
                    }
                }

                AddressPicker {
                    id: arrivalAddressPicker
                    onAccepted: {
                        console.log("选择的省份:", selectedProvince);
                        console.log("选择的城市:", selectedCity);

                        // 触发筛选
                        filterFlights();
                    }
                }

                FluDatePicker {
                    id: datePicker
                    Layout.preferredWidth: 180
                    onAccepted: {
                        console.log("选择日期:", current);
                        filterFlights();
                    }
                }
            }
        }

        Flickable {
            y: filterPanel.height
            width: parent.width
            height: parent.height
            contentWidth: parent.width
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
                        departureAirport: modelData.departureAirport
                        arrivalAirport: modelData.arrivalAirport
                        price: modelData.price
                        airlineCompany: modelData.airlineCompany
                        status: modelData.status
                        isBooked: modelData.isBooked
                        isFaved: modelData.isFaved
                        remainingSeats: modelData.remainingSeats
                    }
                }
            }

            contentHeight: columnLayout.height
        }
    }
}
