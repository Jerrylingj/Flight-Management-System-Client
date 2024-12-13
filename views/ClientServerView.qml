import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15
import "../components"

FluContentPage {
    id: clientchatPage
    title: qsTr("客服页面")
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

        }
    }

}

