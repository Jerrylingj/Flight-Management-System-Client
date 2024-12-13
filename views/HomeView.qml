import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluContentPage {
    id: homeView
    background: Rectangle {
        radius: 5
        anchors.rightMargin: 10
    }

    FluImage {
        id: home_cover
        source: "../figures/homepage-cover.png"
        fillMode: Image.PreserveAspectFit
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        onStatusChanged: {
            if (status === Image.Error) {
                console.error("图像加载失败，请重试");
            }
        }
        clickErrorListener: function() {
            source = "https://example.com/alternative_image.jpg";
        }
    }
}
