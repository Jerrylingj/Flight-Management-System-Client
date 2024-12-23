import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import NetworkHandler 1.0
import "../components"

FluScrollablePage{
    id: usersInfoView
    title: qsTr("用户列表")

    property var userData: []   // 用户信息

    NetworkHandler {
        id: networkHandler
        onRequestSuccess: function(responseData) {
            console.log("responseData：", JSON.stringify(responseData));
            userData = responseData;
        }
        onRequestFailed: function(errorMessage) {
            console.log("请求失败：", errorMessage);
        }
    }

    // 获取用户列表
    function fetchUserData() {
        console.log("获取用户信息");
        var url = "/api/userlist"
        const body = {
            authCode: "123",
        }
        networkHandler.request(url, NetworkHandler.POST, body);
    }

    Component.onCompleted: fetchUserData();

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 400
        padding: 10


    }
}
