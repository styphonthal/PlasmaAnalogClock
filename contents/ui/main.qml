import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import Qt5Compat.GraphicalEffects




PlasmoidItem {
    id: root
    width: 200
    height: 200
    visible: true

    // Maintain aspect ratio
    property real aspectRatio: 1.0  // Aspect ratio (width/height)

    onWidthChanged: {
        height = width / aspectRatio;
    }

    onHeightChanged: {
        width = height * aspectRatio;
    }

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground


    // Tooltip that shows the current time
    ToolTip {
        id: timeTooltip
        width: 100 // Set a width for the tooltip
        height: 30 // Set a height for the tooltip
        visible: false // Initially hidden


        // Styling the tooltip
        background: Rectangle {
            width: parent.width+20
            height: parent.height+5
            color: "#222222"      // Dark background color
            radius: 10            // Rounded corners
            border.color: "#FF4500"  // Border color (orange-red)
            border.width: 3       // Border width


            // Text for the tooltip time
            Text {
                anchors.centerIn: parent
                text: Qt.formatDateTime(new Date(), "hh:mm:ss AP") // Display time
                font.family: "Arial"  // Font family
                font.pixelSize: 20    // Font size
                color: "white"        // Text color
            }
        }


    }
    // MouseArea to detect hover events
    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true // Enable hover events

        onEntered: {
            timeTooltip.visible = true; // Show tooltip when hovered
            //timeTooltip.text = Qt.formatDateTime(new Date(), "hh:mm:ss AP"); // Update tooltip text with current time
            timeTooltip.x = mouse.x; // Position tooltip at mouse cursor x
            timeTooltip.y = mouse.y; // Position tooltip at mouse cursor y - adjust as needed for better placement
        }

        onExited: {
            timeTooltip.visible = false; // Hide tooltip when not hovered
        }
    }


    Image {
        id: background
        source: getBackgroundSource(plasmoid.configuration.backgroundStyle)

        function getBackgroundSource(style) {
            switch (style) {
                case 0:
                    return "file:///home/styphonthal/TestingClock/contents/ui/old_test2.png";
                case 1:
                    return "file:///home/styphonthal/TestingClock/contents/ui/red_clock.png";
                case 2:
                    return "file:///home/styphonthal/TestingClock/contents/ui/test2.png";
                case 3:
                    return "";
                default:
                    return "file:///home/styphonthal/TestingClock/contents/ui/default.png"; // Fallback
            }
        }


        anchors.fill: parent
        // fillMode: Image.PreserveAspectCrop
        fillMode: Image.PreserveAspectFit // Maintain aspect ratio
        smooth: true
    }



    // Canvas for drawing the clock face
    Canvas {
        id: clockFace
        // Maintain proportional scaling


        width: background.width * 0.74 // Scale with the background width
        height: background.height * 0.74 // Scale with the background height
        anchors.horizontalCenter: background.horizontalCenter // Align with the background center
        anchors.horizontalCenterOffset: (background.width / 200) * -4
        anchors.verticalCenter: background.verticalCenter // Align with the background center

        anchors.verticalCenterOffset: (background.height / 200) * 30

        TextMetrics {
            id: textMetrics
            font.family: plasmoid.configuration.noonFont
            font.pixelSize: 24 // Default size
            text: "12"
        }

        // Conditionally enable the shadow based on the configuration
        layer.enabled: plasmoid.configuration.clockShadowEnabled
        layer.effect: DropShadow {
            color: "#ADD8E6" // Baby blue
            radius: 15
            horizontalOffset: 0
            verticalOffset: 0
            samples: 20
        }





        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);


            // Calculate scaling factors based on Canvas size
            var scaleFactor = Math.min(width, height) / 200; // 200 is the base size
            var centerX = width / 2;
            var centerY = height / 2;


            var now = new Date();
            var hours = now.getHours() % 12;
            var minutes = now.getMinutes();
            var seconds = now.getSeconds();

            ctx.save();
            ctx.translate(centerX, centerY);
            ctx.scale(scaleFactor, scaleFactor);

            // Draw clock face background color based on the option
            if (plasmoid.configuration.transparentBackground) {
                ctx.beginPath();

                ctx.ellipse(-95, -90, 192, 178);
                ctx.fillStyle = plasmoid.configuration.clockFaceColor;
                ctx.fill();
            }


            // Draw hour hashmarks (excluding the top for "12")
            ctx.lineWidth = 4;
            ctx.strokeStyle = plasmoid.configuration.clockDashColor;
            for (var i = 1; i < 12; i++) { // Start at 1 to skip the "12" position
                ctx.save();
                ctx.rotate((Math.PI / 6) * i);
                ctx.beginPath();
                ctx.moveTo(0, -85);
                ctx.lineTo(0, -75);
                ctx.stroke();
                ctx.restore();
            }

            // Draw "12" at the top
            ctx.font = (24 * (40 / textMetrics.height)) + "px " + plasmoid.configuration.noonFont;
            //ctx.font = "bold 24px Hack";
            ctx.fillStyle = plasmoid.configuration.clockDashColor;
            ctx.textAlign = "center";
            ctx.fillText("12", 0, -65);

            // Get current time
            var now = new Date();
            var hours = now.getHours() % 12;
            var minutes = now.getMinutes();
            var seconds = now.getSeconds();

            // Draw hour hand
            ctx.save();
            ctx.lineWidth = 10;
            ctx.strokeStyle = plasmoid.configuration.hourHandColor;
            ctx.lineCap = "round"; // Rounded ends

            if (plasmoid.configuration.clockShadowEnabled) {
                ctx.shadowColor = "rgba(205, 92, 92, 0.5)"; // Shadow color (similar to hand color)
                ctx.shadowBlur = 10; // Shadow blur intensity
                ctx.shadowOffsetX = 2; // Optional: Horizontal shadow offset
                ctx.shadowOffsetY = 2; // Optional: Vertical shadow offset
            }

            ctx.rotate((Math.PI / 6) * hours + (Math.PI / 360) * minutes);
            ctx.beginPath();
            ctx.moveTo(0, 10);
            ctx.lineTo(0, -40);
            ctx.stroke();
            ctx.restore();

            // Draw minute hand
            ctx.save();
            ctx.lineWidth = 8;
            ctx.strokeStyle = plasmoid.configuration.minuteHandColor;
            ctx.lineCap = "round"; // Rounded ends
            if (plasmoid.configuration.clockShadowEnabled) {
                ctx.shadowColor = "rgba(205, 92, 92, 0.5)"; // Shadow color (similar to hand color)
                ctx.shadowBlur = 10; // Shadow blur intensity
                ctx.shadowOffsetX = 2; // Optional: Horizontal shadow offset
                ctx.shadowOffsetY = 2; // Optional: Vertical shadow offset
            }
            ctx.rotate((Math.PI / 30) * minutes + (Math.PI / 1800) * seconds);
            ctx.beginPath();
            ctx.moveTo(0, 10);
            ctx.lineTo(0, -70);
            ctx.stroke();
            ctx.restore();

            // Draw second hand
            if (plasmoid.configuration.clockShowSeconds) {
                ctx.save();
                ctx.lineWidth = 4;
                ctx.strokeStyle = plasmoid.configuration.secondHandColor;
                ctx.lineCap = "butt"; // Keep sharp ends for the second hand
                if (plasmoid.configuration.clockShadowEnabled) {
                    ctx.shadowColor = "rgba(205, 92, 92, 0.5)"; // Shadow color (similar to hand color)
                    ctx.shadowBlur = 10; // Shadow blur intensity
                    ctx.shadowOffsetX = 2; // Optional: Horizontal shadow offset
                    ctx.shadowOffsetY = 2; // Optional: Vertical shadow offset
                }
                ctx.rotate((Math.PI / 30) * seconds);
                ctx.beginPath();
                ctx.moveTo(0, 20);
                ctx.lineTo(0, -80);
                ctx.stroke();
                ctx.restore();
            }

            //yellow center dot
            ctx.beginPath();
            ctx.arc(0, 0, 5, 0, Math.PI * 2);
            ctx.fillStyle = "yellow";
            ctx.fill();
            ctx.restore();
        }
    }

    // Timer to update the clock every second
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            clockFace.requestPaint()
            timeTooltip.children[0].text = Qt.formatDateTime(new Date(), "hh:mm:ss AP") // Update tooltip text with current
        }

    }
}
