import QtQuick 2.0
import QtQuick.Controls 2.1

import "setbuilder"

Rectangle {
    color: styles.sideMenuBackground
    property int currentIndex: 0
    property string currentSetName: ""

    Drawer {
        edge: Qt.LeftEdge
        width: sets.width
        height: parent.height
        position: 0.3
        ListView {
            id: sets
            model: setModel
            anchors.top: parent.top
            anchors.bottom: parent.bottom
    //        anchors.left: parent.left
            height: 500
            width: 200
            clip: true
            focus: true
            delegate: SetBuilderSetDelegate {
                width: parent.width
                onRequestSelected: {
                    // TODO need an unselection mechanism. ODI?
                    sets.currentItem.notifySelected()
                    swipeyTuneView.addSetOfChoons(setName)
                    currentSetName = setName
                }
            }
            highlightFollowsCurrentItem: true
            spacing: 5

        }
    }


    function createLabels() {
        if ("" !== currentSetName) {
            if (0 !== currentIndex) {
                setLeftText()
            }
            else
                leftText.text = ""
            setMiddleText()
            if ((setModel.getSetLength(currentSetName)-1) !== currentIndex) {
                setRightText()
            }
            else
                rightText.text = ""
        }
    }

    function setLeftText() {
        var tuneName = setModel.getTuneNameAt(currentSetName, currentIndex-1)
        tuneName = tuneModel.tunePathToName(tuneName)
        leftText.text = "< " + tuneName
    }
    function setMiddleText() {
        mainText.text = currentIndex+1 + "/" + setModel.getSetLength(currentSetName)
    }
    function setRightText() {
        var tuneName = setModel.getTuneNameAt(currentSetName, currentIndex+1)
        tuneName = tuneModel.tunePathToName(tuneName)
        rightText.text = tuneName + " >"
    }

    onCurrentSetNameChanged: {
        createLabels()
    }

    SwipeyTuneView {
        id: swipeyTuneView
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        height: parent.height - 50
        onTuneIndexChanged: {
            currentIndex = newIndex
            createLabels()
        }
    }
    Rectangle {
        height: 50
        anchors.left: swipeyTuneView.left
        anchors.right: swipeyTuneView.right
        anchors.bottom: parent.bottom
        anchors.top: swipeyTuneView.bottom
        color: "transparent"

        Rectangle {
            id: goLeft
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: 150 // TODO: rationalize
            color: "transparent"
            border.color: "black"
            border.width: 1
            Text {
                id: leftText
                anchors.centerIn: parent
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (currentIndex !== 0)
                        swipeyTuneView.setIndex(currentIndex-1)
                }
            }
        }

        Rectangle {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: goLeft.right
            anchors.right: goRight.left
            color: "transparent"
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
//                border.color: "black"
//                border.width: 1
                color: "black"
                height: 1
            }
            Text {
                id: mainText
                anchors.centerIn: parent
            }
        }

        Rectangle {
            id: goRight
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: goLeft.width
            color: "transparent"
            border.color: "black"
            border.width: 1
            Text {
                id: rightText
                anchors.centerIn: parent
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if ((setModel.getSetLength(currentSetName)-1) !== currentIndex) {
                        swipeyTuneView.setIndex(currentIndex+1)
                    }
                }
            }
        }
    }

}
