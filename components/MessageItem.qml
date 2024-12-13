import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15

Item {
    property string type // 消息类型："agent" 或 "user"
    property string content // 消息内容
    property string avatarSource // 头像图片路径
    property int itemWidth
    width: itemWidth
    height: Math.max(agentRow.height, userRow.height)

    // Agent消息布局
    RowLayout{
        id: agentRow
        spacing: 10
        visible: type === "agent"
        anchors.left: parent.left
        Rectangle {
            width: 70
            height: 70
            Image {
                anchors.fill: parent
                source: avatarSource
            }
        }
        Text {
            font.pixelSize: 18
            text: content
        }
    }

    // User消息布局
    RowLayout {
        id: userRow
        spacing: 10
        visible: type === "user"
        anchors.right: parent.right
        Layout.alignment: Qt.AlignRight // 确保 RowLayout 右对齐
        FluText {
            text: content
            font.pixelSize: 18
            Layout.alignment: Qt.AlignRight
        }
        Rectangle {
            width: 70
            height: 70
            Layout.alignment: Qt.AlignRight
            Image {
                anchors.fill: parent
                source: avatarSource
            }
        }
    }





}
