// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
// Author: Simon Brummer (simon.brummer@posteo.de)
// Description: General section of the Configuration dialog.

import QtQuick 2.0
import QtQuick.Controls 2.5 as Controls

import org.kde.kirigami 2.4 as Kirigami

Kirigami.FormLayout {
    id: page
    anchors.fill: parent

    property alias cfg_counterStartValue: counterStartValue.value

    Controls.SpinBox {
        id: counterStartValue

        Kirigami.FormData.label: i18n("Click counter starting value:")
    }
}
