import QtQml 2.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Effects
import QtQuick.Layouts 1.15
import FluentUI 1.0
import QtQuick.Dialogs
import NetworkHandler 1.0

import "../components"

FluContentPage {
    id: userProfileView
    // property string avatar_url
    title: qsTr("个人中心")

    NetworkHandler{
        id:networkHandler
        onRequestSuccess: function(data) {
            console.log(JSON.stringify(data, null, 2))
        }
        onRequestFailed: function(data) {
            console.log(JSON.stringify(data, null, 2))
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 20

        // 个人信息部分
        FluFrame {
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            radius: 5
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10

                // 头像
                FluFrame {
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 150
                    border.color: "#DDDDDD" // 可选，设置边框颜色
                    layer.enabled: true

                    Image {
                        id: avatar
                        source: userInfo.myAvatar.length?userInfo.myAvatar:"qrc:/qt/Flight_Management_System_Client/figures/avatar.jpg"
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                        cache: false
                        Component.onCompleted: {
                            console.log(userInfo.myAvatar)
                            // if(userInfo.myAvatar.length()===0){
                            //     avatar_url = "qrc:/qt/Flight_Management_System_Client/figures/avatar.jpg"
                            // }
                            // else{
                            //    avatar_url = userInfo.myAvatar
                            // }
                        }
                        MouseArea{
                            width:parent.width
                            height: parent.height
                            anchors.fill: parent
                            onClicked: {
                                if(!userInfo.myToken)  {
                                    showWarning(qsTr("请先登录！"))
                                    return
                                }
                                fileDialog.open()
                            }
                        }
                    }
                    FileDialog{
                        id:fileDialog
                        title: "选择图片文件"
                        nameFilters: ["图片文件 (*.png *.jpg *.jpeg *.gif)"]
                        onAccepted: {
                            avatar.source = fileDialog.selectedFiles[0]
                            userInfo.myAvatar = JSON.stringify(fileDialog.selectedFiles[0]).replace(/"/g,'')
                            networkHandler.request('/api/user', NetworkHandler.PUT, {avatar_url:userInfo.myAvatar}, userInfo.myToken)
                        }
                    }
                }


                // 用户信息
                ColumnLayout {
                    spacing: 10

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
        FluFrame {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            radius: 5
            border.width: 1
            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20

                ColumnLayout{
                    height: parent.height
                    width: parent.width/2
                    spacing: 20
                    FluFrame{
                        //Layout.preferredWidth: 140
                        Layout.preferredHeight: parent.height /2 -10
                        FluClip{
                            height: parent.height
                            width: 30
                            anchors.left: parent.left
                            anchors.leftMargin: 5
                            Image {
                                anchors.fill: parent
                                source: "qrc:/qt/Flight_Management_System_Client/figures/love.png"
                            }
                        }
                        FluFilledButton{
                            text: qsTr("收藏")
                            width: 100
                            height: parent.height
                            anchors.left: parent.left
                            anchors.leftMargin: 38
                            onClicked: {
                                if(!userInfo.myToken)  {
                                    showWarning(qsTr("请先登录！"))
                                    return
                                }
                                console.log("跳转到收藏界面");
                                userNavView.push("qrc:/qt/Flight_Management_System_Client/views/FlightFavoriteView.qml")
                                userNavView.setCurrentIndex(3);
                            }
                        }
                    }
                    FluFrame{
                        //Layout.preferredWidth: 140
                        Layout.preferredHeight: parent.height /2 -10
                        FluClip{
                            height: 30
                            width: parent.height
                            anchors.left: parent.left
                            anchors.leftMargin: 5
                            Image {
                                anchors.fill: parent
                                source: "qrc:/qt/Flight_Management_System_Client/figures/shopping-list.png"
                            }
                        }
                        FluFilledButton {
                            text: qsTr("全部订单")
                            width: 100
                            height: parent.height
                            anchors.left: parent.left
                            anchors.leftMargin: 38
                            onClicked: {
                                if(!userInfo.myToken)  {
                                    showWarning(qsTr("请先登录！"))
                                    return
                                }
                                console.log("跳转到全部订单界面");
                                // 跳转到全部订单页面逻辑
                                userNavView.push("qrc:/qt/Flight_Management_System_Client/views/FlightInfoView.qml")
                                userNavView.setCurrentIndex(4);
                            }
                        }
                    }
                }
                ColumnLayout{
                    height: parent.height
                    width: parent.width/2
                    spacing: 20
                    FluFrame{
                        //Layout.preferredWidth: 160
                        Layout.preferredHeight: parent.height /2 - 10
                        FluClip{
                            height: parent.height
                            width: 30
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 5
                            Image {
                                anchors.fill: parent
                                source: "qrc:/qt/Flight_Management_System_Client/figures/edit.png"
                            }
                        }
                        FluFilledButton {
                            text: qsTr("编辑个人信息")
                            width: 120
                            height: parent.height
                            anchors.left: parent.left
                            anchors.leftMargin: 38
                            anchors.verticalCenter: parent.verticalCenter
                            onClicked: {
                                if(!userInfo.myToken)  {
                                    showWarning(qsTr("请先登录！"))
                                    return
                                }
                                console.log("跳转到编辑界面");
                                userNavView.push("qrc:/qt/Flight_Management_System_Client/views/EditPersonalInfo.qml")
                            }
                        }
                    }
                    FluFrame{
                        //Layout.preferredWidth: 160
                        Layout.preferredHeight: parent.height /2 - 10
                        FluClip{
                            height: parent.height
                            width: 30
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 5
                            Image {
                                anchors.fill: parent
                                source: "qrc:/qt/Flight_Management_System_Client/figures/money.png"
                            }
                        }
                        RechargeEntry{
                            id: rechargeEntry1
                        }

                        FluFilledButton {
                            text: qsTr("充值")
                            anchors.verticalCenter: parent.verticalCenter
                            width: 120
                            height: parent.height
                            anchors.left: parent.left
                            anchors.leftMargin: 38
                            onClicked: {
                                if(userInfo.myToken.length<=1){
                                    showWarning("请先登录")
                                }
                                else{
                                    console.log("跳转到充值界面");
                                    rechargeEntry1.open();
                                }
                            }
                        }
                    }
                }
            }
        }

        // 账号操作部分
        FluFrame {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            radius: 5
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20

                // FluFrame{
                //     FluClip{
                //         width: 60
                //         height: 60
                //         anchors.top: parent.top
                //         anchors.horizontalCenter: parent.horizontalCenter
                //         Image{
                //             anchors.fill: parent
                //             source: "qrc:/qt/Flight_Management_System_Client/figures/money.png"
                //         }
                //     }

                //     FluFilledButton{
                //         text: qsTr("登录")
                //         anchors.top: parent.top
                //         anchors.topMargin: 65
                //         anchors.horizontalCenter: parent.horizontalCenter
                //         width: 60
                //         onClicked: {
                //             userNavView.push("qrc:/qt/Flight_Management_System_Client/views/LoginView.qml")
                //             console.log("登录按钮点击");
                //         }
                //     }

                // }

                // FluFrame{
                //     FluClip{
                //         width: 60
                //         height: 60
                //         anchors.top: parent.top
                //         anchors.horizontalCenter: parent.horizontalCenter
                //         Image{
                //             anchors.fill: parent
                //             source: "qrc:/qt/Flight_Management_System_Client/figures/money.png"
                //         }
                //     }

                //     FluFilledButton{
                //         text: qsTr("登录")
                //         anchors.top: parent.top
                //         anchors.topMargin: 65
                //         anchors.horizontalCenter: parent.horizontalCenter
                //         width: 60
                //         onClicked: {
                //             userNavView.push("qrc:/qt/Flight_Management_System_Client/views/LoginView.qml")
                //             console.log("登录按钮点击");
                //         }
                //     }

                // }

                // FluFrame{
                //     FluClip{
                //         width: 60
                //         height: 60
                //         anchors.top: parent.top
                //         anchors.horizontalCenter: parent.horizontalCenter
                //         Image{
                //             anchors.fill: parent
                //             source: "qrc:/qt/Flight_Management_System_Client/figures/money.png"
                //         }
                //     }

                //     FluFilledButton{
                //         text: qsTr("登录")
                //         anchors.top: parent.top
                //         anchors.topMargin: 65
                //         anchors.horizontalCenter: parent.horizontalCenter
                //         width: 60
                //         onClicked: {
                //             userNavView.push("qrc:/qt/Flight_Management_System_Client/views/LoginView.qml")
                //             console.log("登录按钮点击");
                //         }
                //     }

                // }

                FluFilledButton{
                    text: qsTr("登录")
                    Layout.preferredWidth: 100
                    width: 60
                    onClicked: {
                        userNavView.push("qrc:/qt/Flight_Management_System_Client/views/LoginView.qml")
                        console.log("登录按钮点击");
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
                                                    userInfo.userName="旅客"
                                                    userInfo.userPersonalInfo="简单的旅客"
                                                    userInfo.myMoney=-1
                                                    userInfo.userId=0
                                                    userInfo.userEmail="noname@mail2.sysu.edu.cn"
                                                    networkHandler.request('/api/user',NetworkHandler.DELETE,{},userInfo.myToken)
                                                    userInfo.myToken = ""
                                                    userInfo.myAvatar = "qrc:/qt/Flight_Management_System_Client/figures/avatar.jpg"
                                                    avatar.source = userInfo.myAvatar
                                                    userNavView.push("qrc:/qt/Flight_Management_System_Client/views/ProfileView.qml")
                                                }
                    }
                    onClicked: {
                        console.log("注销按钮点击");
                        if(userInfo.myToken.length<=1){
                            showWarning("请先登录")
                        }
                        else{
                            quittextDialog.open();
                        }
                    }
                }
            }
        }
    }
}
