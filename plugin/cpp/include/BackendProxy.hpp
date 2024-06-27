// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
// Author: Simon Brummer (simon.brummer@posteo.de)

#pragma once

#include "cxxbridge/backend.rs.hpp"
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
    rust::Box<rust::Backend> _backend;
};
