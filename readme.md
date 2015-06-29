# VST Template

This repo shows how to create and compile a VST effect from source code, rather than relying on an IDE. Compliation is simplified by use of a `Makefile` with only a few variables. Note that the name of the plugin must also be the name of your source code files (e.g. `PLUGIN_NAME = MyAwesomeGainPlugin` requires that `src/MyAwesomeGainPlugin.h` and `src/MyAwesomeGainPlugin.cpp` be the main plugin). This repo was created more as a coding exercise, but may be expanded on to simplify usage and quickly set up code for creating VST effect plugins, and possibly VST instruments.

There is no GUI support, nor has this been significantly tested. Currently, this only works on Mac OS X.