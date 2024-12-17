import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluContentPage {
    id: homeView

    FluCarousel{
        id:carousel
        anchors.fill: parent
        width: parent.width
        height: parent.height
        loopTime: 3000
        indicatorGravity: Qt.AlignHCenter | Qt.AlignTop
        delegate: Component{
            Item{
                anchors.fill: parent
                FluImage {
                    id: cover
                    anchors.fill: parent
                    source: model.url
                    asynchronous: true
                    fillMode: Image.PreserveAspectCrop
                }
                Rectangle{
                    height: 40
                    width: parent.width
                    anchors.bottom: cover.bottom
                    color: "#33000000"
                    FluText{
                        anchors.fill: parent
                        verticalAlignment: Qt.AlignVCenter
                        horizontalAlignment: Qt.AlignHCenter
                        text:model.title
                        color: FluColors.Grey10
                        font.bold: true
                        font.pixelSize: 20
                        font.family: "KaiTi"    // 楷体
                    }
                }
            }
        }
        Component.onCompleted: {
            carousel.model = [
                {url: "qrc:/qt/Flight_Management_System_Client/figures/homepage-cover.png", title: "欢迎来到云途！"},
                {url: "qrc:/qt/Flight_Management_System_Client/figures/background1.jpg", title: "少年心事当拏云,谁念幽寒坐呜呃。"},
                {url: "qrc:/qt/Flight_Management_System_Client/figures/background2.jpg", title: "云中谁寄锦书来，雁字回时，月满西楼。"},
                {url: "qrc:/qt/Flight_Management_System_Client/figures/background3.jpg", title: "云山苍苍，江水泱泱。"},
                {url: "qrc:/qt/Flight_Management_System_Client/figures/background4.jpg", title: "白云千载空悠悠，天高任我翱翔。"},
                {url: "qrc:/qt/Flight_Management_System_Client/figures/background5.jpg", title: "天高云淡，望断南飞雁。"},
                {url: "qrc:/qt/Flight_Management_System_Client/figures/background6.jpg", title: "欲上青天览明月，万里长空壮我心。"}
            ]
        }
    }
}
