import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15
import NetworkHandler 1.0
import "../components"

FluContentPage {
    id: flightInfoEditView
    title: qsTr("航班信息")

    property var flightData: []   // 所有航班数据
    property var filteredData: [] // 筛选后的航班数据

    NetworkHandler {
        id: networkHandler
        onRequestSuccess: function(responseData) {
            // console.log("请求成功，返回数据：", JSON.stringify(responseData));
            flightData = responseData.data.map(function(flight) {
                flight.action = table_view.customItem(com_action, { flight: JSON.stringify(JSON.parse(JSON.stringify(flight)))}); // 新增操作列
                return flight;
            });
            filterFlights(); // 刷新筛选
        }
        onRequestFailed: function(errorMessage) {
            console.log("请求失败：", errorMessage);
            flightData = [];
        }
    }

    // 删除航班
    NetworkHandler {
        id: delHandler
        onRequestSuccess: function(response) {
            console.log("返回信息:", JSON.stringify(response));
            fetchFlightData();
        }
        onRequestFailed: function(errorMessage) {
            console.error("删除航班失败:", errorMessage);
        }
    }

    // 添加航班
    NetworkHandler {
        id: addHandler
        onRequestSuccess: function(response) {;
            console.log("返回信息:", JSON.stringify(response));
            fetchFlightData();
        }
        onRequestFailed: function(errorMessage) {
            console.error("添加航班失败:", errorMessage);
        }
    }

    // 更新航班
    NetworkHandler {
        id: updateHandler
        onRequestSuccess: function(response) {
            console.log("返回信息:", JSON.stringify(response));
            fetchFlightData();
        }
        onRequestFailed: function(errorMessage) {
            console.error("更新航班失败:", errorMessage);
        }
    }


    function fetchFlightData() {
        const url = "/api/flights";
        networkHandler.request(url, NetworkHandler.GET);
    }

    // 添加航班逻辑
    function addFlight(flight) {
        const url = "/api/flights/add";

        const body = {
            authCode: "123",
            flightNumber: flight.flightNumber,
            departureCity: flight.departureCity,
            arrivalCity: flight.arrivalCity,
            departureTime: flight.departureTime,
            arrivalTime: flight.arrivalTime,
            price: flight.price,
            departureAirport: flight.departureAirport,
            arrivalAirport: flight.arrivalAirport,
            airlineCompany: flight.airlineCompany,
            checkinStartTime: flight.checkinStartTime,
            checkinEndTime: flight.checkinEndTime,
            status: flight.status
        };



        addHandler.request(url, NetworkHandler.POST, body);
    }

    // 更新航班逻辑
    function updateFlight(flight) {
        const url = "/api/flights/update";
        console.log("flightId", flight.flightId);
        const body = {
            authCode: "123",
            flightId: flight.flightId,
            flightNumber: flight.flightNumber,
            departureCity: flight.departureCity,
            arrivalCity: flight.arrivalCity,
            departureTime: flight.departureTime,
            arrivalTime: flight.arrivalTime,
            price: flight.price,
            departureAirport: flight.departureAirport,
            arrivalAirport: flight.arrivalAirport,
            airlineCompany: flight.airlineCompany,
            checkinStartTime: flight.checkinStartTime,
            checkinEndTime: flight.checkinEndTime,
            status: flight.status
        };
        console.log("body",JSON.stringify(body))
        updateHandler.request(url, NetworkHandler.POST, body);
    }


    // 删除航班逻辑
    function deleteFlight(flight) {
        const url = "/api/flights/del";
        const body = {
            authCode: "123",
            flightId: flight.flightId
        };
        delHandler.request(url, NetworkHandler.POST, body);
    }

    Component.onCompleted: fetchFlightData();

    // 筛选航班数据
    function filterFlights() {
        var departureCity = departureAddressPicker.selectedCity;
        var arrivalCity = arrivalAddressPicker.selectedCity;
        var selectedDate = datePicker.current;

        // 过滤航班数据
        filteredData = flightData.filter(function(flight) {
            var matchesDeparture = departureCity ? (departureCity === "全部" || flight.departureCity === departureCity) : true;
            var matchesArrival = arrivalCity ? (arrivalCity === "全部" || flight.arrivalCity === arrivalCity) : true;

            var flightDate = new Date(flight.departureTime);
            var matchesDate = selectedDate ? (
                flightDate.getFullYear() === selectedDate.getFullYear() &&
                flightDate.getMonth() === selectedDate.getMonth() &&
                flightDate.getDate() === selectedDate.getDate()
            ) : true;

            return matchesDeparture && matchesArrival && matchesDate;
        });
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
                    onAccepted: filterFlights();
                }

                FluFilledButton {
                    text: qsTr("添加航班")
                    onClicked: {
                        // showAddFlightDialog();
                        console.log("添加航班")
                    }
                }
            }
        }

        FluTableView {
            id: table_view
            Layout.fillWidth: true
            Layout.fillHeight: true

            columnSource: [
                {
                    title: qsTr("航班ID"),
                    dataIndex: "flightId",
                    width: 60,
                    readOnly: true,
                    frozen: true
                },
                {
                    title: qsTr("航班号"),
                    dataIndex: "flightNumber",
                    readOnly: true,
                    frozen: true
                },
                {
                    title: qsTr("起飞时间"),
                    dataIndex: "departureTime",
                    editDelegate: com_depDateBox
                },
                {
                    title: qsTr("到达时间"),
                    dataIndex: "arrivalTime",
                    editDelegate: com_arrDateBox
                },
                {
                    title: qsTr("价格"),
                    dataIndex: "price",
                    editDelegate: com_priceBox
                },
                {
                    title: qsTr("航空公司"),
                    dataIndex: "airlineCompany",
                    readOnly: true
                },
                {
                    title: qsTr("状态"),
                    dataIndex: "status",
                    editDelegate: com_comboBox
                },
                {
                    title: qsTr("操作"),
                    dataIndex: "action",
                    width: 160,
                    frozen: true
                }
            ]
            dataSource: filteredData
        }
    }


    // 出发时间
    Component {
        id: com_depDateBox
        FluTextBox {
            anchors.fill: parent
            text: String(modelData.departureTime) // 显示价格
            onTextChanged: {
                // 双向绑定到 flight 对象
                editTextChanged(text);
            }
            onEditingFinished: {
                table_view.closeEditor();
            }
        }
    }

    // 到达时间
    Component {
        id: com_arrDateBox
        FluTextBox {
            anchors.fill: parent
            text: String(modelData.arrivalTime) // 显示价格
            onTextChanged: {
                // 双向绑定到 flight 对象
                editTextChanged(text);
            }
            onEditingFinished: {
                table_view.closeEditor();
            }
        }
    }

    // 价格
    Component {
        id: com_priceBox
        FluTextBox {
            anchors.fill: parent
            text: String(modelData.price) // 显示价格

            onTextChanged: {
                modelData.price = parseFloat(text); // 双向绑定到 flight 对象
                editTextChanged(text);
            }
            onEditingFinished: {
                table_view.closeEditor();
            }
        }
    }

    // 状态下拉框组件
    Component {
        id: com_comboBox
        FluComboBox {
            anchors.fill: parent
            model: ["On Time", "Delayed", "Cancelled"]
            currentIndex: model.indexOf(options.flight[dataIndex]) // 显示初始值
            onCurrentIndexChanged: {
                options.flight[dataIndex] = model[currentIndex]; // 实时更新 flight 对象
            }
        }
    }


    Component {
        id: com_action
        Item {
            RowLayout {
                spacing: 10
                anchors.centerIn: parent

                FluFilledButton {
                    text: qsTr("保存")
                    Layout.preferredWidth: 60
                    onClicked: {
                        console.log("保存航班:", options.flight);
                        updateFlight(JSON.parse(options.flight));
                    }
                }

                FluButton {
                    text: qsTr("删除")
                    Layout.preferredWidth: 60
                    onClicked: {
                        console.log("删除航班:", options.flight);
                        deleteFlight(JSON.parse(options.flight));
                    }
                }
            }
        }
    }


}
