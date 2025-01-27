import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts
import NetworkHandler 1.0

FluWindow {
    id: mainWindow
    width: Screen.width * 0.6
    height: Screen.height * 0.6
    minimumWidth: 800
    minimumHeight: 600
    visible: true
    title: qsTr("云途")

    stayTop: false
    showDark: true
    showStayTop: true

    property bool isAdmin: false // 标志当前是否管理员端
    property string adminCode:''

    NetworkHandler {
        id:networkHandler
        onRequestSuccess: function(data) {
            console.log(JSON.stringify(data))
            if(data.code !== 200) {
                showError(data.message)
                return
            }
            if(!data.data) {
                showError('错误')
                return
            }
            userInfo.authCode = adminCode
            authCodeDialog.close()
            isAdmin = true
            toggleSwitch.checked = true
            showSuccess('认证成功')
            authCodeDialog.close();
        }
        onRequestFailed: function(data){
            console.log(data)
        }
    }

    // 顶部切换开关
    RowLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.topMargin: 10
        spacing: 10
        FluToggleSwitch {
            id: toggleSwitch
            checked: false
            Layout.alignment: Qt.AlignVCenter
            text: isAdmin ? "切换为用户端" : "切换为管理员端"

            onCheckedChanged: {
                if(userInfo.authCode.length === 0){
                    checked = false;
                    authCodeDialog.open()
                }else{
                    isAdmin = checked;
                    console.log("当前模式: " + (isAdmin ? "管理员端" : "用户端"));
                }
            }
        }
    }

    FluContentDialog {
        id: authCodeDialog
        title: qsTr("授权码")
        contentWidth: 400
        contentHeight: 150

        contentDelegate: Component {
            Item {
                implicitWidth: parent.width
                implicitHeight: 80

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 20

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Item {
                            Layout.preferredWidth: 20
                        }

                        FluText {
                            text: qsTr("请输入授权码:");
                            font.pixelSize: 14
                            Layout.alignment: Qt.AlignVCenter
                            Layout.preferredWidth: 120
                        }

                        FluTextBox {
                            id: authCodeBox
                            Layout.fillWidth: true
                            Layout.maximumWidth: 180
                            echoMode: TextInput.Password
                            onTextChanged: {
                                adminCode = text;
                                console.log("adminCode: ", adminCode);
                            }
                        }
                    }
                }
            }
        }

        positiveText: qsTr("提交")
        onPositiveClickListener: ()=> {
            networkHandler.request('/api/user/auth', NetworkHandler.POST, { authCode: adminCode })
        }
    }

    // 用户端布局var
    FluNavigationView {
        id: userNavView
        anchors.fill: parent
        pageMode: FluNavigationViewType.NoStack
        displayMode: FluNavigationViewType.Auto
        visible: !isAdmin
        function navigateTo(url) {
            const notAllowRoutes = [
                                     "qrc:/qt/Flight_Management_System_Client/views/FlightFavoriteView.qml",
                                     "qrc:/qt/Flight_Management_System_Client/views/OrdersView.qml"
                                 ]
            console.log(notAllowRoutes.indexOf(url))
            if(userInfo.myToken.length === 0&&notAllowRoutes.indexOf(url) !== -1){
                userNavView.navigateTo("qrc:/qt/Flight_Management_System_Client/views/LoginView.qml")
                return
            }
            userNavView.push(url)
        }

        items: FluPaneItemExpander {
            title: qsTr("主菜单")
            iconVisible: false
            showEdit: true

            FluPaneItem {
                id: item_home
                title: qsTr("首页")
                icon: FluentIcons.Home
                url: "qrc:/qt/Flight_Management_System_Client/views/HomeView.qml"
                onTap: { userNavView.navigateTo(url) }
            }

            FluPaneItem {
                id: item_find
                title: qsTr("发现")
                icon: FluentIcons.QuickNote
                url: "qrc:/qt/Flight_Management_System_Client/views/FindView.qml"
                onTap: { userNavView.navigateTo(url) }
            }

            FluPaneItem {
                id: item_flight_info
                title: qsTr("全部航班")
                icon: FluentIcons.Airplane
                url: "qrc:/qt/Flight_Management_System_Client/views/FlightInfoView.qml"
                onTap: { userNavView.navigateTo(url) }
            }

            FluPaneItem {
                id: item_flight_favorite
                title: qsTr("我的收藏")
                icon: FluentIcons.FavoriteList
                url: "qrc:/qt/Flight_Management_System_Client/views/FlightFavoriteView.qml"
                onTap: { userNavView.navigateTo(url) }
            }

            FluPaneItem {
                id: item_orders
                title: qsTr("我的订单")
                icon: FluentIcons.ShoppingCart
                url: "qrc:/qt/Flight_Management_System_Client/views/OrdersView.qml"
                onTap: { userNavView.navigateTo(url) }
            }

            FluPaneItem {
                id: item_profile
                title: qsTr("个人中心")
                icon: FluentIcons.Contact
                url: "qrc:/qt/Flight_Management_System_Client/views/ProfileView.qml"
                onTap: { userNavView.navigateTo(url) }
            }
        }

        footerItems: FluPaneItemExpander {
            title: qsTr("主菜单")
            iconVisible: false

            FluPaneItem {
                id: item_about
                title: qsTr("关于我们")
                icon: FluentIcons.Info
                url: "qrc:/qt/Flight_Management_System_Client/views/AboutView.qml"
                onTap: { userNavView.navigateTo(url) }
            }

            FluPaneItem {
                id: item_client_server
                title: qsTr("客服")
                icon: FluentIcons.Message
                url: "qrc:/qt/Flight_Management_System_Client/views/ClientServerView.qml"
                onTap: { userNavView.navigateTo(url) }
            }
        }
    }

    // 管理员端布局
    FluNavigationView {
        id: agentNavView
        anchors.fill: parent
        pageMode: FluNavigationViewType.NoStack
        displayMode: FluNavigationViewType.Auto
        visible: isAdmin

        items: FluPaneItemExpander {
            title: qsTr("主菜单")
            iconVisible: false
            showEdit: true

            FluPaneItem {
                id: item_agent_home
                title: qsTr("首页")
                icon: FluentIcons.Home
                url: "qrc:/qt/Flight_Management_System_Client/views/HomeView.qml"
                onTap: { agentNavView.push(url) }
            }

            FluPaneItem {
                id: item_users_info
                title: qsTr("用户列表")
                icon: FluentIcons.ContactPresence
                url: "qrc:/qt/Flight_Management_System_Client/views/UsersInfoView.qml"
                onTap: { agentNavView.push(url) }
            }


            FluPaneItem {
                id: item_agent_flight_info
                title: qsTr("航班管理")
                icon: FluentIcons.Airplane
                url: "qrc:/qt/Flight_Management_System_Client/views/FlightInfoEditView.qml"
                onTap: { agentNavView.push(url) }
            }
        }

        footerItems: FluPaneItemExpander {
            iconVisible: false

            FluPaneItem {
                id: item_agent_about
                title: qsTr("关于我们")
                icon: FluentIcons.Info
                url: "qrc:/qt/Flight_Management_System_Client/views/AboutView.qml"
                onTap: { agentNavView.push(url) }
            }

        }

    }

    Component.onCompleted: {
        userNavView.setCurrentIndex(0)
        userNavView.push("qrc:/qt/Flight_Management_System_Client/views/HomeView.qml")
        agentNavView.setCurrentIndex((0))
    }
}
