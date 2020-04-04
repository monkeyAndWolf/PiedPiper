import QtQuick 2.0
import QtQuick.Controls 1.4

import "../utilities"

Item {

    property bool clientConnecting: false
    property bool clientConnected: false

    function lostFocus() {
        if (tixt.focus)
            tixt.focus = false
    }

    onClientConnectedChanged: {
        if (clientConnected)
            light.lightOn()
        else
            light.lightOff()
    }

    Row {
        anchors.fill: parent
        Text {
            id: jtixt
            text: qsTr("Server Address:")
        }

        Item {
            height: 10; width: height
        }

        TextField {
            id: tixt
            width: parent.width/3
            height: parent.height
        }
        Item {
            height: 10; width: height
        }
        MetronomeLight {
            id: light
            color: "red"
            height: 20; width: 20
        }
        Item {
            height: 10; width: height
        }
        Button {
            id: button
            text:  clientConnected ? qsTr("Disconnect") : qsTr("Connect")
            onClicked: {
                clientConnected = !clientConnected
            }
        }
    }

}
