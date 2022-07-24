import QtQuick 2.0

Item {
    Image {
        id: headerItem
        anchors.fill: parent
        source: "qrc:/images/back ground/title.png"
        // nút nhấn drawer
        SwitchButton {
            id: playlist_button
            heihgtSize: parent.height / 3
            widthSize: heihgtSize
            anchors.left: parent.left
            anchors.leftMargin: widthSize / 2
            anchors.verticalCenter: parent.verticalCenter
            icon_off: "qrc:/images/icon/drawer_p.png"
            icon_on: "qrc:/images/icon/back.png"
            onStatusChanged: {
                if(playlist_button.status === 1) {
                    playlist.open()
                } else {
                    playlist.close()
                }
            }
        }
        // text playlist
        Text {
            anchors.left: playlist_button.right
            anchors.leftMargin: playlist_button.heihgtSize / 2
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("STR_PLAYLIST") + Translator.updateText
            color: "white"
            font.pixelSize: parent.height / 4
        }
        // text media
        Text {
            id: headerTitleText
            text: qsTr("STR_HEADER_TITLE") + Translator.updateText
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: parent.height / 3
        }
        // icon lá cờ việt nam
        Image {
            id: vn_flag
            anchors.right: parent.right
            anchors.rightMargin: playlist_button.heihgtSize
            anchors.verticalCenter: parent.verticalCenter
            width: playlist_button.heihgtSize
            height: playlist_button.heihgtSize
            source: "qrc:/images/icon/vn.png"
            property bool click_vn_flag: false
            Rectangle{
                width: parent.width
                height: width / 1.5
                anchors.verticalCenter: parent.verticalCenter
                border.color: "gray"
                border.width: 3
                color: "transparent"               
                visible: vn_flag.click_vn_flag ? true : false
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Translator.selectLanguage("vn")
                    vn_flag.click_vn_flag = true
                    us_flag.click_us_flag = false
                }
            }
        }
        // icon lá cờ mỹ
        Image {
            id: us_flag
            anchors.right: vn_flag.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            width: vn_flag.width
            height: vn_flag.width
            source: "qrc:/images/icon/us.png"
            property bool click_us_flag: true
            Rectangle{
                width: parent.width
                height: width / 1.5
                anchors.verticalCenter: parent.verticalCenter
                border.color: "gray"
                border.width: 3
                color: "transparent"
                visible: us_flag.click_us_flag ? true : false
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Translator.selectLanguage("us")
                    us_flag.click_us_flag = true
                    vn_flag.click_vn_flag = false
                }
            }
        }
    }
}
