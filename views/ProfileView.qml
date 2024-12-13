import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI

// ProfileView.qml
Page {
    id: profileView

    property string viewName: '个人中心'
    property StackView stack: StackView.view

    Rectangle {
        anchors.fill: parent
        color: "#F5F5F5" // 背景颜色

        Column {
            anchors.topMargin: 20
            anchors.fill: parent
            anchors.centerIn: parent
            spacing: 20


            // 头像和用户名部分
            Row {
                anchors.left: parent.left // 左边对齐到父元素的左边
                anchors.leftMargin: parent.width * 0.05
                spacing: 10
                Rectangle {
                    width: 80
                    height: 80
                    radius: 40
                    color: "#FFD700" // 圆形背景颜色
                    Text {
                        anchors.centerIn: parent
                        text: "头像"
                        color: "white"
                        font.bold: true
                        font.pointSize: 12
                    }
                }

                FluText {
                    text: userInfo.userName
                    anchors.topMargin: 20
                    font.bold: true
                    font.pointSize: 20
                    color: "#333333"
                }

                FluFilledButton {
                    text: "编辑"
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    width: parent.width * 0.4
                    height: 40
                    onClicked: {
                        console.log("编辑个人信息")
                        stack.changeTo("views/EditPersonalInfo.qml")
                    }
                }

            }

            // 个人信息文本框
            FluText {
                anchors.left: parent.left // 左边对齐到父元素的左边
                anchors.leftMargin: parent.width * 0.05
                text: "个人简介"
                font.pointSize: 15
                color: "#008000"
            }

            FluText {
                anchors.left: parent.left // 左边对齐到父元素的左边
                anchors.leftMargin: parent.width * 0.05
                text: "    " + userInfo.userPersonalInfo
                font.pointSize: 14
                color: "#666666"
                wrapMode: Text.Wrap // 自动换行
                horizontalAlignment: Text.AlignLeft // 修改这里为左对齐
                width: parent.width * 0.9 // 增加宽度到90%
            }

            // 剩余金额
            FluText {
                anchors.left: parent.left // 左边对齐到父元素的左边
                anchors.leftMargin: parent.width * 0.1
                text: "剩余金额：￥"+userInfo.myMoney
                font.pointSize: 20
                color: "#EE82EE"
            }

            FluFilledButton {
                anchors.left: parent.left // 左边对齐到父元素的左边
                anchors.leftMargin: parent.width * 0.15
                width: parent.width * 0.7
                height: 40
                text: "我的订单"
                font.pixelSize: 20
                onClicked: {
                    console.log("我的订单")
                    stack.changeTo("views/OrdersView.qml")
                }
            }

            FluFilledButton {
                anchors.left: parent.left // 左边对齐到父元素的左边
                anchors.leftMargin: parent.width * 0.15
                width: parent.width * 0.7
                height: 40
                text: "我的收藏"
                font.pixelSize: 20
                onClicked: {
                    console.log("我的收藏")
                    stack.changeTo("views/FlightInfoView.qml")
                }
            }

            FluFilledButton {
                anchors.left: parent.left // 左边对齐到父元素的左边
                anchors.leftMargin: parent.width * 0.15
                width: parent.width * 0.7
                height: 40
                text: "注册"
                font.pixelSize: 20
                onClicked: {
                    console.log("注册")
                    stack.changeTo('views/Register.qml')
                }
            }

            FluFilledButton {
                anchors.left: parent.left // 左边对齐到父元素的左边
                anchors.leftMargin: parent.width * 0.15
                width: parent.width * 0.7
                height: 40
                text: "登录/切换账号"
                font.pixelSize: 20
                onClicked: {
                    console.log("登录/切换账号")
                    stack.changeTo('views/Login.qml')
                }
            }

            FluFilledButton {
                id: button
                text: qsTr("注销账号")
                anchors.left: parent.left // 左边对齐到父元素的左边
                anchors.leftMargin: parent.width * 0.15
                width: parent.width * 0.7
                height: 40
                font.pixelSize: 20
                onClicked: confirmationDialog.open()

                FluContentDialog {
                    id: confirmationDialog

                    x: (parent.width - width) / 2
                    y: (parent.height - height) / 2
                    parent: Overlay.overlay

                    modal: true
                    title: qsTr("你确认要注销账号？")


                    onPositiveClicked: {
                        console.log("确定")
                        userInfo.userName="未知用户"
                        userInfo.myMoney=0
                        userInfo.userPersonalInfo="无"
                    }
                }
            }
        }
    }
}
