import QtQuick 2.0
import QtQml 2.2
import org.kde.plasma.configuration

ConfigModel {
    id: configmodel

    ConfigCategory {
        name: i18n("Appearance")
        icon: "preferences-desktop-color"
        source: "configGeneral.qml"
    }
    // Add more categories if needed
}
