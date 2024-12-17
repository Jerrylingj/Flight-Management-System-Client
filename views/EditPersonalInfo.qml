import QtQuick 2.15
import FluentUI 1.0

FluPage {
    id: editPersonalInfoPage


    width: parent.width
    height:parent.height

    Column {
        spacing: 20
        anchors.centerIn: parent
        width: parent.width
        height:parent.height

        Rectangle{
            anchors.horizontalCenter: parent.horizontalCenter  // 确保水平居中
            width:150
            height:150
            radius: 15
            Image {
                anchors.fill: parent
                source: "../figures/editinfo.png"
            }
        }

        FluTextBox {
            anchors.horizontalCenter: parent.horizontalCenter  // 确保水平居中
            id: usernameField
            placeholderText: "用户名"
            width: parent.width * 0.8
        }

        FluTextBox {
            anchors.horizontalCenter: parent.horizontalCenter  // 确保水平居中
            id: personlinfoField
            placeholderText: "个人简介"
            width: parent.width * 0.8
        }

        FluButton {
            anchors.horizontalCenter: parent.horizontalCenter  // 确保水平居中
            text: "确认更改"
            width: parent.width * 0.8
            enabled: usernameField.text>0 && personlinfoField.text>0
            onClicked: {
                userInfo.userName=usernameField.text
                userInfo.userPersonalInfo=personlinfoField.text
                showWarning("更改个人信息成功")
                userNavView.push("qrc:/qt/Flight_Management_System_Client/views/ProfileView.qml")
            }
        }
    }
}
