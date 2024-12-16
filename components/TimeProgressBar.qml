import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import FluentUI

// 进度条组件
ProgressBar {
    // 动画持续时间（毫秒）
    property int duration: 888

    // 进度条的宽度
    property real strokeWidth: 6

    // 进度文本是否可见
    property bool progressVisible: true

    // 进度条颜色
    property color color: FluTheme.primaryColor

    // 进度条背景颜色，根据主题变化
    property color backgroundColor : FluTheme.dark ? Qt.rgba(99/255,99/255,99/255,1) : Qt.rgba(214/255,214/255,214/255,1)

    // 进度条组件的唯一标识符
    id: control

    // 是否为不确定进度
    indeterminate: false

    QtObject {
        id: d
        // 进度条圆角半径
        property real _radius: strokeWidth / 2
    }

    // 不确定进度属性变化时的处理程序
    onIndeterminateChanged: {
        if (!indeterminate) {
            animator_x.duration = 0
            rect_progress.x = 0
            animator_x.duration = control.duration
        }
    }

    // 进度条背景
    background: Rectangle {
        implicitWidth: 150
        implicitHeight: control.strokeWidth
        color: control.backgroundColor
        radius: d._radius
    }

    // 进度条内容
    contentItem: FluClip {
        clip: true
        radius: [d._radius, d._radius, d._radius, d._radius]

        // 表示进度填充的矩形
        Rectangle {
            id: rect_progress
            width: {
                if (control.indeterminate) {
                    return 0.5 * parent.width
                }
                return control.visualPosition * parent.width
            }
            height: parent.height
            radius: d._radius
            color: control.color

            // 进度填充的动画
            SequentialAnimation on x {
                id: animator_x
                running: control.indeterminate && control.visible
                loops: Animation.Infinite
                PropertyAnimation {
                    from: -rect_progress.width
                    to: control.width + rect_progress.width
                    duration: control.duration
                }
            }
        }
    }

    // 显示进度百分比的文本
    FluText {
        text: "距离检票开始还有()分钟"
        visible: {
            if (control.indeterminate) {
                return false
            }
            return control.progressVisible
        }
        anchors {
            left: parent.left
            leftMargin: control.width + 5
            verticalCenter: parent.verticalCenter
        }
    }
}
