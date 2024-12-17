import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluContentPage {
    id: homeView

    FluCarousel{
        id:carousel
        width: parent.width
        height: 400
        delegate: Component{
            FluImage {
                anchors.fill: parent
                source: model.url
                asynchronous: true
                fillMode:Image.PreserveAspectCrop
            }
        }
        Component.onCompleted: {
            carousel.model = [{url:"qrc:/qt/Flight_Management_System_Client/figures/homepage-cover.png"},{url:"qrc:/qt/Flight_Management_System_Client/figures/background1.jpg"},{url:"qrc:/qt/Flight_Management_System_Client/figures/background2.jpg"}, {url:"qrc:/qt/Flight_Management_System_Client/figures/background3.jpg"}, {url:"qrc:/qt/Flight_Management_System_Client/figures/background4.jpg"}]
        }
    }
}
