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

    // 创建 NetworkHandler 实例
    NetworkHandler {
        id: networkHandler
        onRequestSuccess: function(responseData) {
            console.log("进入onRequestSuccess函数")
            var jsonString = JSON.stringify(responseData);
            console.log("请求成功，返回数据：", jsonString); // 打印 JSON 字符串
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
            console.log("请求失败：", errorMessage); // 打印失败的错误信息
            flightData = []; // 在请求失败时，确保 flightData 为空数组，避免渲染问题
        }
    }

    // 调用网络请求
    function fetchFlightData() {
        const url = "/api/flights";  // 后端 API URL
        // console.log("发送请求，URL:", url); // 打印请求的 URL
        networkHandler.request(url, NetworkHandler.GET);  // 发送 GET 请求
    }

    // 在页面初始化时调用 fetchFlightData 获取航班数据
    Component.onCompleted: {
        fetchFlightData();  // 页面加载完毕后调用 fetchFlightData 方法获取数据
    }

    // 筛选函数
    function filterFlights() {
        var departureCity = departureAddressPicker.selectedCity;
        var arrivalCity = arrivalAddressPicker.selectedCity;

        // 过滤航班数据
        filteredData = flightData.filter(function(flight) {
            var matchesDeparture = departureCity ? (departureCity === "全部" || flight.departureCity === departureCity) : true;
            var matchesArrival = arrivalCity ? (arrivalCity === "全部" || flight.arrivalCity === arrivalCity) : true;
            return matchesDeparture && matchesArrival;
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
                }


                // 决定做成实时筛选，就不单独放筛选按钮了
                // FluFilledButton {
                //     text: qsTr("查询")
                //     Layout.preferredWidth: 100
                //     onClicked: {
                //         console.log("筛选条件: 起点=${departureInput.text}, 终点=${destinationInput.text}, 日期=${datePicker.date}");
                //         filterFlights(); // 点击查询时也触发筛选
                //     }
                // }
            }
        }

        Flickable {
            y: filterPanel.height
            Layout.fillWidth: true
            Layout.fillHeight: true
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
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
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
