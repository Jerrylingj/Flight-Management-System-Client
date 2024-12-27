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

    property var userData: []       // 用户信息
    property var editingUser: []    // 待编辑的用户信息
    property string defautUrl: "qrc:/qt/Flight_Management_System_Client/figures/avatar.png"

    NetworkHandler {
        id: networkHandler
        onRequestSuccess: function(responseData) {
            console.log("responseData：", JSON.stringify(responseData));
            userData = responseData.data.map(function(user) {
                return {
                    avatar: table_view.customItem(com_avatar, { avatar: user.avatar }),
                    name: user.name,
                    email: user.email,
                    password: user.password.slice(17),
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
            authCode: userInfo.authCode
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
                    width: 100,
                    readOnly: true
                },
                {
                    title: qsTr("邮箱"),
                    dataIndex: "email",
                    width: 200,
                    readOnly: true
                },
                {
                    title: qsTr("密码(加密)"),
                    dataIndex: "password",
                    width: 250,
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
                    width: 100
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
                    source: options && options.avatar ? options.avatar : defautUrl
                    sourceSize: Qt.size(80, 80) // 限制图片大小
                    fillMode: Image.PreserveAspectFit // 保持图片比例
                    onStatusChanged: {
                       if (status === Image.Error || status === Image.Null) {
                           source = defautUrl; // 如果加载失败，则切换到默认图片
                       }
                   }
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
                    text: qsTr("查看")
                    Layout.preferredWidth: 60
                    onClicked: {
                        editingUser = options.user;
                        updateUserDialog.open();
                    }
                }
            }
        }
    }


    // 修改用户信息的弹窗
    FluContentDialog {
        id: updateUserDialog
        title: qsTr("用户信息")
        contentWidth: 600
        contentHeight: 600

        contentDelegate: Component {
            Item {
                implicitWidth: parent.width
                implicitHeight: 400

                ColumnLayout {
                    spacing: 20
                    anchors.fill: parent
                    anchors.margins: 16

                    // 用户头像
                    FluClip {
                        id: avatarContainer
                        width: 100
                        height: 100
                        radius: [50, 50, 50, 50] // 圆形头像
                        Layout.alignment: Qt.AlignHCenter
                        Image {
                            anchors.fill: parent
                            source: editingUser.avatar || defautUrl
                            sourceSize: Qt.size(100, 100)
                            fillMode: Image.PreserveAspectFit

                            onStatusChanged: {
                                   if (status === Image.Error || status === Image.Null) {
                                       source = defautUrl; // 如果加载失败，则切换到默认图片
                                   }
                               }
                        }
                    }

                    // 用户名
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        FluText {
                            text: qsTr("名称: ")
                            font.pixelSize: 14
                            font.bold: true
                        }

                        FluTextBox {
                            placeholderText: qsTr("用户名")
                            Layout.fillWidth: true
                            text: editingUser.name
                            readOnly: true
                        }
                    }



                    // 邮箱
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        FluText {
                            text: qsTr("邮箱: ")
                            font.pixelSize: 14
                            font.bold: true
                        }

                        FluTextBox {
                            placeholderText: qsTr("邮箱")
                            Layout.fillWidth: true
                            text: editingUser.email
                            readOnly: true
                        }
                    }



                    // 显示密码（只读）
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        FluText {
                            text: qsTr("密码: ")
                            font.pixelSize: 14
                            font.bold: true
                        }

                        FluTextBox {
                            placeholderText: qsTr("密码")
                            Layout.fillWidth: true
                            text: editingUser.password
                            readOnly: true
                        }
                    }


                    // 显示余额（只读）
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        FluText {
                            text: qsTr("余额: ")
                            font.pixelSize: 14
                            font.bold: true
                        }

                        FluTextBox {
                            placeholderText: qsTr("余额")
                            Layout.fillWidth: true
                            text: String(editingUser.balance)
                            readOnly: true
                        }
                    }
                }
            }
        }
    }

}
