import QtQuick 2.6
import QtQuick.Controls 2.4
import Qt.labs.settings 1.0

ApplicationWindow {
    id: root
    visible: true
    width: 1920
    height: 1200
    title: qsTr("STR_MAIN_TITLE") + Translator.updateText

    // Backgroud of Application
    Image {
        id: backgroud
        anchors.fill: parent
        source: "qrc:/images/back ground/background.png"
    }

    // Header
    AppHeader{
        id: headerItem
        width: parent.width
        height: parent.height * 0.13
    }

    // Playlist
    PlaylistView{
        id: playlist
        y: headerItem.height
        width: parent.width * 0.35 * playlist.position
        height: parent.height - headerItem.height
    }

    // Media Info
    MediaInfoControl{
        id: mediaInfoControl
        anchors.top: headerItem.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: playlist.width
        anchors.bottom: parent.bottom
    }

    Settings {
        category: "window"
        property alias x: root.x
        property alias y: root.y
        property alias width: root.width
        property alias height: root.height
    }


}
