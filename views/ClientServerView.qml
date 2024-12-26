import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15
import NetworkHandler 1.0
import "../components"

FluContentPage {
    id: clientchatPage
    property bool button_enable: true
    title: qsTr("客服")
    // background: Rectangle { radius: 5 }
    property var messages: [
        {role:"system", content:"你是一个航班信息管理系统的客服，你可以查询航班信息。你需要准确地回答客户，如果你不知道你应该直接回答不知道而不是编造一条数据"}
    ]

    Component.onCompleted:  {
        for(const item of userInfo.myJsonArray)
        {
            listModel.append(item)
            messages.push(item)
        }
    }

    NetworkHandler{
        id: networkHandler
        onRequestSuccess: function(data){
            button_enable=true
            console.log(JSON.stringify(data.data))
            if(data['code'] === 200){
                const msg = data.data
                listModel.append(msg)
                clientchatPage.messages.push(msg)
                userInfo.appendToMyJsonArray(msg)
                messageScroll.contentY = messageScroll.contentHeight;
            }
        }
        onRequestFailed: function(data){
            button_enable=true
            console.error(data.message)
        }
    }

    // 消息列表区域
    Flickable {
        // anchors.fill: parent
        id: messageScroll
        anchors.top:parent.top
        width:parent.width
        height: parent.height - inputRow.height
        contentHeight: messageList.height
        clip: true

        ColumnLayout {
            id: messageList
            width: parent.width
            spacing: 50

            Repeater {
                width: parent.width
                model: ListModel{
                    id: listModel
                }

                delegate: MessageItem {
                    type: role
                    content: model.content
                    avatarSource: role === 'user'?userInfo.myAvatar:"../figures/nailong.jpg"
                    width: clientchatPage.width
                }
            }
        }
    }

    RowLayout {
        id: inputRow
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 10

        FluTextBox {
            id: inputField
            placeholderText: qsTr("请输入消息")
            Layout.fillWidth: true
        }

        FluFilledButton {
            text: qsTr("发送")
            enabled: button_enable
            onClicked: {
                var newMessage=inputField.text.trim()
                if(newMessage.length>=30){
                    showWarning("字数过长");
                    inputField.text = ""
                }

                else if(newMessage!=="" && newMessage.length < 20){
                    button_enable = false
                    // 创建一个新的消息对象
                    const msg = { role: "user", content: newMessage };
                    userInfo.appendToMyJsonArray(msg)
                    listModel.append(msg)
                    clientchatPage.messages.push(msg)

                    inputField.text = ""; // 清空输入框

                    networkHandler.request("/api/aichat", NetworkHandler.POST, {messages:messages})
                    // 滚动到底部
                    messageScroll.contentY = messageScroll.contentHeight;
                }

            }


        }
    }

}
