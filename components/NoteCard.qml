import QtQuick
import QtQuick.Effects
import FluentUI 1.0

Rectangle {
    height: userInfo.height + articleContentRect.height + columnContainer.topPadding + columnContainer.bottomPadding

    // 不知道有没有用的东西，理论上会让边框有阴影。ai写的
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: "#40000000"
        shadowBlur: 0.5
        shadowHorizontalOffset: 3
        shadowVerticalOffset: 3
        shadowScale: 1.02
    }

    required property var note

    color:"transparent"
    z:0

    Image {
        id: sourceImage
        source: note.images[0].dynamicUrl
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectCrop
        opacity: 0.3
    }

    Column{
        id: columnContainer
        width:parent.width
        topPadding: 10
        leftPadding: 10
        rightPadding:10
        bottomPadding:10

        Row { // 头像跟名字
            id: userInfo
            spacing: 20
            width:parent.width
            height: Math.max(avatarRect.height,userNameRect.height)

            Rectangle {
                id: avatarRect
                width: 50
                height: 50
                radius: width/2
                color:"transparent"
                FluImage {
                    // 圆框框头像，ai给的看不懂
                    id: avatar
                    anchors.fill: parent
                    source: note.author.coverImage.dynamicUrl
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

            Rectangle {
                id: userNameRect
                width: parent.width - avatarRect.width - 10
                height: Math.max(userName.implicitHeight,avatarRect.height) // 统一高度
                color:"transparent"
                z:-1
                FluText {
                    id: userName
                    anchors.verticalCenter: parent.verticalCenter // 竖向居中
                    text: qsTr(note.author.nickName)
                    wrapMode: Text.WordWrap
                    width: parent.width
                }
            }
        }
        Rectangle{ //存放标题，请求的数据里好像没有简介
            id: articleContentRect
            color: "transparent"
            width: parent.width - columnContainer.leftPadding - columnContainer.rightPadding
            height: articleTitle.height
            FluText {
                id: articleTitle
                z:0
                text: qsTr("　　" + note.articleTitle)
                font.bold: true  // 粗体
                font.pixelSize: 16  // 字体大小
                wrapMode: Text.Wrap  // 自动换行
                width: parent.width
            }

        }
    }

}
