TODO:

* Control the installation of the IDE via a java USE flag, instead of fragmenting into arduino-[core,ide]

# arduino-overlay
Arduino IDE overlay for gentoo linux

Includes arduino overlay with many bundled dependancies removed:
 * dev-embedded/arduino-builder has a seperate ebuild and is built from go source
 * dev-embedded/avr-libc has been updated to 2.0.0 to work with gcc-5 (solves cannot find crtatmega328p.a link errors)
 * uses system libserialport and astyle
 * platform files havee ben patched to point to system avr-g++ and friends in /usr/bin
 * arduino-core is split from arduino-ide so users can use a different editor.  arduino-core does NOT require java.

The file package.keywords is included in the top level.  This is a first crack at the list of packages that should be ~arch keyworded.  Copy this file to /etc/portage/package.keywords/arduino
