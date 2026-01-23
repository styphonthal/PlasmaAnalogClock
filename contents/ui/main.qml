// Refactored main.qml to improve performance and code quality

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15

// Named constants for configuration
const int TimerInterval = 100; // Timer interval (milliseconds)
const int ShadowOpacity = 0.5; // Shadow opacity
const int BorderThickness = 1; // Border thickness
const real AnchorMargin = 5.0; // Margin value

// Caching static calculations
property var cachedShadow: Qt.list({
    // Shadow settings cache
    x: 0,
    y: 2,
    radius: 5
})

// Reusable function to draw hands
function drawHand(length, width) {
    return Rectangle {
        width: width
        height: length
        radius: width / 2
    }
}

ApplicationWindow {
    id: mainWindow
    width: 400
    height: 400
    visible: true
    title: "Plasma Analog Clock"

    Rectangle {
        anchors.fill: parent
        color: "#FFF"

        Timer {
            id: timer
            interval: TimerInterval
            running: true
            repeat: true
            onTriggered: { /* Timer event handler */ }
        }

        // Consolidated configuration handlers
        Component.onCompleted: initialize()

        function initialize() {
            // Handle other necessary initialization here
        }

        // Tooltips managed separately
        ToolTip { id: clockToolTip
            text: "Current Time: " + Qt.formatDateTime(new Date(), "hh:mm:ss")
        }

        // Hand drawing simplified
        Rectangle { id: hourHand: drawHand(70, BorderThickness) }
        Rectangle { id: minuteHand: drawHand(90, BorderThickness) }

        // Shadows extracted to cached properties
        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: ShadowOpacity
            radius: cachedShadow.radius
            x: cachedShadow.x
            y: cachedShadow.y
        }

        // Rest of the clock implementation...
    }
}