# Example KDE Widget with a Rust backend

## Motivation

I like to develop in rust and as KDE user, I though at some point "I really would like to implement widgets with Rust as backend".
Then I searched for examples and howtos and did not find anything. Then I thought "It can't be that hard to do that", so ended up creating a PoC/this repo.

To get this to work, I basically merged code from three separate examples/project that solve parts of my problem.

I am standing here on the shoulders of giants so many thanks to:

- [KDE](https://github.com/KDE/plasma-framework)
- [CXX-QT](https://github.com/KDAB/cxx-qt)
- [qmetaobject](https://github.com/woboq/qmetaobject-rs)
- [Jiriki86](https://github.com/Jiriki86/Connect4)

## What does it do?

It is a click counter widget, manipulating a counter maintained in the rust component.

## How does it work?

The Rust backend uses qmetaobject to register Rust types as QML types as part of a QML extension plugin.
These custom QML types can be used in plasma widgets.

The entire example is built via KDE CMake build scripts to install things in the correct locations.

# Build instructions

## Build instructions

It is assumed that Rust, QT and KDE develop requirements are met.
The following commands build and install the project.

```
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr
cmake --build .
sudo cmake --install .
```

## Run contained environment

plasmoidviewer -a org.kde.plasma.rust.example
