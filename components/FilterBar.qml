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
    property string departureCity
    property string arrivalCity
    property var startDate
    property var endDate

    signal executeFliter()

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

        AltAirDatePicker {
            id: startDatePicker
            Layout.preferredWidth: 150
        }

        AltAirDatePicker {
            id: endDatePicker
            Layout.preferredWidth: 150
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
            width: 300
            text: qsTr("筛选")
            onClicked:{
                // console.log("点击查询按钮")
                filterButton.progress = 0
                timer_progress.restart()
                departureCity = departureAddressPicker.selectedCity;
                arrivalCity = arrivalAddressPicker.selectedCity;
                startDate = startDatePicker.current;
                endDate = endDatePicker.current;
                executeFliter();
            }
        }
    }
}
