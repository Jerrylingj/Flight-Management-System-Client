import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import NetworkHandler 1.0

FluFrame {
    id: flightFavoriteCard
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
    property bool isBooked: false
    property bool isFaved: false
    property int remainingSeats: 10

    // 收藏与取消收藏的函数
    function toggleFavorite(flightId, isFaved) {
        var url = isFaved
            ? "http://127.0.0.1:8080/api/favorites/remove" // 取消收藏接口
            : "http://127.0.0.1:8080/api/favorites/add"; // 收藏接口

        var payload = {
            flightId: flightId, // 当前航班的 ID
        };

        console.log(isFaved ? "正在取消收藏航班: " + flightId : "正在收藏航班: " + flightId);

        favoriteHandler.request(url, NetworkHandler.POST, payload, userInfo.myToken);
    }

    // 收藏接口的 NetworkHandler 实例
    NetworkHandler {
        id: favoriteHandler

        onRequestSuccess: function (responseData) {
            console.log("收藏/取消收藏请求成功，返回数据：", JSON.stringify(responseData));

            if (responseData.success) {
                console.log("收藏操作成功");

                // 更新 UI 中的 isFaved 状态
                flightFavoriteCard.isFaved = !flightFavoriteCard.isFaved;

                if (flightFavoriteCard.isFaved) {
                    console.log("航班 " + flightFavoriteCard.flightId + " 已收藏");
                } else {
                    console.log("航班 " + flightFavoriteCard.flightId + " 已取消收藏");
                }
                showSuccess(qsTr("操作成功"))
            } else {
                console.error("收藏/取消收藏操作失败，错误信息：", responseData.message);
                showError(qsTr("操作失败"))
            }
        }

        onRequestFailed: function (errorMessage) {
            console.error("收藏/取消收藏请求失败：", errorMessage);
        }
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

        // 收藏按钮
        ColumnLayout {
            Layout.preferredWidth: 150
            spacing: 5

            FluFilledButton {
                text: isFaved ? qsTr("取消收藏") : qsTr("收藏")
                Layout.preferredWidth: 120
                onClicked: {
                    toggleFavorite(flightId, isFaved);
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
