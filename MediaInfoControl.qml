import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.1
import QtMultimedia 5.9


Item {
    // text tên bài hát
    Text {
        id: audioTitle
        anchors.top: parent.top
        anchors.topMargin: headerItem.height / 6
        anchors.left: parent.left
        anchors.leftMargin: headerItem.height / 6
        text: !!album_art_view.currentItem ? album_art_view.currentItem.myData.title : "title"
        color: "white"
        font.pixelSize: headerItem.height / 4
        onTextChanged: {
            textChangeAni.targets = [audioTitle,audioSinger]
            textChangeAni.restart()
        }
    }
    // text tên ca sĩ
    Text {
        id: audioSinger
        anchors.top: audioTitle.bottom
        anchors.left: audioTitle.left
        text: !!album_art_view.currentItem ?  album_art_view.currentItem.myData.singer : "singer"

        color: "white"
        font.pixelSize: headerItem.height / 5.5
    }

    NumberAnimation {
        id: textChangeAni
        property: "opacity"
        from: 0
        to: 1
        duration: 400
        easing.type: Easing.InOutQuad
    }
    // text số bài hát
    Text {
        id: audioCount
        anchors.verticalCenter: audioTitle.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: headerItem.height / 6
        text: album_art_view.count
        color: "white"
        font.pixelSize: headerItem.height / 3.5

        Image {
            source: "qrc:/Image/music.png"
            height: parent.height / 1.4
            width: height
            anchors.right: parent.left
            anchors.rightMargin: parent.width / 3
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: audioCount.height / 10
        }
    }

    // album art
    Component {
        id: appDelegate
        Item {
            property variant myData: model
            width: root.width / 5; height: width
            scale: PathView.iconScale

            Image {
                id: myIcon
                width: parent.width
                height: parent.height
                y: headerItem.height / 6
                anchors.horizontalCenter: parent.horizontalCenter
                source: albumArt
            }

            MouseArea {
                anchors.fill: parent
                // khi nhấn vào album art khác thì index của playlist sẽ thay đổi tương ứng
                onClicked: player.playlist.setCurrentIndex(index)
            }
        }
    }

    PathView {
        id: album_art_view
        anchors.left: parent.left
        anchors.leftMargin: (parent.width - root.width / 1.7) / 2
        anchors.top: parent.top
        anchors.topMargin: parent.height / 3

        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        focus: true
        model: playlistModel
        delegate: appDelegate
        pathItemCount: 3
        path: Path {
            startX: 0
            startY: parent.height * 0.05

            PathAttribute { name: "iconScale"; value: 0.5 }
            PathLine { x: parent.width * 0.29; y: parent.height * 0.05 }
            PathAttribute { name: "iconScale"; value: 1 }
            PathLine { x: parent.width * 0.58 ; y: parent.height * 0.05 }
            PathAttribute { name: "iconScale"; value: 0.5 }
        }
    }
    // khi index của playlist thay đồi thì index của album art cũng thay đổi tương ứng
    Connections{
        target: PlayList
        onCurrentIndexChanged: {
            album_art_view.currentIndex = index;
        }
    }

    //Progress
    Text {
        id: currentTime
        anchors.verticalCenter: progressBar.verticalCenter

        anchors.right: progressBar.left
        anchors.rightMargin: headerItem.height / 6
        text: !!utility ? utility.getTimeInfo(player.position) : "00:00"

        color: "white"
        font.pixelSize: headerItem.height / 4
    }
    Text {
        id: totalTime
        anchors.verticalCenter: progressBar.verticalCenter
        anchors.left: progressBar.right
        anchors.leftMargin: headerItem.height / 6
        text: !!utility ? utility.getTimeInfo(player.duration) : "00:00"

        color: "white"
        font.pixelSize: headerItem.height / 4
    }
    Slider{
        id: progressBar
        width: root.width * 0.77 - playlist.width
        anchors.bottom: parent.bottom
        anchors.bottomMargin: root.height / 5.5
        anchors.horizontalCenter: parent.horizontalCenter
        from: 0
        to: player.duration
        value: player.position
        background: Rectangle {
            x: progressBar.leftPadding
            y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
            implicitWidth: 200
            implicitHeight: totalTime.height * 0.1
            width: progressBar.availableWidth
            height: implicitHeight
            radius: totalTime.height / 5
            color: "gray"

            Rectangle {
                width: progressBar.visualPosition * parent.width
                height: parent.height
                color: "white"
                radius: totalTime.height / 5
            }
        }
        handle: Image {
            anchors.verticalCenter: parent.verticalCenter
            height: totalTime.height
            width: height
            x: progressBar.leftPadding + progressBar.visualPosition * (progressBar.availableWidth - width)
            y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
            source: "qrc:/Image/point.png"
            Image {
                anchors.centerIn: parent
                source: "qrc:/Image/center_point.png"
                height: parent.height/1.5
                width: height
            }
        }
        onMoved: {
            if (player.seekable){
                player.setPosition(Math.floor(position*player.duration))
            }
        }
    }

    //Media control
    // ngẫu nhiên
    SwitchButton {
        id: shuffer
        widthSize: prev.widthSize / 1.5
        heihgtSize: prev.heihgtSize / 1.5
        anchors.verticalCenter: play.verticalCenter
        anchors.left: currentTime.left
        icon_off: "qrc:/Image/shuffle.png"
        icon_on: "qrc:/Image/shuffle-1.png"

        onStatusChanged: {
            if(shuffer.status === 1)
            {
                console.log("Playlist.Random ON")
                APP_CTRL.playBackModeList(Playlist.Random)
            }else{
                console.log("Playlist.Sequential ON")
                APP_CTRL.playBackModeList(Playlist.Sequential)
            }
        }
    }
    // lùi
    ButtonControl {
        id: prev
        widthSize: play.widthSize / 1.2
        heihgtSize: play.heihgtSize / 2
        anchors.verticalCenter: play.verticalCenter
        anchors.right: play.left
        icon_default: "qrc:/Image/prev.png"
        icon_pressed: "qrc:/Image/hold-prev.png"
        icon_released: "qrc:/Image/prev.png"
        onClicked: {
            // khi lùi nếu index bằng 0 thì gán về cuối danh sách
            if (player.playlist.currentIndex > 0)
                player.playlist.previous()
            else player.playlist.setCurrentIndex(album_art_view.count-1)
        }
    }
    // phát
    ButtonControl {
        id: play
        widthSize: root.height / 8
        heihgtSize: widthSize
        anchors.top: progressBar.bottom
        anchors.topMargin: heihgtSize * 0.1
        anchors.horizontalCenter: progressBar.horizontalCenter
        icon_default: player.state == MediaPlayer.PlayingState ?  "qrc:/Image/pause.png" : "qrc:/Image/play.png"
        icon_pressed: player.state == MediaPlayer.PlayingState ?  "qrc:/Image/hold-pause.png" : "qrc:/Image/hold-play.png"
        icon_released: player.state== MediaPlayer.PlayingState ?  "qrc:/Image/pause.png" : "qrc:/Image/play.png"
        onClicked: {
            if (player.state != MediaPlayer.PlayingState){
                player.play()
            } else {
                player.pause()
            }
        }
        Connections {
            target: player
            onStateChanged:{
                play.source = player.state == MediaPlayer.PlayingState ?  "qrc:/Image/pause.png" : "qrc:/Image/play.png"
            }
        }
    }
    // tới
    ButtonControl {
        id: next
        widthSize: play.widthSize /1.2
        heihgtSize: play.heihgtSize / 2
        anchors.verticalCenter: play.verticalCenter
        anchors.left: play.right
        icon_default: "qrc:/Image/next.png"
        icon_pressed: "qrc:/Image/hold-next.png"
        icon_released: "qrc:/Image/next.png"
        onClicked: {
            // khi tiến nếu index ở cuối danh sách thì gán về đầu danh sách
            if (player.playlist.currentIndex < album_art_view.count -1)
                player.playlist.next()
            else player.playlist.setCurrentIndex(0)
        }
    }
    // lặp lại
    SwitchButton {
        id: repeater
        widthSize: next.widthSize / 1.5
        heihgtSize: next.heihgtSize / 1.5
        anchors.verticalCenter: play.verticalCenter
        anchors.right: totalTime.right
        icon_on: "qrc:/Image/repeat1_hold.png"
        icon_off: "qrc:/Image/repeat.png"

        onStatusChanged: {
            if(repeater.status === 1) {
                console.log("Playlist.CurrentItemInLoop ON")
                APP_CTRL.playBackModeList(Playlist.CurrentItemInLoop)
            }
            else {
                console.log("Playlist.Sequential ON")
                APP_CTRL.playBackModeList(Playlist.Sequential)
            }
        }
    }
}
