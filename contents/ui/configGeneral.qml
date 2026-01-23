import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

Kirigami.FormLayout {
    property alias cfg_transparentBackground: transparentBackgroundCheckBox.checked

    // Bool should bind to .checked (not .checkState)
    property alias cfg_clockShowSeconds: showSeconds.checked

    property alias cfg_backgroundStyle: backgroundStyleComboBox.currentIndex
    property alias cfg_clockFaceColor: colorComboBox.currentValue
    property alias cfg_hourHandColor: hourHandcolorComboBox.currentValue
    property alias cfg_minuteHandColor: minuteHandcolorComboBox.currentValue
    property alias cfg_secondHandColor: secondHandcolorComboBox.currentValue
    property alias cfg_clockDashColor: clockDashcolorComboBox.currentValue

    // font should bind to currentText
    property alias cfg_noonFont: noonFontComboBox.currentText

    property alias cfg_clockShadowEnabled: clockShadowCheckBox.checked

    // Plasma 6 config UI injects *Default properties into the root item.
    // If they don't exist, you get the warnings you pasted and Apply/Defaults behavior can break.

    property bool cfg_transparentBackgroundDefault
    property bool cfg_clockShowSecondsDefault
    property int  cfg_backgroundStyleDefault
    property bool cfg_clockShadowEnabledDefault

    // You have these entries in main.xml (kcfg) but no matching root properties.
    // Even if you don't expose a control for them, Plasma may still try to inject them.
    property string cfg_clockShadowColor
    property string cfg_clockShadowColorDefault

    property string cfg_clockFaceColorDefault
    property string cfg_hourHandColorDefault
    property string cfg_minuteHandColorDefault
    property string cfg_secondHandColorDefault
    property string cfg_clockDashColorDefault
    property string cfg_noonFontDefault
    property string title: ""


    // ---- helpers to restore saved values into ComboBoxes ----
    function normalizeColor(v) {
        // normalize to uppercase string; also strip whitespace
        return String(v).trim().toUpperCase()
    }

    function setComboIndexByValue(combo, storedValue) {
        const target = normalizeColor(storedValue)
        const m = combo.model
        if (!m || m.length === 0) return

            let idx = -1
            for (let i = 0; i < m.length; i++) {
                // model entries are {name, value}
                if (normalizeColor(m[i].value) === target) {
                    idx = i
                    break
                }
            }
            if (idx >= 0) combo.currentIndex = idx
    }

    Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "Clock Display Settings"
    }

    CheckBox {
        id: clockShadowCheckBox
        Kirigami.FormData.label: "Enable Shadows"
        tristate: false
        // Do NOT bind checked: cfg_clockShadowEnabled (alias already binds; avoids loops)
    }

    CheckBox {
        id: transparentBackgroundCheckBox
        Kirigami.FormData.label: i18n("Fill In ClockFace:")
    }

    CheckBox {
        Kirigami.FormData.label: "Show seconds"
        id: showSeconds
        tristate: false
        // Do NOT bind checked: cfg_clockShowSeconds (alias already binds; avoids loops)
    }

    ComboBox {
        id: backgroundStyleComboBox
        Kirigami.FormData.label: i18n("Background Image:")
        model: [
            i18n("Pink Monster"),
            i18n("Red Clock/Gray Frame "),
            i18n("Black Frame"),
            i18n("Empty Frame")
        ]
    }

    ComboBox {
        id: noonFontComboBox
        Kirigami.FormData.label: i18n("Noon Font:")
        model: Qt.fontFamilies()

        Component.onCompleted: {
            const idx = model.indexOf(cfg_noonFont)
            if (idx >= 0) currentIndex = idx
        }
    }

    ComboBox {
        id: colorComboBox
        Kirigami.FormData.label: i18n("Clock Face Fill-in Color:")
        model: [
            { name: "White", value: "#FFFFFF" },
            { name: "Red", value: "#FF0000" },
            { name: "Blue", value: "#0000FF" },
            { name: "Green", value: "#00FF00" },
            { name: "Yellow", value: "#FFFF00" },
            { name: "Purple", value: "#800080" },
            { name: "Orange", value: "#FFA500" },
            { name: "Pink", value: "#FFC0CB" },
            { name: "Brown", value: "#A52A2A" },
            { name: "Gray", value: "#808080" },
            { name: "Black", value: "#000000" }
        ]
        textRole: "name"
        valueRole: "value"
        enabled: transparentBackgroundCheckBox.checked

        Component.onCompleted: setComboIndexByValue(this, cfg_clockFaceColor)
    }

    ComboBox {
        id: hourHandcolorComboBox
        Kirigami.FormData.label: i18n("Hour Hand Color:")
        model: [
            { name: "Red", value: "#FF0000" },
            { name: "Yellow", value: "#FFFF00" },
            { name: "White", value: "#FFFFFF" },
            { name: "Blue", value: "#0000FF" },
            { name: "Green", value: "#00FF00" },
            { name: "Purple", value: "#800080" },
            { name: "Orange", value: "#FFA500" },
            { name: "Pink", value: "#FFC0CB" },
            { name: "Brown", value: "#A52A2A" },
            { name: "Gray", value: "#808080" },
            { name: "Black", value: "#000000" }
        ]
        textRole: "name"
        valueRole: "value"

        Component.onCompleted: setComboIndexByValue(this, cfg_hourHandColor)
    }

    ComboBox {
        id: minuteHandcolorComboBox
        Kirigami.FormData.label: i18n("Minute Hand Color:")
        model: [
            { name: "Aqua Blue", value: "#00BFFF" },
            { name: "Yellow", value: "#FFFF00" },
            { name: "White", value: "#FFFFFF" },
            { name: "Red", value: "#FF0000" },
            { name: "Blue", value: "#0000FF" },
            { name: "Green", value: "#00FF00" },
            { name: "Purple", value: "#800080" },
            { name: "Orange", value: "#FFA500" },
            { name: "Pink", value: "#FFC0CB" },
            { name: "Brown", value: "#A52A2A" },
            { name: "Gray", value: "#808080" },
            { name: "Black", value: "#000000" }
        ]
        textRole: "name"
        valueRole: "value"

        Component.onCompleted: setComboIndexByValue(this, cfg_minuteHandColor)
    }

    ComboBox {
        id: secondHandcolorComboBox
        Kirigami.FormData.label: i18n("Second Hand Color:")
        model: [
            { name: "Yellow", value: "#FFFF00" },
            { name: "White", value: "#FFFFFF" },
            { name: "Red", value: "#FF0000" },
            { name: "Blue", value: "#0000FF" },
            { name: "Green", value: "#00FF00" },
            { name: "Purple", value: "#800080" },
            { name: "Orange", value: "#FFA500" },
            { name: "Pink", value: "#FFC0CB" },
            { name: "Brown", value: "#A52A2A" },
            { name: "Gray", value: "#808080" },
            { name: "Black", value: "#000000" }
        ]
        textRole: "name"
        valueRole: "value"

        Component.onCompleted: setComboIndexByValue(this, cfg_secondHandColor)
    }

    ComboBox {
        id: clockDashcolorComboBox
        Kirigami.FormData.label: i18n("Noon/Dashes Color:")
        model: [
            { name: "Blue", value: "#4D2EE6" },
            { name: "Yellow", value: "#FFFF00" },
            { name: "White", value: "#FFFFFF" },
            { name: "Red", value: "#FF0000" },
            { name: "Green", value: "#00FF00" },
            { name: "Purple", value: "#800080" },
            { name: "Orange", value: "#FFA500" },
            { name: "Pink", value: "#FFC0CB" },
            { name: "Brown", value: "#A52A2A" },
            { name: "Gray", value: "#808080" },
            { name: "Black", value: "#000000" }
        ]
        textRole: "name"
        valueRole: "value"

        Component.onCompleted: setComboIndexByValue(this, cfg_clockDashColor)
    }
}
