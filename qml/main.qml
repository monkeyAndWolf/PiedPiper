import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

import "metronome"
import "setbuilder"
import "utilities"
import "websockets"

ApplicationWindow {
    title: qsTr("PiedPiper")
    width: 1000
    height: 780
    visible: true

    onWidthChanged: {
        if (width < 601) {
            styles.narrow = true
        }
        else {
            styles.narrow = false
        }
    }

    property int current: 1



    MagicDrawer {
        id: topBar
//        edge: Qt.TopEdge
        width: parent.width
//        dragMargin: parent.width * 0.01
//        position: 0.3
        onChoonButtonClicked: {
            if (current != 1) {
                stack.push(tuneView)
                current = 1;
                choons.show = true;
            }
            else {
                if (choons.show)
                    choons.show = false;
                else
                    choons.show = true;
            }
        }
        onSetButtonClicked: {
            if (current != 2) {
                stack.push(setView);
                current = 2;
                choons.show = false;
            }
        }
        onSetBuilderButtonClicked: {
            if (current != 3) {
                choons.show = false;
                stack.push(setBuilderView);
                current = 3;
            }

        }
        onImportButtonClicked: {
            if (current != 4) {
                choons.show = false;
                stack.push(importView);
                current = 4;
            }
        }
    }

    TuneList {
        id: choons;
        //anchors.top: parent.top
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom
        width: 150
        x: -150
        model: tuneModel
        delegate: TuneListDelegate { width: choons.width; height: 50; tuneFilename: filename; tuneMeter: meter; tuneTitle: title }
        spacing: 1
        clip: true
        show: true
        color: styles.sideMenuBackground
    }

    StackView {
        id: stack
        anchors.left: choons.right
        anchors.top: topBar.bottom
//        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
//        initialItem: tuneView
        initialItem: setBuilderView
//        initialItem: setView
//        initialItem: importView
    }

    TuneView {
        id: tuneView
    }

    Component {
        id: setView
        SetView {

        }
    }
    Component {
        id: setBuilderView
        AdaptableSetBuilderView {
        }
    }

    Component {
        id: aboutPage
        AboutPiedPiper {
        }
    }

    Component {
        id: importView
        SetupView {

            onOpenImportFromInterwebs: {
                stack.push(importWebView)
            }

            onOpenCameraImport: {
                current = 6
                stack.push(importCameraView)
            }

            onNewTuneImported: {
                openTune(filename)
            }

            onOpenAboutPage: {
                current = 7
                stack.push(aboutPage)
            }
        }
    }

    Component {
        id: importCameraView
        ImportCameraView {
            onNewImageTakenPleaseEdit: {
                current = 5
                tuneEditView.visible = true;
                stack.push(tuneEditView);
                tuneEditView.sneakInNewImage(path);
            }
        }
    }

//    Component {
//        id: importWebView
//        ImportWebPage {

//        }
//    }

    TuneEditView {
        id: tuneEditView
        visible: false;
        onCloseMe: {
            tuneView.openTune(tuneModel.randomTune())
            stack.push(tuneView)
        }
    }

    function openTuneEditPage(filename) {
        current = 5
        tuneEditView.visible = true;
        tuneEditView.setFilename(filename);
        stack.push(tuneEditView);
    }

    function openTune(tunename) {
        current = 1
        tuneView.openTune(tunename)
        stack.push(tuneView)
    }

}
