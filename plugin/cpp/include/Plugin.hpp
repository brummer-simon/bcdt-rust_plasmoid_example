#pragma once

#include <QQmlExtensionPlugin>

class Plugin : public QQmlExtensionPlugin {
private:
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface/1.0")

public:
  void registerTypes(char const *uri) override;
};
