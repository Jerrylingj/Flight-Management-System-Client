import QtQuick 2.15
import FluentUI 1.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

FluContentPage {
    id: flightInfoPage
    title: qsTr("航班信息")

    // 筛选面板
    FluFrame {
        id: filterPanel
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 10
        }
        height: 80
        RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 20

            FluTextBox {
                id: departureInput
                placeholderText: qsTr("请输入起点")
                Layout.preferredWidth: 150
            }

            FluTextBox {
                id: destinationInput
                placeholderText: qsTr("请输入终点")
                Layout.preferredWidth: 150
            }

            FluDatePicker {
                id: datePicker
                Layout.preferredWidth: 150
            }

            FluFilledButton {
                text: qsTr("查询")
                Layout.preferredWidth: 100
                onClicked: {
                    // 模拟查询后更新表格
                    loadFlightData(departureInput.text, destinationInput.text, datePicker.text);
                }
            }
        }
    }

    // 航班表格
    FluTableView {
        id: flightTable
        anchors {
            top: filterPanel.bottom
            left: parent.left
            right: parent.right
            bottom: pagination.top
            topMargin: 10
        }
        width: parent.width

        columnSource: [
            {
                title: qsTr("航班号"),
                dataIndex: "flightNumber",
                width: 100
            },
            {
                title: qsTr("起点"),
                dataIndex: "departure",
                width: 150
            },
            {
                title: qsTr("终点"),
                dataIndex: "destination",
                width: 150
            },
            {
                title: qsTr("日期"),
                dataIndex: "date",
                width: 120
            },
            {
                title: qsTr("票价"),
                dataIndex: "price",
                width: 100
            },
            {
                title: qsTr("操作"),
                dataIndex: "action",
                width: 200
            }
        ]
    }

    // 分页组件
    FluPagination {
        id: pagination
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            bottomMargin: 10
        }
        pageCurrent: 1
        itemCount: 50
        pageButtonCount: 5
        __itemPerPage: 10
        previousText: qsTr("< 上一页")
        nextText: qsTr("下一页 >")
        onRequestPage: function (page, count) {
            loadFlightData(page, count);
        }
    }

    // 模拟数据生成
    function loadFlightData(departure, destination, date) {
        const sampleData = [];
        const flightPrefix = "CA";
        const cities = ["北京", "上海", "广州", "深圳", "杭州", "成都"];
        const randomCity = () => cities[Math.floor(Math.random() * cities.length)];
        const randomPrice = () => `¥${(Math.random() * 500 + 500).toFixed(0)}`;

        for (let i = 0; i < pagination.__itemPerPage; i++) {
            sampleData.push({
                flightNumber: `${flightPrefix}${Math.floor(Math.random() * 9000 + 1000)}`,
                departure: departure || randomCity(),
                destination: destination || randomCity(),
                date: date || "2024-12-12",
                price: randomPrice(),
                action: createActionButtons(i)
            });
        }

        flightTable.dataSource = sampleData;
    }

    // // 创建操作按钮
    // function createActionButtons(index) {
    //     return flightTable.customItem(
    //         Component {
    //             Item {
    //                 RowLayout {
    //                     FluButton {
    //                         text: qsTr("购买")
    //                         onClicked: console.log(`购买航班: ${index}`);
    //                     }
    //                     FluButton {
    //                         text: qsTr("收藏")
    //                         onClicked: console.log(`收藏航班: ${index}`);
    //                     }
    //                 }
    //             }
    //         }
    //     );
    // }

    Component.onCompleted: {
        loadFlightData("", "", "");
    }
}
