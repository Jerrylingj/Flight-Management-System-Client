import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15
import NetworkHandler 1.0
import "../components"

FluContentPage {
    id: flightEditPage
    title: qsTr("航班编辑")

    property var flightData: []   // 航班数据

    NetworkHandler {
        id: networkHandler
        onRequestSuccess: function(responseData) {
            console.log("请求成功，返回数据：", JSON.stringify(responseData));
            flightData = responseData.data.map(function(flight) {
                flight.isEdited = false; // 标记为未编辑状态
                return flight;
            });
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

    function saveFlight(flight) {
        const url = "/api/flights/" + flight.flightId;
        const data = {
            flightNumber: flight.flightNumber,
            departureTime: flight.departureTime,
            arrivalTime: flight.arrivalTime,
            departureAirport: flight.departureAirport,
            arrivalAirport: flight.arrivalAirport,
            price: flight.price,
            status: flight.status,
        };
        console.log("保存航班:", JSON.stringify(data));
        networkHandler.request(url, NetworkHandler.PUT, data);
    }

    function deleteFlight(flightId) {
        const url = "/api/flights/" + flightId;
        console.log("删除航班 ID:", flightId);
        networkHandler.request(url, NetworkHandler.DELETE);
    }

    Component.onCompleted: {
        fetchFlightData(); // 页面加载时获取航班数据
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        FluFrame {
            id: filterPanel
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            padding: 10
            clip: true

            RowLayout {
                anchors.fill: parent
                spacing: 20

                FluButton {
                    text: qsTr("新增航班")
                    onClicked: {
                        const newFlight = {
                            flightId: "new_" + Date.now(),
                            flightNumber: "",
                            departureTime: new Date().toISOString(),
                            arrivalTime: new Date().toISOString(),
                            departureAirport: "",
                            arrivalAirport: "",
                            price: 0,
                            status: "正常",
                            isEdited: true,
                        };
                        flightData.push(newFlight);
                    }
                }
            }
        }

        Flickable {
            y: filterPanel.height
            width: parent.width
            height: parent.height - filterPanel.height
            contentWidth: parent.width
            clip: true

            ColumnLayout {
                id: columnLayout
                width: parent.width
                spacing: 10

                Repeater {
                    model: flightData
                    FlightInfoCard {
                        width: parent.width
                        height: 100

                        flightNumber: modelData.flightNumber
                        departureTime: modelData.departureTime
                        arrivalTime: modelData.arrivalTime
                        departureAirport: modelData.departureAirport
                        arrivalAirport: modelData.arrivalAirport
                        price: modelData.price
                        status: modelData.status
                        editable: true

                        onFlightEdited: function(key, value) {
                            modelData[key] = value;
                            modelData.isEdited = true;
                        }

                        RowLayout {
                            spacing: 10
                            FluButton {
                                text: qsTr("保存")
                                enabled: modelData.isEdited
                                onClicked: {
                                    saveFlight(modelData);
                                    modelData.isEdited = false; // 重置编辑状态
                                }
                            }
                            FluButton {
                                text: qsTr("删除")
                                onClicked: deleteFlight(modelData.flightId);
                            }
                        }
                    }
                }
            }

            contentHeight: columnLayout.height
        }
    }
}
