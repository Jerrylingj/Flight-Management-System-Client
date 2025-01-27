import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import NetworkHandler 1.0

FluContentDialog{
    property int add_money: 0
    id: rechargeDialog
    title: qsTr("奶龙询问您")
    message: qsTr("奶龙帅不帅？")
    NetworkHandler{
        id: networkHandler
        onRequestSuccess:function(data){
            if(data['code'] === 200) {
                userInfo.myMoney += add_money
                if(add_money>0){
                    showSuccess("已到账"+add_money+"奶龙币", 7000, "我是一只慷慨的奶龙，给的钱量大管饱");
                }else{
                    showError("已扣除"+(-add_money)+"奶龙币", 7000, "我会一直看着你哦
NAILONG IS WATCHING YOU")
                }

                console.log(data['data'])
            }else{
                console.error(data['message'])
                showError(qsTr(data['message']))
            }
        }
        onRequestFailed: (data)=>{
                             console.log("error",JSON.stringify(data))
                             showError(qsTr(data['message']))
                         }
    }

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
                add_money = 1000;
                send_msg();
                showWarning(qsTr("我原谅你了"), 7000, qsTr("可我还是喜欢你桀骜不驯的样子"))
            }

            onNegativeClickListener:()=>{
                add_money = -100;
                send_msg();
                // showError(qsTr("我会一直看着你哦"), 2000, qsTr("奶龙 IS WATCHING YOU!"))
            }
        }

        onNegativeClicked: {
            quittextDialog.open();
        }

        positiveText :qsTr("不是")
        onPositiveClicked: {
            add_money = 2000;
            send_msg();
        }
    }
    onNegativeClicked: {
        reAskDialog.open()
    }
    positiveText :qsTr("帅")
    onPositiveClicked: {
        add_money = 3000;
        send_msg();
    }


    function send_msg(){
        networkHandler.request("/api/user", NetworkHandler.PUT, {
                                   balance: add_money
                               },userInfo.myToken)
    }
}
