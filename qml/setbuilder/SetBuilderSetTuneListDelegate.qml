import QtQuick 2.0

Rectangle {
    id: root
    property int undex; // the index in the model
    property int ondex: 0; // tune position in set
    property string fileName: "";
    signal setChanged(var setName)

    Text {
        id: spud
        anchors.centerIn: parent
    }

    height: 50
    width: 250
    color: styles.sideMenuButtonUp
    radius: 10
    Component.onCompleted: {

        if (undex % 2 === 0) {
            ondex += undex/2
            fileName = setModel.getTuneNameAt(setName, ondex)
            var choonName = settingsAccess.getValue(fileName, "title")
            if (choonName !== undefined)
                spud.text = choonName
        }
    }

    states: [
        State {
            id: hasTune
        },
        State {
            id: hasNoTune
            when: spud.text === ""
            PropertyChanges {
                target: root
                color: "#c0c0c0"
                height: 25
            }
        }

    ]

    Rectangle {
        id: overlay
        color: "black"
        opacity: 0
        radius: parent.radius
        anchors.fill: parent
        DropArea {
            id: drop
            anchors.fill: parent
            keys: [ "tune" ]
            onEntered: {
                // It would be better here to use the State system
                overlay.opacity = 0.5
            }
            onExited: {
                overlay.opacity = 0
            }
            onDropped: {
                actionDrop(drop.source.tuneFilename)
                overlay.opacity = 0
            }
        }
    }

    function actionDrop(filename) {
        // Take the Undex, and calculate it back to where it needs to go,
        // then just push it into the SetModel!!!! HOLY FRAK!!!
        var locationToInsert = -1
        if (undex %2 === 0) {
            // overwrite existing tune
            if (undex === 0)
                locationToInsert = 0
            else
                locationToInsert = undex / 2
            setModel.removeTuneFromSet(setName,  fileName)
            setModel.addTuneToSet(setName, filename, locationToInsert)

        }
        else {
            // Add new tune
            if (undex === 0) {
                locationToInsert = 1 // New set, no tunes
            }
            else {
                if (undex === 1) {
                    locationToInsert = 2
                }
                else  {
                    locationToInsert = (undex / 2) + 1.5
                }
            }
            setModel.addTuneToSet(setName, filename, locationToInsert)
        }
        setChanged(setName)
    }

    MouseArea {
        anchors.fill: parent
        onDoubleClicked: {
            setModel.removeTuneFromSet(setName,  fileName)
            setChanged(setName)
        }
    }

}
