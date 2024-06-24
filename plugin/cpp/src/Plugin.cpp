#include "Plugin.hpp"
#include "BackendProxy.hpp"
#include <QQmlEngine>

// TODO: Supply module name externaly (maybe define)

namespace {
QObject *backendProxySingletonBuilder(QQmlEngine *, QJSEngine *) {
  return new BackendProxy();
}
} // namespace

void Plugin::registerTypes(char const *uri) {
  Q_ASSERT(QLatin1String(uri) == QLatin1String("bcdt.rust_backend_example"));

  qmlRegisterSingletonType<BackendProxy>(uri, 1, 0, "Backend",
                                         backendProxySingletonBuilder);
}

#include "moc_Plugin.cpp"
