import QtQuick 2.0
import QtQuick.Controls 2.1

Item {

    onWidthChanged: {
        fillComponent()
    }

    Component.onCompleted: {

        styles.narrowChanged.connect(fillComponent)

        fillComponent()
    }

    Loader {
        id: mom
        anchors.fill: parent
    }

    function fillComponent() {
        if (styles.narrow) {
            mom.source = "NarrowSetBuilder.qml"
        }
        else {
            mom.source = "WideSetBuilder.qml"
        }

        /*
        if (width < 601) {
            mom.source = "NarrowSetBuilder.qml"
        }
        else {
            mom.source = "WideSetBuilder.qml"
        }
        */
    }
}
