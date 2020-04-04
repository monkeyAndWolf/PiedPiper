import QtQuick 2.0
import PiedPiper 1.0

Rectangle {

    id: root
    property int margin: 2
    property string tuneFilename;
    property string tuneKey;

    radius: 10;

    Drag.source: root
    Drag.keys: [ tuneKey ]
    Drag.active: mouseArea.drag.active


    MouseArea {
        anchors.fill: parent
        drag.target: parent
        id: mouseArea
        onPressed: {

        }
        onContainsMouseChanged: {
            if (containsMouse) parent.color = styles.sideMenuButtonDown  //"#006600"
            else parent.color = styles.sideMenuButtonUp;
        }

        onReleased: {
            parent.Drag.drop()
        }

    }

    color: styles.sideMenuButtonUp
    Rectangle {
        x: margin; y: margin; width: parent.width - (margin*2); height: parent.height - (margin*2);
        color: "transparent"

        Column {
            anchors.fill: parent
            property string content: content
            Text {
                id: tit
                text: title
                font.bold: true
                wrapMode: Text.WordWrap
            }
            Text {
                id: met
                text: meter
            }
        }
    }
}
