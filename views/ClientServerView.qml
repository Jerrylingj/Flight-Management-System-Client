import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15
import NetworkHandler 1.0
import "../components"

FluContentPage {
    id: clientchatPage
    title: qsTr("客服")
    background: Rectangle { radius: 5 }
    property var messages: [
{role:"system", content:"你是一个航班信息管理系统的客服，你可以查询航班信息。你需要准确地回答客户，如果你不知道你应该直接回答不知道而不是编造一条数据"}
    ]

    NetworkHandler{
        id: networkHandler
        onRequestSuccess: function(data){
            console.log(JSON.stringify(data.data))
            if(data['code'] === 200){
                const msg = data.data
                listModel.append(msg)
                clientchatPage.messages.push(msg)
            }else{
                // error
            }


        }
        onRequestFailed: function(data){
            console.error(data.message)
        }
    }

    // 消息列表区域
    Flickable {
        anchors.top:parent.top
        anchors.left:parent.left
        anchors.right: parent.right
        anchors.bottom: inputRow.top

        id: messageScroll

        contentHeight: messageList.height
        clip: true

        ColumnLayout {
            id: messageList
            width: parent.width
            spacing: 50

            Repeater {
                width: parent.width
                model: ListModel{
                    id:listModel
                }

                delegate: MessageItem {
                    type: role
                    content: model.content
                    avatarSource: role === 'user'?"../figures/avatar.jpg":"../figures/nailong.jpg"
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
            FluContentDialog{
                id:quittextDialog
                title: "字数过长"
            }
            onClicked: {
                var newMessage=inputField.text.trim()
                if(newMessage.length>=20){
                    quittextDialog.open()
                }

                else if(newMessage!=="" && newMessage.length < 20){
                    // 创建一个新的消息对象
                    const msg = { role: "user", content: newMessage };

                    listModel.append(msg)
                    clientchatPage.messages.push(msg)

                    inputField.text = ""; // 清空输入框

                    networkHandler.request("/api/aichat", NetworkHandler.POST, {messages:clientchatPage.messages})
                    // 滚动到底部
                    messageScroll.contentY = messageScroll.contentHeight;
                }

            }


        }
    }

}

