import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15
import NetworkHandler 1.0
import "../components"

FluContentPage {
    id: flightInfoPage
    title: qsTr("航班信息")
    // background: FluRectangle { radius: 5 }

    property var flightData: []   // 所有航班数据
    property var filteredData: [] // 筛选后的航班数据

    // 用于获取航班信息
    NetworkHandler {
        id: networkHandler
        onRequestSuccess: function(responseData) {
            // console.log("进入onRequestSuccess函数")
            // var jsonString = JSON.stringify(responseData);
            // console.log("请求成功，返回数据：", jsonString); // 打印 JSON 字符串
            flightData = responseData.data.map(function(flight) {
                /*** 初始化数据 ***/
                flight.isBooked = false;
                flight.isFaved = false;
                flight.remainingSeats = 10;
                return flight;
            });
            filteredData = flightData; // 初始化时显示所有航班数据
        }
        onRequestFailed: function(errorMessage) {
            // console.log("请求失败：", errorMessage);
            flightData = []; // 在请求失败时，确保 flightData 为空数组，避免渲染问题
        }
    }

    // 用于查询收藏信息
    NetworkHandler {
        id: favoriteNetworkHandler
        onRequestSuccess: function(responseData) {
            console.log("进入onRequestSuccess函数，已收藏航班请求成功");

            if (responseData.success && responseData.favorites) {
                var favoriteFlightIds = responseData.favorites.map(function(flight) {
                    return flight.flightId;  // 提取 flightId
                });

                flightData.forEach(function(flight) {
                    if (favoriteFlightIds.includes(flight.flightId)) {
                        flight.isFaved = true;  // 标记为已收藏
                    }
                });

                filteredData = flightData;
            }
        }

        onRequestFailed: function(errorMessage) {
            console.log("已收藏航班请求失败：", errorMessage);
        }
    }

    // 查询收藏信息
    function fetchFavoriteFlights() {
        var url = "/api/favorites"; // 收藏信息 API URL
        console.log("发送收藏航班信息请求，URL:", url);
        console.log("token: ", userInfo.myToken)
        favoriteNetworkHandler.request(url, NetworkHandler.POST, {}, userInfo.myToken);
    }

    // 查询航班
    function fetchFlightData() {
        const url = "/api/flights";  // 后端 API URL
        // console.log("发送请求，URL:", url); // 打印请求的 URL
        networkHandler.request(url, NetworkHandler.GET);  // 发送 GET 请求
    }

    Component.onCompleted: {
        fetchFlightData();
        if (userInfo.myToken) fetchFavoriteFlights(); // 只有用户登录时才调用
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
                        // console.log("选择的省份:", selectedProvince);
                        // console.log("选择的城市:", selectedCity);
                        filterFlights();
                    }
                }

                AddressPicker {
                    id: arrivalAddressPicker
                    onAccepted: {
                        // console.log("选择的省份:", selectedProvince);
                        // console.log("选择的城市:", selectedCity);
                        filterFlights();
                    }
                }

                FluDatePicker {
                    id: datePicker
                    Layout.preferredWidth: 180
                    onAccepted: {
                        // console.log("选择日期:", current);
                        filterFlights();
                    }
                }
            }
        }

        Flickable {
            y: filterPanel.height
            width: parent.width
            height: parent.height - filterPanel.height - 90
            contentWidth: parent.width
            clip: true

            ColumnLayout {
                id: columnLayout
                width: parent.width
                spacing: 10

                Repeater {
                    model: filteredData.length > 0 ? filteredData : []  // 如果 filteredData 为空，避免空数组导致的问题
                    width: parent.width

                    FlightInfoCard {
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
