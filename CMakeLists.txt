# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Author: Simon Brummer (simon.brummer@posteo.de)
# Description: CMake file building the entire project.

# TODO: Compile with release config
# TODO: Rename Repo to prefix bcdt-
# TODO: Move binding generation into CMake
# TODO: Test for missing cargo install cxxbridge-cmd

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

find_package(Corrosion REQUIRED)
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
# TODO: centralize install paths and names/roll them out into the project
set(PLASMOID_NAME       "bcdt.rust_backend_example")

# Plugin related attributes
set(PLUGIN_NAME              "plugin")
set(PLUGIN_ARTIFACT_QML      "plugin/qmldir")
set(PLUGIN_ARTIFACT          "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/lib${PLUGIN_NAME}.so")
set(PLUGIN_INSTALL_DIR       "${KDE_INSTALL_QMLDIR}/bcdt/rust_backend_example")

set(BINDINGS_GEN_NAME        "generate_cxxbridge")
set(BINDINGS_GEN_DIR         "${CMAKE_BINARY_DIR}/${BINDINGS_GEN_NAME}")
set(BINDINGS_GEN_INCLUDE_DIR "${BINDINGS_GEN_DIR}/include/cxxbridge")
set(BINDINGS_GEN_SOURCE_DIR  "${BINDINGS_GEN_DIR}/src")

set(CRATE_NAME               "plugin_impl")

# Build Plugin (Rust core)
corrosion_import_crate(
    MANIFEST_PATH plugin/rust/Cargo.toml
    CRATES ${CRATE_NAME}
)

# Build Rust <-> CPP bindings
add_custom_target(
    ${BINDINGS_GEN_NAME}
    COMMAND rm -rf   ${BINDINGS_GEN_DIR}
    COMMAND mkdir -p ${BINDINGS_GEN_INCLUDE_DIR}
    COMMAND mkdir -p ${BINDINGS_GEN_SOURCE_DIR}
    COMMAND cxxbridge plugin/rust/src/backend.rs --header --output "${BINDINGS_GEN_INCLUDE_DIR}/backend.rs.hpp"
    COMMAND cxxbridge plugin/rust/src/backend.rs --output "${BINDINGS_GEN_SOURCE_DIR}/backend.rs.cpp"
)

# TODO: Change later to binding generation
add_dependencies(
    ${CRATE_NAME}
    ${BINDINGS_GEN_NAME}
)

# TODO: Compile Bindings into static lib

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
        plugin/rust/target
)

target_link_libraries(
    ${PLUGIN_NAME}
    ${CRATE_NAME}
    Qt6::Core
    Qt6::Qml
)

# Installation paths
plasma_install_package(package ${PLASMOID_NAME})
install(FILES ${PLUGIN_ARTIFACT_QML} DESTINATION ${PLUGIN_INSTALL_DIR})
install(FILES ${PLUGIN_ARTIFACT}     DESTINATION ${PLUGIN_INSTALL_DIR})

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
ecm_feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
