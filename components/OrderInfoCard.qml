import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

FluFrame {
    id: orderInfoCard
    radius: 10
    Layout.fillWidth: true
    Layout.preferredHeight: 100
    padding: 10

    property int  orderId
    property int userId
    property int flightId
    property int totalChangeCount
    property bool paymentStatus

    property string flightNumber
    property string airlineCompany
    property double price
    property string flightStatus

    property string departure
    property string destination
    property string departureTime
    property string arrivalTime
    property string departureAirport
    property string arrivalAirport

    property string checkInStartTime
    property string checkInEndTime

    property string currentTimeValue: Qt.formatTime(new Date(), "HH:mm")

    // 整个Card
    RowLayout{
        // Card的左半边（信息部分）
        ColumnLayout{
            // 主要信息展示栏
            RowLayout{
                // 航空公司 Logo 和航班信息
                ColumnLayout{
                    Layout.preferredWidth: 150
                    spacing: 5

                    FluText {
                        text: airlineCompany // 航空公司名称
                        font.pixelSize: 14
                    }

                    FluText {
                        text: flightNumber // 航班号
                        font.pixelSize: 12
                    }
                }

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

                // 价格和状态
                ColumnLayout {
                    Layout.preferredWidth: orderInfoCard.width / 6
                    spacing: 5

                    FluText {
                        text: qsTr("￥") + price.toFixed(2) // 动态绑定价格
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

            // 进度条
            TimeProgressBar {
                id: progressBar
                indeterminate: false
            }
        }

        // Card的右半边（按钮部分）
        ColumnLayout{
            // 显示二维码和支付/退改签按钮
            Layout.preferredWidth: orderInfoCard.width / 6

            // 登机二维码按钮
            FluFilledButton {
                text: disabled ? qsTr("尚未支付") : qsTr("登机二维码")
                Layout.preferredWidth: 100
                disabled: !paymentStatus
                onClicked: {
                   qRCodeDialog.open()
                }
            }

            // 登机二维码弹窗
            FluContentDialog{
                id: qRCodeDialog
                title: qsTr("登机二维码")
                message: qsTr("提反高诈意识，请勿描扫陌生二维码")
                contentDelegate: Component{
                    Item{
                        implicitWidth: parent.width
                        implicitHeight: 300
                        anchors.alignWhenCentered: parent.Center
                        FluQRCode{
                            anchors.fill: parent
                            color:"black"
                            text:"https://www.bilibili.com/video/BV1uT4y1P7CX/?share_source=copy_web"
                            size:200
                        }
                    }
                }
                buttonFlags: FluContentDialogType.PositiveButton
                positiveText: qsTr("完成")
                onPositiveClicked: {
                    showSuccess(qsTr("祝您旅途愉快！"))
                }
            }

            // 支付/退改签按钮
            FluToggleButton {
                id: payOrRebookButton
                text: checked ? qsTr("退改签") : qsTr("支付")
                normalColor: {
                    if(!checked){
                        return "#F3CF2A"
                    }else{
                        return FluTheme.dark ? "#FA98EB" : "#E13EE1"
                    }
                }
                hoverColor: {
                    // if(!checked){
                        return FluTheme.dark ? Qt.darker(normalColor,1.1) : Qt.lighter(normalColor,1.1)
                    // }else{
                    //     return FluTheme.dark ? Qt.rgba(68/255,68/255,68/255,1) : Qt.rgba(246/255,246/255,246/255,1)
                    // }
                    }

                Layout.preferredWidth: 100
                checked: paymentStatus
                onClicked: {
                    if(!checked){
                        checked = !checked;
                        selectionDialog.open();
                    }else{
                        checked = !checked;
                        paymentDialog.open();
                    }
                }
            }

            // 支付弹窗
            FluContentDialog{
                id: paymentDialog
                title: qsTr("支付")
                message: qsTr("提反高诈意识，请勿描扫陌生二维码")
                buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
                contentDelegate: Component{
                    FluText{
                        text: "您当前资产为 "+userInfo.myMoney+" 奶龙币，本次购票将消耗您"+price+"奶龙币，余下"+(userInfo.myMoney-price)+"奶龙币，确定执行支付操作吗？"
                    }
                }
                negativeText: qsTr("狠心拒绝")
                onNegativeClicked: {
                    showWarning(qsTr("我还是喜欢你桀骜不驯的样子"))
                }

                positiveText: qsTr("大方支付")
                onPositiveClicked: {
                    showSuccess(qsTr("感谢您的信赖！"))
                    payOrRebookButton.checked = !payOrRebookButton.checked;
                    paymentStatus = !paymentStatus;
                    userInfo.myMoney = userInfo.myMoney - price;
                }
            }

            // 选择弹窗
            FluContentDialog{
                id:selectionDialog
                title: qsTr("您希望如何操作？")
                message: qsTr("请选择退签或改签")
                negativeText: qsTr("☀霓🐎退💴")
                buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
                onNegativeClicked:{
                    paymentStatus = !paymentStatus;
                    userInfo.myMoney = userInfo.myMoney + price;
                    payOrRebookButton.checked = !payOrRebookButton.checked;
                    showSuccess(qsTr("已全款退还 " + price + " 元"))
                }
                positiveText: qsTr("改签")
                onPositiveClicked:{
                    showSuccess(qsTr("触发改签逻辑"))
                    }
                }

            // 改签弹窗
            FluContentDialog{
                id : rebookingDialog
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
