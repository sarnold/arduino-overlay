# arduino-overlay
Arduino IDE overlay for gentoo linux

Includes arduino overlay with many bundled dependancies removed:
 * dev-embedded/arduino-builder has a seperate ebuild and is built from go source
 * dev-embedded/avr-libc has been updated to 2.0.0 to work with gcc-5 (solves cannot find crtatmega328p.a link errors)
 * dev-java/jssc has been fixed (the version in portage is broken as of 2016-03-18)
 * uses system libserialport and astyle
 * platform files havee ben patched to point to system avr-g++ and friends in /usr/bin
