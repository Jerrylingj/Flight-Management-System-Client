import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15
import QtQuick.Effects

Item {
    property string type // 消息类型："agent" 或 "user"
    property string content // 消息内容
    property string avatarSource // 头像图片路径
    property int itemWidth
    width: itemWidth
    height: Math.max(agentRow.height, userRow.height)

    // 动态计算文本宽度
    function calculateTextWidth(text) {
        var totalWidth = 0;
        for (var i = 0; i < text.length; i++) {
            var charCode = text.charCodeAt(i);
            if (charCode >= 0x4e00 && charCode <= 0x9fff) {
                totalWidth += 20; // 中文字符宽度
            } else {
                totalWidth += 12; // 英文、数字字符宽度
            }
        }
        return totalWidth + 10; // 最小100，最大为父宽度的70%
    }


    // Agent消息布局
    RowLayout {
        id: agentRow
        spacing: 10
        visible: type === "assistant"
        anchors.left: parent.left
        //anchors.margins: 5 // 左右边距设置
        width: parent.width
        Component.onCompleted: {
            console.log("raw layout",x,y,height,width)
        }
        //width:parent.width
        FluClip {
            id:assistantAvatar
            width: 50
            height: 50
            radius: [25, 25, 25, 25]
            Image {
                id: agent
                anchors.fill: parent
                source: avatarSource
            }
            Component.onCompleted: {
                console.log("clip",x,y,height,width)
            }
        }
        Rectangle {
            radius: 10
            //anchors.left: assistantAvatar.right + 5
            width:(agentRow.width - assistantAvatar.width) * 0.5
            height: text.implicitHeight + 20 // 根据文本高度动态调整
            color: "#F5F5F5"
            border.color: "#DDDDDD"
            border.width: 1
            Text {
                anchors.centerIn: parent
                id:text
                text: content
                font.pixelSize: 18
                width:parent.width * 0.9
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }
            Component.onCompleted: {
                console.log("rectangle",x,y,height,width)
            }
        }
    }

    // User消息布局
    RowLayout {
        id: userRow
        spacing: 10
        visible: type === "user"
        anchors.right: parent.right
        anchors.margins: 20 // 左右边距设置
        Rectangle {
            radius: 10
            color: "#D1F5FF"
            border.color: "#0099FF"
            border.width: 1
            Layout.preferredWidth: calculateTextWidth(content) // 自动适应文本长度
            Layout.preferredHeight: Math.max(40, content.length / 40 * 20) // 自动调整高度
            Text {
                text: content
                font.pixelSize: 18
                wrapMode: Text.Wrap
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }
        }

        FluClip {
            width: 50
            height: 50
            radius: [25, 25, 25, 25]
            Image {
                id: user
                anchors.fill: parent
                source: avatarSource
            }
        }
    }
}
