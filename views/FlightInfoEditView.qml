import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15
import NetworkHandler 1.0
import "../components"

FluContentPage {
    id: flightInfoEditView
    title: qsTr("航班信息")

    property var flightData: []                 // 所有航班数据
    property var filteredData: []               // 筛选后的航班数据

    property var newFlightData: ({              // 待添加的航班
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

    property var editingFlight: ({})            // 待编辑航班

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
            if (response.success === true) {
                showSuccess("保存成功!");
                updateFlightDialog.close();
                fetchFlightData();
            }
            else showError("航班信息有误，请重新输入！");
        }
        onRequestFailed: function(errorMessage) {
            console.error("更新航班失败:", errorMessage);
        }
    }

    // 获取航班信息
    function fetchFlightData() {
        const url = "/api/flights";
        networkHandler.request(url, NetworkHandler.GET);
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
        // console.log("flightId", flight.flightId);
        const body = {
            authCode: "123",
            flightId: flight.flightId,
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
        // console.log("body",JSON.stringify(body))
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

    /*** 添加航班 ***/
    // 辅助函数：格式化时间
    function formatDateString(dateString) {
        // 如果日期字符串包含 'GMT'，去掉从 'GMT' 开始的部分
        const gmtIndex = dateString.indexOf("GMT");
        if (gmtIndex !== -1) {
            return dateString.substring(0, gmtIndex).trim();
        }
        return dateString; // 如果不包含 'GMT'，返回原始字符串
    }
    // 辅助函数：更新日期
    function combineDate(date, time) {

        if (date === "") return Date(time).toString();

        const dateObj = new Date(date);
        const timeObj = new Date(time);

        dateObj.setFullYear(timeObj.getFullYear());
        dateObj.setMonth(timeObj.getMonth());
        dateObj.setDate(timeObj.getDate());

        return dateObj.toString();
    }
    // 辅助函数：更新时刻
    function combineTime(date, time) {
        if (date === "") return Date(time).toString();

        const dateObj = new Date(date);
        const timeObj = new Date(time);

        dateObj.setHours(timeObj.getHours());
        dateObj.setMinutes(timeObj.getMinutes());
        dateObj.setSeconds(timeObj.getSeconds());

        return dateObj.toString();
    }
    // 验证航班填写是否有效
    function validateFlight(flight) {
        if (flight.departureCity === "全部") flight.departureCity = "";
        if (flight.arrivalCity === "全部") flight.arrivalCity = "";
        const required = ["flightNumber", "departureCity", "arrivalCity", "departureTime", "arrivalTime", "price", "departureAirport", "arrivalAirport", "airlineCompany"];
        for (const key of required) {
            if (!flight[key]) {
                console.error(`缺少字段：${key}`);
                return false;
            }
        }
        return true;
    }
    // 计算检票开始时间
    function calcCheckinStart(depTime) {
        let t = new Date(depTime);
        t.setHours(t.getHours() - 2);
        return t.toString();
    }
    // 计算检票结束时间
    function calcCheckinEnd(depTime) {
        let t = new Date(depTime);
        t.setMinutes(t.getMinutes() - 30);
        return t.toString();
    }
    // // 更新行
    // function updateFlightData(rowIndex, field, value) {
    //     // 更新航班数据
    //     if (rowIndex >= 0 && rowIndex < flightData.length) {
    //         flightData[rowIndex][field] = value;
    //         // 拷贝
    //         const flightCopy = Object.assign({}, flightData[rowIndex]);
    //         delete flightCopy.action;
    //         // 更新 action 列的内容
    //         flightData[rowIndex]["action"] = table_view.customItem(com_action, {flight: JSON.stringify(flightCopy)});
    //     }
    // }

    Component.onCompleted: fetchFlightData();

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
                    title: qsTr("出发城市"),
                    dataIndex: "departureCity",
                    readOnly: true
                },
                {
                    title: qsTr("到达城市"),
                    dataIndex: "arrivalCity",
                    readOnly: true
                },
                {
                    title: qsTr("起飞时间"),
                    dataIndex: "departureTime",
                    readOnly: true
                },
                {
                    title: qsTr("到达时间"),
                    dataIndex: "arrivalTime",
                    readOnly: true
                },
                {
                    title: qsTr("价格"),
                    dataIndex: "price",
                    readOnly: true
                },
                {
                    title: qsTr("航空公司"),
                    dataIndex: "airlineCompany",
                    readOnly: true
                },
                {
                    title: qsTr("状态"),
                    dataIndex: "status",
                    readOnly: true
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

    Component {
        id: com_action
        Item {
            RowLayout {
                spacing: 10
                anchors.centerIn: parent

                FluFilledButton {
                    text: qsTr("编辑")
                    Layout.preferredWidth: 60
                    onClicked: {
                        console.log("编辑航班:", options.flight);
                        editingFlight = JSON.parse(options.flight); // 深拷贝当前航班数据
                        updateFlightDialog.open();
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

    // 修改航班的弹窗
    FluContentDialog {
        id: updateFlightDialog
        title: qsTr("修改航班")
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
                            text: editingFlight.airlineCompany
                            onTextChanged:
                            {
                                editingFlight.airlineCompany = text;
                                console.log("航空公司：", text);
                            }
                        }

                        FluTextBox {
                            placeholderText: qsTr("航班号")
                            Layout.fillWidth: true
                            text: editingFlight.flightNumber
                            onTextChanged:
                            {
                                editingFlight.flightNumber = text;
                                console.log("航班号:", text);
                            }
                        }

                        FluTextBox {
                            placeholderText: qsTr("价格")
                            Layout.fillWidth: true
                            inputMethodHints: Qt.ImhDigitsOnly
                            text: String(editingFlight.price)
                            onTextChanged:
                            {
                                editingFlight.price = parseFloat(text);
                                console.log("价格:", parseFloat(text));
                            }
                        }
                    }

                    RowLayout {
                        spacing: 10
                        Layout.fillWidth: true

                        AddressPicker {
                            Layout.fillWidth: true
                            currentCity: editingFlight.departureCity
                            onAccepted:
                            {
                                editingFlight.departureCity = selectedCity;
                                console.log("出发城市:", selectedCity);
                            }
                        }

                        AddressPicker {
                            Layout.fillWidth: true
                            currentCity: editingFlight.arrivalCity
                            onAccepted:
                            {
                                editingFlight.arrivalCity = selectedCity;
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
                            text: editingFlight.departureAirport
                            onTextChanged:
                            {
                                editingFlight.departureAirport = text;
                                console.log("起飞机场:", text);
                            }
                        }

                        FluTextBox {
                            placeholderText: qsTr("到达机场")
                            Layout.fillWidth: true
                            text: editingFlight.arrivalAirport
                            onTextChanged:
                            {
                                editingFlight.arrivalAirport = text;
                                console.log("到达机场:", text);
                            }
                        }
                    }

                    RowLayout {
                        spacing: 10
                        Layout.fillWidth: true

                        FluComboBox {
                            Layout.fillWidth: true
                            model: ["On Time", "Delayed", "Cancelled"]
                            currentIndex: 0
                            onCurrentIndexChanged:
                            {
                                editingFlight.status = model[currentIndex];
                                console.log("状态:", currentIndex);
                            }
                        }

                        FluDatePicker {
                            Layout.fillWidth: true
                            current: editingFlight.departureTime ? new Date(editingFlight.departureTime) : new Date()
                            onAccepted: {
                                // 初始化出发时间, 到达时间
                                editingFlight.departureTime = combineDate(editingFlight.departureTime, current);
                                editingFlight.arrivalTime = combineDate(editingFlight.arrivalTime, current);
                                // console.log("出发日期:", editingFlight.departureTime);
                                // console.log("到达日期:", editingFlight.arrivalTime);
                            }
                        }
                    }

                    RowLayout {
                        spacing: 10
                        Layout.fillWidth: true

                        FluTimePicker {
                            Layout.fillWidth: true
                            current: editingFlight.departureTime ? new Date(editingFlight.departureTime) : new Date()
                            onAccepted: {
                                // 更新出发时间的时刻
                                editingFlight.departureTime = combineTime(editingFlight.departureTime, current);
                                // console.log("出发时间:", editingFlight.departureTime);

                            }

                        }

                        FluTimePicker {
                            Layout.fillWidth: true
                            current: editingFlight.arrivalTime ? new Date(editingFlight.arrivalTime) : new Date()
                            onAccepted: {
                                editingFlight.arrivalTime = combineTime(editingFlight.arrivalTime, current);
                                // console.log("到达时间:", editingFlight.arrivalTime);
                            }
                        }
                    }
                }
            }
        }

        positiveText: qsTr("保存")
        onPositiveClickListener: ()=> {
            const dep = editingFlight.departureTime;
            const arr = editingFlight.arrivalTime;

            console.log("验证航班");
            if (new Date(dep) >= new Date(arr)) {
                showError("到达时间早于起飞时间");
                return;
            }


            editingFlight.checkinStartTime = calcCheckinStart(dep);
            editingFlight.checkinEndTime = calcCheckinEnd(dep);

            if (!validateFlight(editingFlight)) {
                showError("航班信息不全！");
                return;
            }

            console.log("更新航班:", JSON.stringify(editingFlight));
            updateFlight(editingFlight);
        }
    }
}
