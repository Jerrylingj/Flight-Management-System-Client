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
            console.log("进入onRequestSuccess函数")
            var jsonString = JSON.stringify(responseData);
            console.log("请求成功，返回数据：", jsonString); // 打印 JSON 字符串

            // 检查 responseData 是否为数组
            if (Array.isArray(responseData)) {
                console.log("responseData 是一个数组，长度为:", responseData.length);
                // 为每个航班添加 isBooked 和 isFaved 字段，初始化为 false，确保每个字段存在
                flightData = responseData.map(function(flight) {
                    flight.isBooked = (flight.isBooked !== undefined) ? flight.isBooked : false;
                    flight.isFaved = (flight.isFaved !== undefined) ? flight.isFaved : false;
                    flight.remainingSeats = (flight.remainingSeats !== undefined) ? flight.remainingSeats : 10;
                    return flight;
                });
            } else {
                console.log("responseData 不是一个数组，类型为:", typeof responseData);
                // 如果 responseData 不是数组，检查是否包含数组字段
                if (responseData.data && Array.isArray(responseData.data)) {
                    console.log("responseData.data 是一个数组，长度为:", responseData.data.length);
                    flightData = responseData.data.map(function(flight) {
                        flight.isBooked = (flight.isBooked !== undefined) ? flight.isBooked : false;
                        flight.isFaved = (flight.isFaved !== undefined) ? flight.isFaved : false;
                        flight.remainingSeats = (flight.remainingSeats !== undefined) ? flight.remainingSeats : 10;
                        return flight;
                    });
                } else {
                    console.log("无法识别的响应数据结构");
                    flightData = []; // 如果数据结构无法识别，确保 flightData 为一个空数组
                }
            }
        }

        onRequestFailed: function(errorMessage) {
            console.log("请求失败：", errorMessage); // 打印失败的错误信息
            flightData = []; // 在请求失败时，确保 flightData 为空数组，避免渲染问题
        }
    }



    // 调用网络请求
    function fetchFlightData() {
        var url = "http://127.0.0.1:8080/api/flights";  // 后端 API URL
        console.log("发送请求，URL:", url); // 打印请求的 URL
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
            // color: FluTheme.backgroundSecondaryColor

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 20

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

            // 绑定 contentHeight
            contentHeight: columnLayout.height
        }



    }
}
