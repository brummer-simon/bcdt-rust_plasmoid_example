#pragma once

#include "cxxbridge/rust_backend_example_plugin_impl/src/lib.rs.h"

#include <QObject>
#include <qqmlintegration.h>
#include <qtmetamacros.h>

class BackendProxy : public QObject {
private:
  Q_OBJECT
  Q_PROPERTY(qint32 number READ number WRITE setNumber NOTIFY numberChanged)

public:
  explicit BackendProxy(QObject *parent = nullptr);
  ~BackendProxy() = default;

  qint32 number() const;
  void setNumber(qint32 number);

  Q_INVOKABLE void incrementNumber();

Q_SIGNALS:
  void numberChanged(qint32 const &number);

private:
    rust::Box<rust_ffi::Backend> _backend;
};
