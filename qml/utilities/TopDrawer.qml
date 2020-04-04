import QtQuick 2.0
import QtQuick.Controls 2.1
import "../metronome"

Drawer {

    height: ihod.height
    width: parent.width

    signal choonButtonClicked();
    signal setButtonClicked();
    signal setBuilderButtonClicked();
    signal importButtonClicked();
    signal metronomeButtonClicked();

    Rectangle {
        id: ihod
        y: 0
        anchors.left: parent.left;
        anchors.right: parent.right;
        height: (width > 878 ? 50 : (width > 470 ? 100 : 150))
        color: styles.topMenuBackground;

        Flow {

            anchors.fill: parent
            spacing: 5
            anchors.margins: 5

            Rectangle {
                id: choonsButton
                height: 40
                width: 150
                color: styles.topMenuButtonUp
                radius: 5
                Text {
                    anchors.centerIn: parent
                    text: qsTr("Tunes")
                }

                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        choonButtonClicked();
                    }
                    onContainsMouseChanged: {
                        if (containsMouse) parent.color = styles.topMenuButtonDown
                        else parent.color = styles.topMenuButtonUp
                    }
                }
            }

            Rectangle {
                id: setsButton
                height: 40
                width: 150
                color: styles.topMenuButtonUp
                radius: 5
                Text {
                    anchors.centerIn: parent
                    text: qsTr("Sets")
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: setButtonClicked();
                    onContainsMouseChanged: {
                        if (containsMouse) parent.color = styles.topMenuButtonDown
                        else parent.color = styles.topMenuButtonUp
                    }
                }
            }

            Rectangle {
                id: setBuilderButton
                height: 40
                width: 150
                color: styles.topMenuButtonUp
                radius: 5
                Text {
                    anchors.centerIn: parent
                    text: qsTr("Set Builder")
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: setBuilderButtonClicked();
                    onContainsMouseChanged: {
                        if (containsMouse) parent.color = styles.topMenuButtonDown
                        else parent.color = styles.topMenuButtonUp
                    }
                }
            }

            Rectangle {
                id: importButton
                height: 40
                width: 150
                color: styles.topMenuButtonUp
                radius: 5
                Text {
                    anchors.centerIn: parent
                    text: qsTr("Setup")
                }
                MouseArea {
                    anchors.fill: parent
                    onContainsMouseChanged: {
                        if (containsMouse) parent.color = styles.topMenuButtonDown
                        else parent.color = styles.topMenuButtonUp
                    }
                    onClicked: importButtonClicked();
                }
            }


            Metronome {
                id: metronomeButton
                height: 40
                width: 250
                color: styles.topMenuButtonUp
                radius: 5
            }

        } // End of Flow layout box

    }
}
