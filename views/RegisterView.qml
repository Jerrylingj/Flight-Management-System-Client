import QtQuick 2.15
import FluentUI 1.0
import NetworkHandler 1.0

FluPage {
    id: registrationView

    NetworkHandler{
        id:networkHandler_gettoken
        onRequestSuccess:function(data){
            console.log("函数被调用了")

            if(data['code'] === 200) {
                userInfo.myToken = data['data']['token']
                woyebuzhidao.request('/api/user', NetworkHandler.GET, {}, userInfo.myToken)
            }else{
                console.error(data['message'])
                showError(data['message'])
            }

        }
    }

    NetworkHandler{
        id:woyebuzhidao
        onRequestSuccess: function(data){
            if(data['code'] === 200) {
                const info = data['data']
                console.log(JSON.stringify(info))
                userInfo.myMoney = info['balance']
                userInfo.myAvatar = info['avatar_url']
                userInfo.myCreateTime = info['created_at']
                userInfo.userName = info['username']
                userInfo.userEmail = info['email']
                userNavView.push("qrc:/qt/Flight_Management_System_Client/views/ProfileView.qml")
                userNavView.setCurrentIndex(5);
            } else{
                console.error(data['message'])
                showError(qsTr(data['message']))
            }
        }
    }

    NetworkHandler{
        id: networkHandler
        onRequestSuccess:function(data){
            if(data['code'] === 200) {
                if(data['data'].length>10){
                    registrationView.value = data['data']
                }else{
                    console.log(data['data'])
                    networkHandler_gettoken.request('/api/login', NetworkHandler.POST, {
                                                        email:emailField.text,
                                                        password:passwordField.text
                                                    })
                    showSuccess(qsTr("注册成功"))
                }
            }else{
                console.error(data['message'])
                showError(qsTr(data['message']))
            }
        }
        onRequestFailed: (data)=>{
                             console.log("error",JSON.stringify(data))
                         }
    }

    width: parent.width
    height:parent.height

    property string value:""

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
                source: "../figures/login-flight.png"
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

            id: emailField
            placeholderText: "邮箱"
            width: parent.width * 0.8
        }

        FluTextBox {
            anchors.horizontalCenter: parent.horizontalCenter  // 确保水平居中

            id: passwordField
            placeholderText: "密码"
            width: parent.width * 0.8
            echoMode: TextInput.Password
        }

        FluTextBox {
            anchors.horizontalCenter: parent.horizontalCenter  // 确保水平居中

            id: confirmPasswordField
            placeholderText: "确认密码"
            width: parent.width * 0.8
            echoMode: TextInput.Password
        }

        FluTextBox {
            anchors.horizontalCenter: parent.horizontalCenter  // 确保水平居中

            id: captchaField
            placeholderText: "验证码"
            width: parent.width * 0.8
        }

        FluButton {
            anchors.horizontalCenter: parent.horizontalCenter  // 确保水平居中

            text: "发送验证码"
            width: parent.width * 0.8
            onClicked: {
                networkHandler.request("/api/send-code", NetworkHandler.POST, {email:emailField.text})
            }
        }

        FluButton {
            anchors.horizontalCenter: parent.horizontalCenter  // 确保水平居中

            text: "注册"
            width: parent.width * 0.8
            enabled: usernameField.text.length>0&&emailField.text.length>0&&passwordField.text.length>0&&confirmPasswordField.text.length>0&&captchaField.text.length>0&&registrationView.value.length>0

            onClicked: {
                // 模拟注册
                if(confirmPasswordField.text!==passwordField.text){
                    showWarning("密码不一致")
                }
                else{
                    networkHandler.request("/api/register", NetworkHandler.POST, {
                                               email:emailField.text,
                                               username:usernameField.text,
                                               password:passwordField.text,
                                               code:captchaField.text,
                                               value:registrationView.value
                                           })
                }
            }
        }
    }
}
