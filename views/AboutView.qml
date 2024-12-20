import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "../components"

FluScrollablePage {
    id: aboutView
    title: qsTr("关于我们")

    FluFrame {
        Layout.fillWidth: true
        Layout.preferredHeight: 500
        padding: 10

        FluPivot {
            anchors.fill: parent
            currentIndex: 0

            FluPivotItem {
                title: qsTr("团队简介")
                contentItem: ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    // 外层 FluRectangle，用于承载顶部图片
                    FluRectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 160
                        color: "transparent" // 可根据需要设置背景颜色

                        // 顶部图片
                        FluImage {
                            id: personnelImage
                            anchors.centerIn: parent
                            source: "qrc:/qt/Flight_Management_System_Client/figures/personnel.png"
                            width: 565
                            height: 150
                        }
                    }

                    // 可滚动的文字区域，放在 FluRectangle 下方，确保两部分不重叠
                    Flickable {
                        clip: true
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.margins: 20
                        ScrollBar.vertical: FluScrollBar {}

                        // 将两个文本放进 Column，按顺序垂直排列
                        Column {
                            id: columnLayout1
                            width: parent.width
                            spacing: 10

                            FluText {
                                text: qsTr("终端露台(Terminal Terrace)")
                                font.pixelSize: 32
                                font.family: "华文中宋"
                                wrapMode: Text.WordWrap
                                width: parent.width
                                horizontalAlignment: Text.AlignHCenter  // 设置水平居中
                            }

                            FluText {
                                text: qsTr("        终端露台团队(Terminal Terrace Team, also the TTT)团队由中山大学软件工程学院2023级的4名同学组成，他们分别是（上图从左到右）：林国佳、林省煜、朱玄烨和杨普旭。")
                                font.pixelSize: 18
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }

                            FluText {
                                text: qsTr("        团队的总部位于珠海高新区榕园经济技术开发区9栋二层，拥有先进的软硬件设施。")
                                font.pixelSize: 18
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }

                            FluText {
                                text: qsTr("        云途 AltAir 项目基于 QML + Cpp 开发，全程使用 Github 进行项目管理。")
                                font.pixelSize: 18
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }
                        }
                        // 计算内容可滚动高度
                        contentHeight: columnLayout1.implicitHeight
                    }
                }
            }

            FluPivotItem {
                title: qsTr("林国佳")
                contentItem: ColumnLayout {
                    width: parent.width
                    FluRectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 160
                        color: "transparent" // 可根据需要设置背景颜色
                        FluImage {
                            anchors.centerIn: parent
                            width: 150
                            height: 150
                            source: "qrc:/qt/Flight_Management_System_Client/figures/lgj.png"
                        }
                    }

                    // 可滚动的文字区域，放在 FluRectangle 下方，确保两部分不重叠
                    Flickable {
                        clip: true
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.margins: 20
                        ScrollBar.vertical: FluScrollBar {}

                        // 将两个文本放进 Column，按顺序垂直排列
                        Column {
                            id: columnLayout2
                            width: parent.width
                            spacing: 10

                            FluText {
                                text: qsTr("Guojia Lin 总经理")
                                font.pixelSize: 32
                                font.family: "华文中宋"
                                wrapMode: Text.WordWrap
                                width: parent.width
                                horizontalAlignment: Text.AlignHCenter  // 设置水平居中
                            }

                            FluText {
                                text: qsTr("        主要负责模块有：用户端全部航班获取、航班收藏预定状态获取、航班筛选、主页；管理员端航班编辑、用户信息编辑")
                                font.pixelSize: 18
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }
                        }
                        // 计算内容可滚动高度
                        contentHeight: columnLayout2.implicitHeight
                    }
                }
            }

            FluPivotItem {
                title: qsTr("林省煜")
                contentItem: ColumnLayout {
                    width: parent.width
                    FluRectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 160
                        color: "transparent" // 可根据需要设置背景颜色
                        FluImage {
                            anchors.centerIn: parent
                            width: 150
                            height: 150
                            source: "qrc:/qt/Flight_Management_System_Client/figures/lsy.png"
                        }
                    }

                    // 可滚动的文字区域，放在 FluRectangle 下方，确保两部分不重叠
                    Flickable {
                        clip: true
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.margins: 20
                        ScrollBar.vertical: FluScrollBar {}

                        // 将两个文本放进 Column，按顺序垂直排列
                        Column {
                            id: columnLayout3
                            width: parent.width
                            spacing: 10

                            FluText {
                                text: qsTr("Shengyü Lin 技术部主任")
                                font.pixelSize: 32
                                font.family: "华文中宋"
                                wrapMode: Text.WordWrap
                                width: parent.width
                                horizontalAlignment: Text.AlignHCenter  // 设置水平居中
                            }

                            FluText {
                                text: qsTr("        主要负责模块有：网络请求封装、AI大模型客服、发现页旅游笔记实时获取、航班信息实时获取")
                                font.pixelSize: 18
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }
                        }
                        // 计算内容可滚动高度
                        contentHeight: columnLayout3.implicitHeight
                    }
                }
            }


            FluPivotItem {
                title: qsTr("朱玄烨")
                contentItem: ColumnLayout {
                    width: parent.width
                    FluRectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 160
                        color: "transparent" // 可根据需要设置背景颜色
                        FluImage {
                            anchors.centerIn: parent
                            width: 150
                            height: 150
                            source: "qrc:/qt/Flight_Management_System_Client/figures/zxy.png"
                        }
                    }

                    // 可滚动的文字区域，放在 FluRectangle 下方，确保两部分不重叠
                    Flickable {
                        clip: true
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.margins: 20
                        ScrollBar.vertical: FluScrollBar {}

                        // 将两个文本放进 Column，按顺序垂直排列
                        Column {
                            id: columnLayout4
                            width: parent.width
                            spacing: 10

                            FluText {
                                text: qsTr("Xuanye Zhu 人事部主任")
                                font.pixelSize: 32
                                font.family: "华文中宋"
                                wrapMode: Text.WordWrap
                                width: parent.width
                                horizontalAlignment: Text.AlignHCenter  // 设置水平居中
                            }

                            FluText {
                                text: qsTr("         主要负责模块有：用户端用户中心界面、用户注册登录、信息修改、头像修改、充值后端实现；管理员端用户信息获取后端实现")
                                font.pixelSize: 18
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }
                        }
                        // 计算内容可滚动高度
                        contentHeight: columnLayout4.implicitHeight
                    }
                }
            }

            FluPivotItem {
                title: qsTr("杨普旭")
                contentItem: ColumnLayout {
                    width: parent.width
                    FluRectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 160
                        color: "transparent" // 可根据需要设置背景颜色
                        FluImage {
                            anchors.centerIn: parent
                            width: 150
                            height: 150
                            source: "qrc:/qt/Flight_Management_System_Client/figures/ypx.png"
                        }
                    }

                    // 可滚动的文字区域，放在 FluRectangle 下方，确保两部分不重叠
                    Flickable {
                        clip: true
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.margins: 20
                        ScrollBar.vertical: FluScrollBar {}

                        // 将两个文本放进 Column，按顺序垂直排列
                        Column {
                            id: columnLayout5
                            width: parent.width
                            spacing: 10

                            FluText {
                                text: qsTr("Puxü Yang 信息部主任")
                                font.pixelSize: 32
                                font.family: "华文中宋"
                                wrapMode: Text.WordWrap
                                width: parent.width
                                horizontalAlignment: Text.AlignHCenter  // 设置水平居中
                            }

                            FluText {
                                text: qsTr("        主要负责模块有：用户端订单的预定、支付、取消支付、退签、改签的前后端实现；充值页面前后端实现、关于我们页面前端实现")
                                font.pixelSize: 18
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }
                        }
                        // 计算内容可滚动高度
                        contentHeight: columnLayout5.implicitHeight
                    }
                }
            }
        }
    }
}
