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
    property string arrivalAirport
    property double price
    property string airlineCompany
    property string status

    property int currentSelectedFlightId

    property bool isSelected : (currentSelectedFlightId === flightId)

    property bool enabled : currentSelectedFlightId === flightId || currentSelectedFlightId === -1

    signal cardSelected()
    signal cardDeselected()


    onEnabledChanged: {
        console.log("代表着航班号"+flightNumber+"的卡片"+(enabled?"被启用":"被禁用"));
    }

    onIsSelectedChanged: {
        console.log("代表着航班号"+flightNumber+"的卡片"+(isSelected?"被选中":"被取消选中"));
    }

    // 处理外部 selectedFlightId 的变化
    onCurrentSelectedFlightIdChanged: {
        // 自动更新 isSelected
        console.log("当前改签航班信息的currentSelectedFlightId已经发生了改变，现在是"+currentSelectedFlightId);
        isSelected = (currentSelectedFlightId === flightId);
    }

    // 当卡片被选中时，发射信号
    onCardSelected: {
        rebookFlightInfoCard.cardSelected()
    }

    // 当卡片被取消选中时，发射信号
    onCardDeselected: {
        rebookFlightInfoCard.cardDeselected()
    }

    border.color: isSelected ? "#409EFF" : "gray"
    border.width: isSelected ? 5 : 1
    color: isSelected ? "#f0f0f0" : "white"

    MouseArea {
        anchors.fill: parent
        enabled: parent.enabled  // 根据enabled属性控制是否可点击
        onClicked: {
            if(enabled){
                if (!isSelected) {
                    cardSelected();
                    console.log("当前卡片发出了被选择的信号");

                } else {
                    cardDeselected();
                    console.log("当前卡片发出了被取消选择的信号");
                }
                console.log("当前改签航班信息的currentSelectedFlightId是"+currentSelectedFlightId+"，请检查改签窗口的currentId是否改变");
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 30
        // 航空公司信息
        ColumnLayout {
            Layout.preferredWidth: 80
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
            Layout.preferredWidth: 100
            spacing: 5

            // FluText {
            //     text: qsTr("￥") + price.toFixed(2)
            //     font.pixelSize: 18
            //     font.bold: true
            //     color: "#F39C12"
            // }

            Rectangle {
                id: statusBadge
                Layout.alignment: Qt.AlignHCenter
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
    }

    // 函数：格式化时间为 "hh:mm" 格式
    function formatTime(timeString) {
        var date = new Date(timeString);
        var hours = date.getHours();
        var minutes = date.getMinutes();
        return (hours < 10 ? '0' + hours : hours) + ":" + (minutes < 10 ? '0' + minutes : minutes);
    }
}
