import QtQuick 2.0

Rectangle {

    color: styles.mainScreenBackground
    signal choonButtonClicked()
    signal setButtonClicked()
    signal setBuilderButtonClicked()
    signal importButtonClicked()

    height: (show ? bar.height : 20)
    id: root

    property bool show: true

    Image {
        height: parent.height; width: height
        source: "../../assets/show-menu-icon.png"
        fillMode: Image.PreserveAspectFit
        sourceSize.width: width
        sourceSize.height: height
        visible: !root.show

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.show = true
            }
        }
    }

    function fitUpTheThing() {
        if (styles.narrow) {
           show = false
        }
        else {
            show = true
        }
    }

    onShowChanged: {
        if (show) bar.y = 0
        else bar.y = bar.height * -1
    }

    onActiveFocusChanged: {
        console.log("Pussy whip", activeFocus)
        if (show) show = !show
    }

    TopBar {
        id: bar
//        height: root.height
        width: parent.width
        onChoonButtonClicked: root.choonButtonClicked()
        onSetButtonClicked: root.setButtonClicked()
        onSetBuilderButtonClicked: root.setBuilderButtonClicked()
        onImportButtonClicked: root.importButtonClicked()
        onMetronomeButtonClicked: root.metronomeButtonClicked()

        Behavior on height {
            PropertyAnimation { duration: 500 }
        }
        Behavior on y {
            PropertyAnimation {
                duration: 800
            }
        }
    }

    Component.onCompleted: {
        fitUpTheThing()
        styles.narrowChanged.connect(fitUpTheThing)
    }



//    Component {
//        id: topBar
//    }
//    Loader {
//        id: larryTheLoader
//    }
//    Component {
//        id: topDrawer
//        TopDrawer {
//            edge: Qt.TopEdge
//            dragMargin: root.width * 0.01
//            position: 0.3
//            onChoonButtonClicked: choonButtonClicked()
//            onSetButtonClicked: setButtonClicked()
//            onSetBuilderButtonClicked: setBuilderButtonClicked()
//            onImportButtonClicked: importButtonClicked()
//            onMetronomeButtonClicked: metronomeButtonClicked()
//        }
//    }
}
