import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluWindow {
    id: mainWindow
    width: Screen.width * 0.6
    height: Screen.height * 0.6
    minimumWidth: 800
    minimumHeight: 600
    visible: true
    title: qsTr("云途")

    // 判断是否为管理员端
    /*
      由于当前userInfo没有管理员字段，暂时用userInfo.myToken代替
    */

    stayTop: false
    showDark: true
    showStayTop: true

    // 用户端布局var
    FluNavigationView {
        id: userNavView
        anchors.fill: parent
        pageMode: FluNavigationViewType.NoStack
        displayMode: FluNavigationViewType.Auto
        visible: !userInfo.myToken // 只有当Identity为false时显示用户端

        items: FluPaneItemExpander {
            title: qsTr("主菜单")
            iconVisible: false
            showEdit: true

            FluPaneItem {
                id: item_home
                title: qsTr("首页")
                icon: FluentIcons.Home
                url: "qrc:/qt/Flight_Management_System_Client/views/HomeView.qml"
                onTap: { userNavView.push(url) }
            }

            FluPaneItem {
                id: item_find
                title: qsTr("发现")
                icon: FluentIcons.QuickNote
                url: "qrc:/qt/Flight_Management_System_Client/views/FindView.qml"
                onTap: { userNavView.push(url) }
            }

            FluPaneItem {
                id: item_flight_info
                title: qsTr("全部航班")
                icon: FluentIcons.Airplane
                url: "qrc:/qt/Flight_Management_System_Client/views/FlightInfoView.qml"
                onTap: { userNavView.push(url) }
            }

            FluPaneItem {
                id: item_flight_favorite
                title: qsTr("我的收藏")
                icon: FluentIcons.FavoriteList
                url: "qrc:/qt/Flight_Management_System_Client/views/FlightFavoriteView.qml"
                onTap: { userNavView.push(url) }
            }

            FluPaneItem {
                id: item_orders
                title: qsTr("我的订单")
                icon: FluentIcons.ShoppingCart
                url: "qrc:/qt/Flight_Management_System_Client/views/OrdersView.qml"
                onTap: { userNavView.push(url) }
            }

            FluPaneItem {
                id: item_profile
                title: qsTr("个人中心")
                icon: FluentIcons.Contact
                url: "qrc:/qt/Flight_Management_System_Client/views/ProfileView.qml"
                onTap: { userNavView.push(url) }
            }
        }

        footerItems: FluPaneItemExpander {
            title: qsTr("主菜单")
            iconVisible: false

            FluPaneItem {
                id: item_client_server
                title: qsTr("客服")
                icon: FluentIcons.Message
                url: "qrc:/qt/Flight_Management_System_Client/views/ClientServerView.qml"
                onTap: { userNavView.push(url) }
            }
        }
    }

    // 管理员端布局
    FluNavigationView {
        id: agentNavView
        anchors.fill: parent
        pageMode: FluNavigationViewType.NoStack
        displayMode: FluNavigationViewType.Auto
        visible: userInfo.myToken // 只有当Identity为true时显示管理员端

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
        if (userInfo.myToken) {
            agentNavView.setCurrentIndex(0)
        } else {
            userNavView.setCurrentIndex(0)
        }
    }
}
