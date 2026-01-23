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

    // Maintain aspect ratio - varies by background style
    property real aspectRatio: getAspectRatio(plasmoid.configuration.backgroundStyle)

    function getAspectRatio(style) {
        switch (style) {
            case 0: return 1.0   // pinkClock.png - square
            case 1: return 0.92  // redClock.png - taller
            case 2: return 0.92  // blackClock.png - taller
            case 3: return 1.0   // no background - square
            default: return 1.0
        }
    }


    // Cached properties for performance
    property string validFont: safeFontFamily(plasmoid.configuration.noonFont)
    property real cachedFontScale: 1.0

    function safeFontFamily(family) {
        if (!family) return "Sans Serif"
            const fam = String(family).trim()
            const list = Qt.fontFamilies()
            return (list.indexOf(fam) >= 0) ? fam : "Sans Serif"
    }

    // Use binding to maintain aspect ratio - cleaner than mutual handlers
    Binding {
        target: root
        property: "height"
        value: root.width / root.aspectRatio
        when: root.width > 0
    }

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    ToolTip {
        id: timeTooltip
        parent: hoverArea
        width: 100
        height: 30
        visible: false
        x: hoverArea.mouseX + 10
        y: hoverArea.mouseY + 10

        background: Rectangle {
            width: parent.width + 20
            height: parent.height + 5
            color: "#222222"
            radius: 10
            border.color: "#FF4500"
            border.width: 3

            Text {
                id: timeText
                anchors.centerIn: parent
                text: Qt.formatDateTime(new Date(), "hh:mm:ss AP")
                font.family: "Arial"
                font.pixelSize: 20
                color: "white"
            }
        }
    }

    // Tooltip timer - now matches main timer for efficiency
    Timer {
        id: tooltipTimer
        interval: 1000
        running: timeTooltip.visible
        repeat: true
        onTriggered: timeText.text = Qt.formatDateTime(new Date(), "hh:mm:ss AP")
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            timeText.text = Qt.formatDateTime(new Date(), "hh:mm:ss AP")
            timeTooltip.visible = true
        }

        onPositionChanged: {
            if (timeTooltip.visible) {
                timeTooltip.x = mouseX + 10
                timeTooltip.y = mouseY + 10
            }
        }

        onExited: timeTooltip.visible = false
    }

    Image {
        id: background
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        smooth: true

        source: getBackgroundSource(plasmoid.configuration.backgroundStyle)

        function getBackgroundSource(style) {
            switch (style) {
                case 0: return "pinkClock.png"
                case 1: return "redClock.png"
                case 2: return "blackClock.png"
                case 3: return ""
                default: return "pinkClock.png"
            }
        }
    }

    // TextMetrics for font sizing
    TextMetrics {
        id: textMetrics
        font.family: root.validFont
        font.pixelSize: 24
        text: "12"

        onHeightChanged: {
            root.cachedFontScale = 40 / height
        }
    }

    Item {
        id: clockContainer
        width: background.width * 0.74
        height: background.height * 0.74
        anchors.horizontalCenter: background.horizontalCenter
        anchors.horizontalCenterOffset: (background.width / 200) * -4
        anchors.verticalCenter: background.verticalCenter
        anchors.verticalCenterOffset: (background.height / 200) * 30

        layer.enabled: plasmoid.configuration.clockShadowEnabled
        layer.effect: DropShadow {
            color: "#ADD8E6"
            radius: 15
            horizontalOffset: 0
            verticalOffset: 0
            samples: 12  // Reduced from 20 for better performance
        }

        // Static canvas - draws once, only redraws on config changes
        Canvas {
            id: staticCanvas
            anchors.fill: parent

            Component.onCompleted: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)

                var scaleFactor = Math.min(width, height) / 200
                var centerX = width / 2
                var centerY = height / 2

                ctx.save()
                ctx.translate(centerX, centerY)
                ctx.scale(scaleFactor, scaleFactor)

                // Draw clock face background
                if (plasmoid.configuration.transparentBackground) {
                    // Get offset adjustments based on background style
                    var offsetX = 0
                    var offsetY = 0
                    var radiusAdjust = 0

                    switch (plasmoid.configuration.backgroundStyle) {
                        case 1: // redClock.png
                            offsetX = 2
                            offsetY = -1
                            radiusAdjust = 2
                            break
                        case 2: // blackClock.png
                            offsetX = 2
                            offsetY = 0
                            radiusAdjust = 4
                            break
                        default: // pinkClock.png or none
                            break
                    }

                    ctx.beginPath()
                    ctx.arc(offsetX, offsetY, 95 + radiusAdjust, 0, Math.PI * 2)
                    ctx.fillStyle = plasmoid.configuration.clockFaceColor
                    ctx.fill()
                }

                // Draw hour dashes
                ctx.lineWidth = 4
                ctx.strokeStyle = plasmoid.configuration.clockDashColor
                for (var i = 1; i < 12; i++) {
                    ctx.save()
                    ctx.rotate((Math.PI / 6) * i)
                    ctx.beginPath()
                    ctx.moveTo(0, -85)
                    ctx.lineTo(0, -75)
                    ctx.stroke()
                    ctx.restore()
                }

                // Draw "12" text
                var px = (24 * root.cachedFontScale)
                ctx.font = px + "px \"" + root.validFont + "\""
                ctx.fillStyle = plasmoid.configuration.clockDashColor
                ctx.textAlign = "center"
                ctx.textBaseline = "middle"
                ctx.fillText("12", 0, -60)

                ctx.restore()
            }
        }

        // Dynamic canvas - only draws clock hands, updated every second/minute
        Canvas {
            id: dynamicCanvas
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)

                var scaleFactor = Math.min(width, height) / 200
                var centerX = width / 2
                var centerY = height / 2

                var now = new Date()
                var hours = now.getHours() % 12
                var minutes = now.getMinutes()
                var seconds = now.getSeconds()

                ctx.save()
                ctx.translate(centerX, centerY)
                ctx.scale(scaleFactor, scaleFactor)

                // Hour hand
                ctx.save()
                ctx.lineWidth = 10
                ctx.strokeStyle = plasmoid.configuration.hourHandColor
                ctx.lineCap = "round"
                if (plasmoid.configuration.clockShadowEnabled) {
                    ctx.shadowColor = "rgba(205, 92, 92, 0.5)"
                    ctx.shadowBlur = 10
                    ctx.shadowOffsetX = 2
                    ctx.shadowOffsetY = 2
                }
                ctx.rotate((Math.PI / 6) * hours + (Math.PI / 360) * minutes)
                ctx.beginPath()
                ctx.moveTo(0, 10)
                ctx.lineTo(0, -40)
                ctx.stroke()
                ctx.restore()

                // Minute hand
                ctx.save()
                ctx.lineWidth = 8
                ctx.strokeStyle = plasmoid.configuration.minuteHandColor
                ctx.lineCap = "round"
                if (plasmoid.configuration.clockShadowEnabled) {
                    ctx.shadowColor = "rgba(205, 92, 92, 0.5)"
                    ctx.shadowBlur = 10
                    ctx.shadowOffsetX = 2
                    ctx.shadowOffsetY = 2
                }
                ctx.rotate((Math.PI / 30) * minutes + (Math.PI / 1800) * seconds)
                ctx.beginPath()
                ctx.moveTo(0, 10)
                ctx.lineTo(0, -70)
                ctx.stroke()
                ctx.restore()

                // Second hand
                if (plasmoid.configuration.clockShowSeconds) {
                    ctx.save()
                    ctx.lineWidth = 4
                    ctx.strokeStyle = plasmoid.configuration.secondHandColor
                    ctx.lineCap = "butt"
                    if (plasmoid.configuration.clockShadowEnabled) {
                        ctx.shadowColor = "rgba(205, 92, 92, 0.5)"
                        ctx.shadowBlur = 10
                        ctx.shadowOffsetX = 2
                        ctx.shadowOffsetY = 2
                    }
                    ctx.rotate((Math.PI / 30) * seconds)
                    ctx.beginPath()
                    ctx.moveTo(0, 20)
                    ctx.lineTo(0, -80)
                    ctx.stroke()
                    ctx.restore()
                }

                // Center dot
                ctx.beginPath()
                ctx.arc(0, 0, 5, 0, Math.PI * 2)
                ctx.fillStyle = "yellow"
                ctx.fill()

                ctx.restore()
            }
        }
    }

    // Main repaint timer - now properly updates interval
    Timer {
        id: repaintTimer
        interval: plasmoid.configuration.clockShowSeconds ? 1000 : 60000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            dynamicCanvas.requestPaint()
            if (timeTooltip.visible) {
                timeText.text = Qt.formatDateTime(new Date(), "hh:mm:ss AP")
            }
        }
    }

    // Configuration change handlers
    Connections {
        target: plasmoid.configuration

        function onClockShowSecondsChanged() {
            repaintTimer.interval = plasmoid.configuration.clockShowSeconds ? 1000 : 60000
            repaintTimer.restart()
            dynamicCanvas.requestPaint()
        }

        function onNoonFontChanged() {
            root.validFont = safeFontFamily(plasmoid.configuration.noonFont)
            textMetrics.font.family = root.validFont
            staticCanvas.requestPaint()
        }

        function onBackgroundStyleChanged() {
            staticCanvas.requestPaint()
        }

        function onTransparentBackgroundChanged() {
            staticCanvas.requestPaint()
        }

        function onClockFaceColorChanged() {
            staticCanvas.requestPaint()
        }

        function onClockDashColorChanged() {
            staticCanvas.requestPaint()
        }

        function onHourHandColorChanged() {
            dynamicCanvas.requestPaint()
        }

        function onMinuteHandColorChanged() {
            dynamicCanvas.requestPaint()
        }

        function onSecondHandColorChanged() {
            dynamicCanvas.requestPaint()
        }

        function onClockShadowEnabledChanged() {
            dynamicCanvas.requestPaint()
        }
    }
}
