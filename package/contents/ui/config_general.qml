// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
// Author: Simon Brummer (simon.brummer@posteo.de)
// Description: General section of the Configuration dialog.

import QtQuick 6.0
import QtQuick.Controls 6.0 as Controls
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: page
    anchors.fill: parent

    property alias cfg_counterStartValue: counterStartValue.value

    Controls.SpinBox {
        id: counterStartValue

        Kirigami.FormData.label: i18n("Click counter starting value:")
    }
}
