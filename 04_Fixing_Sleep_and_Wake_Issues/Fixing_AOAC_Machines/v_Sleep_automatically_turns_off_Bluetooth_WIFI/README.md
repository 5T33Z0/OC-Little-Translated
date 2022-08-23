# Turning off Bluetooth and WiFi during Sleep

The following Tools can be used to disable Bluetoth and WiFi uring sleep to reduce power consumption:

## **blueutil** 
CLI for bluetooth on OSX: power, discoverable state, list, inquire devices, connect, info, …

### Installation and Usage

1. Install [Homebrew](https://brew.sh/) if you haven't already
2. Enther the following commands in Terminal: 
	```
	port install blueutil
	port selfupdate
	port upgrade blueutil
	```
3. Follow the instructions on github to configure it

## SleepWatcher
Command line tool (daemon) for macOS that monitors sleep, wakeup and idleness of a Mac. It can be used to execute a Unix command when the Mac or the display of the Mac goes to sleep mode or wakes up, after a given time without user interaction or when the user resumes activity after a break or when the power supply of a Mac notebook is attached or detached. 

It also can send the Mac to sleep mode or retrieve the time since last user activity. A little bit knowledge of the Unix command line is required to benefit from this software. For Mac OS X 10.3 and 10.4, use SleepWatcher 2.0.5 (and sources). For Mac OS X 10.1 and 10.2, download SleepWatcher 1.0.1. 

This is a MAC script to turn off Bluetooth WIFI when you sleep and turn on Bluetooth WIFI when you wake up. You only need to execute this script once to turn off Bluetooth WIFI when you sleep.

### Installation and Usage
1. Install [Homebrew](https://brew.sh/) if you haven't already
2. Enter in Terminal: `brew install sleepwatcher`
3. Configure it. 

For SleepWatcher to work, you will need to write sleep and
wakeup scripts, located here when using brew services:

~/.sleep </br>
~/.wakeup

## Credits
- blueutil by [toy](https://github.com/toy/blueutil)
- Sleepwatcher by [Bernhard Baehr](https://www.bernhard-baehr.de/)