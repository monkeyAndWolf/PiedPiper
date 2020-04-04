import QtQuick 2.0
import QtQuick.Controls 1.4

Item {

    signal setSelected(var setNameToOpen)

    Item {
        id: topBop
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50

        Button {
            id: newSetButton
            text: qsTr("New Set")
            onClicked: {
                var noNameSet = "The set with no name"
                var counter = 0
                var testValue = noNameSet
                while (setModel.setExists(testValue)) {
                    counter++;
                    testValue = noNameSet + " " + counter
                }
                setModel.newSet(testValue)
                setSelected(testValue)
            }
        }

    }



    ListView {
        id: setView
        clip: true
        anchors.top: topBop.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        model: setModel
        spacing: 2
        delegate: SetBuilderSetDelegate {
            width: parent.width
            onRequestSelected: {
                setSelected(setName)
            }
            onDeleteThisSet: {
                setModel.deleteSet(setName)
            }
        }
    }

}
