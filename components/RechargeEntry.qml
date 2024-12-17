import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

FluContentDialog{
    id: rechargeDialog
    title: qsTr("奶龙询问您")
    message: qsTr("奶龙帅不帅？")

    contentDelegate: Component{
        Item {
            implicitWidth: parent.width
            implicitHeight: 300

            FluImage {
                width: 250
                height: 250
                source: "qrc:/qt/Flight_Management_System_Client/figures/NailongAskYou.jpg"
                anchors.centerIn: parent // 将 FluImage 居中于其父级 Item 内
            }
        }
    }
    negativeText: qsTr("不帅")

    FluContentDialog{
        id: reAskDialog
        title: qsTr("奶龙再次询问您")
        message: qsTr("你是来找茬的吗？")
        contentDelegate: Component{
            Item{
                implicitWidth: parent.width
                implicitHeight: 300

                FluImage{
                    width : 250
                    height : 250
                    source:"qrc:/qt/Flight_Management_System_Client/figures/NailongAskYouAgain.jpg"
                    anchors.centerIn: parent
                }

            }
        }

        negativeText: qsTr("是的")
        FluContentDialog{
            id:quittextDialog
            title: "确定注销账号？"
            message: "本奶龙给您最后一次机会！"
            contentDelegate: Component{
                Item{
                    implicitWidth: parent.width
                    implicitHeight: 300

                    FluImage{
                        width : 250
                        height : 250
                        source:"qrc:/qt/Flight_Management_System_Client/figures/NailongAskYouLastOne.png"
                        anchors.centerIn: parent
                    }
                }
            }
            positiveText: qsTr("不为五斗米折腰！")
            negativeText: qsTr("奶龙大人我错了")
            onPositiveClickListener:()=>{
                showInfo("我会一直看着你哦")
            }
        }

        onNegativeClicked: {
            quittextDialog.open();
        }

        positiveText :qsTr("不是")
        onPositiveClicked: {
            recharge();
            showSuccess(qsTr("已到账3000奶龙币"))
        }
    }
    onNegativeClicked: {
        reAskDialog.open()
        // showSuccess(qsTr("Click the Cancel Button"))
    }
    positiveText :qsTr("帅")
    onPositiveClicked: {
        recharge();
        showSuccess(qsTr("已到账3000奶龙币"))
    }


    function recharge(){
        userInfo.myMoney += 3000;
    }
}




