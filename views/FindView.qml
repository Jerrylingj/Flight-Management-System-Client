import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../components"

FluPage {
    id: ordersView
    title: "发现"
    // background: Rectangle { radius: 5 }

    NoteList{
        width: parent.width
        height: parent.height
        Component.onCompleted: {
            console.log(height,width)
        }
    }
}
