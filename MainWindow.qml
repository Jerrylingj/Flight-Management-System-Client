import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluWindow {
    id: mainWindow
    width: Screen.width * 0.6
    height: Screen.height * 0.6
    visible: true
    title: qsTr("云途")

    stayTop: true
    showDark: true
    showStayTop: true

    FluNavigationView {
        id: navView
        anchors.fill: parent
        pageMode: FluNavigationViewType.NoStack
        displayMode: FluNavigationViewType.Auto

        // 使用 FluPaneItemExpander 包裹多个 FluPaneItem
        items: FluPaneItemExpander {
            title: "Main Menu"
            iconVisible: false

            FluPaneItem {
                id: item_home
                title: qsTr("首页")
                icon: FluentIcons.Home
                url: "qrc:/qt/Flight_Management_System_Client/views/HomeView.qml"
                onTap: { navView.push(url) }
            }

            FluPaneItem {
                id: item_flight_info
                title: qsTr("全部航班")
                icon: FluentIcons.Airplane
                url: "qrc:/qt/Flight_Management_System_Client/views/FlightInfoView.qml"
                onTap: { navView.push(url) }
            }

            FluPaneItem {
                id: item_orders
                title: qsTr("我的订单")
                icon: FluentIcons.ShoppingCart
                url: "qrc:/qt/Flight_Management_System_Client/views/OrdersView.qml"
                onTap: { navView.push(url) }
            }

            FluPaneItem {
                id: item_profile
                title: qsTr("个人中心")
                icon: FluentIcons.Contact
                url: "qrc:/qt/Flight_Management_System_Client/views/ProfileView.qml"
                onTap: { navView.push(url) }
            }
        }

        onLogoClicked: {
            console.log("Logo clicked");
        }


        Component.onCompleted: {
            navView.setCurrentIndex(0)
        }
    }
}
