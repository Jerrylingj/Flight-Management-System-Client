import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15
import NetworkHandler 1.0
import "../components"

// 第一步：获取当前用户的订单
// 第二步：将基本的订单卡片列表展示出来
// 第三步：点击“查看按钮”弹出弹窗
// 第四步：点击“退改签”显示界面，点击“检票二维码”显示弹窗
// 第五步：出发到达城市 + 时间段复合筛选
// 第六步：“退改签”界面和相应功能
// 第七步：整体美化

FluContentPage {
    id: ordersDetailView
    title: "订单详情"
    background: Rectangle { radius: 5 }

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

    ColumnLayout{
        // anchors.fill: parent
        // spacing: 16
        FluCopyableText{
            text: qsTr("This is a text that can be copied")
        }

        FluCopyableText{
            text: qsTr("This is a text that can be copied")
        }

        FluCopyableText{
            text: qsTr("This is a text that can be copied")
        }

        FluCopyableText{
            text: qsTr("This is a text that can be copied")
        }

        FluCopyableText{
            text: qsTr("This is a text that can be copied")
        }

        RowLayout{
            FluButton{
                id : showQRCode

                FluQRCode{
                    color:"red"
                    text: "https://www.bilibili.com/video/BV1uT4y1P7CX/?share_source=copy_web&vd_source=cd13ddf48088066cc8d1f4a5fb0d8705"
                    size:100
                }

                onClicked: {

                }
            }
        }
    }
}
