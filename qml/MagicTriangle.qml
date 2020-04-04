import QtQuick 2.4

Canvas {
    id: triangle
    antialiasing: true

    property bool down: true

    property int triangleWidth: width * 0.5
    property int triangleHeight: height * 0.5
    property color strokeStyle:  "#000000"
    property color fillStyle: "pink"
    property int lineWidth: 2
    property bool fill: false
    property bool stroke: true
    property real alpha: 1.0
    states: [
        State {
            name: "pressed"; when: ma1.pressed
            PropertyChanges { target: triangle; fill: true; }
        }
    ]

    onDownChanged: requestPaint()

    onLineWidthChanged:requestPaint();
    onFillChanged:requestPaint();
    onStrokeChanged:requestPaint();

    signal clicked()

    onPaint: {
        var ctx = getContext("2d");
        ctx.save();
        ctx.clearRect(0,0,triangle.width, triangle.height);
        ctx.strokeStyle = triangle.strokeStyle;
        ctx.lineWidth = triangle.lineWidth
        ctx.fillStyle = triangle.fillStyle
        ctx.fillRect(0,0,triangle.width, triangle.height);
        ctx.globalAlpha = triangle.alpha
        ctx.lineJoin = "round";
        ctx.beginPath();

        // put rectangle in the middle
        ctx.translate( (0.5 *width - 0.5*triangleWidth),
                       (0.5 * height - 0.5 * triangleHeight))

        if (down) {
            // draw the rectangle
            ctx.moveTo(0,0 ); // left point of triangle
            ctx.lineTo(triangleWidth, 0);
            ctx.lineTo(triangleWidth/2,triangleHeight);
        }
        else {
            // draw the rectangle
            ctx.moveTo(triangleWidth/2,0 ); // left point of triangle
            ctx.lineTo(0, triangleHeight);
            ctx.lineTo(triangleWidth,triangleHeight);
        }
        ctx.closePath();
        if (triangle.fill)
            ctx.fill();
        if (triangle.stroke)
            ctx.stroke();
        ctx.restore();
    }
}
