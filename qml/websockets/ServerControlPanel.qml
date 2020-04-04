import QtQuick 2.0
import QtQuick.Controls 1.4

import "../utilities"

Item {

    property bool serverRunning: false

    function serverStarted(socketAddress) {
        serverRunning = true
        output.text = "Server name: " + socketAddress
    }
    function serverStopped() {
        serverRunning = false
        output.text = ""
    }

    function clientConnected() {

    }

    onServerRunningChanged: {
        if (serverRunning)
            light.lightOn()
        else
            light.lightOff()
    }

    Component.onCompleted: {
        wss.socketOpen.connect(serverStarted)
        wss.socketClosed.connect(serverStopped)
    }

    Row {
        anchors.fill: parent

        MetronomeLight {
            id: light
            color: "yellow"
            height: 20
            width: 20
        }
        Item {
            width: 5
            height: width
        }
        Button {
            text: serverRunning ? qsTr("Stop Server") : qsTr("Start Server")
            onClicked: {
                if (serverRunning)
                    wss.closeTheSocket()
                else
                    wss.openTheSocket()
            }
        }
        Item {
            width: 5
            height: width
        }

        Text {
            id: output
        }

    }

}
