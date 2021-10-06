## Introduction

SleepWatcher is a command line tool (daemon) for macOS that monitors sleep, wakeup and idleness of a Mac. It can be used to execute a Unix command when the Mac or the display of the Mac goes to sleep mode or wakes up, after a given time without user interaction or when the user resumes activity after a break or when the power supply of a Mac notebook is attached or detached. 

It also can send the Mac to sleep mode or retrieve the time since last user activity. A little bit knowledge of the Unix command line is required to benefit from this software. For Mac OS X 10.3 and 10.4, use SleepWatcher 2.0.5 (and sources). For Mac OS X 10.1 and 10.2, download SleepWatcher 1.0.1. 

This is a MAC script turning off Bluetooth and WIFI during sleep and turns ist back on after waking up. You only need to execute this script once to turn off Bluetooth WIFI when you sleep.

## Installation

1. If you have already installed brew and can update the software normally, open the terminal, drag install.sh into the terminal and enter to execute the installation (**recommended**)
2. If you have not installed brew or the installation failed, open the terminal, drag install-without-brew.sh into the terminal and enter to execute the installation.

## Changelog

https://www.bernhard-baehr.de/

### V1.5

 1. Fix the problem that WIFI can't be turned on after waking up  
 2. Add uninstall script uninstall.sh

### v1.4

1. fix the problem that bluetooth can't be turned off

### V1.3

1. add installation method without brew, not tested, test by yourself

### v1.2

1. modify brew installation detection (no longer automatically installed, require manual installation)
2. need to change overwrite to append, clean up junk files

### v1.1 
1. modify bluetil source