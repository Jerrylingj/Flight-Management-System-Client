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
        return totalWidth; // 最小100，最大为父宽度的70%
    }

    // Agent消息布局
    RowLayout {
        id: agentRow
        spacing: 10
        visible: type === "agent"
        anchors.left: parent.left
        anchors.margins: 20 // 左右边距设置
        Rectangle {
            width: 50
            height: 50
            radius: 25
            color: "transparent"
            border.color: "#DDDDDD"
            border.width: 1
            Image {
                id: agent
                anchors.fill: parent
                source: avatarSource
                layer.enabled: true
                layer.effect: MultiEffect {
                    maskEnabled: true
                    maskSource: ShaderEffectSource {
                        sourceItem: Rectangle {
                            width: agent.width
                            height: agent.height
                            radius: agent.width / 2 - 1
                            color: "black"
                        }
                    }
                }
            }
        }
        Rectangle {
            radius: 10
            color: "#F5F5F5"
            border.color: "#DDDDDD"
            border.width: 1
            Layout.preferredWidth: calculateTextWidth(content)  // 自动适应文本长度，最小50，最大400
            Layout.preferredHeight: Math.max(40, content.length / 40 * 20) // 自动调整高度
            Text {
                text: content
                font.pixelSize: 18
                wrapMode: Text.Wrap
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
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
            FluText {
                text: content
                font.pixelSize: 18
                wrapMode: Text.Wrap
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
        Rectangle {
            width: 50
            height: 50
            radius: 25
            color: "transparent"
            border.color: "#DDDDDD"
            border.width: 1
            Image {
                id: user
                anchors.fill: parent
                source: avatarSource
                layer.enabled: true
                layer.effect: MultiEffect {
                    maskEnabled: true
                    maskSource: ShaderEffectSource {
                        sourceItem: Rectangle {
                            width: user.width
                            height: user.height
                            radius: user.width / 2 - 1
                            color: "black"
                        }
                    }
                }
            }
        }
    }
}
