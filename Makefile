# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Author: Simon Brummer (simon.brummer@posteo.de)

BUILD_TYPE ?= Release
BUILD_RELEASE_DIR ?= build_release
BUILD_DEBUG_DIR ?= build_debug

help:
	echo "This makefile supports the following targets:"
	echo "    - build_debug     - Build module (debug config)"
	echo "    - build_release   - Build module (release config)"
	echo "    - build           - Build module. Set BUILD_TYPE to select variant"
	echo "    - clean_debug     - Delete build artifacts (debug config)"
	echo "    - clean_release   - Delete build artifacts (release config)"
	echo "    - clean           - Delete build artifacts. Set BUILD_TYPE to select variant"
	echo "    - install_debug   - Install modules and all related files (debug config)"
	echo "    - install_release - Install modules and all related files (release config)"
	echo "    - install         - Install modules and all related files. Set BUILD_TYPE to select variant"
	echo "    - uninstall       - Uninstall modules and all related files"
	echo "    - run             - Run plasmoid in dedicated viewer"
	echo "    - help            - Print help"
	echo

build_debug:
	mkdir -p $(BUILD_DEBUG_DIR);   pushd $(BUILD_DEBUG_DIR); cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/usr ..
	cmake --build $(BUILD_DEBUG_DIR)
	ln -sf $(PWD)/$(BUILD_DEBUG_DIR)/compile_commands.json $(PWD)/compile_commands.json

build_release:
	mkdir -p $(BUILD_RELEASE_DIR); pushd $(BUILD_RELEASE_DIR); cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr ..
	cmake --build $(BUILD_RELEASE_DIR)
	ln -sf $(PWD)/$(BUILD_RELEASE_DIR)/compile_commands.json $(PWD)/compile_commands.json

ifeq ($(BUILD_TYPE),Debug)
build: build_debug
else ifeq ($(BUILD_TYPE),Release)
build: build_release
else
$(error Unknown build type: "$(BUILD_TYPE)")
endif

clean_debug:
	rm -rf $(BUILD_DEBUG_DIR)

clean_release:
	rm -rf $(BUILD_RELEASE_DIR)

ifeq ($(BUILD_TYPE),Debug)
clean: clean_debug
else ifeq ($(BUILD_TYPE),Release)
clean: clean_release
else
$(error Unknown build type: "$(BUILD_TYPE)")
endif

install_debug:
	sudo cmake --install $(BUILD_DEBUG_DIR)

install_release:
	sudo cmake --install $(BUILD_RELEASE_DIR)

ifeq ($(BUILD_TYPE),Debug)
install: install_debug
else ifeq ($(BUILD_TYPE),Release)
install: install_release
else
$(error Unknown build type: "$(BUILD_TYPE)")
endif

uninstall:
	sudo rm -rf /usr/share/plasma/plasmoids/bcdt.rust_backend_example
	sudo rm -rf /usr/lib/qt6/qml/bcdt/rust_backend_example

run:
	plasmoidviewer -a bcdt.rust_backend_example

.PHONY:\
	help\
	build_debug\
	build_release\
	build\
	clean_debug\
	clean_release\
	clean\
	install_debug\
	install_release\
	install\
	uninstall\
	run

.SILENT:\
	help
