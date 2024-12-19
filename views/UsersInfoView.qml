import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "../components"

FluScrollablePage{
    id: usersInfoView
    title: qsTr("用户列表")

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 400
        padding: 10


    }
}
