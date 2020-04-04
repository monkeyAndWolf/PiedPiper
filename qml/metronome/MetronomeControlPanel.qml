import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

Rectangle {
    id: controlPanel
    property bool running: false;

    property variant timeSignatures: [ "2/4", "3/4", "4/4", "6/8", "7/5", "9/8", "beats"]
    property variant beatLine: [ 2, 3, 4, 6, 7, 9, 1 ]

    property variant speeds: [ "grave",
                                "largo",
                                "adagio",
                                "andante",
                                "moderato",
                                "allegreto",
                                "vivace",
                                "presto",
                                "vivacissimo",
                                "prestissimo"]
    property variant speedValues: [ 44,
                                    50,
                                    60,
                                    80,
                                    100,
                                    120,
                                    140,
                                    160,
                                    180,
                                    201]


    clip: true


    onRunningChanged: {
        if (running) {
            tangle.y = parent.height*-1 + 5*2
            lights.meter = beatLine[meter.currentIndex];
            lights.running = true;
        }
        else {
            tangle.y = 0
            lights.running = false;
        }
    }


    Rectangle {

        Behavior on y { PropertyAnimation { duration: 500 }}


        id: tangle
        height: parent.height*2;
        width: parent.width
        color: styles.topMenuButtonUp
        ComboBox {
            anchors.top: parent.top
            anchors.left: parent.left
            id: meter
            model: timeSignatures
            width: 75
            height: controlPanel.height
            currentIndex: 2
        }
        ComboBox {
            id: speed
            anchors.top: parent.top
            anchors.left: meter.right
            height: controlPanel.height
            currentIndex: 5
            width: 75
            model: speeds
            onCurrentIndexChanged: {
                if (tempo)
                    tempo.value = speedValues[currentIndex]
            }
        }

        SpinBox {
            anchors.margins: 2
            anchors.top: parent.top
            anchors.left: speed.right
            height: controlPanel.height -6

            id: tempo
            minimumValue: 40
            maximumValue: 209
            decimals: 0
            value: 120
            onValueChanged: {
                lights.bpm = value;
            }
        }
        MetronomeLightPanel {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: controlPanel.height
            z: 2
            width: meter.width;// + meter.width + 10; // TODO fix magic numbers
            id: lights;
        }
    }




}
