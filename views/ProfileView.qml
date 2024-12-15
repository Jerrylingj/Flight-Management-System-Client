import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Effects
import QtQuick.Layouts 1.15
import FluentUI 1.0

FluContentPage {
    id: userProfilePage
    title: qsTr("个人中心")
    background: Rectangle { radius: 5 }

    ColumnLayout {
        anchors.fill: parent
        spacing: 20

        // 个人信息部分
        Rectangle {
            Layout.fillWidth: true
            height: 200
            radius: 5
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10

                // 头像
                Rectangle {
                    width: 150
                    height: 150
                    border.color: "#DDDDDD" // 可选，设置边框颜色
                    layer.enabled: true

                    Image {
                        id: avatar
                        source: "qrc:/qt/Flight_Management_System_Client/figures/avatar.jpg"
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                    }
                }


                // 用户信息
                ColumnLayout {
                    spacing: 10

                    FluText {
                        text: qsTr("用户 ID: ") + userInfo.userId
                        font.pixelSize: 16
                    }

                    FluText {
                        text: qsTr("用户名: ") + userInfo.userName
                        font.pixelSize: 16
                    }

                    FluText {
                        text: qsTr("账号: ") + userInfo.userEmail
                        font.pixelSize: 16
                    }

                    FluText {
                        text: qsTr("简介: ") + userInfo.userPersonalInfo
                        font.pixelSize: 14
                        wrapMode: Text.WordWrap
                    }

                    FluText {
                        text: qsTr("钱包余额: ") + userInfo.myMoney
                        font.pixelSize: 16
                        color: FluTheme.primaryColor
                    }
                }
            }
        }

        // 导航功能部分
        Rectangle {
            Layout.fillWidth: true
            height: 120
            radius: 5
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20

                FluFilledButton {
                    text: qsTr("收藏")
                    Layout.preferredWidth: 120
                    onClicked: {
                        console.log("跳转到收藏界面");
                        userNavView.push("qrc:/qt/Flight_Management_System_Client/views/FlightFavoriteView.qml")
                        userNavView.setCurrentIndex(3);
                    }
                }

                FluFilledButton {
                    text: qsTr("全部订单")
                    Layout.preferredWidth: 120
                    onClicked: {
                        console.log("跳转到全部订单界面");
                        // 跳转到全部订单页面逻辑
                        userNavView.push("qrc:/qt/Flight_Management_System_Client/views/FlightInfoView.qml")
                        userNavView.setCurrentIndex(4);
                    }
                }

            }
        }

        // 账号操作部分
        Rectangle {
            Layout.fillWidth: true
            height: 120
            radius: 5
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20

                FluFilledButton {
                    text: qsTr("登录")
                    Layout.preferredWidth: 100
                    onClicked: {
                        userNavView.push("qrc:/qt/Flight_Management_System_Client/views/LoginView.qml")
                        console.log("登录按钮点击");
                        // 登录逻辑
                    }
                }

                FluFilledButton {
                    text: qsTr("注册")
                    Layout.preferredWidth: 100
                    onClicked: {
                        userNavView.push("qrc:/qt/Flight_Management_System_Client/views/RegisterView.qml")
                        console.log("注册按钮点击");
                        // 注册逻辑
                    }
                }


                FluTextButton {
                    text: qsTr("注销")
                    Layout.preferredWidth: 100

                    FluContentDialog{
                        id:quittextDialog
                        title: "确定注销账号？"
                        onPositiveClickListener:()=>{
                                                    quittextDialog.close()
                                                    userInfo.userName="未知用户"
                                                    userInfo.userPersonalInfo="无"
                                                    userInfo.myMoney=0
                                                    userInfo.userId=0
                                                    userInfo.userEmail="none"
                                                }
                    }
                    onClicked: {
                        console.log("注销按钮点击");
                        // 注销逻辑
                        quittextDialog.open();
                    }
                }
            }
        }
    }
}
