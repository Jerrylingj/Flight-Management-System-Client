import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import NetworkHandler 1.0

FluFrame {
    id: rebookFlightInfoCard
    radius: 10
    Layout.preferredWidth: 560
    Layout.preferredHeight: 100
    padding: 10
    Layout.alignment: Qt.AlignCenter

    property int flightId
    property string flightNumber
    property string departureTime
    property string arrivalTime
    property string departureAirport
    property string originalDepAirport
    property string arrivalAirport
    property double originalPrice
    property double price
    property string airlineCompany
    property string status

    property int currentSelectedFlightId

    property bool isSelected : (currentSelectedFlightId === flightId)

    property bool enabled

    signal cardSelected()

    // 在父组件中自动水平居中
    // anchors.horizontalCenter: parent.horizontalCenter


    onEnabledChanged: {
        // console.log("代表着航班号"+flightNumber+"的卡片"+(enabled?"被启用":"被禁用"));
    }

    onIsSelectedChanged: {
        // console.log("代表着航班号"+flightNumber+"的卡片"+(isSelected?"被选中":"被取消选中"));
    }

    // 处理外部 selectedFlightId 的变化
    onCurrentSelectedFlightIdChanged: {
        // 自动更新 isSelected
        // console.log("当前改签航班信息的currentSelectedFlightId已经发生了改变，现在是"+currentSelectedFlightId);
        isSelected = (currentSelectedFlightId === flightId);
    }

    // 当卡片被选中时，发射信号
    // onCardSelected: {
    //     // rebookFlightInfoCard.cardSelected()
    // }

    // 当卡片被取消选中时，发射信号
    // onCardDeselected: {
    //     // rebookFlightInfoCard.cardDeselected()
    // }

    border.color: isSelected ? "#409EFF" : "gray"
    border.width: isSelected ? 5 : 1
    color: isSelected ? (FluTheme.dark ? "#555555" : "#f0f0f0") : (FluTheme.dark ? "#333333" : "white")

    MouseArea {
        id : mouseArea
        anchors.fill: parent
        onClicked: {
            if(rebookFlightInfoCard.enabled){
                cardSelected()
                // console.log("当前改签航班信息的currentSelectedFlightId是"+currentSelectedFlightId+"，请检查改签窗口的currentId是否改变");
            }else{
                // console.log("抱歉，当前卡片非可选择卡片")
            }
        }
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
                        text: departure + departureAirport
                        font.pixelSize: 12
                        font.bold: departureAirport !== originalDepAirport
                        color: departureAirport !== originalDepAirport ? (FluTheme.dark ? "#FF6666" : "red") : "black"
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
                        text: destination + arrivalAirport
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

                // 差价
                FluText {
                    text: price === originalPrice ? qsTr("价格不变") : (price > originalPrice ? qsTr("另付￥") + (price - originalPrice).toFixed(2) : qsTr("退还￥") + (originalPrice - price).toFixed(2))
                    font.pixelSize: 16
                    font.bold: true
                    color: price === originalPrice ? "green" : (price > originalPrice ? (FluTheme.dark ? "#FF6666" : "red") : "#F39C12")
                    horizontalAlignment: Text.AlignHCenter
                }

                // 状态徽章
                Rectangle {
                    id: statusBadge
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
                        horizontalAlignment: Text.AlignHCenter
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
