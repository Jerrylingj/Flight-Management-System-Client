import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15
import NetworkHandler 1.0
import "../components"

FluContentPage {
    id: flightInfoPage
    title: qsTr("航班信息")
    background: Rectangle { radius: 5 }

    property var flightData: []

    // 创建 NetworkHandler 实例
    NetworkHandler {
        id: networkHandler

        onRequestSuccess: function(responseData) {
            var jsonString = JSON.stringify(responseData);
            // console.log("请求成功，返回数据：", jsonString); // 打印 JSON 字符串


            flightData = responseData.data.map(function(flight) {
                /*** 初始化数据 ***/
                flight.isBooked = false;
                flight.isFaved = false;
                flight.remainingSeats = 10;
                return flight;
            });

        }

        onRequestFailed: function(errorMessage) {
            console.log("请求失败：", errorMessage); // 打印失败的错误信息
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


    ColumnLayout {
        // anchors.fill: parent
        // spacing: 16

        // 筛选区域
        FluRectangle {
            z: 10
            id: filterPanel
            radius: 10
            Layout.fillWidth: true
            height: 40
            color: FluTheme.backgroundSecondaryColor

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 20

                // FluTextBox {
                //     id: departureInput
                //     placeholderText: qsTr("请输入起点")
                //     Layout.preferredWidth: 150
                // }

                // FluTextBox {
                //     id: destinationInput
                //     placeholderText: qsTr("请输入终点")
                //     Layout.preferredWidth: 150
                // }
                // AddressPicker {
                //     id: departureAddressPicker
                //     onAccepted: {
                //         console.log("选择的省份:", selectedProvince);
                //         console.log("选择的城市:", selectedCity);

                //         // 更新页面显示选择结果
                //         selectedAddress.text = qsTr("当前选择: ") + selectedProvince + ", " + selectedCity;
                //     }
                // }

                // AddressPicker {
                //     id: arrivalAddressPicker
                //     onAccepted: {
                //         console.log("选择的省份:", selectedProvince);
                //         console.log("选择的城市:", selectedCity);

                //         // 更新页面显示选择结果
                //         selectedAddress.text = qsTr("当前选择: ") + selectedProvince + ", " + selectedCity;
                //     }
                // }

                FluDatePicker {
                    id: datePicker
                    Layout.preferredWidth: 180
                }

                FluFilledButton {
                    text: qsTr("查询")
                    Layout.preferredWidth: 100
                    onClicked: {
                        console.log("筛选条件: 起点=${departureInput.text}, 终点=${destinationInput.text}, 日期=${datePicker.date}");
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
                    model: flightData
                    width: parent.width

                    FlightInfoCard {
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

            // 绑定 contentHeight
            contentHeight: columnLayout.height
        }
    }
}
