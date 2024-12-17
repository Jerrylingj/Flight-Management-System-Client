import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts

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

    // 顶部切换开关
    RowLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.topMargin: 10
        spacing: 10
        FluToggleSwitch {
            id: toggleSwitch
            checked: isAdmin
            Layout.alignment: Qt.AlignVCenter
            text: isAdmin ? "切换为用户端" : "切换为管理员端"

            onCheckedChanged: {
                isAdmin = checked;
                userNavView.visible = !isAdmin;
                agentNavView.visible = isAdmin;
                console.log("当前模式: " + (isAdmin ? "管理员端" : "用户端"));
            }
        }
    }

    // 用户端布局var
    FluNavigationView {
        id: userNavView
        anchors.fill: parent
        pageMode: FluNavigationViewType.NoStack
        displayMode: FluNavigationViewType.Auto
        visible: true
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
        displayMode: FluNatruevigationViewType.Auto
        visible: false

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

            FluPaneItem {
                id: item_agent_server
                title: qsTr("用户咨询")
                icon: FluentIcons.Message
                url: "qrc:/qt/Flight_Management_System_Client/views/AgentServerView.qml"
                onTap: { agentNavView.push(url) }
            }
        }

    }

    Component.onCompleted: {
        // if (userInfo.myToken) {
        //     agentNavView.setCurrentIndex(0)
        // } else {
        //     userNavView.setCurrentIndex(0)
        // }
        userNavView.setCurrentIndex(0)
        agentNavView.setCurrentIndex((0))
    }
}
