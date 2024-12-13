import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15

FluRectangle {
    id: flightInfoCard
    width: parent.width
    height: 20
    radius: 10

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

    // 布局
    RowLayout {
        spacing: 30

        // 航空公司 Logo 和航班信息
        ColumnLayout {
            Layout.preferredWidth: flightInfoCard.width / 6
            spacing: 5

            // FluImage {
            //     id: airlineLogo
            //     source: "qrc:/images/airline_logo.png" // 替换为真实路径
            //     width: 40
            //     height: 20
            //     fillMode: Image.PreserveAspectFit
            // }

            FluText {
                text: airlineCompany // 航空公司名称
                font.pixelSize: 14
            }

            FluText {
                text: flightNumber // 航班号
                font.pixelSize: 12
            }
        }

        // 时间和机场信息
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredWidth: flightInfoCard.width * 2 / 6
            spacing: 20

            ColumnLayout{
                Layout.fillWidth: true
                FluText {
                    id: departure
                    text: formatTime(departureTime) // 起飞时间
                    font.pixelSize: 24
                    font.bold: true
                }

                FluText {
                    text: departureAirport // 起点机场
                    font.pixelSize: 12
                }
            }

            FluText {
                width: 50
                text: "→"
                font.bold: true
            }

            ColumnLayout {
                Layout.fillWidth: true

                FluText {
                    id: arrival
                    text: formatTime(arrivalTime) // 到达时间
                    font.pixelSize: 24
                    font.bold: true
                }
                FluText {
                    text: arrivalAirport // 终点机场
                    font.pixelSize: 12
                }
            }
        }

        // 价格和状态
        ColumnLayout {
            Layout.preferredWidth: flightInfoCard.width / 6
            spacing: 5

            FluText {
                text: qsTr("￥") + price.toFixed(2) // 动态绑定价格
                font.pixelSize: 18
                font.bold: true
                color: "#F39C12"
            }

            Rectangle {
                z: 5
                id: statusBadge
                anchors.horizontalCenter: parent.horizontalCenter // 居中对齐
                width: 80
                height: 24
                radius: 5
                color: status === "On Time" ? "#27AE60" : (status === "Delayed" ? "#F39C12" : "#C0392B")
                FluText {
                    anchors.centerIn: parent
                    text: status
                    color: "white"
                    font.pixelSize: 14
                    font.bold: true
                }
            }
        }

        // 预订和收藏按钮
        ColumnLayout {
            Layout.preferredWidth: flightInfoCard.width / 6

            FluFilledButton {
                text: isBooked ? qsTr("取消预订") : qsTr("预订")
                Layout.preferredWidth: 100
                onClicked: {
                    isBooked = !isBooked;
                    console.log(isBooked ? "预订航班: " + flightNumber : "取消预订航班: " + flightNumber);
                }
            }

            FluTextButton {
                text: isFaved ? qsTr("取消收藏") : qsTr("收藏")
                Layout.preferredWidth: 100
                onClicked: {
                    isFaved = !isFaved;
                    console.log(isFaved ? "收藏航班: " + flightNumber : "取消收藏航班: " + flightNumber);
                }
            }
        }
    }

    // 函数：格式化时间为 "hh:mm" 格式
    function formatTime(timeString) {
        var date = new Date(timeString);  // 使用 JavaScript 内置的 Date 对象解析时间字符串
        var hours = date.getHours();  // 获取小时
        var minutes = date.getMinutes();  // 获取分钟

        // 保证小时和分钟都是两位数格式
        return (hours < 10 ? '0' + hours : hours) + ":" + (minutes < 10 ? '0' + minutes : minutes);
    }
}
