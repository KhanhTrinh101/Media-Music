import QtQuick 2.0

MouseArea {
    id: root
    property string icon_on: ""
    property string icon_off: ""
    property int status: 0 //0-Off 1-On
    property alias heihgtSize: img.height
    property alias widthSize: img.width
    implicitWidth: img.width
    implicitHeight: img.height
    Image {
        id: img        
        source: root.status === 0 ? icon_off : icon_on
    }
    onClicked: status = !status
}
