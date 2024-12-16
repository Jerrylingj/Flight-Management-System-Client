import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15
import NetworkHandler 1.0
import "../components"

FluContentPage {
    id: flightInfoPage
    title: qsTr("航班信息")

    property var flightData: []   // 所有航班数据
    property var filteredData: [] // 筛选后的航班数据

    NetworkHandler {
        id: networkHandler
        onRequestSuccess: function(responseData) {
            console.log("请求成功，返回数据：", JSON.stringify(responseData));
            flightData = responseData.data.map(function(flight) {
                flight.checked = false; // 添加选中状态
                return flight;
            });
            filterFlights(); // 刷新筛选
        }
        onRequestFailed: function(errorMessage) {
            console.log("请求失败：", errorMessage);
            flightData = [];
        }
    }

    function fetchFlightData() {
        const url = "/api/flights";
        networkHandler.request(url, NetworkHandler.GET);
    }

    Component.onCompleted: fetchFlightData();

    // 筛选航班数据
    function filterFlights() {
        filteredData = flightData; // 默认不过滤所有数据
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        // 筛选面板
        FluFrame {
            id: filterPanel
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            padding: 10

            RowLayout {
                spacing: 20
                anchors.fill: parent

                AddressPicker {
                    id: departureAddressPicker
                    onAccepted: filterFlights();
                }

                AddressPicker {
                    id: arrivalAddressPicker
                    onAccepted: filterFlights();
                }

                FluDatePicker {
                    id: datePicker
                    Layout.preferredWidth: 180
                }
            }
        }

        FluTableView {
            id: flightTable
            Layout.fillWidth: true
            Layout.fillHeight: true
            // rowHeight: 60 // 增加行高

            columnSource: [
                { title: qsTr("选择"), dataIndex: "checkbox", width: 80, editDelegate: checkboxDelegate },
                { title: qsTr("航班号"), dataIndex: "flightNumber" },
                { title: qsTr("起飞时间"), dataIndex: "departureTime" },
                { title: qsTr("到达时间"), dataIndex: "arrivalTime" },
                { title: qsTr("起点机场"), dataIndex: "departureAirport" },
                { title: qsTr("终点机场"), dataIndex: "arrivalAirport" },
                { title: qsTr("价格"), dataIndex: "price" },
                { title: qsTr("航空公司"), dataIndex: "airlineCompany" },
                { title: qsTr("状态"), dataIndex: "status" },
                { title: qsTr("操作"), dataIndex: "action", width: 200, editDelegate: actionDelegate }
            ]

            dataSource: filteredData

            // 复选框组件
            Component {
                id: checkboxDelegate
                Item {
                    FluCheckBox {
                        anchors.centerIn: parent
                        checked: modelData.checked
                        onClicked: {
                            modelData.checked = !modelData.checked;
                            console.log("复选框状态:", modelData.checked);
                        }
                    }
                }
            }

            // 操作按钮组件
            Component {
                id: actionDelegate
                Item {
                    RowLayout {
                        spacing: 10
                        anchors.centerIn: parent

                        FluFilledButton {
                            text: qsTr("编辑")
                            Layout.preferredWidth: 60
                            onClicked: {
                                console.log("编辑航班:", modelData.flightNumber);
                                // 这里添加编辑逻辑
                            }
                        }

                        FluButton {
                            text: qsTr("删除")
                            Layout.preferredWidth: 60
                            onClicked: {
                                var index = flightData.indexOf(modelData);
                                if (index !== -1) {
                                    flightData.splice(index, 1);
                                    filterFlights();
                                    console.log("删除航班:", modelData.flightNumber);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
