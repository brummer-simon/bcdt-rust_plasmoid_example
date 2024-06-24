#include "BackendProxy.hpp"

BackendProxy::BackendProxy(QObject *parent) : QObject{parent}, _number{} {}

qint32 BackendProxy::number() const {
    return _number;
}

void BackendProxy::setNumber(qint32 number) {
    if (_number != number) {
        _number = number;
        Q_EMIT numberChanged(_number);
    }
}

void BackendProxy::incrementNumber() {
    setNumber(_number + 1);
}

#include "moc_BackendProxy.cpp"
