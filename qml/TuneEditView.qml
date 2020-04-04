import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import PiedPiper 1.0

Rectangle {

    id: root

    signal closeMe();

    onWidthChanged: {
    }

    property string filename;
    property bool isEditable: false;
    property int fileType;
    function setFilename(thefilename) {
        filename = thefilename;
        var title =   settingsAccess.getValue(filename, "title");
        title  = ( title ? title : qsTr("<not set>"));
        titleText.text = title;
        var meter = settingsAccess.getValue(filename, "meter");
        meter = (meter ? meter : qsTr("<not set>"));
        meterText.text = meter;
        var author = settingsAccess.getValue(filename, "author");
        author = (author ? author : qsTr("<not set>"));
        authorText.text = author;
        var type = settingsAccess.getValue(filename, "type");
        type = (type ? type : qsTr("<not set>"));
        typeText.text = type;
        var notes = settingsAccess.getValue(filename, "notes");
        notes = (notes ? notes : qsTr("No notes"));
        notesText.text = notes;
        fileType =  settingsAccess.getValue(filename, "fileType");
        fileType = (fileType ? fileType : Tune.Duff);

        var mightBeEditable= settingsAccess.getValue(filename, "editable");
        isEditable = (mightBeEditable ? mightBeEditable : false);
    }

    // This is not the best way to do it. Basically, a new Image has been shot
    // with the camera, and it probably is not in the settings store yet. So
    // we sneak past all the usual checks to see that it gets onto the edit page.
    function sneakInNewImage(thefilename) {
        filename = thefilename;
        var title =   settingsAccess.getValue(filename, "title");
        title  = ( title ? title : qsTr("<not set>"));
        titleText.text = title;
        var meter = settingsAccess.getValue(filename, "meter");
        meter = (meter ? meter : qsTr("<not set>"));
        meterText.text = meter;
        var author = settingsAccess.getValue(filename, "author");
        author = (author ? author : qsTr("<not set>"));
        authorText.text = author;
        var type = settingsAccess.getValue(filename, "type");
        type = (type ? type : qsTr("<not set>"));
        typeText.text = type;
        var notes = settingsAccess.getValue(filename, "notes");
        notes = (notes ? notes : qsTr("No notes"));
        notesText.text = notes;
        fileType = Tune.Image;

        isEditable = true;
    }


    color: styles.mainScreenBackground

    ColumnLayout {
        x: 15; y: 15
        width: parent.width
        id: coluum

        RowLayout {
            Button {
                text: qsTr("Delete This Tune")
                onClicked: deleteTune(titleText.text, filename);
            }
        }

        RowLayout {
            TuneEditRowBox {
                id: titleText;
                label: qsTr("Title:");
                text: qsTr("rubbish");
                value: "title";
                nameOfFile: filename;
                editable: isEditable;
            }
        }

        RowLayout {
            TuneEditRowBox {
                id: meterText;
                label: qsTr("Meter:");
                text: qsTr("rubbish");
                value: "meter";
                nameOfFile: filename;
                editable: isEditable;
            }
        }

        RowLayout {
            TuneEditRowBox {
                id: typeText;
                label: qsTr("Type:");
                text: qsTr("perkele");
                value: "type";
                nameOfFile: filename;
                editable: isEditable;
            }
        }

        RowLayout {
            TuneEditRowBox {
                id: authorText;
                label: qsTr("Author:");
                text: qsTr("<not set>");
                value: "author";
                nameOfFile: filename;
                editable: isEditable;
            }
        }

        RowLayout {
            TuneEditRowBox {
                id: notesText;
                label: qsTr("Notes:");
                text: qsTr("like");
                value: "notes";
                nameOfFile: filename;
                editable: true;
                lines: 5
                boxWidth: 2
            }
        }

        RowLayout {
            Image {
                visible: (fileType === Tune.Image);
                source: (visible? "file://" + filename : "");
                width: root.width;
                onWidthChanged: {
                    width = root.width - 50;
                    height = width/2;
                }
            }
        }
    }

    function deleteTune(tunename, filename) {
        confirmFileDelete.text = qsTr("Would you like to delete the tune \"") + tunename + "\"";
        confirmFileDelete.fileName = filename;
        confirmFileDelete.open();
    }

    MessageDialog {
        id: confirmFileDelete
        property string fileName;
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: {
            logger.logTuneDelete(fileName)
            filePusher.deleteFile(fileName)
            closeMe()
        }
    }

}
