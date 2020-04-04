import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4

Rectangle {

    // We know that the Metronome is 250x40, but try not to hard code against this

    id: root

    property bool running: false

    Image {
        id: button
        anchors.margins: 5
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: height
        source: (root.running ? "../../assets/stop.png" : "../../assets/play.png")

        MouseArea {
            anchors.fill: parent
            onClicked: root.running = !root.running
        }
    }

    states: [
        State {
            id: running
            when: root.running
        },
        State {
            id: notRunning
            when: !root.running
        }
    ]

    MetronomeControlPanel {
        id: controlPanel
        running: root.running
        anchors.margins: 5
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: button.right
        anchors.right: parent.right
    }



}
