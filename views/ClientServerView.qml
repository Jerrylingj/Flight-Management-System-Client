import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

FluPage {
    id: clientServerView
    title: qsTr("客服咨询")
    background: Rectangle { radius: 5 }

    // ColumnLayout {
    //     anchors.fill: parent

    //     // 消息显示区域
    //     ListView {
    //         id: messageListView
    //         Layout.fillWidth: true
    //         Layout.fillHeight: true
    //         model: messageModel
    //         delegate: Item {
    //             width: messageListView.width
    //             height: textItem.paintedHeight + 20
    //             Text {
    //                 id: textItem
    //                 text: model.message
    //                 wrapMode: Text.Wrap
    //                 anchors {
    //                     left: parent.left
    //                     right: parent.right
    //                     leftMargin: 10
    //                     rightMargin: 10
    //                 }
    //             }
    //         }
    //     }

    //     // 输入区域
    //     RowLayout {
    //         Layout.fillWidth: true
    //         spacing: 10

    //         TextArea {
    //             id: inputArea
    //             Layout.fillWidth: true
    //             placeholderText: qsTr("请输入消息...")
    //         }

    //         Button {
    //             text: qsTr("发送")
    //             onClicked: {
    //                 if (inputArea.text.trim() !== "") {
    //                     messageModel.append({"message": inputArea.text})
    //                     inputArea.text = ""
    //                     messageListView.positionViewAtEnd()
    //                 }
    //             }
    //         }
    //     }
    // }

    // ListModel {
    //     id: messageModel
    // }
}
