# TODO: Cleanup readme.md

help:
	echo "This makefile supports the following targets:"
	echo "    - build     - Build module"
	echo "    - clean     - Delete build artifacts"
	echo "    - install   - Install modules and all related files"
	echo "    - uninstall - Uninstall modules and all related files"
	echo "    - viewer    - Run plasmoid in dedicated viewer"
	echo

build:
	mkdir -p build; pushd build; cmake -DCMAKE_INSTALL_PREFIX=/usr ..; popd
	cmake --build build

clean:
	rm -rf build

install:
	sudo cmake --install build

uninstall:
	sudo rm -rf /usr/share/plasma/plasmoids/bcdt.rust_backend_example
	sudo rm -rf /usr/lib/qt6/qml/bcdt/rust_backend_example

viewer:
	plasmoidviewer -a bcdt.rust_backend_example

.PHONY:\
	help\
	build\
	clean\
	install\
	uninstall\
	viewer

.SILENT:\
	help
