# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Author: Simon Brummer (simon.brummer@posteo.de)
# Description: CMake file building the entire project.

cmake_minimum_required(VERSION 3.24)

project(plasma_rust_backend)

set(KF6_MIN_VERSION "6.1.0")
set(QT6_MIN_VERSION "6.6.0")

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(FeatureSummary)
include(ECMFeatureSummary)


find_package(Plasma REQUIRED)

find_package(KF6 ${KF6_MIN_VERSION} REQUIRED COMPONENTS
    KCMUtils
    Config
)

find_package(Qt6 ${QT6_MIN_VERSION} CONFIG REQUIRED COMPONENTS
    Qml
    Gui
    Quick
    Core
)

# Project properties
# TODO: centralize install paths and names?
set(PLASMOID_NAME       "bcdt.rust_backend_example")

set(PLUGIN_NAME         "rust_backend_example_plugin")
set(PLUGIN_ARTIFACT_QML "plugin/qmldir")
set(PLUGIN_ARTIFACT     "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/lib${PLUGIN_NAME}.so")
set(PLUGIN_INSTALLDIR   "${KDE_INSTALL_QMLDIR}/bcdt/rust_backend_example")

# Build Plugin (C++ entry point)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_library(
    ${PLUGIN_NAME}
    SHARED
        plugin/cpp/src/BackendProxy.cpp
        plugin/cpp/src/Plugin.cpp
)

target_include_directories(
    ${PLUGIN_NAME}
    PRIVATE
        plugin/cpp/include
)

target_link_libraries(
    ${PLUGIN_NAME}
    Qt6::Core
    Qt6::Qml
)



# TODO:
# Install C++ Plugin 
#
#find_package(Corrosion REQUIRED)
#
## Build rust based qml plugin
#set(CRATE rust_backend_example_plugin)
#set(CRATE_ARTIFACT ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/lib${CRATE}.so)
#set(PLUGIN_INSTALL_DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/plasma/private/rust_backend_example)
#
#get_target_property(QMAKE Qt6::qmake IMPORTED_LOCATION)
#
#corrosion_import_crate(
#MANIFEST_PATH plugin/Cargo.toml
#CRATE_TYPES cdylib
#CRATES ${CRATE}
#)
#
#corrosion_set_env_vars(${CRATE}
#"QMAKE=${QMAKE}"
#)

# Installation paths
# TODO: Create qmldir on the fly from cmake variables?

plasma_install_package(package ${PLASMOID_NAME})
install(FILES ${PLUGIN_ARTIFACT} DESTINATION ${PLUGIN_INSTALLDIR})
install(FILES ${PLUGIN_ARTIFACT_QML} DESTINATION ${PLUGIN_INSTALLDIR})

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
ecm_feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)

