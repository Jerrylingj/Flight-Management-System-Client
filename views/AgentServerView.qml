import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15
import "../components"

FluContentPage {
    id: agentchatPage
    title: qsTr("用户")
    // background: Rectangle { radius: 5 }
    property var messages: [
        { type: "user", content: "我想看看航班信息", avatar: "../figures/avatar.jpg" },
        { type: "agent", content: "我是奶龙", avatar: "../figures/nailong.jpg" },
        { type: "user", content: "我想看看航班信息", avatar: "../figures/avatar.jpg" },
        { type: "agent", content: "我是奶龙", avatar: "../figures/nailong.jpg" },
        { type: "user", content: "我想看看航班信息", avatar: "../figures/avatar.jpg" },
        { type: "agent", content: "我是奶龙", avatar: "../figures/nailong.jpg" },
        { type: "user", content: "我想看看航班信息", avatar: "../figures/avatar.jpg" },
        { type: "agent", content: "我是奶龙", avatar: "../figures/nailong.jpg" }
    ]

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
                model: messages
                delegate: MessageItem {
                    type: modelData.type
                    content: modelData.content
                    avatarSource: modelData.avatar
                    width: agentchatPage.width
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
            onClicked: {
                var newMessage=inputField.text.trim()
                if(newMessage!=="" && newMessage.length < 20){
                    // 创建一个新的消息对象
                    var message = { type: "user", content: newMessage, avatar: "../figures/avatar.jpg" };

                    // 更新 messages 数组并强制刷新
                    var tempMessages = agentchatPage.messages.slice(); // 复制当前的消息数组
                    tempMessages.push(message); // 添加新消息
                    agentchatPage.messages = []; // 置空以触发变化通知
                    agentchatPage.messages = tempMessages; // 设置为新的消息数组

                    inputField.text = ""; // 清空输入框

                    // 滚动到底部
                    messageScroll.contentY = messageScroll.contentHeight;
                }

            }


        }
    }

}

