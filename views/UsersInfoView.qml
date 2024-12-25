import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import NetworkHandler 1.0
import "../components"

FluContentPage {
    id: usersInfoView
    title: qsTr("用户列表")

    // property var userData: [] // 用户信息
    property var userData: []

    NetworkHandler {
        id: networkHandler
        onRequestSuccess: function(responseData) {
            // console.log("responseData：", JSON.stringify(responseData));
            userData = responseData.data.map(function(user) {
                return {
                    avatar: table_view.customItem(com_avatar, { avatar: user.avatar }),
                    name: user.name,
                    email: user.email,
                    balance: user.balance,
                    action: table_view.customItem(com_action, { user: user })
                };
            })
        }
        onRequestFailed: function(errorMessage) {
            console.log("请求失败：", errorMessage);
        }
    }

    // 获取用户列表
    function fetchUserData() {
        console.log("获取用户信息");
        const url = "/api/userlist";
        const body = {
            authCode: "123"
        };
        networkHandler.request(url, NetworkHandler.POST, body);
    }

    Component.onCompleted: {
        fetchUserData();
    }

    ColumnLayout {
        anchors.fill: parent
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 16

        FluTableView {
            id: table_view
            Layout.fillWidth: true
            Layout.fillHeight: true

            columnSource: [
                {
                    title: qsTr("头像"),
                    dataIndex: "avatar",
                    readOnly: true,
                    width: 100

                },
                {
                    title: qsTr("用户名"),
                    dataIndex: "name",
                    width: 150,
                    readOnly: true
                },
                {
                    title: qsTr("邮箱"),
                    dataIndex: "email",
                    width: 200,
                    readOnly: true
                },
                {
                    title: qsTr("余额"),
                    dataIndex: "balance",
                    readOnly: true,
                    width: 100
                },
                {
                    title: qsTr("操作"),
                    dataIndex: "action",
                    frozen: true,
                    width: 160
                }

            ]

            dataSource: userData

            Component.onCompleted: {
                console.log("用户信息：", JSON.stringify(dataSource));
            }
        }
    }

    // 用户头像
    Component {
        id: com_avatar
        Item {
            FluClip {
                anchors.centerIn: parent
                width: 40
                height: 40
                radius: [20, 20, 20, 20] // 圆形效果
                Image {
                    anchors.fill: parent
                    source: options && options.avatar ? options.avatar : "qrc:/default_avatar.png"
                    sourceSize: Qt.size(80, 80) // 限制图片大小
                    fillMode: Image.PreserveAspectFit // 保持图片比例
                }
            }
        }
    }

    // 操作
    Component {
        id: com_action
        Item {
            RowLayout {
                spacing: 10
                anchors.centerIn: parent

                FluFilledButton {
                    text: qsTr("编辑")
                    Layout.preferredWidth: 60
                    onClicked: {
                    }
                }

                FluButton {
                    text: qsTr("删除")
                    Layout.preferredWidth: 60
                    onClicked: {
                    }
                }
            }
        }
    }


}
