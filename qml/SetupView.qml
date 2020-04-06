import QtQuick 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4

import "websockets"

Rectangle {
    color: styles.mainScreenBackground
    id: page

    signal openImportFromInterwebs();
    signal openCameraImport();

    signal openAboutPage();
    signal openGnuGplPage();

    signal newTuneImported(var filename);

    Column {
        x: 20

        LabelBox {
            label: qsTr("Import")
        }

        Flow {
            spacing: 20
            anchors.margins: 20

            Button {
                text: qsTr("Import from local machine")
                onClicked: {
                    elFileDialog.open();
                }
            }

            Button {
                text: qsTr("Take a picture")
                onClicked: {
                    openCameraImport();
                }
            }

        }
        LabelBox {
            label: qsTr("General settings")
        }
        Text {
            text: "Embiggen music {where possible | always | don't}"
        }

        LabelBox {
            label: qsTr("Piper Server")
            id: serverLab
        }

        ServerClientControlPanel {
        }

        LabelBox {
            label: qsTr("User Guide")
        }
        Text {
            text: "Read our user manual"
        }

        LabelBox {
            label: qsTr("About PiedPiper")
        }

        Button {
            text: qsTr("Read about PiedPiper")
            onClicked: openAboutPage()
        }

        Button {
            text: qsTr("GNU GPL License")
            onClicked: openGnuGplPage()
        }
    }



    FileDialog {
        id: elFileDialog
        folder: shortcuts.home
        selectMultiple: false
        onAccepted: {
            // FIXME at the moment only one file can be added at a time. If that changes, this
            // code will break. And it is so easy to fix.
            var filename = elFileDialog.fileUrl;
            logger.logTuneImport(filename)
            var newFile = tuneModel.importAFile(filename)
            newTuneImported(newFile)
        }
    }
}
