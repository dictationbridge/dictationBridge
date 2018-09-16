# DictationBridge

Welcome to DictationBridge, a collection of screen reader extensions designed to interface with various dictation products.

This repository contains the DictationBridge Core, along with data needed to build JAWS scripts and/or NVDA add-on.

Note: support for Dragon NaturallySpeaking is still under heavy development.

## DictationBridge Core

This is the screen-reader-independent core of DictationBridge. Its primary purpose is to detect text input via Windows Speech Recognition and Dragon NaturallySpeaking, so the screen-reader-specific add-on can echo back that text.

### Building

To build the core, you need Python 2.7, a recent version of SCons, and Visual Studio 2015.

First, fetch Git submodules with this command:

    git submodule update --init --recursive

Then simply run SCons.

## DictationBridge NVDA add-on

This is the NVDA add-on package for DictationBridge. It depends on the screen-reader-independent core described above.

### Building

To build the add-on, you need Python 2.7, a recent version of SCons, and Visual Studio 2015.

First, fetch Git submodules with this command:

    git submodule update --init --recursive

Then simply run SCons.

## dictationbridge-jfw

This is the Jaws scripts package for DictationBridge. It depends on the screen-reader-independent core described above.

### Building

To build this package, you need Python 2.7, a recent version of SCons, [NSIS](http://nsis.sourceforge.net/Main_Page), and Visual Studio 2015 or 2017. If using Visual Studio 2017, be sure to install MFC/ATL tools.

First, fetch Git submodules with this command:

    git submodule update --init --recursive

Then run:

```
scons
makensis installer.nsi
```

This will produce an installer as `DictationBridge.exe`.

## Copyright and license

Copyright 2016 3 Mouse Technology, LLC. Based on code licensed from Serotek Corporation. This software is provided under the Mozilla Public License, version 2.0.
