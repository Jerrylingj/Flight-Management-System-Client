import QtQuick 2.15
import FluentUI 1.0

FluPage {
    id: registrationPage

    width: parent.width
    height:parent.height

    Column {
        spacing: 20
        anchors.centerIn: parent
        width: parent.width
        height:parent.height

        FluTextBox {
            id: emailField
            placeholderText: "邮箱"
            width: parent.width * 0.8
        }

        FluTextBox {
            id: passwordField
            placeholderText: "密码"
            width: parent.width * 0.8
            echoMode: TextInput.Password
        }

        FluButton {
            text: "注册"
            width: parent.width * 0.8
            enabled: true
            onClicked: {
                // 模拟注册
                console.log("注册成功！")
            }
        }
    }
}
