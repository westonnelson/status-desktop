import QtQuick 2.3
import QtMultimedia 5.14
import QtGraphicalEffects 1.13
import "../../../../../shared"
import "../../../../../imports"

Item {
    property string audioSource: ""

    id: root
    height: 20
    width: 350

    Audio {
        id: audioMessage
        source: audioSource
//        source: "../../../../../sounds/notification.wav"
//        audioRole: Audio.NotificationRole
//        source: "data:audio/mp4;base64,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"
        notifyInterval: 10
    }


    SVGImage {
        id: playButton
        source: audioMessage.playbackState === Audio.PlayingState ? "../../../../img/icon-pause.svg" : "../../../../img/icon-play.svg"
        width: 15
        height: 15
        anchors.left: parent.left
        anchors.leftMargin: Style.current.padding
        anchors.verticalCenter: parent.verticalCenter

        ColorOverlay {
            anchors.fill: parent
            source: parent
            color: Style.current.textColor
        }

        MouseArea {
            id: playArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onPressed: {
                console.log('Current state: ' + audioMessage.playbackState)
                console.log('bufferProgress: ' + audioMessage.bufferProgress)
                console.log('duration : ' + audioMessage.duration )
                console.log('error : ' + audioMessage.error )
                console.log('errorString : ' + audioMessage.errorString )
                console.log('hasAudio  : ' + audioMessage.hasAudio  )
                console.log('muted : ' + audioMessage.muted )
                console.log('position  : ' + audioMessage.position  )
//                console.log('source   : ' + audioMessage.source.toString()  )
                console.log('status   : ' + audioMessage.status   )
                console.log('volume   : ' + audioMessage.volume   )
                if (audioMessage.playbackState === Audio.PlayingState) {
                    console.log('PAUSE')
                    audioMessage.pause();
                } else {
                    console.log('PLAY')
                    audioMessage.play();
                }
            }
        }
    }
    
    Rectangle {
        height: 2
        width: 300
        color: Style.current.inputBackground
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: playButton.right
        anchors.leftMargin: 20
        Rectangle {
            id: progress
            height: 2
            width: {
                if(audioMessage.duration === 0) return 0;
                if(audioMessage.playbackState === Audio.StoppedState) return 0;
                return parent.width * audioMessage.position / audioMessage.duration;
            }
            color: Style.current.textColor
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            id: handle
            width: 10
            height: 10
            color: Style.current.textColor
            radius: 10
            anchors.verticalCenter: parent.verticalCenter
            x: progress.width
            state: "default"

            states: State {
                name: "pressed"
                when: handleMouseArea.pressed
                PropertyChanges {
                    target: handle;
                    scale: 1.2
                }
            }
            transitions: Transition {
                NumberAnimation { 
                    properties: "scale";
                    duration: 100;
                    easing.type: Easing.InOutQuad
                }
            }

            MouseArea {
                id: handleMouseArea
                cursorShape: Qt.PointingHandCursor
                anchors.fill: parent
                drag.target: parent
                drag.axis: Drag.XAxis
                drag.minimumX: 0
                drag.maximumX: parent.parent.width
                onPressed: {
                    handle.state = "pressed"
                    if(audioMessage.playbackState === Audio.PlayingState){
                        audioMessage.pause();
                    }
                }
                onReleased: {
                    handle.state = "default"
                    audioMessage.seek(audioMessage.duration * handle.x / parent.parent.width);
                }
            }
        }
    }
}
