import QtQuick
import QtQuick.Controls
import NetworkHandler 1.0
import FluentUI 1.0
import QtQuick.Layouts
import QtQuick.Effects

// import "../static/sites.js" as Site

Item{
    id:root
    property var selectedCity:null

    Flickable {
        width: parent.width
        height: parent.height
        id:flickableContainer
        contentWidth: width
        contentHeight: Math.min(...yArray)
        clip: true

        function changeToDetail(article){
            root.selectedCity = article
            // console.log(JSON.stringify(article, null, 2))
        }
        interactive: selectedCity === null

        property var yArray:[]
        property int column: 2 // 列数，默认为2
        property real spacing: 5

        property bool isLoading: false
        property int cityID: 27 // 城市id, 默认珠海

        property int pageIndex: 1

        NetworkHandler{
            id:networkHandler
            onRequestSuccess:(response)=>{
                                const list = response.resultList
                                list.forEach((item)=>{
                                    noteContainer.model.append({article:item.article})
                                            })
                                if(!response.hasMore){
                                    // cityID = Site.getRandomID()
                                }
                                flickableContainer.isLoading = false
                            }
            onRequestFailed:(response)=>{
                                console.log(JSON.stringify(response,null,2))
                                flickableContainer.isLoading = false
                            }
        }

        function getMoreData(pageSize=10){
            isLoading = true
            networkHandler.request(
                          "https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2",
                          NetworkHandler.POST,
                          {
                                                                         "districtId": cityID, // 城市
                                                                         "groupChannelCode": "tourphoto_all",
                                                                         // "locatedDistrictId": 0,
                                                                         "pagePara": {
                                                                             "pageIndex": pageIndex,
                                                                             "pageSize": pageSize,
                                                                             "sortType": 9,
                                                                             "sortDirection": 0
                                                                         },
                                                                         // "imageCutType": 1,
                                                                         "head": {
                                                                             // "cid": "09031099210072157423",
                                                                             "ctok": "",
                                                                             "cver": "1.0",
                                                                             "lang": "01",
                                                                             "sid": "8888",
                                                                             "syscode": "09",
                                                                             "auth": "",
                                                                             "xsid": "",
                                                                             "extension": [
                                                                                 {
                                                                                     "name": "source",
                                                                                     "value": "web"
                                                                                 },
                                                                                 {
                                                                                     "name": "technology",
                                                                                     "value": "H5"
                                                                                 },
                                                                                 {
                                                                                     "name": "os",
                                                                                     "value": "PC"
                                                                                 },
                                                                                 {
                                                                                     "name": "application",
                                                                                     "value": ""
                                                                                 }
                                                                             ]
                                                                         }
                                                                     }
                          )
        }

        // 根据宽度决定列数
        property var changeColumns:function(windowWidth){
            if(windowWidth<=400){
                return 2
            }else if(windowWidth>400&&windowWidth<=800){
                return 3
            }else{
                return 4
            }
        }

        Repeater {
            id: noteContainer
            model:ListModel{
                id:listModel
            }
            delegate: Rectangle{
                objectName: article.articleId
                height: card.height
                width:parent.width/flickableContainer.column - flickableContainer.spacing
                color:"transparent"

                NoteCard {
                    id: card
                    Component.onCompleted: {
                        curY = flickableContainer.yArray[card.num]
                        flickableContainer.yArray[card.num] += card.height + flickableContainer.spacing * 2
                        // 刷新数组, 触发yArray改变
                        flickableContainer.yArray = [...flickableContainer.yArray]
                    }
                    width: parent.width
                    // 判断第几列
                    property int num: index%flickableContainer.column
                    x: num * parent.width + 2 * flickableContainer.spacing * num
                    property real curY : 0

                    y:curY
                    note: article
                    MouseArea {
                        anchors.fill: parent
                        width: parent.width
                        height:parent.height
                        z:1
                        onClicked: {
                            flickableContainer.changeToDetail(article)
                        }
                    }
                }
            }

            Component.onCompleted: {
                flickableContainer.getMoreData(16)
            }
        }

        // 滑到底部附近加载数据
        onContentYChanged: {
            if ((contentY >= contentHeight - height - 50) && !isLoading) {
                getMoreData(12)
            }
        }

        Component.onCompleted: {
            column = changeColumns(width)
            yArray.length = column
            yArray.fill(0)
        }

        // 重置
        function reset() {
            if(isLoading){
                return
            }

            const newColumn = changeColumns(width)
            if(newColumn === column){
                return
            }
            isLoading = true
            column = newColumn

            // 重置为0, 设置length多余的会删掉
            yArray.length = newColumn
            yArray.fill(0)

            // 刷新数据, 让页面更新
            noteContainer.model = null
            noteContainer.model = listModel

            isLoading = false
        }

        // 定义 Timer 用于防抖
        Timer {
            id: debounceTimer
            interval: 200  // 设置防抖的延迟时间（200 毫秒）
            running: false
            repeat: false

            onTriggered: {
                flickableContainer.reset()  // 防抖后调用 reset
            }
        }

        // 监听宽度变化
        onWidthChanged: {
            if (debounceTimer.running) {
                debounceTimer.stop();  // 如果 Timer 正在运行，则停止它
            }
            debounceTimer.start();  // 启动新的定时器
        }
    }


    FluFrame{
        visible: selectedCity !== null
        width: parent.width
        height: parent.height
        opacity: 0.8
        // color: "black"
        z:2
        Flickable{
            width: parent.width * 0.7
            height: parent.height - closeButton.height
            anchors.horizontalCenter: parent.horizontalCenter
            contentHeight: userInfo.height + articleContent.implicitHeight + imageContainer.height
            clip: true

            FluRectangle{
                height: parent.height
                width: parent.width
                // color: "white"
            }

            Column {
                width: parent.width
                height: parent.height
                spacing: 20
                // 轮播图
                FluCarousel {
                    id: imageContainer
                    width: parent.width
                    height: 300
                    loopTime: 3000
                    model: selectedCity === null ? [] : selectedCity.images
                    anchors.horizontalCenter: parent.horizontalCenter
                    delegate: Component {
                        Item {
                            anchors.fill: parent
                            FluImage {
                                anchors.fill: parent
                                source: model.dynamicUrl
                                fillMode: Image.PreserveAspectCrop
                            }
                        }
                    }
                }

                // 头像和用户名
                Row {
                    id: userInfo
                    spacing: 15
                    width: parent.width
                    height: Math.max(avatarRect.height, userNameRect.height)

                    // 用户头像
                    Rectangle {
                        id: avatarRect
                        width: 50
                        height: 50
                        color: "transparent"
                        FluImage {
                            id: avatar
                            anchors.fill: parent
                            source: selectedCity === null ? '' : selectedCity.author.coverImage.dynamicUrl
                            fillMode: Image.PreserveAspectCrop
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                maskEnabled: true
                                maskSource: ShaderEffectSource {
                                    sourceItem: Rectangle {
                                        width: avatar.width
                                        height: avatar.height
                                        radius: width/2
                                        color: "black"
                                    }
                                }
                            }
                        }
                    }

                    // 用户名
                    Rectangle {
                        id: userNameRect
                        width: parent.width - avatarRect.width - 15
                        height: Math.max(userName.implicitHeight, avatarRect.height)
                        color: "transparent"
                        FluText {
                            id: userName
                            text: qsTr(selectedCity === null ? '匿名用户' : selectedCity.author.nickName)
                            wrapMode: Text.WordWrap
                            width: parent.width
                            color: "black"
                            font.pixelSize: 20
                            font.bold: true
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                // 文章内容
                FluText {
                    id: articleContent
                    width: parent.width
                    text: selectedCity === null ? '暂无内容' : selectedCity.content
                    wrapMode: Text.WordWrap
                    font.pixelSize: 18
                    font.family: "Arial"
                    font.bold: true
                    color: "black"
                    anchors.topMargin: 10
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                }
            }

        }
        FluIconButton{
            id:closeButton
            iconSource:FluentIcons.ChromeCloseContrast
            onClicked: {
                selectedCity = null
            }
        }
    }

}

