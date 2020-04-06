import QtQuick 2.0
import PiedPiper 1.0

Item {

    id: root

    property int margin: 0
    property string tuneFilename;
    property alias tuneMeter: met.text
    property alias tuneTitle: tit.text

    property Item homeTarget


    Rectangle {
        id: dragBoi
        radius: 10;
        anchors.top: parent.top
        anchors.right: parent.right
        border.color: "#123456"
        border.width: 2
        x: margin; y: margin; width: root.width - (margin*2); height: root.height - (margin*2);
        color: root.state === "dragging" ? styles.sideMenuButtonDown : styles.sideMenuButtonUp

        Column {
            anchors.fill: parent
            anchors.margins: 2
            property string content: content
            Text {
                id: tit
                font.bold: true
                wrapMode: Text.WordWrap
            }
            Text {
                id: met
            }
        }
    }

    MouseArea {
        id: maus
        anchors.fill: dragBoi
        drag.target: dragBoi
    }

    states: [
        State {
            name: "dragging"
            when: maus.pressed
            ParentChange { target: dragBoi; parent: root.homeTarget }
            AnchorChanges { target: dragBoi; anchors.top: undefined; anchors.right: undefined }
        }
    ]
}
