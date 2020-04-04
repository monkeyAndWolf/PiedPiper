import QtQuick 2.0

Rectangle {
    color: "transparent"
    radius: 5

    property alias label: label.text
    height: label.height + shim.height + topShim.height;
    width: page.width - 40;

    Item {
        id: topShim
        width: parent.width
        height: 20
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: label.top
    }

    Text {
        id: label
        anchors.left: parent.left
        anchors.bottom: bar.top
//        y: (parent.height - height) - 10
//        anchors.margins: (parent.height - label.height)/2
        wrapMode: Text.WordWrap
        text: qsTr("Nobody set a label yet")
    }

    Rectangle {
        id: bar
        height: 1; width: parent.width/2
        color: "black"
        anchors.bottom: shim.top
    }

    Item {
        id: shim
        height: 10; width: parent.width
        anchors.bottom: parent.bottom
    }
}
