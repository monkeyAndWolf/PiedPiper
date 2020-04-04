import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle {
    color: styles.mainScreenBackground
    id: root

    // This is used for the TuneView when in the SetView.
    // It takes time to get HTML loaded, and this gives it
    // time to get the page setup. Pöh!
    property bool ready: true
    property var buffer
    property bool hasBufer: false

    function openTune(filename) {
        var fileType = settingsAccess.getValue(filename, "fileType");

        if (fileType === 1 && !ready) {
            buffer = filename
            hasBufer = true
            return;
        }

        // query type
        fileType = (fileType ? fileType : 0 );
//        Duff = 0,
//        Abc = 1,
//        Image = 2,
//        Pdf = 3

        switch (fileType) {
        case 0:
            break;
        case 1:
             setAbcContent(filename)
            break;
        case 2:
            var title =   settingsAccess.getValue(filename, "title");
            title  = ( title ? title : qsTr("<not set>"));
            var author = settingsAccess.getValue(filename, "author");
            author = (author ? author : qsTr("<not set>"));
            var meter = settingsAccess.getValue(filename, "meter");
            meter = (meter ? meter : qsTr("<not set>"));
            setImageContent(title, author, meter, filename)
            break;
        case 3:

            break;
        }
    }

    function setAbcContent(filename) {
         var svgFile = svgGen.getSvgPath(filename)
        image.visible = true
        image.source = "file://" + svgFile
        internalText.text = ""
        setImageToRights()
    }

    function setImageContent(title, author, meter, content) {
        image.source = "file://" + content;
        image.text = title + " " + author + " " + meter;
        image.visible = true;
        setImageToRights();
    }

    function setImageToRights() {
        scrollio.flickableItem.contentY = 0;
//        internalImage.width = root.width * 0.9
//        if (internalImage.sourceSize.height < root.height) {
//            internalImage.height = root.height
//            internalImage.fillMode = Image.Stretch
//        }
//        else {
//            internalImage.fillMode = Image.PreserveAspectFit
//        }
//        internalImage.width = root.width * 0.9
//        internalImage.fillMode = Image.PreserveAspectFit
    }

    Item {
        id: image
        anchors.fill: parent
        visible: false;
        property alias source: internalImage.source;
        property alias text: internalText.text;

        Rectangle {
            color: "transparent"
            id: holderColumn
            anchors.fill: parent
            Text {
                anchors.top: parent.top
                height: font.pixelSize + 10
                anchors.left: parent.left
                anchors.right: parent.right
                id: internalText
                text: "";
            }
            ScrollView {
                id: scrollio
                anchors.top: internalText.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                onWidthChanged: {
                    internalImage.width = width * 0.9
                    internalImage.x = width * 0.05
                }

                Image {
                    x: parent.width * 0.05
                    id: internalImage
                    width: parent.width * 0.9
                    fillMode: Image.PreserveAspectFit
                }
            }
        }


    }
}
