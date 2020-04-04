import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0

Rectangle {
    visible: true
    width: 640
    height: 480

    property Component component;
    property var startPage: null;
    property bool hasPageLoaded: false;

    function reloadPage(pageurl) {
        if (hasPageLoaded) {
            startPage.destroy()
        }
        reloader.trimCache()

        component = Qt.createComponent(pageurl)
        if (component.status === Component.Ready) {
            finishCreation()
        }
        else {
            component.statusChanged.connect(finishCreation)
        }
    }

    function finishCreation() {
        if (component.status === Component.Ready) {
            startPage = component.createObject(boxboxbox)
            hasPageLoaded = true
            if (startPage === null) {
                // Well frak
                // would be fun to create a QML error page here :)
            }
            else {
//                startPage.anchors.fill = boxboxbox
            }
        }
        else {
            if (component.status === Component.Ready) {
                // Gosh darn
            }
        }
        component.destroy()
    }

    Item {
        id: boxboxbox
        anchors.fill: parent
    }

    Component.onCompleted: {
        reloadPage(reloader.filepath)
        reloader.filepathChanged.connect(reloadPage)
    }

}
