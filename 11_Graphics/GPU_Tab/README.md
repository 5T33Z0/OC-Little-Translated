[![macOS](https://img.shields.io/badge/Supported_macOS:-≤13.0_beta-white.svg)](https://www.apple.com/macos/macos-ventura-preview/)
# How to enable "GPU" Tab in Activity Monitor (and Metal 3 Support in macOS Ventura)
> :warning: **Disclaimer**: The Framebuffer Data used in this guide is for an Intel UHD 630 – don't use it to fix *your* iGPU (unless you have a Comet Lake CPU as well). Use the Framebuffer data required for your iGPU instead! 
> 
> If you are using a CPU without on-board graphics and/or an SMBIOS which utilizes the GPU for Quick Sync Video and other background tasks – like **iMacPro1,1** or **MacPro7,1** – don't add an iGPU. Use the defaults-write method explained in S[](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/GPU_Tab/README.md#5-shortcut-using-a-defaults-write-command)ection 5 instead!

**TABLE of CONTENTS**

- [How to enable "GPU" Tab in Activity Monitor (and Metal 3 in macOS Ventura)](#how-to-enable-gpu-tab-in-activity-monitor-and-metal-3-in-macos-ventura)
	- [About](#about)
	- [1. Requirements](#1-requirements)
		- [Hardware Requirements](#hardware-requirements)
		- [`config.plist` Requirements](#configplist-requirements)
		- [Required Software and Resources](#required-software-and-resources)
			- [A note on Big Endian and Little Endian](#a-note-on-big-endian-and-little-endian)
	- [2. Checking if you need this fix](#2-checking-if-you-need-this-fix)
	- [3. Obtaining AAPL,slot-name for iGPU and GPU](#3-obtaining-aaplslot-name-for-igpu-and-gpu)
		- [Method 1: using Hackintool](#method-1-using-hackintool)
		- [Method 2: "calculating" `AAPL,slot-name` manually (for Advanced Users)](#method-2-calculating-aaplslot-name-manually-for-advanced-users)
		- [ADDENDUM](#addendum)
	- [4. Verifying and Troubleshooting](#4-verifying-and-troubleshooting)
	- [5. Shortcut: Using a defaults-write command](#5-shortcut-using-a-defaults-write-command)
	- [Credits and Resources](#credits-and-resources)

## About
If the Device Properties of your iGPU and dGPU are configured correctly, you will find the Tab "GPU" in the Activity Monitor App which lists the graphics devices and the tasks/processes assigned to each of them.

Here's an example from my Desktop which uses an 10th Gen i9 CPU with an Intel UHD 630 (configured headless) and a RX580 Nitro+ in macOS Ventura:

![GPUTabActMon](https://user-images.githubusercontent.com/76865553/177569534-bd40eefd-7bca-4b23-bfe0-bd47ad4bc22b.png)

You can follow this guide not only to enable the "GPU" Tab but also to figure out if your iGPU and/or GPU supports metal 3 and enable it for the iGPU if it is not supported by your GPU.

## 1. Requirements

### Hardware Requirements
- System with both Intel (U)HD on-board Graphics and a discrete GPU
- SMBIOS which utilized the iGPU &rarr; **iMacPro1,1** or **MacPro7,1** users: don't add an iGPU!
- iGPU must be enabled in BIOS
- iGPU must be configured headless, using an empty Framebuffer
- GPU must be supported by macOS (obviously)

From what I understand, the "GPU" Tab only appears if your system has *both* an iGPU and a dedicated GPU (especially on macOS Ventura). So unless your system matches these specs, skip to [Section 5](#5-shortcut-using-a-defaults-write-command) to enable the GPU Tab via a defaults-write command.

### `config.plist` Requirements
- Device Property entries for both iGPU and dGPU
- **GPU**: 
	- `AAPL,slot-name` with correct location (internal@…)
- **iGPU**:
	- `AAPL,ig-platform-id` entry with correct empty Framebuffer
	- `AAPL,slot-name` with correct location (internal@…)
	- Correct `device-id` for used CPU (may be optional)

### Required Software and Resources
- [**Hackintool**](https://github.com/headkaze/Hackintool) to obtain DeviceProperties, specifically `AAPL,slot-name`
- [**XPlist**](https://github.com/ic005k/Xplist) or PlistEditPro to copy keys from one .plist file to another
- [**metalgpu**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/GPU_Tab/metalgpu.zip?raw=true) for checking metal support of iGPU and GPU in macOS 13 (download and unzip)
- [**VDADecoderChecker**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/GPU_Tab/VDADecoderChecker.zip?raw=true) for checking Hardware Acceleration is working (download and unzip)
- WhateverGreen's [**Intel HD Framebuffer Guide**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md)
- [**Big/Little Endian Converter**](https://www.save-editor.com/tools/wse_hex.html#littleendian) (online)

#### A note on Big Endian and Little Endian

Keep in mind that the byte order (or "Endianness") of Framebuffers and Device-IDs may differ depending on the source of data you are using: WhateverGreen's Intel HD Graphics FAQ uses Big Endian, while the `config.plist` requires data to be entered in Little Endian!

**Example**: For 10th Gen Intel Core Desktop CPUs, the OpenCore Install Guide recommends Framebuffer `07009B3E`. But if you compare this value with Whatevergreen's Intel HD Graphics FAQ, the recommended Framebuffer is `0x3E9B0007`. It's the same framebuffer just with a different Endianness.

So when implementing data from the Intel HD Graphics FAQ into your config, such as `AAPL,ig-platform-id`, make sure to convert it to little Endian first using the converter listed above. The inverted principle applies when trying to find info about a framebuffer you are using in your config.plist: convert it to Big Endian and then paste it as a search term into the Intel HD Graphics FAQ to find it.

## 2. Checking if you need this fix
1. Checking if "GPU" Tab is present in Activity Monitor
	- Run Activity Monitor (located under Programs/Utilities)
	- Check if it contains a Tab called "GPU" (as shown in the "About" section)
	- If it is present, you don't have to fix it
	- If it is not present you can follow the guide to fix your DeviceProperties or skip straight to section 5 to use a defaults-write command to enable the GPU Tab instead.
2. Checking Hardware Acceleration and Metal Support
	- Double-click **VDADecoderChecker** &rarr; if Hardware Acceleration is not working, follow the Guide to fix your Framebuffer patch via `DeviceProperties`
	- macOS 13 only: double-click **metalgpu** to check metal support of iGPU and GPU &rarr; if the iGPU is not listed in the test results, Metal 3 is not working. Follow the guide to add `enable-metal` to the `DeviceProperties` of your iGPU.

**NOTE**: The Metal capabilities of GPUs are limited by the used hardware. GPUs of the Polaris family (RX 500 series) only support Metal 1 and 2, while GPUs of the Navi 10 (RX 5000 series) and Navi 20 (RX 6000 series) family also support Metal 3.

## 3. Obtaining AAPL,slot-name for iGPU and GPU
In order to get the "GPU" Tab to display in macOS Ventura you need to add AAPL,slot-name to the DeviceProperties of the iGPU and dGPU. Follow either Method 1 or 2 to do so:

### Method 1: using Hackintool 

1. Start Hackintool
2. In the Toolbar, click on "PCIe":</br>![PCIe01](https://user-images.githubusercontent.com/76865553/177569617-13373bc4-7d6d-4a60-baf4-a486a4621c8a.png)
3. Next, click on the Export button at the bottom of the Window:</br>![PCIe02](https://user-images.githubusercontent.com/76865553/177569699-4b7eca90-091e-43ef-9a4a-9ad04543dad2.png)
4. This will create 4 new files on your Desktop: pcidevices.dsl, pcidevices.json, pcidevices.plist, pcidevices.txt. Open `pcidevices.plist`
5. Find the Device Properties of your iGPU located under `PciRoot(0x0)/Pci(0x2,0x0)`
6. Expand the entry and find the Key `AAPL,slot-name`:</br>![slotname01](https://user-images.githubusercontent.com/76865553/177569800-af6a2502-52a7-4586-bcf7-c884156ae9d5.png)
7. Copy the key to the clipboard
8. Mount your EFI and open your config.plist
9. Under `DeviceProperties/Add` find `PciRoot(0x0)/Pci(0x2,0x0)`
10. Paste the `AAPL,slot-name` as a child. The resulting entry should like like this:</br>![slotname02a](https://user-images.githubusercontent.com/76865553/177569902-844f6663-1d6a-4619-ac8a-39b59ffd1ffc.png)
11. Alternatively you can set `AAPL,slot-name` to `built-in`: </br>![slotname02](https://user-images.githubusercontent.com/76865553/177569983-9c4602a7-acd7-42e8-b791-8141f88dbee1.png)
12. In case you haven't already, also add key `enable-metal` (DATA) `01000000` to the iGPU to enable Metal 3 support in macOS Ventura.
13. Repeat the same for the GPU. In the `pcidevices.plist`, search for the GPU Model (like "Radeon" or "GTX"). Since the PCI path for GPUs is not fixed and my differ from system to system it's easier to find it this way,
14. Copy the `AAPL,slot-name` key for the GPU and paste it into the corresponding section of your config.plist:</br>![slotname03](https://user-images.githubusercontent.com/76865553/177570223-cd78b7e5-197d-456f-b100-deaac61d084d.png)
15. Save the config.plist and reboot
16. Continue in Chapter 4

### Method 2: "calculating" `AAPL,slot-name` manually (for Advanced Users)
You may have noticed the similarities between the numbers used in the PCI path and the ones used in `AAPL,slot-name`: whatever number is contained in the PCI path after `0x` becomes part ot the "Internal@" string:</br>![slotname04](https://user-images.githubusercontent.com/76865553/177570451-d0501d80-fac1-4dae-b646-0bfbf881788c.png)

- For iGPUs `AAPL,slot-name`, use: `internal@0,2,0` or `built-in` (both work)
- For the dGPU, you have to calculate it based on its PCI path. In my case it's `Internal@0,1,0/0,0`. You have to incorporate slashes as well if the PCI path contains additional "PCI" levels, which is the case for my GPU: `PciRoot(0x0)/Pci(0x1,0x0)/Pci(0x0,0x0)`. Only the slashes separating "Pci" are relevant for this, not the "PciRoot" part.

:warning: **CAUTION**: Keep in mind that the numbers used in PCI paths are hexadecimal. So you have to convert them to decimal (if they exceed `0x09`) before adding them to the `AAPL,slot-name` key. You can use the Hackintool's calculator to convert from hex to dec.

**Example**: The `AAPL,slot-name` of **PciRoot(0x0)/Pci(0x17,0x0)** is **not** Internal@0,17,0 but **Internal@0,23,0**. That's because `17` in hex is `23` in decimal!

### ADDENDUM 
After further research and testing, it turns out that the number of properties can be reduced to 3 to get it working, respectively 4 (device-id) to get the name of the iPGU correct as well:</br>![DevProps3](https://user-images.githubusercontent.com/76865553/178031340-50b48d34-6d54-424d-a972-493b9bcb4a88.png)

## 4. Verifying and Troubleshooting
After applying the changes to the config and a reboot, open Activity Monitor and check if the Tab "GPU" is present. If it is present everything should be working correctly. But just to make sure, run the "metalgpu" script for macOS13:</br>![macOS13Metal](https://user-images.githubusercontent.com/76865553/177574170-8f5158ab-1222-433f-9937-861e62ef2342.png)

If the GPU Tab is missing from Activity Monitor, you need a different empty framebuffer. Depending on the CPU family you are using there might be more than one framebuffer to choose from. 

1. Visit Whatevergreen's [**Intel HD Graphics FAQ**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md)
2. Find the Framebuffers for your CPU Family, in my case I have a Comet Lake CPU with [**Intel UHD 630**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#intel-uhd-graphics-610-655-coffee-lake-and-comet-lake-processors)
3. Only Framebuffers with `0` Connectors and `1 MB` Stolen Memory are applicable. In my case there are 6 possible Framebuffers.
4. Copy the first one into memory. In this example: `0x3E920003`
5. Convert it from Big Endian to Little Endian using the online converter mentioned earlier:</br>![Convert](https://user-images.githubusercontent.com/76865553/177570832-4198ba52-7ad6-4657-a0b0-2522718f3879.png)
6. Copy the converted Framebuffer to the Clipboard (`0300923E` in this example) 
7. Open your config.plist
9. Under `DeviceProperties/Add` find `PciRoot(0x0)/Pci(0x2,0x0)`
10. Look for Key `AAPL,ig-platform-id`
11. Paste the new Framebuffer: `0300923E`
12. Save the config and reboot
13. If it is working, congrats. Otherwise test the remaining Framebuffers one by ome until you find a working one.

## 5. Shortcut: Using a defaults-write command
If all of above doesn't work, or you just can't be bothered, enter the following defaults-write command in Terminal to enable the "GPU" Tab in Activity Monitor: 

`defaults write com.apple.ActivityMonitor ShowGPUTab -bool true`

To disable it, enter

`defaults write com.apple.ActivityMonitor ShowGPUTab -bool false`

**NOTE**: You still may have to fix your DeviceProperties to get proper Hardware Acceleration and Metal 3 support in macOS Ventura, though.

## Credits and Resources
- FirstCustomac for his [post](https://www.insanelymac.com/forum/topic/351969-pre-release-macos-ventura/?do=findComment&comment=2788030) showing the correlation of `AAPL,slot-name` and the "GPU" Tab in Activity Monitor
- ricoc90 and miliuco for the [Metal GPU Testing Utility](https://www.insanelymac.com/forum/topic/351969-pre-release-macos-ventura/?do=findComment&comment=2787954) for macOS 13
- [notjosh](https://github.com/notjosh) for the defaults-write command
- Headkaze for Hackintool
- Dortania for VDADecoderChecker
- About [Apple GUC](https://www.reddit.com/r/hackintosh/comments/gbg5ms/oopencores_igfxfw_and_apples_guc/)
- [Test](https://www.insanelymac.com/forum/topic/352523-imac191headless-vs-imacpro11-video-encoding-performance-test): iMac19,1 (Headless) vs iMacPro1,1 Video Encoding Performance
- [Issues](https://github.com/acidanthera/bugtracker/issues/800) related to the `igfxfw=2` property 
