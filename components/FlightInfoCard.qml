import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import NetworkHandler 1.0

FluFrame {
    id: flightInfoCard
    radius: 10
    Layout.fillWidth: true
    Layout.preferredHeight: 100
    padding: 10

    property int flightId
    property string flightNumber
    property string departureTime
    property string arrivalTime
    property string departureAirport
    property string arrivalAirport
    property double price
    property string airlineCompany
    property string status
    property bool isBooked
    property bool isFaved


    // 收藏接口的 NetworkHandler 实例
    NetworkHandler {
        id: favoriteHandler

        onRequestSuccess: function (responseData) {
            if (responseData.success) {
                console.log("收藏操作成功");

                isFaved = !isFaved;

                if (isFaved) {
                    console.log("航班 " + flightId + " 已收藏");
                    showSuccess(qsTr("收藏成功"), 4000, qsTr("您可以前往“我的收藏”界面查看"))
                }
            } else {
                console.error("收藏/取消收藏操作失败，错误信息：", responseData.message);
                showError(qsTr("操作失败了"), 4000, qsTr("↙请点击左下角客服界面反馈"))
            }
        }

        onRequestFailed: function (errorMessage) {
            console.error("收藏/取消收藏请求失败：", errorMessage);
        }
    }

    NetworkHandler{
        id: orderHandler

        onRequestSuccess: function (responseData) {
            if (responseData.success) {
                console.log("预定操作成功");
                isBooked = true;
                showSuccess(qsTr("预定操作成功"), 4000, qsTr("您可以前往“我的订单”界面进行支付"))
            } else {
                console.error("收藏/取消收藏操作失败，错误信息：", responseData.message);
                showError(qsTr("操作失败了"), 4000, qsTr("↙请点击左下角客服界面反馈"))
            }
        }

        onRequestFailed: function (errorMessage) {
            console.error("收藏/取消收藏请求失败：", errorMessage);
            showError(qsTr("操作失败了"), 4000, qsTr("↙请点击左下角客服界面反馈"))
        }
    }

    // 收藏的函数
    function toggleFavorite() {
        var url = "/api/favorites/add"; // 收藏接口

        var payload = {
            flightId: flightId, // 当前航班的 ID
        };

        console.log("正在收藏航班: " + flightId);

        favoriteHandler.request(url, NetworkHandler.POST, payload, userInfo.myToken);
    }

    // 预定的函数
    function toggleBooked(){
        var url = "/api/orders/add";

        var payload = {
            flightId : flightId
        };

        console.log("正在预定航班（toggledBooked函数运行中）：" + flightId + flightNumber);

        orderHandler.request(url, NetworkHandler.POST, payload, userInfo.myToken);
    }

    RowLayout {
        anchors.fill: parent
        spacing: 30
        // 航空公司信息
        ColumnLayout {
            Layout.preferredWidth: 150
            spacing: 5

            FluText {
                text: airlineCompany
                font.pixelSize: 14
            }

            FluText {
                text: flightNumber
                font.pixelSize: 12
            }
        }

        // 时间和机场信息
        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            ColumnLayout {
                Layout.fillWidth: true

                FluText {
                    id: departure
                    text: formatTime(departureTime)
                    font.pixelSize: 24
                    font.bold: true
                }

                FluText {
                    text: departureAirport
                    font.pixelSize: 12
                }
            }

            FluText {
                text: "→"
                font.bold: true
                verticalAlignment: Text.AlignVCenter
            }

            ColumnLayout {
                Layout.fillWidth: true

                FluText {
                    id: arrival
                    text: formatTime(arrivalTime)
                    font.pixelSize: 24
                    font.bold: true
                }

                FluText {
                    text: arrivalAirport
                    font.pixelSize: 12
                }
            }
        }

        // 价格和状态
        ColumnLayout {
            Layout.preferredWidth: 150
            spacing: 5

            FluText {
                text: qsTr("￥") + price.toFixed(2)
                font.pixelSize: 18
                font.bold: true
                color: "#F39C12"
            }

            Rectangle {
                id: statusBadge
                Layout.alignment: Qt.AlignHCenter
                width: 80
                height: 24
                radius: 5
                color: status === "on Time" ? "#27AE60" : (status === "Delayed" ? "#F39C12" : "#C0392B")

                FluText {
                    anchors.centerIn: parent
                    text: status
                    color: "white"
                    font.pixelSize: 14
                    font.bold: true
                }
            }
        }

        // 收藏和预定按钮
        ColumnLayout {
            Layout.preferredWidth: 150
            spacing: 5

            FluFilledButton {
                text: isBooked ? qsTr("已预订") : qsTr("预订")
                disabled: isBooked
                Layout.preferredWidth: 120
                onClicked: {
                    if(!userInfo.myToken)  {
                        showWarning(qsTr("请先登录！"))
                        return
                    }
                    toggleBooked();
                    console.log(qsTr("已发送预定航班请求：" + flightId + flightNumber));
                }
            }

            FluTextButton {
                text: isFaved ? qsTr("已收藏") : qsTr("收藏")
                Layout.preferredWidth: 120
                enabled: !isFaved  // 如果已收藏，禁用按钮
                onClicked: {
                    if(!userInfo.myToken)  {
                        showWarning(qsTr("请先登录！"))
                        return
                    }
                    if (!isFaved) {
                        toggleFavorite(flightId, isFaved);
                    }
                }
            }

        }
    }
    // 函数：格式化时间为 "hh:mm" 格式
    function formatTime(timeString) {
        var date = new Date(timeString);
        var hours = date.getHours();
        var minutes = date.getMinutes();
        return (hours < 10 ? '0' + hours : hours) + ":" + (minutes < 10 ? '0' + minutes : minutes);
    }
}
