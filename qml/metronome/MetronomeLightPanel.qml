import QtQuick 2.0
import QtMultimedia 5.5

import "../utilities"

Rectangle {
    color: styles.topMenuButtonUp

    property int bpm: 120
    property int meter: 4
    property bool running: false

    property int count: 0

    Timer {
        id: timer
        interval: 500
        repeat: true
        onTriggered: {
            lightFantastic.currentIndex = count;
            lightFantastic.currentItem.flash();
            count++;
            if (count === 1){
                boom.play();
            }
            else {
                tick.play();
            }
            if (count === meter) {
                count = 0;
            }
        }
    }

    onRunningChanged: {
        if (running) {
            count = 0;
            timer.start();
        }
        else {
            timer.stop();
        }
    }

    onBpmChanged: setSpeed();

    function setSpeed() {
        // bpm / 60 === bps
        var bps = bpm/60
        // milliseconds is 1000/bps
        timer.interval = 1000/bps
    }

    ListView {
        id: lightFantastic
        opacity: (parent.width < 1 ? 0 : 1)
        spacing: 2
        anchors.fill: parent
        anchors.margins: 8
        model: meter
        orientation: Qt.Horizontal
        delegate: MetronomeLight { width: 16; color: (index === 0 ? "red": "yellow") }
    }


    // /TODO sounds need to be attributed to
    // http://soundbible.com/tags-tick.html
    SoundEffect {
        loops: 1
        source: "../../assets/boom.wav"
        id: boom
        volume: 1
    }

    SoundEffect {
        loops: 1
        source: "../../assets/tick.wav"
        id: tick
        volume: 1
    }
}
