import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../components"

FluPage {
    id: findView
    title: "发现"
    height: parent.height
    width: parent.width
    // background: Rectangle { radius: 5 }

    NoteList{
        id:list
        width: parent.width
        height: parent.height
        Component.onCompleted: {
            console.log(height,width)
        }
    }
}
