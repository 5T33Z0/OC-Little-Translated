[![macOS](https://img.shields.io/badge/Supported_macOS:-13.2+-white.svg)](https://www.apple.com/macos/ventura/)

# Enabling Metal 3 Support and "GPU" Tab in Activity Monitor

> **Disclaimer**: The framebuffer data used in this guide is for an Intel UHD 630. Don't use it to fix *your* iGPU (unless you have a Comet Lake CPU as well). Use the framebuffer data required for your iGPU instead!

**TABLE of CONTENTS**

- [About](#about)
- [1. Requirements](#1-requirements)
	- [Hardware and Software](#hardware-and-software)
	- [Required `DeviceProperties`](#required-deviceproperties)
	- [Required Software and Resources](#required-software-and-resources)
	- [A note on Big Endian and Little Endian](#a-note-on-big-endian-and-little-endian)
- [2. Test Hardware Acceleration, Metal 3 and the "GPU" tab](#2-test-hardware-acceleration-metal-3-and-the-gpu-tab)
- [3. Obtaining `AAPL,slot-name` for iGPU and dGPU](#3-obtaining-aaplslot-name-for-igpu-and-dgpu)
	- [Method 1: using Hackintool](#method-1-using-hackintool)
	- [Method 2: calculating `AAPL,slot-name` manually (for advanced users)](#method-2-calculating-aaplslot-name-manually-for-advanced-users)
- [4. Verifying and Troubleshooting](#4-verifying-and-troubleshooting)
- [5. Shortcut: Using a defaults-write command](#5-shortcut-using-a-defaults-write-command)
- [Credits and Resources](#credits-and-resources)

## About
Follow this guide to enable Metal 3 for the iGPU if your AMD GPU does not support it (Metal 3 requires Navi or newer).

If the Device Properties of your iGPU and dGPU are configured correctly, you will find the tab "GPU" in the Activity Monitor app, which lists the graphics devices and the processes assigned to each of them.

Here's a screenshot from my system, which uses a 10th Gen i9 CPU with an Intel UHD 630 (configured headless) and an RX 580 Nitro+ in macOS Ventura:

![GPUTabActMon](https://user-images.githubusercontent.com/76865553/177569534-bd40eefd-7bca-4b23-bfe0-bd47ad4bc22b.png)

## 1. Requirements

### Hardware and Software
- System with both Intel (U)HD 630 on-board graphics and a macOS-compatible dGPU
- iGPU must be enabled in BIOS
- iGPU must be configured for offline ("headless") use, using an empty framebuffer
- macOS Monterey or newer (for Metal 3)
- **SMBIOS** that utilizes the iGPU (so no **iMacPro1,1** or **MacPro**)

### Required `DeviceProperties`
Only 3 properties are required to make the "GPU" tab show up. A 4th one corrects the name of the iGPU. Add them to `DeviceProperties/Add` in your `config.plist`:

| Device | Key | Type | Value |
|--------|-----|------|-------|
| **iGPU** `PciRoot(0x0)/Pci(0x2,0x0)` | `AAPL,ig-platform-id` | Data | [**Empty framebuffer**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/iGPU/iGPU_DeviceProperties.md#empty-framebuffers-for-desktop) for your CPU (Little Endian) |
| **iGPU** `PciRoot(0x0)/Pci(0x2,0x0)` | `AAPL,slot-name` | String | `built-in` (or `internal@0,2,0`) |
| **dGPU** (PCI path varies) | `AAPL,slot-name` | String | `internal@…`, see [section 3](#3-obtaining-aaplslot-name-for-igpu-and-dgpu) |
| **iGPU** (optional) | `device-id` | Data | Correct ID for your CPU, so that the iGPU is named correctly |

In my test, it wasn't even necessary to add an `AAPL,ig-platform-id` to the iGPU properties:

![DevProps3](https://user-images.githubusercontent.com/76865553/178031340-50b48d34-6d54-424d-a972-493b9bcb4a88.png)

If your dGPU doesn't support Metal 3 (Polaris and older), also add the following key to the iGPU to enable Metal 3 on it (Intel (U)HD 630 only):

| Device | Key | Type | Value |
|--------|-----|------|-------|
| **iGPU** | `enable-metal` | Data | `01000000` |

> [!NOTE]
>
> The "GPU" tab only appears if your system has *both* an iGPU and a dedicated GPU. If it only has one or the other, use a [**defaults-write command**](#5-shortcut-using-a-defaults-write-command) to enable it instead.

### Required Software and Resources
- [**Hackintool**](https://github.com/headkaze/Hackintool) to obtain `AAPL,slot-name`
- [**ProperTree**](https://github.com/corpnewt/ProperTree) to copy keys from one .plist file to another
- [**metalgpu**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/Metal_3/metalgpu.zip?raw=true) script for checking Metal 3 support (iGPU/dGPU) in macOS Ventura
- [**VDADecoderChecker**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/Metal_3/VDADecoderChecker.zip?raw=true) for checking if hardware acceleration is working
- WhateverGreen's [**Intel HD Framebuffer Guide**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md) (optional)
- [**Big/Little Endian Converter**](https://www.save-editor.com/tools/wse_hex.html#littleendian) (online)

### A note on Big Endian and Little Endian
The byte order ("endianness") of framebuffers and device IDs differs depending on the source: WhateverGreen's Intel HD Graphics FAQ uses Big Endian, while the `config.plist` requires data to be entered in Little Endian!

**Example**: For 10th Gen Intel Core desktop CPUs, the OpenCore Install Guide recommends framebuffer `07009B3E`, while WhateverGreen's Intel HD Graphics FAQ lists `0x3E9B0007`. It's the same framebuffer, just with a different endianness.

:bulb: When taking data from WEG's Intel HD Graphics FAQ (such as `AAPL,ig-platform-id`), convert it to Little Endian before entering it in your `config.plist`. The same applies in reverse: if you want to look up a framebuffer from your config in the FAQ, convert it to Big Endian first and then use it as a search term.

## 2. Test Hardware Acceleration, Metal 3 and the "GPU" tab
1. Double-click **VDADecoderChecker** to check if hardware acceleration is working:
	- If it is working, you don't need a fix
	- If it is not, fix your framebuffer patch via `DeviceProperties` (see [section 1](#required-deviceproperties))
2. Double-click **metalgpu** to check Metal 3 support (macOS 13 only):
	- If Metal 3 is available for either iGPU or dGPU, you don't need a fix
	- If Metal 3 is not available, your dGPU doesn't support it and it isn't enabled for the iGPU either. Add `enable-metal` to the `DeviceProperties` of your iGPU (works on Intel (U)HD 630 only)
3. Open **Activity Monitor** (in `Applications/Utilities`) and check if it contains a tab called "GPU" (see "About" section):
	- If it is present, you don't need a fix
	- If it is missing, follow this guide to fix your `DeviceProperties`, or skip to [section 5](#5-shortcut-using-a-defaults-write-command)

> [!NOTE]
>
> The Metal capabilities of dGPUs are limited by the hardware. AMD GPUs of the Polaris family (RX 500 series) only support Metal 1 and 2, while GPUs of the Navi 10 (RX 5000 series) and Navi 20 (RX 6000 series) families also support Metal 3.

## 3. Obtaining `AAPL,slot-name` for iGPU and dGPU
The `AAPL,slot-name` of the dGPU depends on its PCI path, so it has to be looked up or calculated. Follow either Method 1 or 2.

### Method 1: using Hackintool
1. Start Hackintool
2. In the toolbar, click on "PCIe":</br>![PCIe01](https://user-images.githubusercontent.com/76865553/177569617-13373bc4-7d6d-4a60-baf4-a486a4621c8a.png)
3. Click the Export button at the bottom of the window:</br>![PCIe02](https://user-images.githubusercontent.com/76865553/177569699-4b7eca90-091e-43ef-9a4a-9ad04543dad2.png)
4. This creates 4 new files on your Desktop: `pcidevices.dsl`, `pcidevices.json`, `pcidevices.plist`, `pcidevices.txt`. Open `pcidevices.plist`
5. Search for the model of your dGPU (like "Radeon" or "GTX"). The PCI path of GPUs is not fixed and can differ from system to system, so searching for the model is easier than browsing by path
6. Expand the entry, find the key `AAPL,slot-name` and copy it:</br>![slotname03](https://user-images.githubusercontent.com/76865553/177570223-cd78b7e5-197d-456f-b100-deaac61d084d.png)
7. Mount your EFI and open your `config.plist`. Under `DeviceProperties/Add`, paste the key into the entry of your dGPU
8. For the iGPU, add `AAPL,slot-name` to `PciRoot(0x0)/Pci(0x2,0x0)` with the value `built-in` (or copy the `internal@0,2,0` entry from `pcidevices.plist`):</br>![slotname02](https://user-images.githubusercontent.com/76865553/177569983-9c4602a7-acd7-42e8-b791-8141f88dbee1.png)
9. Save the `config.plist` and reboot
10. Continue with [section 4](#4-verifying-and-troubleshooting)

### Method 2: calculating `AAPL,slot-name` manually (for advanced users)
Note the similarities between the PCI path and the `AAPL,slot-name`: the numbers in the PCI path after `0x` become part of the `internal@` string:</br>![slotname04](https://user-images.githubusercontent.com/76865553/177570451-d0501d80-fac1-4dae-b646-0bfbf881788c.png)

- **iGPU**: use `internal@0,2,0` or `built-in` (both work)
- **dGPU**: calculate it from its PCI path. In my case it's `Internal@0,1,0/0,0`. If the PCI path contains additional "Pci" levels, separate them with a slash as well. My GPU's path is `PciRoot(0x0)/Pci(0x1,0x0)/Pci(0x0,0x0)`. Only the slashes between the "Pci" levels count, not the one after "PciRoot"

:warning: **CAUTION**: Numbers in PCI paths are hexadecimal. Convert them to decimal (if they exceed `0x09`) before adding them to `AAPL,slot-name`. You can use Hackintool's calculator for this.

**Example**: The `AAPL,slot-name` of `PciRoot(0x0)/Pci(0x17,0x0)` is **not** `Internal@0,17,0` but `Internal@0,23,0`, because `0x17` is `23` in decimal!

## 4. Verifying and Troubleshooting
After applying the changes and rebooting, open Activity Monitor and check if the "GPU" tab is present. If it is, everything should be working. To make sure, run the **metalgpu** script in macOS 13:</br>![macOS13Metal](https://user-images.githubusercontent.com/76865553/177574170-8f5158ab-1222-433f-9937-861e62ef2342.png)

If the "GPU" tab is missing, you need a different empty framebuffer. Depending on your CPU family there may be more than one to choose from:

1. Visit WhateverGreen's [**Intel HD Graphics FAQ**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md)
2. Find the framebuffers for your CPU family. In my case, a Comet Lake CPU with [**Intel UHD 630**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#intel-uhd-graphics-610-655-coffee-lake-and-comet-lake-processors)
3. Only framebuffers with `0` connectors and `1 MB` stolen memory are applicable. In my case there are 6 possible framebuffers
4. Copy the first one. In this example: `0x3E920003`
5. Convert it from Big Endian to Little Endian using the online converter mentioned above:</br>![Convert](https://user-images.githubusercontent.com/76865553/177570832-4198ba52-7ad6-4657-a0b0-2522718f3879.png)
6. Copy the converted framebuffer (`0300923E` in this example)
7. Open your `config.plist`
8. Under `DeviceProperties/Add`, find `PciRoot(0x0)/Pci(0x2,0x0)`
9. Look for the key `AAPL,ig-platform-id` and paste the new framebuffer: `0300923E`
10. Save the config and reboot
11. If it is working, congrats. Otherwise, test the remaining framebuffers one by one until you find a working one

## 5. Shortcut: Using a defaults-write command
If all of the above doesn't work, or you just can't be bothered, enter the following command in Terminal to enable the "GPU" tab in Activity Monitor:

```
defaults write com.apple.ActivityMonitor ShowGPUTab -bool true
```

To disable it, enter:

```
defaults write com.apple.ActivityMonitor ShowGPUTab -bool false
```

> [!NOTE]
>
> You may still have to fix your `DeviceProperties` to get proper hardware acceleration and Metal 3 support in macOS Ventura.

## Credits and Resources
- FirstCustomac for his [post](https://www.insanelymac.com/forum/topic/351969-pre-release-macos-ventura/?do=findComment&comment=2788030) showing the correlation of `AAPL,slot-name` and the "GPU" tab in Activity Monitor
- ricoc90 and miliuco for the [Metal GPU Testing Utility](https://www.insanelymac.com/forum/topic/351969-pre-release-macos-ventura/?do=findComment&comment=2787954) for macOS 13
- [notjosh](https://github.com/notjosh) for the defaults-write command
- Headkaze for Hackintool
- Dortania for VDADecoderChecker
- [Test](https://www.insanelymac.com/forum/topic/352523-imac191headless-vs-imacpro11-video-encoding-performance-test): iMac19,1 (Headless) vs iMacPro1,1 Video Encoding Performance
- [Issues](https://github.com/acidanthera/bugtracker/issues/800) related to the `igfxfw=2` property
