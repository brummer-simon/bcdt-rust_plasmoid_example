#include "BackendProxy.hpp"

BackendProxy::BackendProxy(QObject *parent)
    : QObject{parent}, _backend{rust::make_backend()} {}

qint32 BackendProxy::number() const { return _backend->number(); }

void BackendProxy::setNumber(qint32 number) {
  if (_backend->number() != number) {
    _backend->set_number(number);

    Q_EMIT numberChanged(_backend->number());
  }
}

void BackendProxy::incrementNumber() {
  _backend->increment_number();

  Q_EMIT numberChanged(_backend->number());
}

#include "moc_BackendProxy.cpp"
