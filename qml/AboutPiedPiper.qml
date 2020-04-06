import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle {

    color: styles.mainScreenBackground
    function setTextWidth() {
        text.width = width * 0.9
    }

    ScrollView {
        anchors.centerIn: parent
        height: parent.height
        width: parent.width
        anchors.margins: 15
        onWidthChanged: setTextWidth()
        Text {
            x: parent.width * 0.05
            id: text
            anchors.centerIn: parent
            text: "
PiedPiper


Created by Mr. Monkey & Ms. Wolf in San Jose California, 2016.

PiedPiper is an electronic sheet music reader, designed specifically to work with ABC notation. It also supports most image formats, and you can even take pictures of sheet music and add it to the library. The application is mostly aimed at folk music players.

The authors urge users to remember copyright and not copy music illegally, but accept that many players take pictures of sheet music anyway. What can you do?

Tunes appear in the column on the left when in the Tunes view. Select a tune by tapping it once. Open a tune to add notes and other details, or even delete it, by tapping the tune name twice.

Folk music is very often played in sets, and PiedPiper offers a drag and drop SetBuilder view. These can be played through the Set view, simply swipe left to move to the next tune.

Setup page lets you tweak settings and import new tunes. You can also add tunes by copying them into the PiedPiperTunes directory. On Desktop platforms this is to be found in the Home directory, on mobile devices it could be, well, anywhere.

Copyright and credits:

The application is written using the Qt framework, and requires a minimum of Qt 5.7 to run.
The ABC to sheet music renderer is called ABCShot, and is derived from the abc2mps application, written by Jef Moines.

PiedPiper is released under the GNU GPL license: you have a right to the source code. Please ask, and we will send it.

We have tested the application on Macintosh and Android contraptions, and are satisfied with the performance.


The name PiedPiper was inspired by the HBO TV Show ‘Silicon Valley’. The PiedPiper application in SV is a super-high ‘middle out’ compression algorithm. Our implementation takes files of about 2-4k, and allows musicians to expand them to fill up a room, a concert hall, or even a whole country.

We think that we have the better compression ratio.

Peace,

M&W
San Jose, California.
"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }
    }

}
