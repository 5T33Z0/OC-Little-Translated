# Installing Intel PCM on macOS
![macOS](https://img.shields.io/badge/Requirements:-macOS_12+-default.svg)

## About
In October 2023, Intel discontinued [**Intel Power Gadget**](https://www.intel.com/content/www/us/en/developer/articles/tool/power-gadget.html) (but you can still get it from [**insanelymac**](https://www.insanelymac.com/forum/files/file/1056-intel-power-gadget](https://www.insanelymac.com/forum/files/file/1056-intel-power-gadget))). A simple but super useful tool which allows monitoring the CPU's behavior in a really elegant manner. It displayed all the relevant data inside a neatly desgined GUI (on macOS at least).

But the app is no longer comapatible with newer Intel CPUs (11th Gen+). In macOS 14.2 beta 3, Intel Power Gadget causes the CPU to freak out and run at 100% on all cores. Luckily, this issues was resolved by the 14.2 beta 4 update, so you can use it again. 

As a replacement, Intel introduced the **Performance Counter Monitor** (or: [**PCM**](https://github.com/intel/pcm)). This "glorious" new tool has no macOS app that you can simply download, install and run. Instead, you have to jump through hoops to get it working. And on top of that: it runs in Terminal and doesn't really help you much with monitoring CPU frequencies since everything mostly consists of charts with stats – no graphs.

Anyway, below you will find instructions to download, compile, install and run Intel PCM.

## 1. Prerequisites

1. Uninstall **Intel Power Gadget** (if present):
	- Run `Uninstaller.pkg` (located under `Application/Intel Power Gadget`)
	- This will uninstall the .app as well as the `EnergyDriver.kext`
	- Maybe you also have to log-off to unload the kext.

2. Install **Homebrew** via Terminal: 

	```
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	```

3. Next, install **Cmake**: 
	
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
cd ~/pcm
sudo ~/pcm/build/bin/pcm -r
```

After entering your password, PCM will start and a bunch of stats and tables will appear.

## Uninstalling
To uninstall Intel PCM, do the following: 

1. Delete the `PcmMsrDriver.kext` from `/Library/Extensions`

2. Enter in Terminal (and confirm with your Admin password):

	```
	sudo ~/pcm/build/bin/pcm --uninstallDriver
	```
3.  Next, clean up manually:
	
	```
	rm /usr/local/sbin/*
	```
	Enter "y" to delete the following entries (one by one):
	
	```
	override rwxr-xr-x root/admin for /usr/local/sbin/pcm? y
	override rwxr-xr-x root/admin for /usr/local/sbin/pcm-accel? y
	override rwxr-xr-x root/admin for /usr/local/sbin/pcm-bw-histogram? y
	override rwxr-xr-x root/admin for /usr/local/sbin/pcm-core? y
	override rwxr-xr-x root/admin for /usr/local/sbin/pcm-iio? y
	override rwxr-xr-x root/admin for /usr/local/sbin/pcm-latency? y
	override rwxr-xr-x root/admin for /usr/local/sbin/pcm-lspci? y
	override rwxr-xr-x root/admin for /usr/local/sbin/pcm-memory? y
	override rwxr-xr-x root/admin for /usr/local/sbin/pcm-mmio? y
	override rwxr-xr-x root/admin for /usr/local/sbin/pcm-msr? y
	override rwxr-xr-x root/admin for /usr/local/sbin/pcm-numa? y
	override rwxr-xr-x root/admin for /usr/local/sbin/pcm-pcicfg? y
	override rwxr-xr-x root/admin for /usr/local/sbin/pcm-pcie? y
	override rwxr-xr-x root/admin for /usr/local/sbin/pcm-power? y
	override rwxr-xr-x root/admin for /usr/local/sbin/pcm-raw? y
	override rwxr-xr-x root/admin for /usr/local/sbin/pcm-sensor? y
	override rwxr-xr-x root/admin for /usr/local/sbin/pcm-tpmi? y
	override rwxr-xr-x root/admin for /usr/local/sbin/pcm-tsx? y
 	```	
4. Remove the dynamic link library of the PcmMsrDriver:
	
	```
	sudo rm /usr/local/lib/libPcmMsr.dylib
	```
5. Finally, delete the `pcm` folder home folder. 

## Thank Yous
- Thanks to Dreamwhite and jozews321 for their help
- Thanks to User232 for the Uninstall Instructions
