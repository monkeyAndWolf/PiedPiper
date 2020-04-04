import QtQuick 2.0

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
            listOfTunesNotInSet.openASet(setNameToOpen)
        }
    }

    SetListASetWide {
        id: wideSetShower
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: setList.right
        width: (parent.width > 900) ? 300 : parent.width / 3
    }

    ListOfTunesThatAreNotInTheSet {
        id: listOfTunesNotInSet
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: wideSetShower.right
        width: (parent.width > 900) ? 300 : parent.width / 3
    }
}
