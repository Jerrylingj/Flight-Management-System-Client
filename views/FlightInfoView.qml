import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15
import NetworkHandler 1.0
import "../components"

FluContentPage {
    id: flightInfoView
    title: qsTr("航班信息")
    property var flightData: []   // 所有航班数据
    property var filteredData: [] // 筛选后的航班数据

    property int offset: 0         // 当前偏移量
    property int batchSize: 20     // 每次加载的数据量
    property bool isLoading: false // 是否正在加载数据
    property bool hasMore: true    // 是否还有更多数据

    // 防抖时间（冷却时间）
    property bool isCooldown: false
    property int cooldownTime: 500  // 冷却时间（毫秒）

    // 用于获取航班信息
    NetworkHandler {
        id: networkHandler
        onRequestSuccess: function(responseData) {
            if (!responseData.data || responseData.data.length === 0) {
                hasMore = false; // 没有更多数据了
                return;
            }

            flightData = flightData.concat(responseData.data.map(function(flight) {
                /*** 初始化数据 ***/
                flight.isBooked = false;
                flight.isFaved = false;
                return flight;
            }));

            if (userInfo.myToken){
                fetchFavoriteFlights();
            } else{
                // 如果用户没有登录，初始化时直接显示所有航班数据
                filterFlights();
            }

            offset += batchSize;        // 更新偏移量
            isLoading = false;
            isCooldown = false;         // 冷却结束
        }
        onRequestFailed: function(errorMessage) {
            console.log("请求失败：", errorMessage);
            flightData = [];                // 在请求失败时，确保 flightData 为空数组，避免渲染问题
            filteredData = flightData;
            isLoading = false;
            isCooldown = false;
        }
    }


    // 用于查询收藏信息
    NetworkHandler {
        id: favoriteNetworkHandler
        onRequestSuccess: function(responseData) {
            if (responseData.success && responseData.favorites) {
                var favoriteFlightIds = responseData.favorites.map(function(flight) {
                    return flight.flightId;  // 提取 flightId
                });

                flightData.forEach(function(flight) {
                    if (favoriteFlightIds.includes(flight.flightId)) {
                        flight.isFaved = true;  // 标记为已收藏
                        console.log("航班id为" + flight.flightId + "，name为" + flight.flightNumber + "的航班已被收藏")
                    }
                });

                if(userInfo.myToken){
                    fetchOrderedFlights();
                }else{
                    showError(qsTr("出现错误"), 4000, qsTr("↙请点击左下角联系客服解决"))
                    console.log("用户id在favoriteNetworkHandler中不为空，但在orderNetworkHandler中为空")
                }
            }
        }

        onRequestFailed: function(errorMessage) {
            console.log("已收藏航班请求失败：", errorMessage);
        }
    }

    // 用于查询预定信息
    NetworkHandler{
        id: orderNetworkHandler
        onRequestSuccess: function(responseData) {
            if (responseData.success && responseData.data) {
                var orderedFlightIds = responseData.data.map(function(order) {
                    return order.flightId;  // 提取 flightId
                });

                flightData.forEach(function(flight) {
                    if (orderedFlightIds.includes(flight.flightId)) {
                        flight.isBooked = true;  // 标记为已预定
                        console.log("航班id为" + flight.flightId + "，name为" + flight.flightNumber + "的航班已被预定")
                    }
                });

                filterFlights();
            }
        }

        onRequestFailed: function(errorMessage) {
            console.log("已预定航班请求失败：", errorMessage);
        }
    }

    // 查询收藏信息
    function fetchFavoriteFlights() {
        var url = "/api/favorites"; // 收藏信息 API URL
        // console.log("发送收藏航班信息请求，URL:", url);
        favoriteNetworkHandler.request(url, NetworkHandler.POST, {}, userInfo.myToken);
    }

    // 查询预定信息
    function fetchOrderedFlights(){
        var url = "/api/orders"; // 订单信息 API URL
        // console.log("发送订单信息请求，URL:" ,url);
        orderNetworkHandler.request(url, NetworkHandler.POST, {}, userInfo.myToken);
    }

    // 查询航班
    function fetchFlightData() {
        if (isLoading || !hasMore || isCooldown) return;    // 正在加载或没有更多数据或处于冷却时间时，不发起请求
        if (flightData.length > 300) return;                // 前端最多保留300条信息
        isLoading = true;
        isCooldown = true;

        // 开启冷却计时器
        cooldownTimer.restart();

        console.log("查询航班：", offset, " ", batchSize);
        const url = "/api/flights";
        const body = {
            offset: offset,
            limit: batchSize,
        };

        networkHandler.request(url, NetworkHandler.POST, body);
    }

    Timer {
        id: cooldownTimer
        interval: flightInfoView.cooldownTime
        running: false
        repeat: false
        onTriggered: {
            flightInfoView.isCooldown = false; // 冷却时间结束
        }
    }

    // 页面加载完毕后获取航班信息
    Component.onCompleted: {
        fetchFlightData();
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
        Layout.fillWidth: true
        Layout.fillHeight: true
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
            id: flickableContainer
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
                   model: filteredData.length > 0 ? filteredData : []  // 如果 filteredData 为空，避免空数组导致的问题
                   width: parent.width

                   FlightInfoCard {
                       width: parent.width
                       height: 80
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

            // 滑到底部时触发加载更多
            onContentYChanged: {
                if ((contentY + height) >= contentHeight - 50 && !isLoading && hasMore) {
                    fetchFlightData();
                }
            }
        }
    }
}
