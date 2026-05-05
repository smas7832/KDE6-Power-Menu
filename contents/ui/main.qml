import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.private.sessions
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root

    property var customCommandsModel: []

    preferredRepresentation: compactRepresentation
    
    // Panel Icon
    compactRepresentation: PlasmaComponents.ToolButton {
        icon.name: "system-shutdown"
        onClicked: root.expanded = !root.expanded
    }

    SessionManagement {
        id: sessionManager
    }

    Plasma5Support.DataSource {
        id: executableEngine
        engine: "executable"
        connectedSources: []
        
        onNewData: function(sourceName, data) {
            disconnectSource(sourceName)
        }

        function exec(cmd) {
            connectSource(cmd)
        }
    }

    fullRepresentation: ColumnLayout {
        id: layout
        spacing: 0

        PlasmaComponents.ItemDelegate {
            Layout.fillWidth: true
            text: "Lock Screen"
            icon.name: Plasmoid.configuration.iconLock || "system-lock-screen"
            visible: sessionManager.canLock
            onClicked: {
                sessionManager.lock()
                root.expanded = false
            }
        }

        PlasmaComponents.ItemDelegate {
            Layout.fillWidth: true
            text: "Log Out"
            icon.name: Plasmoid.configuration.iconLogout || "system-log-out"
            visible: sessionManager.canLogout
            onClicked: {
                sessionManager.requestLogout()
                root.expanded = false
            }
        }

        PlasmaComponents.ItemDelegate {
            Layout.fillWidth: true
            text: "Sleep"
            icon.name: Plasmoid.configuration.iconSleep || "system-suspend"
            visible: sessionManager.canSuspend
            onClicked: {
                sessionManager.suspend()
                root.expanded = false
            }
        }

        PlasmaComponents.ItemDelegate {
            Layout.fillWidth: true
            text: "Restart"
            icon.name: Plasmoid.configuration.iconRestart || "system-reboot"
            visible: sessionManager.canReboot
            onClicked: {
                sessionManager.requestReboot()
                root.expanded = false
            }
        }

        PlasmaComponents.ItemDelegate {
            Layout.fillWidth: true
            text: "Shut Down"
            icon.name: Plasmoid.configuration.iconShutdown || "system-shutdown"
            visible: sessionManager.canShutdown
            onClicked: {
                sessionManager.requestShutdown()
                root.expanded = false
            }
        }

        // Separator if we have custom commands
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: PlasmaCore.Theme.separatorColor
            visible: root.customCommandsModel.length > 0
        }

        // Custom Commands
        Repeater {
            id: customCommandsRepeater
            model: root.customCommandsModel

            delegate: PlasmaComponents.ItemDelegate {
                Layout.fillWidth: true
                text: modelData.name
                icon.name: modelData.icon || "utilities-terminal"
                onClicked: {
                    executableEngine.exec(modelData.command)
                    root.expanded = false
                }
            }
        }
    }

    function loadCustomCommands() {
        try {
            var raw = Plasmoid.configuration.customCommands;
            if (raw) {
                root.customCommandsModel = JSON.parse(raw);
            } else {
                root.customCommandsModel = [];
            }
        } catch(e) {
            console.error("Failed to parse custom commands", e);
            root.customCommandsModel = [];
        }
    }

    Component.onCompleted: {
        loadCustomCommands();
    }

    Connections {
        target: Plasmoid.configuration
        function onCustomCommandsChanged() {
            loadCustomCommands();
        }
    }
}
