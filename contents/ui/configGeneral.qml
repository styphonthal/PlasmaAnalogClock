import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

Kirigami.FormLayout {
    property alias cfg_transparentBackground: transparentBackgroundCheckBox.checked
    property alias cfg_clockShowSeconds: showSeconds.checkState
    property alias cfg_backgroundStyle: backgroundStyleComboBox.currentIndex
    property alias cfg_clockFaceColor: colorComboBox.currentValue
    property alias cfg_hourHandColor: hourHandcolorComboBox.currentValue
    property alias cfg_minuteHandColor: minuteHandcolorComboBox.currentValue
    property alias cfg_secondHandColor: secondHandcolorComboBox.currentValue
    property alias cfg_clockDashColor: clockDashcolorComboBox.currentValue
    property alias cfg_noonFont: noonFontComboBox.currentValue

    property alias cfg_clockShadowEnabled: clockShadowCheckBox.checked



    Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "Clock Display Settings"
    }

    CheckBox {
        id: clockShadowCheckBox
        Kirigami.FormData.label: "Enable Shadows"
        tristate: false
        checked: cfg_clockShadowEnabled
    }

    CheckBox {
        id: transparentBackgroundCheckBox
        Kirigami.FormData.label: i18n("Fill In ClockFace:")
    }

    CheckBox {
        Kirigami.FormData.label: "Show seconds"
        id: showSeconds
        tristate: false
        checked: cfg_clockShowSeconds
    }

    ComboBox {
        id: backgroundStyleComboBox
        Kirigami.FormData.label: i18n("Background Image:")
        model: [i18n("Pink Monster"), i18n("Red Clock/Gray Frame "), i18n("Black Frame"), i18n("Empty Frame")]
    }

    ComboBox {
        id: noonFontComboBox
        Kirigami.FormData.label: i18n("Noon Font:")
        model: Qt.fontFamilies()
        currentIndex: model.indexOf(plasmoid.configuration.noonFont)
        onCurrentTextChanged: plasmoid.configuration.noonFont = currentText
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
    }

}
