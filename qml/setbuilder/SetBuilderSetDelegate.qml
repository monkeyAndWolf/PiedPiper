import QtQuick 2.0

Rectangle {
    id: mom

    function notifySelected() {
    }

    signal requestSelected(var setName)
    signal deleteThisSet(var setName)

    property bool mouseDown: false
    property int dragLine: -1

    function startDeleteProcess() {
        color = "red"
        setNameText.text = qsTr("Swipe right to delete ") + setName
    }
    Behavior on color {
        PropertyAnimation {
            duration: 200
        }
    }

    color: styles.topMenuButtonUp
    border.width: 2
    border.color: "black"
    radius: 10
    height: 50
    Rectangle {
        height: parent.height/2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        color: "transparent"
        Text {
            id: setNameText
            anchors.centerIn: parent
            text: setName
        }
    }
    Rectangle {
        height: parent.height/2
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        color: "transparent"
        Text {
            anchors.centerIn: parent
            text: length + " tune" + (length != 1?"s.":".")
        }
    }

    MouseArea {
        anchors.fill: parent
        onDoubleClicked: {
            requestSelected(setName)
        }
        onPressAndHold: {
            mouseDown = true
            dragLine = mouse.x
            startDeleteProcess()
        }
        onReleased: {
            mouseDown = false
            dragLine = -1
            mom.color = styles.topMenuButtonUp
            setNameText.text = setName
        }
        onPositionChanged: {
            if (dragLine !== -1) {
                var xit = mouse.x - dragLine
                if (xit > width/2)
                    deleteThisSet(setName)
            }
        }
    }
}
