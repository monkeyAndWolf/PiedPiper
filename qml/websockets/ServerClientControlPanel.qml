import QtQuick 2.0
import QtQuick.Controls 1.4

Item {

    id: root
    height: 25 // TODO this is a hard-coded magic number
    width: parent.width

    property bool serverMode: switcheroo.checked

    Row {
        Text {
            text: serverMode ? qsTr("Server Mode"): qsTr("Client Mode")
        }
        Item {
            height: 5
            width: height
        }
        Switch {
            id: switcheroo
            checked: true
        }
        Item {
            id: spacer2
            height: 5
            width: height
        }
        Rectangle {
            height: root.height
            width: root.width/2
            clip: true
            color: "transparent"

            Item {
                height: parent.height * 2
                width: parent.width
                y: switcheroo.checked ? 0: (parent.parent.height * -1)

                Behavior on y {
                    ParallelAnimation {
                        PropertyAnimation { duration: 500 }
                        ScriptAction { script:  {
                                ccp.lostFocus()
                            }
                        }
                    }
                }

                ServerControlPanel {
                    id: scp
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: parent.height/2
                }
                ClientControlPanel {
                    id: ccp
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: parent.height/2
                }
            }
        }
    }
/*
        Rectangle {
            height: 10;//parent.height * 2
//            y: parent.height * -1
            anchors.left: switcheroo.right
            anchors.right: parent.right
            color: "#c0c0c0"
/*
            Rectangle {
                color: "yellow"
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height
            }
            Rectangle {
                color: "red"
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height
           }
            */

        //}
//    }




/*
        Item {
            height: 5
            width: 20
        }
        MetronomeLight {
            id: frikkinLight
            color: "yellow"
            height: 12; width: height
        }

        Item {
            height: 5
            width: 20
        }

        Text {
            id: ipText
            text: ""
        }

    }
    QQ1.Button {
        id: serverButton
        enabled: switcheroo.checked
        text: serverRunning ? qsTr("Stop Server") : qsTr("Start Server")
        onClicked: {
            serverRunning = !serverRunning
        }
    }



    property bool serverRunning: false

    onServerRunningChanged: {
        if (serverRunning)
            frikkinLight.lightOn()
        else
            frikkinLight.lightOff()
    }
/**/
}
