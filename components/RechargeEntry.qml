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
            negativeText: qsTr("不为五斗米折腰！")
            positiveText: qsTr("奶龙大人我错了")
            onPositiveClicked:{
                recharge(1000);
                showWarning(qsTr("我原谅你了"), 7000, qsTr("可我还是喜欢你桀骜不驯的样子"))
            }

            onNegativeClickListener:()=>{
                showError(qsTr("我会一直看着你哦"), 2000, qsTr("奶龙 IS WATCHING YOU!"))
            }
        }

        onNegativeClicked: {
            quittextDialog.open();
        }

        positiveText :qsTr("不是")
        onPositiveClicked: {
            recharge(2000);
        }
    }
    onNegativeClicked: {
        reAskDialog.open()
    }
    positiveText :qsTr("帅")
    onPositiveClicked: {
        recharge();

    }


    function recharge(value = 3000){
        userInfo.myMoney += value;
        showSuccess(qsTr("已到账"+value+"奶龙币"), 4000, qsTr("我是只慷慨的奶龙，给的钱量大管饱"))
    }
}
