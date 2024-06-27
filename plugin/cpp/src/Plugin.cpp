#include "Plugin.hpp"
#include "BackendProxy.hpp"
#include <QQmlEngine>

#ifndef PLUGIN_URI
#error Missing external define. Pass PLUGIN_URI to plugin build step
#endif

namespace {
QObject *backendProxySingletonBuilder(QQmlEngine *, QJSEngine *) {
  return new BackendProxy();
}
} // namespace

void Plugin::registerTypes(char const *uri) {
  Q_ASSERT(QLatin1String(uri) == QLatin1String(PLUGIN_URI));

  qmlRegisterSingletonType<BackendProxy>(uri, 1, 0, "Backend",
                                         backendProxySingletonBuilder);
}

#include "moc_Plugin.cpp"
