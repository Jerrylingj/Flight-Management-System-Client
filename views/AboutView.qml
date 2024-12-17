import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "../components"

FluScrollablePage{

    title: qsTr("关于我们")

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 400
        padding: 10



        FluPivot{
            anchors.fill: parent
            currentIndex: 2

            FluPivotItem{
                title: qsTr("团队简介")
                contentItem:FluText{
                    text: qsTr("云途航班信息管理有限公司，即AltAir，总部坐落于中国广东省珠海市高新区榕园开发中心。我们引领航空业革新，以尖端技术提供无与伦比的航班管理服务，优化全球航空运营效率，树立行业新标准。")
                }
            }
            FluPivotItem{
                title: qsTr("林省煜")
                contentItem: FluText{
                    text: qsTr("林省煜")
                }
            }
            FluPivotItem{
                title: qsTr("林国佳")
                contentItem: FluText{
                    text: qsTr("林国佳")
                }
            }
            FluPivotItem{
                title: qsTr("朱玄烨")
                contentItem: FluText{
                    text: qsTr("朱玄烨")
                }
            }
            FluPivotItem{
                title: qsTr("杨普旭")
                contentItem: FluText{
                    text: qsTr("杨普旭")
                }
            }
        }
    }
}
