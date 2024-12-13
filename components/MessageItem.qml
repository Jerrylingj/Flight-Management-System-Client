import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15

Item {
    property string type // 消息类型："agent" 或 "user"
    property string content // 消息内容
    property string avatarSource // 头像图片路径

    width: parent.width
    height: implicitHeight

    RowLayout {
        spacing: 10

        Rectangle{
            width: 70
            height: 70
            Image {
                anchors.fill: parent
                source: avatarSource
            }
        }

        FluText {
            text: content // 将 text 绑定到 content 属性
            font.pixelSize: 14

        }

    }
}
