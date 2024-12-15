import QtQuick 2.15
import FluentUI 1.0
import NetworkHandler 1.0

FluPage {
    id: registrationPage

    NetworkHandler{
        id: networkHandler
        onRequestSuccess:function(data){
            if(data['code'] === 200) {
                console.log(JSON.stringify(data['data'], null, 2))
                userInfo.myToken = data['data']['token']
                console.log(userInfo.myToken)
            }else{
                console.error(data['message'])
            }
        }
        onRequestFailed: (data)=>{console.log(JSON.stringify(data))}
    }

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
            text: "登录"
            width: parent.width * 0.8
            enabled: emailField.text.length>0&&passwordField.text.length>0
            onClicked: {
                // 模拟注册
                networkHandler.request('/api/login', NetworkHandler.POST, {
                                           email:emailField.text,
                                           password:passwordField.text
                                       })
            }
        }
    }
}
