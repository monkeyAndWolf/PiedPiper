import QtQuick 2.0

import '..'

Rectangle {
    color: styles.mainScreenBackground

    SetListJustSets {
        id: setList
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: (parent.width > 900) ? 300 : parent.width / 3
        onSetSelected: {
            wideSetShower.openASet(setNameToOpen)
//            listOfTunesNotInSet.openASet(setNameToOpen)
        }
    }

    // Show _all_ tunes for now. This means that you can enter the same tune multiple times.
    TuneList {
        id: choonList
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: (parent.width > 900) ? 300 : parent.width / 3

        model: tuneModel
        delegate: DraggyTuneListDelegate {
            homeTarget: wideSetShower
            width: parent.width
            height: 50
            tuneFilename: filename
            tuneMeter: meter
            tuneTitle: title
        }
    }

    SetListASetWide {
        id: wideSetShower
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: setList.right
        anchors.right: choonList.left
        width: (parent.width > 900) ? 300 : parent.width / 3
    }
}
