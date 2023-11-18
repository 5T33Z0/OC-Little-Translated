# Installing Intel PCM on macOS
![macOS](https://img.shields.io/badge/Requirements:-macOS_12+-default.svg)

## About
In October 2023, Intel discontinued [Intel Power Gadget](https://www.intel.com/content/www/us/en/developer/articles/tool/power-gadget.html). A simple but super useful tool which allowed monitoring the CPU's behavior in a really elegant manner. It displayed all the relevant data inside a neatly desgined GUI (on macOS at least).

But the app is no longer comapatible with macOS and newer Intel CPUs (11th Gen+). In macOS 14.2 beta 3, Intel Power Gadget causes the CPU to freak out and run at 100% on all cores. So it's highly recommended to uninstal it via the included uninstaller, so the `EnergyDriver.kext` it uses is uninstalled as well. 

So as a replacement, Intel introduced the Performance Counter Monitor (or: [PCM](https://github.com/intel/pcm)). This "glorious" new tool has no macOS app that you can simply download, install and run. Instead, you have to jump through hoops to get it working. And on top of that: it runs in Terminal and doesn't really help you much with monitoring CPU frequencies since everything mostly consists of charts with stats – no graphs.

Anyway, below you will find the instructions, to download, compile, install and run Intel PCM.

## 1. Prerequisites

1. Install **Homebrew** via Terminal: 

	```
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	```

2. Next, install **Cmake**: 
	
	```
	brew install cmake
	```

Once that's done, you can build and install Intel PCM Tools.

## 2. Building PCM Tools

1. Clone PCM repository with submodules:

	```
	git clone --recursive https://github.com/opcm/pcm.git
	```
	**NOTE**: The `pcm` folder will be created in your User's HOME folder 

2. Navigate to the `pcm` folder:

	```
	cd ~/pcm
	```

3. Next, Build the PCM binaries (this can take a few minutes):

	```
	mkdir build
	cd build
	cmake ..
	cmake --build .
	```

3. Next, enter:
	
	```
	sudo make install
	```
	
	This will install the the required `PcmMsrDriver.kext` under `~/Library/Extensions`.
	
	**NOTE**: macOS will notify you about a new extension beeing added. You have to allow "Unidentified PcmMsrDriver" in System Settings (under Gatekeeper).
	
4. Reboot

## 3. Running PCM Tools
In Terminal, enter:

```
sudo ~/pcm/build/bin/pcm -r
```

After entering your password, PCM will start and a bunch of stats and tables will appear.

## Credits
Thanks to Dreamwhite and jozews321 for their help.
