import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15

FluFrame{
    z: 10
    id: filterBar
    Layout.fillWidth: true
    Layout.preferredHeight: 100
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

        // 出发地点与时间
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 10

            AddressPicker {
                id: departureAddressPicker
                Layout.fillWidth: true
                Layout.minimumWidth: 150
                Layout.maximumWidth: 200
            }

            AltAirDatePicker {
                id: startDatePicker
                Layout.fillWidth: true
                Layout.minimumWidth: 150
                Layout.maximumWidth: 200
            }
        }

        // Spacer 左侧
        Item {
            Layout.fillWidth: true
            Layout.preferredWidth: 20
        }

        // 箭头
        FluText {
            Layout.preferredWidth: 40
            text: "→"
            font.pixelSize: 20
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        // Spacer 右侧
        Item {
            Layout.fillWidth: true
            Layout.preferredWidth: 20
        }

        // 到达地点与时间
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 10

            AddressPicker {
                id: arrivalAddressPicker
                Layout.fillWidth: true
                Layout.minimumWidth: 150
                Layout.maximumWidth: 200
            }

            AltAirDatePicker {
                id: endDatePicker
                Layout.fillWidth: true
                Layout.minimumWidth: 150
                Layout.maximumWidth: 200
            }
        }

        // 还无法调节速度
        FluProgressButton {
            id: filterButton
            Layout.preferredWidth: 150
            text: qsTr("筛选")

            Timer {
                id: timer_progress
                interval: 30
                onTriggered: {
                    filterButton.progress = (filterButton.progress + 0.1).toFixed(1)
                    if (filterButton.progress === 1) {
                        timer_progress.stop()
                    } else {
                        timer_progress.start()
                    }
                }
            }

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
