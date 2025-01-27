import QtQuick 2.15
import FluentUI 1.0
import NetworkHandler 1.0

FluPage {
    id: loginView

    NetworkHandler{
        id: loginHandler
        // 枚举类型不知道为什么用不了，用了构建不成功
        property string curType:'login'
        onRequestSuccess:function(data){
            if(data['code'] === 200) {
                userInfo.myToken = data['data']['token']
                infoHandler.request('/api/user', NetworkHandler.GET, {}, userInfo.myToken)
                showSuccess(qsTr("登录成功"))
            }else{
                console.error(data['message'])
                showError(data['message'])
            }
        }
        onRequestFailed: (data)=>{console.log(JSON.stringify(data))}
    }

    NetworkHandler{
        id: infoHandler
        onRequestSuccess: function(data) {
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
        onRequestFailed: (data)=>{console.log(JSON.stringify(data))}
    }

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
                source: "../figures/user.png"
            }
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

        FluButton {
            anchors.horizontalCenter: parent.horizontalCenter  // 确保水平居中
            text: "登录"
            width: parent.width * 0.8
            enabled: emailField.text.length>0&&passwordField.text.length>0
            onClicked: {
                loginHandler.request('/api/login', NetworkHandler.POST, {
                                         email:emailField.text,
                                         password:passwordField.text
                                     })
            }
        }
    }
}
