import QtQuick 2.15
import FluentUI 1.0
import NetworkHandler 1.0

FluPage {
    id: loginPage

    NetworkHandler{
        id: networkHandler
        // 枚举类型不知道为什么用不了，用了构建不成功
        property string curType:'login'
        onRequestSuccess:function(data){
            switch(networkHandler.curType){
            case 'login':{
                if(data['code'] === 200) {
                    console.log(JSON.stringify(data['data'], null, 2))
                    userInfo.myToken = data['data']['token']
                    console.log(userInfo.myToken)
                    networkHandler.curType = 'user'
                    networkHandler.request('/api/user', NetworkHandler.GET, {}, userInfo.myToken)
                }else{
                    console.error(data['message'])
                }
                break
            }

            case 'user':{
                if(data['code'] === 200) {
                    console.log(JSON.stringify(data['data']))
                    const info = data['data']
                    userInfo.myMoney = info['balance']
                    userInfo.myAvatar = info['avatar_url']
                    userInfo.myCreateTime = info['created_at']
                    userInfo.userName = info['username']
                    userInfo.userEmail = info['email']
                }else{
                    console.error(data['message'])
                }
                break
            }
            default:{
                console.log("?")
            }
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
