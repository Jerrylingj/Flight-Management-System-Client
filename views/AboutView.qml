import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "../components"

FluScrollablePage {
    title: qsTr("关于我们")

    FluFrame {
        Layout.fillWidth: true
        Layout.preferredHeight: 500
        padding: 10

        FluPivot {
            anchors.fill: parent
            currentIndex: 2

            FluPivotItem {
                title: qsTr("团队简介")
                contentItem: ColumnLayout {
                    width: parent.width
                    FluImage {
                        id: perssonelImage
                        Layout.preferredWidth: 250
                        Layout.preferredHeight: 250
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.topMargin: 20
                        source: "qrc:/qt/Flight_Management_System_Client/figures/personnel.png"
                    }
                }
            }
            FluPivotItem {
                title: qsTr("林国佳")
                contentItem: ColumnLayout {
                    width: parent.width
                    FluImage {
                        id: igjImage
                        Layout.preferredWidth: 150
                        Layout.preferredHeight: 150
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.topMargin: 20
                        source: "qrc:/qt/Flight_Management_System_Client/figures/lgj.png"
                    }
                }
            }

            FluPivotItem {
                title: qsTr("林省煜")
                contentItem: ColumnLayout {
                    width: parent.width
                    FluImage {
                        id: isyImage
                        Layout.preferredWidth: 150
                        Layout.preferredHeight: 150
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.topMargin: 20
                        source: "qrc:/qt/Flight_Management_System_Client/figures/lsy.png"
                    }
                }
            }

            FluPivotItem {
                title: qsTr("朱玄烨")
                contentItem: ColumnLayout {
                    width: parent.width
                    FluImage {
                        id: zxyImage
                        Layout.preferredWidth: 150
                        Layout.preferredHeight: 150
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.topMargin: 20
                        source: "qrc:/qt/Flight_Management_System_Client/figures/zxy.png"
                    }
                }
            }

            FluPivotItem {
                title: qsTr("杨普旭")
                contentItem: ColumnLayout {
                    width: parent.width
                    FluImage {
                        id: ypxImage
                        Layout.preferredWidth: 150
                        Layout.preferredHeight: 150
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.topMargin: 20
                        source: "qrc:/qt/Flight_Management_System_Client/figures/ypx.png"
                    }
                }
            }
        }
    }
}
