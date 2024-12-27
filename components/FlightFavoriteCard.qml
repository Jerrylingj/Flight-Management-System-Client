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
    property string departureCity
    property string arrivalCity
    property string departureAirport
    property string arrivalAirport
    property double price
    property string airlineCompany
    property string status
    property bool isBooked: false
    property bool isFaved: false

    // 收藏接口
    NetworkHandler {
        id: favoriteHandler

        onRequestSuccess: function (responseData) {
            if (responseData.success) {
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

    // 收藏与取消收藏的函数
    function toggleFavorite(flightId, isFaved) {
        var url = isFaved
            ? "/api/favorites/remove" // 取消收藏接口
            : "/api/favorites/add"; // 收藏接口

        var payload = {
            flightId: flightId, // 当前航班的 ID
        };

        console.log(isFaved ? "正在取消收藏航班: " + flightId : "正在收藏航班: " + flightId);

        favoriteHandler.request(url, NetworkHandler.POST, payload, userInfo.myToken);
    }


    RowLayout {
        anchors.fill: parent
        spacing: 30

        ColumnLayout {
            Layout.preferredWidth: 150
            spacing: 5

            // 航班号
            FluText {
                text: flightNumber
                font.bold: true
                font.pixelSize: 20
                color: FluTheme.dark ? "#FFFF00" : "#409EFF"
            }

            // 航空公司信息
            FluText {
                text: airlineCompany
                font.pixelSize: 12
            }
        }

        // 时间和机场信息
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 5

            // 时刻与航班
            RowLayout {
               spacing: 20

                ColumnLayout {
                    FluText {
                        Layout.alignment: Qt.AlignRight // 右对齐
                        text: formatTime(departureTime)
                        font.pixelSize: 24
                        font.bold: true
                    }

                    FluText {
                        Layout.alignment: Qt.AlignRight // 右对齐
                        text: departureCity + departureAirport
                        font.pixelSize: 12
                    }

                    FluText {
                        Layout.alignment: Qt.AlignRight // 右对齐
                        visible: isCrossDay()
                        text: formatDate(departureTime)
                        font.pixelSize: 14
                    }
                }

                FluText {
                    text: "→"
                    font.pixelSize: 20
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                }

                ColumnLayout {
                    // 默认左对齐
                    FluText {
                        text: formatTime(arrivalTime)
                        font.pixelSize: 24
                        font.bold: true
                    }

                    FluText {
                        text: arrivalCity + arrivalAirport
                        font.pixelSize: 12
                    }

                    FluText {
                        visible: isCrossDay()
                        text: formatDate(arrivalTime)
                        font.pixelSize: 14
                    }
                }
            }

            // 日期显示
            FluText {
                Layout.alignment: Qt.AlignHCenter
                visible: !isCrossDay()
                text: formatDate(departureTime)
                font.pixelSize: 14
            }
        }

        // 价格和状态
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 10

            ColumnLayout {
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 150
                spacing: 10

                // 价格
                FluText {
                    text: qsTr("￥") + price.toFixed(2)
                    font.pixelSize: 18
                    font.bold: true
                    color: "#F39C12"
                    horizontalAlignment: Text.AlignHCenter
                }

                // 状态徽章
                Rectangle {
                    id: statusBadge
                    width: 80
                    height: 24
                    radius: 5
                    color: status === "on Time" ? "#27AE60" : (status === "delayed" ? "#F39C12" : "#C0392B")

                    FluText {
                        anchors.centerIn: parent
                        text: status
                        color: "white"
                        font.pixelSize: 14
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                    }
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


    // 函数：判断航班是否跨天
    function isCrossDay() {
        const depDate = new Date(departureTime);
        const arrDate = new Date(arrivalTime);

        // 比较日期部分是否相同
        return depDate.getFullYear() !== arrDate.getFullYear() ||
               depDate.getMonth() !== arrDate.getMonth() ||
               depDate.getDate() !== arrDate.getDate();
    }

    // 函数：格式化时间为 "hh:mm" 格式
    function formatTime(timeString) {
        var date = new Date(timeString);
        var hours = date.getHours();
        var minutes = date.getMinutes();
        return (hours < 10 ? '0' + hours : hours) + ":" + (minutes < 10 ? '0' + minutes : minutes);
    }

    // 函数：格式化日期为 "YYYY-MM-DD" 格式
    function formatDate(dateString) {
        var date = new Date(dateString);
        var year = date.getFullYear();
        var month = date.getMonth() + 1;
        var day = date.getDate();
        return year + "-" + (month < 10 ? '0' + month : month) + "-" + (day < 10 ? '0' + day : day);
    }
}
