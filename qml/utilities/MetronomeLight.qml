import QtQuick 2.0

Rectangle {
    border.color: "black"
    border.width: 1
    color: "yellow"
    radius: width/2
    height: width

    Rectangle {
        anchors.fill: parent;
        color: "black";
        opacity: 0.5
        radius: width/2
        id: cover
    }

    function flash() {
        cover.opacity = 0
        timer.start()
    }

    function lightOn() {
        cover.opacity = 0
    }

    function lightOff() {
        cover.opacity = 0.5
    }

    Timer {
        id: timer
        interval: 200
        repeat: false;
        onTriggered: {
            cover.opacity = 0.5;
        }
    }

}
