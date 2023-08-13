// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
// Author: Simon Brummer (simon.brummer@posteo.de)
// Description: The QML Plugin glue code declaration.

#ifndef PLUGIN_HPP_2023_08_13_11_03_43
#define PLUGIN_HPP_2023_08_13_11_03_43

#include <QQmlExtensionPlugin>

class Plugin : public QQmlExtensionPlugin {
private:
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
  void registerTypes(const char *uri) override;
};

#endif // PLUGIN_HPP_2023_08_13_11_03_43
