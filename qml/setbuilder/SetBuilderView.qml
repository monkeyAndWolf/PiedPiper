import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4

/* =====================
  NB: This is prototype standard code. It's a frikkin mess. But if it works
  it works and that's grand, because this is _not_ a simple part of the
  application.

  Delete this note iff the file ever gets refactored.
===================== */

Rectangle {

    id: root
    color: "transparent"//styles.sideMenuBackground
    property bool setOpen: false
    property string choon: "tune"

    property string setName: ""

    function openASet(openSetName) {
        setOpen = true;
        setName = openSetName;
        setNameEditor.text = setName
        // hack: when the model changes, if the set is the same length then the model doesn't
        // actually change. Setting the model to 0 forces the set to be changed every time, and
        // as in ITM most sets are two or three tunes, this is a good workaround.
        setTuneList.model = 0
        setTuneList.model =  (setModel.getSetLength(setName) === 0 ? 1 : (setModel.getSetLength(setName)*2))
        choons.model = 0
        choons.model = tuneModel
    }

    function noSetLoaded() {
        setName = ""
        setTuneList.model = 0
        setOpen = false
        setNameEditor.text = ""
    }


    states: [
        State {
            when: dragHerePlz.containsDrag && !setOpen
            PropertyChanges {
                target: dropTangle
                color: "yellow"
            }
            PropertyChanges {
                target: dropHereText
                visible: true
            }
        },
        State {
            id: stateSetOpen
            when: setOpen
        }

    ]


    ListView {

        id: setView
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: 200
        model: setModel
        spacing: 2
        delegate: SetBuilderSetDelegate {
            width: parent.width
            onRequestSelected: {
                root.openASet(setName)
            }
        }
    }

    Rectangle {
        id: dropTangle

        anchors.top: parent.top
        anchors.left: setView.right
        anchors.right: choons.left
        anchors.bottom: parent.bottom

        color: styles.mainScreenBackground



        Button {
            id: newSetButton
            text: "Create a new set"
            anchors.top: parent.top
            anchors.left: parent.left
            onClicked: {
                var noNameSet = "The set with no name"
                var counter = 0
                var testValue = noNameSet
                while (setModel.setExists(testValue)) {
                    counter++;
                    testValue = noNameSet + " " + counter
                }
                setModel.newSet(testValue)
                openASet(testValue)
            }
        }

        Button {
            id: deleteSetButton
            text: "Delete " + root.setName
            anchors.top: parent.top
            anchors.right: parent.right
            visible: setOpen
            onClicked: {
                setModel.deleteSet(setName)
                root.noSetLoaded()
            }
        }

        Rectangle {
            id: setNameTextContraption
            width: parent.width - 22; height: 22
            x: 11;
            anchors.top: newSetButton.bottom
            radius: 6
            color: "transparent"
            border.color: "black"
            border.width: 1
            TextEdit {
                id: setNameEditor
                font.pixelSize: 18
                anchors.centerIn: parent
                width: parent.width * 0.9
                opacity: 1
                property string currentText;
                onTextChanged: {

                    if (currentText === "" || text !== currentText) {
                        for (var i = 0; i < text.length; i++) {
                            var aChar = text.charAt(i)
                            if (aChar === "\n") {
                                setNameEditor.text = currentText
                                root.focus = true
                                return
                            }
                        }
                    }
                    currentText = text
                    setModel.renameSet(setName, text)
                    setName = text
                }
            }
        }

        // This DropArea prevents the rest of the list from working. May reinstate
        // for when there are no sets loaded, but gone for now.
//        DropArea {
//            id: dragHerePlz
//            anchors.fill: parent
//            keys: [ "tune" ]
//        //            Drag.keys: ["tune"]
//            onDropped: {
//            }
//            z:1

//            onEntered: {

//            }
//        }
// Set tunes list start

ListView {

    // I think that this needs to be a ListView with a model that is (setModel.length * 2) - 1
    // Then iterate through, so there are tunes and gaps for tunes. The drop area is in the
    // place of a gap. Drop a tune, respond by adding it to the model, rebuild the ListView.
    // Might work, if I'm very lucky. Well, it's prototype code.....

    id: setTuneList
    anchors.top: setNameTextContraption.bottom
    anchors.bottom: parent.bottom
    x: (parent.width - 250) / 2
    spacing: 2
    z: 50

    delegate: SetBuilderSetTuneListDelegate {
        undex: index

        onSetChanged: {
            openASet(setName)
        }
    }
}
// Set tunes list end



        Text {
            anchors.centerIn: parent
            id: dropHereText
            text: qsTr("Drop here to create a new set")
            visible: false
        }

    }

    TuneList {
        id: choons
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 1

        width: 200
        model: tuneModel

        delegate: SetBuilderTuneDelegate {
            tuneKey: choon
            id: dragegate
            width: choons.width;
            height: 50;
            tuneFilename: filename


        }
    }

}
