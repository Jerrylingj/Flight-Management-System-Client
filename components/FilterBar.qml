import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15

FluFrame{
    z: 10
    id: filterBar
    Layout.fillWidth: true
    Layout.preferredHeight: 80
    padding: 10
    clip: true

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 20

        AddressPicker {
            id: departureAddressPicker
            Layout.preferredWidth: 80
        }

        AddressPicker {
            id: arrivalAddressPicker
            Layout.preferredWidth: 80
        }

        FluDatePicker {
            id: startDatePicker
            Layout.preferredWidth: 120
        }

        FluDatePicker {
            id: endDatePicker
            Layout.preferredWidth: 120
        }

        Timer{
            id: timer_progress
            interval: 30
            onTriggered: {
                filterButton.progress = (filterButton.progress + 0.1).toFixed(1)
                if(filterButton.progress===1){
                    timer_progress.stop()
                }else{
                    timer_progress.start()
                }
            }
        }

        // 还无法调节速度
        FluProgressButton {
            id: filterButton
            width: 200
            text: qsTr("筛选")
            onClicked:{
                // console.log("点击查询按钮")
                filterButton.progress = 0
                timer_progress.restart()
                executeFliter();
            }
        }

        function executeFliter() {
            console.log("开始执行筛选");
        }
    }
}
