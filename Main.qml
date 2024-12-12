import QtQuick
import FluentUI

FluLauncher {
    id: app

    Component.onCompleted: {
        FluApp.init(app)  
        FluApp.useSystemAppBar = false      // 不使用原生的AppBar
        FluTheme.animationEnabled = true    // 开启动画
        FluTheme.nativeText = true          // 这个字体更清晰
        FluApp.windowIcon = "qrc:/qt/Flight_Management_System_Client/favicon.ico"

        // 配置各个页面路由
        FluRouter.routes = {
            "/": "qrc:/qt/Flight_Management_System_Client/MainWindow.qml",
        }
        FluRouter.navigate("/")
    }

}
