import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import FluentUI.Controls

FluFrame {
    id: flightInfoEditCard
    radius: 10
    Layout.fillWidth: true
    Layout.preferredHeight: 120
    padding: 10

    property int flightId
    property string flightNumber
    property string departureTime
    property string arrivalTime
    property string departureAirport
    property string arrivalAirport
    property double price
    property string airlineCompany
    property string status
    property bool isEdited: false

    // signal onSave(flightId, data)
    // signal onDelete(flightId)

    RowLayout {
        spacing: 20
        anchors.fill: parent

        // 航班号和航空公司信息
        ColumnLayout {
            Layout.preferredWidth: flightInfoEditCard.width / 6
            spacing: 5

            FluTextField {
                id: flightNumberField
                text: flightNumber
                placeholderText: qsTr("航班号")
                onTextChanged: {
                    flightNumber = text;
                    isEdited = true;
                }
            }

            FluTextField {
                id: airlineField
                text: airlineCompany
                placeholderText: qsTr("航空公司")
                onTextChanged: {
                    airlineCompany = text;
                    isEdited = true;
                }
            }
        }

        // 时间和机场信息
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 10

            RowLayout {
                spacing: 10
                FluTextField {
                    id: departureTimeField
                    text: departureTime
                    placeholderText: qsTr("起飞时间")
                    onTextChanged: {
                        departureTime = text;
                        isEdited = true;
                    }
                }

                FluTextField {
                    id: departureAirportField
                    text: departureAirport
                    placeholderText: qsTr("起点机场")
                    onTextChanged: {
                        departureAirport = text;
                        isEdited = true;
                    }
                }
            }

            RowLayout {
                spacing: 10
                FluTextField {
                    id: arrivalTimeField
                    text: arrivalTime
                    placeholderText: qsTr("到达时间")
                    onTextChanged: {
                        arrivalTime = text;
                        isEdited = true;
                    }
                }

                FluTextField {
                    id: arrivalAirportField
                    text: arrivalAirport
                    placeholderText: qsTr("终点机场")
                    onTextChanged: {
                        arrivalAirport = text;
                        isEdited = true;
                    }
                }
            }
        }

        // 价格和状态
        ColumnLayout {
            Layout.preferredWidth: flightInfoEditCard.width / 6
            spacing: 10

            FluTextField {
                id: priceField
                text: price.toFixed(2)
                placeholderText: qsTr("价格")
                inputMethodHints: Qt.ImhDigitsOnly
                onTextChanged: {
                    price = parseFloat(text);
                    isEdited = true;
                }
            }

            FluComboBox {
                id: statusComboBox
                model: ["正常", "延误", "取消"]
                currentText: status
                onCurrentTextChanged: {
                    status = currentText;
                    isEdited = true;
                }
            }
        }

        // 操作按钮
        ColumnLayout {
            Layout.preferredWidth: flightInfoEditCard.width / 6
            spacing: 10

            FluFilledButton {
                text: qsTr("保存")
                enabled: isEdited
                onClicked: {
                    flightInfoEditCard.onSave(flightId, {
                        flightNumber: flightNumber,
                        departureTime: departureTime,
                        arrivalTime: arrivalTime,
                        departureAirport: departureAirport,
                        arrivalAirport: arrivalAirport,
                        price: price,
                        airlineCompany: airlineCompany,
                        status: status
                    });
                    isEdited = false;
                }
            }

            FluTextButton {
                text: qsTr("删除")
                onClicked: {
                    flightInfoEditCard.onDelete(flightId);
                }
            }
        }
    }
}
