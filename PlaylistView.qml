import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.1

Drawer {
    id: drawerId
    interactive: false
    modal: false
    background: Rectangle {
        id: playList_bg
        anchors.fill: parent
        color: "transparent"
    }
    // danh sách bài hát
    ListView {
        id: mediaPlaylist
        anchors.fill: parent
        model: playlistModel
        clip: true
        spacing: 2
        currentIndex: 0
        delegate: MouseArea {
            property variant myData: model
            implicitWidth: playlistItem.width
            implicitHeight: playlistItem.height
            Image {
                id: playlistItem
                width: mediaPlaylist.width
                height: mediaPlaylist.height / 6
                source: "qrc:/Image/playlist.png"
                opacity: 0.5
            }
            Text {
                text: title
                anchors.fill: parent
                anchors.leftMargin: mediaPlaylist.width / 7
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.pixelSize: playlistItem.height / 4.5
            }
            onClicked: {
                // khi nhấn vào bài hát khác thì index của playlist sẽ thay đổi tương ứng
                player.playlist.setCurrentIndex(index)
            }
            onPressed: {
                playlistItem.source = "qrc:/Image/hold.png"
            }
            onReleased: {
                playlistItem.source = "qrc:/Image/playlist.png"
            }
            onCanceled:  {
                playlistItem.source = "qrc:/Image/playlist.png"
            }
        }
        // nếu local file music rỗng thì danh sách sẽ hiển thị một thông báo
        Text {            
            anchors.horizontalCenter: parent.horizontalCenter   
            text: qsTr("STR_NOTIFY") + Translator.updateText
            color: "white"
            font.pointSize: headerItem.height / 9
            visible: mediaPlaylist.count ? false : true
        }

        highlight: Image {
            source: "qrc:/Image/playlist_item.png"
            width: mediaPlaylist.width
            height: mediaPlaylist.height / 6
            Image {
                source: "qrc:/Image/playing.png"
                anchors.left: parent.left
                anchors.leftMargin: width / 2
                anchors.verticalCenter: parent.verticalCenter
                width: headerItem.height * 0.3
                height: width
            }
        }
        ScrollBar.vertical: ScrollBar {
            parent: mediaPlaylist.parent
            anchors.top: mediaPlaylist.top
            anchors.left: mediaPlaylist.right
            anchors.bottom: mediaPlaylist.bottom
        }
    }

    // khi index của playlist thay đồi thì index của danh sách hiển thị cũng thay đổi tương ứng
    Connections{
        target: PlayList
        onCurrentIndexChanged: {
            mediaPlaylist.currentIndex = index;
        }
    }
}
