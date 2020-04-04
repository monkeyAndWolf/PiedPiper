import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
    color: styles.mainScreenBackground
    radius: 33

    property int currentTuneCount: 0

    property Component swipeViewTemploit;
    property Component tuneViewTemploit;

    property Item swipeView;
    property bool isSwipeView: false

    function setIndex(index) {
        if (isSwipeView) {
            swipeView.currentIndex = index
        }

    }

    signal tuneIndexChanged(var newIndex);
    function prepareToEmitIndex() {
        tuneIndexChanged(swipeView.currentIndex)
    }

    Component.onCompleted: {
        swipeViewTemploit = Qt.createComponent("SubSwipeView.qml")
        tuneViewTemploit = Qt.createComponent("TuneView.qml")
    }

    function addSetOfChoons(setName) {

        if (isSwipeView) {
            swipeView.destroy()
        }

        swipeView = swipeViewTemploit.createObject(swipeholder)
        isSwipeView = true
        swipeView.clip = true
        swipeView.anchors.fill = swipeholder
        swipeView.currentIndexChanged.connect(prepareToEmitIndex)

        currentTuneCount = setModel.getSetLength(setName)

        var listOfTunes = []
        for (var i = 0; i < currentTuneCount; i++) {
            var pongot = tuneViewTemploit.createObject(swipeView);
            listOfTunes.push(pongot)
        }
        for (var i = 0; i < currentTuneCount; i++) {
            var filename = setModel.getTuneNameAt(setName, i)
            listOfTunes[i].openTune(filename);
        }
    }

    Item {
        id: swipeholder
        anchors.fill: parent
    }
}
