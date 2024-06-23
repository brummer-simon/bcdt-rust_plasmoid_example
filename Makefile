# Currently selected kernel module to build
# TODO: Align on path
# TODO: Fix help and document makefile

help:
	echo "This makefile supports the following targets:"
	echo "    - uninstall - Uninstall modules and all related files"
	echo "    - viewer    - Run plasmoid in dedicated viewer"
	echo

viewer:
	plasmoidviewer -a org.kde.plasma.rust_backend_example

clean:
	rm -rf build

install:
	sudo cmake --install build

uninstall:
	sudo rm -rf /usr/share/plasma/plasmoids/org.kde.plasma.rust_backend_example
	sudo rm -rf /usr/lib/qt6/qml/org/kde/plasma/private/rust_backend_example
	sudo rm -f  /usr/share/metainfo/org.kde.plasma.rust_backend_example.appdata.xml


.PHONY:\
	help\
	viewer\
	install\
	uninstall

.SILENT:\
	help
