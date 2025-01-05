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
         departureCity: "珠海",
         arrivalCity: "上海",
         departureTime: "",
         arrivalTime: "",
         price: 1500.0,
         departureAirport: "金湾机场",
         arrivalAirport: "虹桥国际机场",
         airlineCompany: "东方航空",
         checkinStartTime: "",
         checkinEndTime: "",
         status: "on Time"
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
                     departureCity: "珠海",
                     arrivalCity: "上海",
                     departureTime: "",
                     arrivalTime: "",
                     price: 1500.0,
                     departureAirport: "金湾机场",
                     arrivalAirport: "虹桥国际机场",
                     airlineCompany: "东方航空",
                     checkinStartTime: "",
                     checkinEndTime: "",
                     status: "on Time"
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
                showSuccess("更新成功！");
                updateFlightDialog.close();
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
            authCode: userInfo.authCode,
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
            authCode: userInfo.authCode,
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
            authCode: userInfo.authCode,
            flightId: flight.flightId
        };
        delHandler.request(url, NetworkHandler.POST, body);
    }


    // 筛选函数
    function filterFlights() {
        var departureCity = filterBar.departureCity;
        var arrivalCity = filterBar.arrivalCity;
        var startDate = filterBar.startDate;
        var endDate = filterBar.endDate;
        console.log(departureCity + " " + arrivalCity);
        console.log(startDate + " " + endDate);

        // 过滤航班数据
        filteredData = flightData.filter(function(flight) {
            var matchesDeparture = departureCity ? (departureCity === "全部" || flight.departureCity === departureCity) : true;
            var matchesArrival = arrivalCity ? (arrivalCity === "全部" || flight.arrivalCity === arrivalCity) : true;
            var matchesStartDate = startDate ? (new Date(flight.departureTime).setHours(0, 0, 0, 0) >= new Date(startDate).setHours(0, 0, 0, 0)) : true;
            var matchesEndDate = endDate ? (new Date(flight.departureTime).setHours(23, 59, 59, 999) <= new Date(endDate).setHours(23, 59, 59, 999)) : true;

            return matchesDeparture && matchesArrival && matchesStartDate && matchesEndDate;
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

        const airportCityMap = new Map([
            ["首都国际机场", "北京"],
            ["大兴国际机场", "北京"],
            ["虹桥国际机场", "上海"],
            ["浦东国际机场", "上海"],
            ["白云国际机场", "广州"],
            ["宝安国际机场", "深圳"],
            ["双流国际机场", "成都"],
            ["天府国际机场", "成都"],
            ["萧山国际机场", "杭州"],
            ["咸阳国际机场", "西安"],
            ["江北国际机场", "重庆"],
            ["禄口国际机场", "南京"],
            ["天河国际机场", "武汉"],
            ["滨海国际机场", "天津"],
            ["长水国际机场", "昆明"],
            ["黄花国际机场", "长沙"],
            ["周水子国际机场", "大连"],
            ["胶东国际机场", "青岛"],
            ["高崎国际机场", "厦门"],
            ["长乐国际机场", "福州"],
            ["美兰国际机场", "海口"],
            ["凤凰国际机场", "三亚"],
            ["地窝堡国际机场", "乌鲁木齐"],
            ["龙洞堡国际机场", "贵阳"],
            ["吴圩国际机场", "南宁"],
            ["太平国际机场", "哈尔滨"],
            ["龙嘉国际机场", "长春"],
            ["桃仙国际机场", "沈阳"],
            ["新郑国际机场", "郑州"],
            ["遥墙国际机场", "济南"],
            ["新桥国际机场", "合肥"],
            ["武宿国际机场", "太原"],
            ["正定国际机场", "石家庄"],
            ["昌北国际机场", "南昌"],
            ["贡嘎国际机场", "拉萨"],
            ["河东国际机场", "银川"],
            ["白塔国际机场", "呼和浩特"],
            ["中川国际机场", "兰州"],
            ["曹家堡国际机场", "西宁"],
            ["南泥湾机场", "延安"],
            ["金湾机场", "珠海"],
            ["龙湾国际机场", "温州"],
            ["栎社国际机场", "宁波"],
            ["晋江国际机场", "泉州"],
            ["两江国际机场", "桂林"],
            ["香格里拉机场", "香格里拉"],
            ["嘎洒国际机场", "西双版纳"],
            ["二里半机场", "包头"],
            ["鄂尔多斯机场", "鄂尔多斯"],
            ["白莲机场", "柳州"],
            ["三峡机场", "宜昌"],
            ["屯溪国际机场", "黄山"],
            ["大水泊机场", "威海"],
            ["蓬莱国际机场", "烟台"],
            ["荷花机场", "张家界"],
            ["福成机场", "北海"],
            ["奔牛国际机场", "常州"],
            ["北郊机场", "洛阳"],
            ["兴东国际机场", "南通"],
            ["湛江机场", "湛江"],
            ["浪头国际机场", "丹东"],
            ["南郊机场", "绵阳"],
            ["恩阳机场", "巴中"],
            ["五粮液机场", "宜宾"],
            ["荒草坝机场", "大理"],
            ["驼峰机场", "腾冲"],
            ["甘州机场", "张掖"]
        ]);

        // 必填字段检查
        const required = ["flightNumber", "departureCity", "arrivalCity", "departureTime", "arrivalTime", "price", "departureAirport", "arrivalAirport", "airlineCompany"];
        for (const key of required) {
            if (!flight[key]) {
                const errorMessage = `缺少字段：${key}`;
                console.error(errorMessage);
                showError(errorMessage);
                return false;
            }
        }

        // 起点和终点不能相同
        if (flight.departureCity === flight.arrivalCity) {
            const errorMessage = "出发城市和到达城市不能相同";
            console.error(errorMessage);
            showError(errorMessage);
            return false;
        }

        // 起点机场和起点城市是否匹配
        const departureCity = airportCityMap.get(flight.departureAirport);
        if (!departureCity || departureCity !== flight.departureCity) {
            const errorMessage = `起点机场与起点城市不匹配：${flight.departureCity} - ${flight.departureAirport}`;
            console.error(errorMessage);
            showError(errorMessage);
            return false;
        }

        // 终点机场和终点城市是否匹配
        const arrivalCity = airportCityMap.get(flight.arrivalAirport);
        if (!arrivalCity || arrivalCity !== flight.arrivalCity) {
            const errorMessage = `终点机场与终点城市不匹配：${flight.arrivalCity} - ${flight.arrivalAirport}`;
            console.error(errorMessage);
            showError(errorMessage);
            return false;
        }

        // 航班时间逻辑验证
        const departureTime = new Date(flight.departureTime);
        const arrivalTime = new Date(flight.arrivalTime);
        const currentTime = new Date();

        if (departureTime <= currentTime) {
            const errorMessage = "起飞时间不能早于当前时间";
            console.log("当前时间 ", currentTime, " 起飞时间 ", departureTime);
            console.error(errorMessage);
            showError(errorMessage);
            return false;
        }

        const departureHours = departureTime.getHours(), arrivalHours = arrivalTime.getHours();
        const departureMinutes = departureTime.getMinutes(), arrivalMinutes = arrivalTime.getMinutes();
        const isCrossDay = (arrivalHours < departureHours) ||
                           (arrivalHours === departureHours && arrivalMinutes < departureMinutes);

        if (isCrossDay) {
            console.log("检测到跨天航班（基于时刻判断）");
            arrivalTime.setDate(departureTime.getDate() + 1);
            flight.arrivalTime = arrivalTime.toString();
            console.log("到达时间：", arrivalTime);
        }

        const flightDuration = (arrivalTime - departureTime) / (1000 * 60 * 60); // 以小时为单位
        if (flightDuration <= 0.5 || flightDuration > 6) {
            const errorMessage = `飞行时长不合理：${flightDuration.toFixed(1)}小时`;
            console.error(errorMessage);
            showError(errorMessage);
            return false;
        }

        // 航班价格范围检查
        const minPrice = 100;
        const maxPrice = 5000;
        if (flight.price < minPrice || flight.price > maxPrice) {
            const errorMessage = `航班价格不合理：${flight.price}元，范围应为 ${minPrice}-${maxPrice} 元`;
            console.error(errorMessage);
            showError(errorMessage);
            return false;
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

    Component.onCompleted: fetchFlightData();

    ColumnLayout {
        anchors.fill: parent
        spacing: 16

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

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 10

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
                            filterBar.departureCity = departureAddressPicker.selectedCity;
                            filterBar.arrivalCity = arrivalAddressPicker.selectedCity;
                            startDate = startDatePicker.current;
                            endDate = endDatePicker.current;
                            executeFliter();
                        }
                    }

                    FluFilledButton {
                        Layout.preferredWidth: 150
                        text: qsTr("添加航班")

                        onClicked: {
                            addFlightDialog.open();
                        }
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

            Component.onCompleted: {
                console.log("航班信息:", JSON.stringify(dataSource));
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
                            currentCity: newFlightData.departureCity
                            onAccepted:
                            {
                                newFlightData.departureCity = selectedCity;
                                console.log("出发城市:", selectedCity);
                            }
                        }

                        AddressPicker {
                            Layout.fillWidth: true
                            currentCity: newFlightData.arrivalCity
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
                            model: ["on Time", "delayed", "cancelled"]
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

            newFlightData.checkinStartTime = calcCheckinStart(dep);
            newFlightData.checkinEndTime = calcCheckinEnd(dep);

            if (!validateFlight(newFlightData)) {
                return;
            }

            console.log("添加航班:", JSON.stringify(newFlightData));
            addFlight(newFlightData);
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
                            model: ["on Time", "delayed", "cancelled"]
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

            editingFlight.checkinStartTime = calcCheckinStart(dep);
            editingFlight.checkinEndTime = calcCheckinEnd(dep);

            if (!validateFlight(editingFlight)) {
                return;
            }

            console.log("更新航班:", JSON.stringify(editingFlight));
            updateFlight(editingFlight);
        }
    }
}
