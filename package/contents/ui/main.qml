// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
// Author: Simon Brummer (simon.brummer@posteo.de)
// Description: Widget used to read/write data from the Qml Extension
//              that is implemented in Rust.

import QtQuick 6.0
import QtQuick.Layouts 6.0
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents

//import org.kde.plasma.private.rust.backend 1.0

PlasmoidItem {
    id: root

    /*
    Component.onCompleted: {
        Backend.number = plasmoid.configuration.counterStartValue
    }
    */

    fullRepresentation: ColumnLayout {
        anchors.fill: parent

        PlasmaComponents.Label {
            Layout.alignment: Qt.AlignCenter

            //text: i18n("Click Counter: %1", Backend.number)
            text: i18n("Test")
        }

        Row {
            spacing: 10

            PlasmaComponents.Button {
                Layout.alignment: Qt.AlignCenter

                text: i18n("Click Me")

                //onClicked: Backend.incrementNumber()
            }

            PlasmaComponents.Button {
                Layout.alignment: Qt.AlignCenter

                text: i18n("Reset")

                //onClicked: Backend.number = plasmoid.configuration.counterStartValue
            }
        }
    }
}

