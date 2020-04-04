import QtQuick 2.0

Rectangle {
    anchors.margins: 40
    id: importWebsButton
    height: 40; width: 200;
    color: "#0becca"
    property string lowlightColor: "#0becca"
    property string highlightColor: "blue"
    property alias text: actualText.text
    radius: 8

    signal clicked();

    Component.onCompleted: {
        lowlightColor = color;
    }

    Text {
        id: actualText
        anchors.centerIn: parent
        text: "Nobody added text here"
    }
    MouseArea {
        anchors.fill: parent

        onClicked: {
            importWebsButton.clicked();
        }

        onContainsMouseChanged: {
            if (containsMouse) parent.color = highlightColor
            else parent.color = lowlightColor;
        }
    }
}
