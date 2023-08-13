# Example KDE Widget with a Rust backend

## Motivation

I like to develop in rust and as KDE user, I though at some point "I really would like implement widgets with Rust as backend".
Then I searched for examples in that regard and did not find anything.
A few days after that I thought "It can't be that hard to do that", so ended up creating a PoC/this repo.

To get this to work, I basically merged code from three separate examples/project that solve parts of my problem.

I am standing here on the shoulders of giants so many thanks to:

- [KDE](https://github.com/KDE/plasma-framework)
- [CXX-QT](https://github.com/KDAB/cxx-qt)
- [Jiriki86](https://github.com/Jiriki86/Connect4)

## What does it do?

It is a click counter widget, manipulating a counter maintained in the rust component.

## How does it work?

The whole example is build around a QML Extension. The Rust backend uses cxx-qt to
generate QT compatible wrappers for rust types (plugin/rust/build.rs). These wrappers are registered
as QML Types in a tiny C++ based piece of code forming a QML plugin.
These custom QML types can be used in the KDE Framework.

The entire example is build with the KDE CMake build scripts.
The Rust code is compiled into a static library, that is linked into the dynamic
library forming the QML Plugin. The plugin then can be used in widgets.

# Build instructions

## Build instructions

It is assumed that a Rust, QT and KDE develop requirements are met.
The following command build and install the project.

mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr
cmake --build .
sudo cmake --install .

## Run contained environment

plasmoidviewer -a org.kde.plasma.rust.example
