import QtQuick
import QtQuick.Controls
import NetworkHandler 1.0
import "../static/sites.js" as Site

Flickable {
    id:flickableContainer
    contentWidth: width
    contentHeight: Math.min(...yArray) + homeViewImage.height

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
                                cityID = Site.getRandomID()
                            }
                            isLoading = false
                        }
        onRequestFailed:(response)=>{
                            console.log(JSON.stringify(response,null,2))
                            isLoading = false
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

    function changeToDetail(article){
        parent.selectedCity = article
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


    Image {
        id:homeViewImage
        source: "../figure/homepage-cover.png"
        width: parent.width
        height: 200
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
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
                    curY = yArray[card.num] + homeViewImage.height
                    yArray[card.num] += card.height + flickableContainer.spacing * 2
                    // 刷新数组, 触发yArray改变
                    yArray = [...yArray]
                }
                width: parent.width
                // 判断第几列
                property int num: index%flickableContainer.column
                x: num * parent.width + 2 * flickableContainer.spacing * num
                property real curY : 0

                // 这个 : 疑似双向绑定, 用curY间接赋值
                y:curY
                note: article
                MouseArea {
                    anchors.fill: parent
                    width: parent.width
                    height:parent.height
                    z:5
                    onClicked: {
                        changeToDetail(article)
                    }
                }
            }
        }

        Component.onCompleted: {
            getMoreData(16)
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

    onWidthChanged: {
        // 可能要考虑做个防抖，但是好像又没啥必要，也就电脑用鼠标移动边框的时候性能有问题
        reset()
    }

}
