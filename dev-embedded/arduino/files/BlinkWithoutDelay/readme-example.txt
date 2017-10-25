Sample updated makefile for building arduino firmware via commane line.

* corrected model parsing for mega, defaults to atmega2560
  (note mega1280 needs to be set as MCU=atmega1280 for now)

* make default is uno if not specified, otherwise "make MODEL=foo"
  "make list" to see a list of supported models

* paths are set to current arduino IDE hardware path for avr, 
  adjust the ARDUINO_DIR path as needed

* note internal paths are set in multiple places and only support avr
  currently

* also note this Makefile demo needs write permissions to the arduino
  hardware tree for object files; either set group write permissions
  or copy /usr/share/arduino to somewhere you have write perms

