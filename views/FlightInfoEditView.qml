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

property var newFlightData: ({
         flightNumber: "MU100",
         departureCity: "",
         arrivalCity: "",
         departureTime: "",
         arrivalTime: "",
         price: 1500.0,
         departureAirport: "北京首都国际机场",
         arrivalAirport: "上海虹桥国际机场",
         airlineCompany: "东方航空",
         checkinStartTime: "",
         checkinEndTime: "",
         status: "On Time"
   })

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
            showSuccess("删除成功!");
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
            if(response.success === true) {
                showSuccess("添加成功！");
                newFlightData = ({
                     flightNumber: "MU100",
                     departureCity: "",
                     arrivalCity: "",
                     departureTime: "",
                     arrivalTime: "",
                     price: 1500.0,
                     departureAirport: "北京首都国际机场",
                     arrivalAirport: "上海虹桥国际机场",
                     airlineCompany: "东方航空",
                     checkinStartTime: "",
                     checkinEndTime: "",
                     status: "On Time"
                });
                addFlightDialog.close();
            }
            else showError("航班信息有误，请重新输入！");
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
            showSuccess("保存成功!");
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

    // 一个辅助格式化函数
    function formatDateString(dateString) {
        // 如果日期字符串包含 'GMT'，去掉从 'GMT' 开始的部分
        const gmtIndex = dateString.indexOf("GMT");
        if (gmtIndex !== -1) {
            return dateString.substring(0, gmtIndex).trim();
        }
        return dateString; // 如果不包含 'GMT'，返回原始字符串
    }

    // 添加航班逻辑
    function addFlight(flight) {
        const url = "/api/flights/add";
        // console.log("添加航班", flight);

        const body = {
            authCode: "123",
            flightNumber: flight.flightNumber,
            departureCity: flight.departureCity,
            arrivalCity: flight.arrivalCity,
            departureTime: formatDateString(flight.departureTime),
            arrivalTime: formatDateString(flight.arrivalTime),
            price: flight.price,
            departureAirport: flight.departureAirport,
            arrivalAirport: flight.arrivalAirport,
            airlineCompany: flight.airlineCompany,
            checkinStartTime: formatDateString(flight.checkinStartTime),
            checkinEndTime: formatDateString(flight.checkinEndTime),
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


    function updateFlightData(rowIndex, field, value) {
        // 更新航班数据
        if (rowIndex >= 0 && rowIndex < flightData.length) {
            flightData[rowIndex][field] = value;
            // 拷贝
            const flightCopy = Object.assign({}, flightData[rowIndex]);
            delete flightCopy.action;
            // 更新 action 列的内容
            flightData[rowIndex]["action"] = table_view.customItem(com_action, {flight: JSON.stringify(flightCopy)});
        }
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
                        addFlightDialog.open();
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
            text: String(JSON.parse(options.flight).departureTime) // 显示价格
            onTextChanged: {
                updateFlightData(modelIndex, "departureTime", text);
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
            text: String(JSON.parse(options.flight).arrivalTime) // 显示价格
            onTextChanged: {
                updateFlightData(modelIndex, "arrivalTime", text);
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
            text: String(JSON.parse(options.flight).price) // 显示价格
            onTextChanged: {
                updateFlightData(modelIndex, "price", text);
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

    // 添加航班的弹窗
    FluContentDialog {
        id: addFlightDialog
        title: qsTr("添加航班")
        contentWidth: 600
        contentHeight: 600

        contentDelegate: Component {
            Item {
                implicitWidth: parent.width
                implicitHeight: 300

                ColumnLayout {
                    spacing: 20
                    anchors.fill: parent
                    anchors.margins: 16

                    RowLayout {
                        spacing: 10
                        Layout.fillWidth: true

                        FluTextBox {
                            placeholderText: qsTr("航空公司")
                            Layout.fillWidth: true
                            text: newFlightData.airlineCompany
                            onTextChanged:
                            {
                                newFlightData.airlineCompany = text;
                                console.log("航空公司：", text);
                            }
                        }

                        FluTextBox {
                            placeholderText: qsTr("航班号")
                            Layout.fillWidth: true
                            text: newFlightData.flightNumber
                            onTextChanged:
                            {
                                newFlightData.flightNumber = text;
                                console.log("航班号:", text);
                            }
                        }
                    }

                    RowLayout {
                        spacing: 10
                        Layout.fillWidth: true

                        AddressPicker {
                            Layout.fillWidth: true
                            onAccepted:
                            {
                                newFlightData.departureCity = selectedCity;
                                console.log("出发城市:", selectedCity);
                            }
                        }

                        AddressPicker {
                            Layout.fillWidth: true
                            onAccepted:
                            {
                                newFlightData.arrivalCity = selectedCity;
                                console.log("到达城市:", selectedCity);
                            }
                        }
                    }

                    RowLayout {
                        spacing: 10
                        Layout.fillWidth: true

                        FluTextBox {
                            placeholderText: qsTr("起飞机场")
                            Layout.fillWidth: true
                            text: newFlightData.departureAirport
                            onTextChanged:
                            {
                                newFlightData.departureAirport = text;
                                console.log("起飞机场:", text);
                            }
                        }

                        FluTextBox {
                            placeholderText: qsTr("到达机场")
                            Layout.fillWidth: true
                            text: newFlightData.arrivalAirport
                            onTextChanged:
                            {
                                newFlightData.arrivalAirport = text;
                                console.log("到达机场:", text);
                            }
                        }
                    }

                    RowLayout {
                        spacing: 10
                        Layout.fillWidth: true

                        FluTextBox {
                            placeholderText: qsTr("价格")
                            Layout.fillWidth: true
                            inputMethodHints: Qt.ImhDigitsOnly
                            text: String(newFlightData.price)
                            onTextChanged:
                            {
                                newFlightData.price = parseFloat(text);
                                console.log("价格:", parseFloat(text));
                            }
                        }

                        FluComboBox {
                            Layout.fillWidth: true
                            model: ["On Time", "Delayed", "Cancelled"]
                            currentIndex: 0
                            onCurrentIndexChanged:
                            {
                                newFlightData.status = model[currentIndex];
                                console.log("状态:", currentIndex);
                            }
                        }

                        FluDatePicker {
                            Layout.fillWidth: true
                            onAccepted: {
                                // 初始化出发时间, 到达时间
                                newFlightData.departureTime = combineDate(newFlightData.departureTime, current);
                                newFlightData.arrivalTime = combineDate(newFlightData.arrivalTime, current);
                                // console.log("出发日期:", newFlightData.departureTime);
                                // console.log("到达日期:", newFlightData.arrivalTime);
                            }
                        }
                    }

                    RowLayout {
                        spacing: 10
                        Layout.fillWidth: true

                        FluTimePicker {
                            Layout.fillWidth: true
                            onAccepted: {
                                // 更新出发时间的时刻
                                newFlightData.departureTime = combineTime(newFlightData.departureTime, current);
                                // console.log("出发时间:", newFlightData.departureTime);

                            }

                        }

                        FluTimePicker {
                            Layout.fillWidth: true
                            onAccepted: {
                                newFlightData.arrivalTime = combineTime(newFlightData.arrivalTime, current);
                                // console.log("到达时间:", newFlightData.arrivalTime);
                            }
                        }
                    }
                }
            }
        }

        onPositiveClickListener: ()=> {
            const dep = newFlightData.departureTime;
            const arr = newFlightData.arrivalTime;

            console.log("验证航班");
            if (new Date(dep) >= new Date(arr)) {
                showError("到达时间早于起飞时间");
                return;
            }


            newFlightData.checkinStartTime = calcCheckinStart(dep);
            newFlightData.checkinEndTime = calcCheckinEnd(dep);

            if (!validateFlight(newFlightData)) {
                showError("航班信息不全！");
                return;
            }

            console.log("添加航班:", JSON.stringify(newFlightData));
            addFlight(newFlightData);
            // addFlightDialog.close();
        }
    }

    function combineDate(date, time) {

        if (date === "") return Date(time).toString();

        const dateObj = new Date(date);
        const timeObj = new Date(time);

        dateObj.setFullYear(timeObj.getFullYear());
        dateObj.setMonth(timeObj.getMonth());
        dateObj.setDate(timeObj.getDate());

        return dateObj.toString();
    }

    function combineTime(date, time) {
        if (date === "") return Date(time).toString();

        const dateObj = new Date(date);
        const timeObj = new Date(time);

        dateObj.setHours(timeObj.getHours());
        dateObj.setMinutes(timeObj.getMinutes());
        dateObj.setSeconds(timeObj.getSeconds());

        return dateObj.toString();
    }


    function validateFlight(flight) {
        const required = ["flightNumber", "departureCity", "arrivalCity", "departureTime", "arrivalTime", "price", "departureAirport", "arrivalAirport", "airlineCompany"];
        for (const key of required) {
            if (!flight[key]) {
                console.error(`缺少字段：${key}`);
                return false;
            }
        }
        return true;
    }

    function calcCheckinStart(depTime) {
        let t = new Date(depTime);
        t.setHours(t.getHours() - 2);
        return t.toString();
    }

    function calcCheckinEnd(depTime) {
        let t = new Date(depTime);
        t.setMinutes(t.getMinutes() - 30);
        return t.toString();
    }

}
