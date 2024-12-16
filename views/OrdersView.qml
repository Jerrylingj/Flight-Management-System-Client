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

    /*
    property var orderData:[
        {
          "flightNumber": "CA123",
          "departure": "北京",
          "destination": "上海",
          "departureTime": "07:00",
          "arrivalTime": "09:50",
          "departureAirport": "北京大兴国际机场",
          "arrivalAirport": "上海虹桥国际机场",
          "checkInStartTime": "04:30",
          "checkInEndTime": "05:30",
          "airlineCompany": "东方航空",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA124",
          "departure": "北京",
          "destination": "广州",
          "departureTime": "08:00",
          "arrivalTime": "11:00",
          "departureAirport": "北京首都国际机场",
          "arrivalAirport": "广州白云国际机场",
          "checkInStartTime": "05:30",
          "checkInEndTime": "06:30",
          "airlineCompany": "南方航空",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA125",
          "departure": "北京",
          "destination": "深圳",
          "departureTime": "09:00",
          "arrivalTime": "12:00",
          "departureAirport": "北京大兴国际机场",
          "arrivalAirport": "深圳宝安国际机场",
          "checkInStartTime": "06:30",
          "checkInEndTime": "07:30",
          "airlineCompany": "中国国航",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA126",
          "departure": "上海",
          "destination": "北京",
          "departureTime": "10:00",
          "arrivalTime": "12:50",
          "departureAirport": "上海虹桥国际机场",
          "arrivalAirport": "北京大兴国际机场",
          "checkInStartTime": "07:30",
          "checkInEndTime": "08:30",
          "airlineCompany": "东方航空",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA127",
          "departure": "上海",
          "destination": "广州",
          "departureTime": "11:00",
          "arrivalTime": "13:50",
          "departureAirport": "上海浦东国际机场",
          "arrivalAirport": "广州白云国际机场",
          "checkInStartTime": "08:30",
          "checkInEndTime": "09:30",
          "airlineCompany": "南方航空",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA128",
          "departure": "上海",
          "destination": "深圳",
          "departureTime": "12:00",
          "arrivalTime": "14:50",
          "departureAirport": "上海虹桥国际机场",
          "arrivalAirport": "深圳宝安国际机场",
          "checkInStartTime": "09:30",
          "checkInEndTime": "10:30",
          "airlineCompany": "中国国航",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA129",
          "departure": "广州",
          "destination": "北京",
          "departureTime": "13:00",
          "arrivalTime": "16:00",
          "departureAirport": "广州白云国际机场",
          "arrivalAirport": "北京首都国际机场",
          "checkInStartTime": "10:30",
          "checkInEndTime": "11:30",
          "airlineCompany": "东方航空",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA130",
          "departure": "广州",
          "destination": "上海",
          "departureTime": "14:00",
          "arrivalTime": "16:50",
          "departureAirport": "广州白云国际机场",
          "arrivalAirport": "上海浦东国际机场",
          "checkInStartTime": "11:30",
          "checkInEndTime": "12:30",
          "airlineCompany": "南方航空",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA131",
          "departure": "广州",
          "destination": "深圳",
          "departureTime": "15:00",
          "arrivalTime": "16:30",
          "departureAirport": "广州白云国际机场",
          "arrivalAirport": "深圳宝安国际机场",
          "checkInStartTime": "12:30",
          "checkInEndTime": "13:30",
          "airlineCompany": "中国国航",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA132",
          "departure": "深圳",
          "destination": "北京",
          "departureTime": "16:00",
          "arrivalTime": "19:00",
          "departureAirport": "深圳宝安国际机场",
          "arrivalAirport": "北京大兴国际机场",
          "checkInStartTime": "13:30",
          "checkInEndTime": "14:30",
          "airlineCompany": "东方航空",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA133",
          "departure": "深圳",
          "destination": "上海",
          "departureTime": "17:00",
          "arrivalTime": "19:50",
          "departureAirport": "深圳宝安国际机场",
          "arrivalAirport": "上海虹桥国际机场",
          "checkInStartTime": "14:30",
          "checkInEndTime": "15:30",
          "airlineCompany": "南方航空",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA134",
          "departure": "深圳",
          "destination": "广州",
          "departureTime": "18:00",
          "arrivalTime": "19:30",
          "departureAirport": "深圳宝安国际机场",
          "arrivalAirport": "广州白云国际机场",
          "checkInStartTime": "15:30",
          "checkInEndTime": "16:30",
          "airlineCompany": "中国国航",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA135",
          "departure": "北京",
          "destination": "深圳",
          "departureTime": "19:00",
          "arrivalTime": "22:00",
          "departureAirport": "北京大兴国际机场",
          "arrivalAirport": "深圳宝安国际机场",
          "checkInStartTime": "16:30",
          "checkInEndTime": "17:30",
          "airlineCompany": "东方航空",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA136",
          "departure": "北京",
          "destination": "广州",
          "departureTime": "20:00",
          "arrivalTime": "23:00",
          "departureAirport": "北京首都国际机场",
          "arrivalAirport": "广州白云国际机场",
          "checkInStartTime": "17:30",
          "checkInEndTime": "18:30",
          "airlineCompany": "南方航空",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA137",
          "departure": "北京",
          "destination": "上海",
          "departureTime": "21:00",
          "arrivalTime": "23:50",
          "departureAirport": "北京大兴国际机场",
          "arrivalAirport": "上海虹桥国际机场",
          "checkInStartTime": "18:30",
          "checkInEndTime": "19:30",
          "airlineCompany": "中国国航",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA138",
          "departure": "上海",
          "destination": "深圳",
          "departureTime": "22:00",
          "arrivalTime": "00:50",
          "departureAirport": "上海虹桥国际机场",
          "arrivalAirport": "深圳宝安国际机场",
          "checkInStartTime": "19:30",
          "checkInEndTime": "20:30",
          "airlineCompany": "东方航空",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA139",
          "departure": "上海",
          "destination": "广州",
          "departureTime": "23:00",
          "arrivalTime": "01:50",
          "departureAirport": "上海浦东国际机场",
          "arrivalAirport": "广州白云国际机场",
          "checkInStartTime": "20:30",
          "checkInEndTime": "21:30",
          "airlineCompany": "南方航空",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA140",
          "departure": "上海",
          "destination": "北京",
          "departureTime": "00:00",
          "arrivalTime": "02:50",
          "departureAirport": "上海虹桥国际机场",
          "arrivalAirport": "北京大兴国际机场",
          "checkInStartTime": "21:30",
          "checkInEndTime": "22:30",
          "airlineCompany": "中国国航",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA141",
          "departure": "广州",
          "destination": "深圳",
          "departureTime": "01:00",
          "arrivalTime": "02:30",
          "departureAirport": "广州白云国际机场",
          "arrivalAirport": "深圳宝安国际机场",
          "checkInStartTime": "22:30",
          "checkInEndTime": "23:30",
          "airlineCompany": "东方航空",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA142",
          "departure": "广州",
          "destination": "上海",
          "departureTime": "02:00",
          "arrivalTime": "04:50",
          "departureAirport": "广州白云国际机场",
          "arrivalAirport": "上海浦东国际机场",
          "checkInStartTime": "23:30",
          "checkInEndTime": "00:30",
          "airlineCompany": "南方航空",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA143",
          "departure": "广州",
          "destination": "北京",
          "departureTime": "03:00",
          "arrivalTime": "06:00",
          "departureAirport": "广州白云国际机场",
          "arrivalAirport": "北京首都国际机场",
          "checkInStartTime": "00:30",
          "checkInEndTime": "01:30",
          "airlineCompany": "中国国航",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA144",
          "departure": "深圳",
          "destination": "广州",
          "departureTime": "04:00",
          "arrivalTime": "05:30",
          "departureAirport": "深圳宝安国际机场",
          "arrivalAirport": "广州白云国际机场",
          "checkInStartTime": "01:30",
          "checkInEndTime": "02:30",
          "airlineCompany": "东方航空",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA145",
          "departure": "深圳",
          "destination": "上海",
          "departureTime": "05:00",
          "arrivalTime": "07:50",
          "departureAirport": "深圳宝安国际机场",
          "arrivalAirport": "上海虹桥国际机场",
          "checkInStartTime": "02:30",
          "checkInEndTime": "03:30",
          "airlineCompany": "南方航空",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA146",
          "departure": "深圳",
          "destination": "北京",
          "departureTime": "06:00",
          "arrivalTime": "09:00",
          "departureAirport": "深圳宝安国际机场",
          "arrivalAirport": "北京大兴国际机场",
          "checkInStartTime": "03:30",
          "checkInEndTime": "04:30",
          "airlineCompany": "中国国航",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA147",
          "departure": "北京",
          "destination": "深圳",
          "departureTime": "07:00",
          "arrivalTime": "10:00",
          "departureAirport": "北京大兴国际机场",
          "arrivalAirport": "深圳宝安国际机场",
          "checkInStartTime": "04:30",
          "checkInEndTime": "05:30",
          "airlineCompany": "东方航空",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA148",
          "departure": "北京",
          "destination": "广州",
          "departureTime": "08:00",
          "arrivalTime": "11:00",
          "departureAirport": "北京首都国际机场",
          "arrivalAirport": "广州白云国际机场",
          "checkInStartTime": "05:30",
          "checkInEndTime": "06:30",
          "airlineCompany": "南方航空",
          "status": "OnTime"
        },
        {
          "flightNumber": "CA149",
          "departure": "北京",
          "destination": "上海",
          "departureTime": "09:00",
          "arrivalTime": "11:50",
          "departureAirport": "北京大兴国际机场",
          "arrivalAirport": "上海虹桥国际机场",
          "checkInStartTime": "06:30",
          "checkInEndTime": "07:30",
          "airlineCompany": "中国国航",
          "status": "OnTime"
        }
      ]
      */

    // 创建 NetworkHandler 实例
    NetworkHandler {
        id: networkHandler
        onRequestSuccess: function(responseData) {
            console.log("进入onRequestSuccess函数")
            var jsonString = JSON.stringify(responseData);
            console.log("请求成功，返回数据：", jsonString); // 打印 JSON 字符串
            orderData = responseData.data.map(function(order) {
                /*** 初始化数据 ***/
                // 订单界面需要怎么初始化吗？
                return order;
            });
            orderData = orderData; // 初始化时显示所有航班数据
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

    // FluRectangle {
    //     z: 10
    //     id: filterPanel
    //     radius: 10
    //     Layout.fillWidth: true
    //     height: 40
    //     // color: FluTheme.backgroundSecondaryColor

    //     RowLayout {
    //         anchors.fill: parent
    //         anchors.margins: 10
    //         spacing: 20

    //         FluTextBox {
    //             id: departureInput
    //             placeholderText: qsTr("请输入起点")
    //             Layout.preferredWidth: 150
    //         }

    //         FluTextBox {
    //             id: destinationInput
    //             placeholderText: qsTr("请输入终点")
    //             Layout.preferredWidth: 150
    //         }

    //         FluDatePicker {
    //             id: datePicker
    //             Layout.preferredWidth: 180
    //         }

    //         FluProgressButton {
    //             id: queryButton
    //             text: "查询"
    //             // progress : 0
    //             // Layout.preferredWidth: 50

    //             onClicked: {
    //                 queryButton.progress = 0
    //                 var timer = Qt.createQmlObject('import QtQuick 2.0; Timer {}', queryButton)
    //                 timer.interval = 100
    //                 timer.repeat = true
    //                 timer.triggered.connect(function() {
    //                     queryButton.progress += 0.1
    //                     if (queryButton.progress >= 1) {
    //                         timer.stop()
    //                     }
    //                 })
    //                 timer.start()
    //                 // checked = !checked
    //                 console.log("筛选条件: 起点=${departureInput.text}, 终点=${destinationInput.text}, 日期=${datePicker.date}");
    //             }
    //         }
    //     }
    // }

    // Repeater {
    //     model: orderData.length > 0 ? orderData : []  // 如果 OrderData 为空，避免空数组导致的问题
    //     width: parent.width

    //     OrderInfoCard {
    //         width: parent.width
    //         height: 80
    //         orderId: modelData.orderId
    //         userId: modelData.userId
    //         flightId: modelData.flightId
    //         totalChangeCount: modelData.totalChangeCount
    //         paymentStatus: modelData.paymentStatus
    //         flightNumber: modelData.flightNumber
    //         airlineCompany: modelData.airlineCompany
    //         price: modelData.price
    //         flightStatus: modelData.flightStatus
    //         departure: modelData.departure
    //         destination: modelData.destination
    //         departureTime: modelData.departureTime
    //         arrivalTime: modelData.arrivalTime
    //         departureAirport: modelData.departureAirport
    //         arrivalAirport: modelData.arrivalAirport
    //         checkInStartTime: modelData.checkInStartTime
    //         checkInEndTime: modelData.checkInEndTime
    //     }
    // }
}
