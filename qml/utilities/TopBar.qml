import QtQuick 2.0
import "../metronome"

Rectangle {
    id: topBar
    y: 0
    height: (width > 878 ? 50 : (width > 470 ? 100 : 150))
    color: styles.topMenuBackground;

    signal choonButtonClicked();
    signal setButtonClicked();
    signal setBuilderButtonClicked();
    signal importButtonClicked();
    signal metronomeButtonClicked();

    property bool hide: false

    // The mouse area is an unsatisfactory way to dismiss the top bar when we don't need it
    // it should be replaced with an arrow up button or something like that.
    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (styles.narrow && root.show)
                root.show = false
        }

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


    // TopBar animation shit

    states: [
        State {
            name: "hidden"
            when: topBar.hide
            PropertyChanges {
                target: topBar
                y: (height * -1) + 11
            }
        },
        State {
            name: "displayed"
        }
    ]

    transitions: Transition {
        from: ""
        to: "hidden"
        reversible: true

        NumberAnimation {
            target: topBar
            property: "y"
            duration: 1000
            easing.type: Easing.InOutQuad
        }
    }
} // end TopBar
