import QtQuick 2.0
import PiedPiper 1.0

Rectangle {

    id: root
    property int margin: 2
    property string tuneFilename;
    property alias tuneMeter: met.text
    property alias tuneTitle: tit.text

    Connections {
        onTuneTitleChanged: {
            tuneTitle = title
        }
    }


    MouseArea {
        anchors.fill: parent
        onPressed: {
            logger.logTuneOpen(filename + " " + title)
            openTune(tuneFilename);
        }
        onContainsMouseChanged: {
            if (containsMouse) parent.color = styles.sideMenuButtonDown  //"#006600"
            else parent.color = styles.sideMenuButtonUp;
        }
        onDoubleClicked: {
            openTuneEditPage(tuneFilename);
        }

    }
    radius: 10;

    color: styles.sideMenuButtonUp
    Rectangle {
        x: margin; y: margin; width: parent.width - (margin*2); height: parent.height - (margin*2);
        color: "transparent"

        Column {
            anchors.fill: parent
            property string content: content
            Text {
                id: tit
//                text:
                font.bold: true
                wrapMode: Text.WordWrap
            }
            Text {
                id: met
//                text:
            }
        }
    }
}
