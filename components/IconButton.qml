import QtQuick
import QtQuick.Layouts 1.15
import FluentUI 1.0

Item {
    property string url_source: "none"
    property string name: "none"
    property int size: 24
    RowLayout{
        FluClip{
            width: size
            height: size
            radius: [size/2, size/2, size/2, size/2]
            Image {
                anchors.fill: parent
                source: url_source
            }
        }
        FluFilledButton{

        }
    }
}
