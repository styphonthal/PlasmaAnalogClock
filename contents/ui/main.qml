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

    // ===== CONFIGURATION CONSTANTS =====
    readonly property real clockContainerSizeFactor: 0.74
    readonly property int clockContainerHorizontalOffset: -4
    readonly property int clockContainerVerticalOffset: 30
    readonly property real clockFaceRadius: 95
    readonly property real hourDashInnerRadius: 75
    readonly property real hourDashOuterRadius: 85
    readonly property real hourDashLength: 10
    readonly property real hourHandBaseLength: 40
    readonly property real minuteHandBaseLength: 70
    readonly property real secondHandBaseLength: 80
    readonly property real centerDotRadius: 5
    readonly property real textNoonYOffset: -65
    readonly property int hourDashCount: 11
    readonly property int hourDashLineWidth: 4
    readonly property int hourHandLineWidth: 10
    readonly property int minuteHandLineWidth: 8
    readonly property int secondHandLineWidth: 4
    readonly property int textMetricsPixelSize: 32
    readonly property real canvasScaleDivisor: 200

    // ===== SHADOW CONFIGURATION CONSTANTS =====
    readonly property var shadowConfig: ({
        color: "rgba(205, 92, 92, 0.5)",
        blur: 10,
        offsetX: 2,
        offsetY: 2
    })

    // ===== CACHED PROPERTIES =====
    property real aspectRatio: getAspectRatio(plasmoid.configuration.backgroundStyle)
    property string validFont: safeFontFamily(plasmoid.configuration.noonFont)
    property real cachedFontScale: 1.0

    // ===== CACHED BACKGROUND OFFSETS =====
    property real cachedOffsetX: 0
    property real cachedOffsetY: 0
    property real cachedRadiusAdjust: 0

    // ===== UTILITY FUNCTIONS =====

    function getAspectRatio(style) {
        switch (style) {
            case 0: return 1.0   // pinkClock.png - square
            case 1: return 0.92  // redClock.png - taller
            case 2: return 0.92  // blackClock.png - taller
            case 3: return 1.0   // no background - square
            default: return 1.0
        }
    }

    function safeFontFamily(family) {
        if (!family) return "Sans Serif"
        const fam = String(family).trim()
        const list = Qt.fontFamilies()
        return (list.indexOf(fam) >= 0) ? fam : "Sans Serif"
    }

    function updateCachedOffsets(style) {
        switch (style) {
            case 1: // redClock.png
                cachedOffsetX = 2
                cachedOffsetY = -1
                cachedRadiusAdjust = 2
                break
            case 2: // blackClock.png
                cachedOffsetX = 2
                cachedOffsetY = 0
                cachedRadiusAdjust = 4
                break
            default: // pinkClock.png or none
                cachedOffsetX = 0
                cachedOffsetY = 0
                cachedRadiusAdjust = 0
                break
        }
    }

    function drawHand(ctx, angle, length, lineWidth, strokeStyle, shouldApplyShadow) {
        ctx.save()
        ctx.lineWidth = lineWidth
        ctx.strokeStyle = strokeStyle
        ctx.lineCap = "round"
        
        if (shouldApplyShadow && plasmoid.configuration.clockShadowEnabled) {
            ctx.shadowColor = shadowConfig.color
            ctx.shadowBlur = shadowConfig.blur
            ctx.shadowOffsetX = shadowConfig.offsetX
            ctx.shadowOffsetY = shadowConfig.offsetY
        }
        
        ctx.rotate(angle)
        ctx.beginPath()
        ctx.moveTo(0, 10)
        ctx.lineTo(0, -length)
        ctx.stroke()
        ctx.restore()
    }

    // Use binding to maintain aspect ratio - cleaner than mutual handlers
    Binding {
        target: root
        property: "height"
        value: root.width / root.aspectRatio
        when: root.width > 0
    }

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    // ===== TOOLTIP COMPONENT =====
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

    // ===== MOUSE HOVER AREA =====
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

    // ===== BACKGROUND IMAGE =====
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

    // ===== TEXT METRICS FOR FONT SIZING =====
    TextMetrics {
        id: textMetrics
        font.family: root.validFont
        font.pixelSize: textMetricsPixelSize
        text: "12"

        onHeightChanged: {
            root.cachedFontScale = textMetricsPixelSize / height
        }
    }

    // ===== CLOCK CONTAINER =====
    Item {
        id: clockContainer
        width: background.width * clockContainerSizeFactor
        height: background.height * clockContainerSizeFactor
        anchors.horizontalCenter: background.horizontalCenter
        anchors.horizontalCenterOffset: (background.width / canvasScaleDivisor) * clockContainerHorizontalOffset
        anchors.verticalCenter: background.verticalCenter
        anchors.verticalCenterOffset: (background.height / canvasScaleDivisor) * clockContainerVerticalOffset

        layer.enabled: plasmoid.configuration.clockShadowEnabled
        layer.effect: DropShadow {
            color: "#ADD8E6"
            radius: 15
            horizontalOffset: 0
            verticalOffset: 0
            samples: 12
        }

        // ===== STATIC CANVAS =====
        Canvas {
            id: staticCanvas
            anchors.fill: parent

            Component.onCompleted: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)

                var scaleFactor = Math.min(width, height) / canvasScaleDivisor
                var centerX = width / 2
                var centerY = height / 2

                ctx.save()
                ctx.translate(centerX, centerY)
                ctx.scale(scaleFactor, scaleFactor)

                // Draw clock face background
                if (plasmoid.configuration.transparentBackground) {
                    ctx.beginPath()
                    ctx.arc(cachedOffsetX, cachedOffsetY, clockFaceRadius + cachedRadiusAdjust, 0, Math.PI * 2)
                    ctx.fillStyle = plasmoid.configuration.clockFaceColor
                    ctx.fill()
                }

                // Draw hour dashes
                ctx.lineWidth = hourDashLineWidth
                ctx.strokeStyle = plasmoid.configuration.clockDashColor
                for (var i = 1; i < 12; i++) {
                    ctx.save()
                    ctx.rotate((Math.PI / 6) * i)
                    ctx.beginPath()
                    ctx.moveTo(0, -hourDashOuterRadius)
                    ctx.lineTo(0, -hourDashInnerRadius)
                    ctx.stroke()
                    ctx.restore()
                }

                // Draw "12" text
                var px = (textMetricsPixelSize * root.cachedFontScale)
                ctx.font = px + "px \"" + root.validFont + "\""
                ctx.fillStyle = plasmoid.configuration.clockDashColor
                ctx.textAlign = "center"
                ctx.textBaseline = "middle"
                ctx.fillText("12", 0, textNoonYOffset)

                ctx.restore()
            }
        }

        // ===== DYNAMIC CANVAS (CLOCK HANDS) =====
        Canvas {
            id: dynamicCanvas
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)

                var scaleFactor = Math.min(width, height) / canvasScaleDivisor
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
                var hourAngle = (Math.PI / 6) * hours + (Math.PI / 360) * minutes
                drawHand(ctx, hourAngle, hourHandBaseLength, hourHandLineWidth, 
                         plasmoid.configuration.hourHandColor, true)

                // Minute hand
                var minuteAngle = (Math.PI / 30) * minutes + (Math.PI / 1800) * seconds
                drawHand(ctx, minuteAngle, minuteHandBaseLength, minuteHandLineWidth,
                         plasmoid.configuration.minuteHandColor, true)

                // Second hand (if enabled)
                if (plasmoid.configuration.clockShowSeconds) {
                    var secondAngle = (Math.PI / 30) * seconds
                    ctx.save()
                    ctx.lineWidth = secondHandLineWidth
                    ctx.strokeStyle = plasmoid.configuration.secondHandColor
                    ctx.lineCap = "butt"
                    if (plasmoid.configuration.clockShadowEnabled) {
                        ctx.shadowColor = shadowConfig.color
                        ctx.shadowBlur = shadowConfig.blur
                        ctx.shadowOffsetX = shadowConfig.offsetX
                        ctx.shadowOffsetY = shadowConfig.offsetY
                    }
                    ctx.rotate(secondAngle)
                    ctx.beginPath()
                    ctx.moveTo(0, 20)
                    ctx.lineTo(0, -secondHandBaseLength)
                    ctx.stroke()
                    ctx.restore()
                }

                // Center dot
                ctx.beginPath()
                ctx.arc(0, 0, centerDotRadius, 0, Math.PI * 2)
                ctx.fillStyle = "yellow"
                ctx.fill()

                ctx.restore()
            }
        }
    
    }

    // ===== MAIN REPAINT TIMER =====
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

    // ===== CONFIGURATION CHANGE HANDLERS =====
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
            aspectRatio = getAspectRatio(plasmoid.configuration.backgroundStyle)
            updateCachedOffsets(plasmoid.configuration.backgroundStyle)
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
            staticCanvas.requestPaint()
            dynamicCanvas.requestPaint()
        }
    }

    // Initialize cached offsets on startup
    Component.onCompleted: {
        updateCachedOffsets(plasmoid.configuration.backgroundStyle)
    }
}
