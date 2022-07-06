# How to enable "GPU" Tab in Activity Monitor
> :warning: **Disclamer**: The Framebuffer Data used in this guide is for an Intel UHD 630 – don't use them to fix your iGPU (unless you have a Comet Lake CPU as well). Follow the Guide don't just copy data from the guide and expect

## About
If the Device Properties of your iGPU and dGPU are configured correctly, you will find the Tab "GPU" in the Activity Monitor App which lists the graphics devices and the tasks/processes assigned to each of them. 

Here's an example from my Desktop which uses an 10th Gen i9 CPU with an Intel UHD 630 (configured headless( and an RX580 Nitro+:

![GPUTabActMon](https://user-images.githubusercontent.com/76865553/177569534-bd40eefd-7bca-4b23-bfe0-bd47ad4bc22b.png)

## 1. Requirements

### Hardware Requirements
- System with both Intel (U)HD on-board Graphics and a discrete GPU
- iGPU must be enabled in BIOS
- iGPU must be configured headless, using an empty Framebuffer
- GPU must be supported by macOS (obviously)

From what I understand, this Tab is only appears if your system has *both* an iGPU and a dedicated GPU. So unless your system matches these specs, you can stop here.

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
- Download [**metalgpu.zip**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/GPU_Tab/metalgpu.zip?raw=true) and upack it
- WhateverGreen's [**Intel HD Framebuffer Guide**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md)
- Big/Little Endian Converter: https://www.save-editor.com/tools/wse_hex.html#littleendian

#### A note on Big Endian and Little Endian

Keep in mind that the byte order (or "Endianness") of Framebuffers and Device-IDs may differ depending on the source of data you are using: WhateverGreen's Intel HD Graphics FAQ uses Big Endian, while the `config.plist` requires data to be entered in Little Endian!

**Example**: For 10th Gen Intel Core Desktop CPUs, the OpenCore Install Guide recommends Framebuffer `07009B3E`. But if you compare this value with Whatevergreen's Intel HD Graphics FAQ, the recommended Framebuffer is `0x3E9B0007`. It's the same framebuffer just with a different Endianness.

So when implementing data from the Intel HD Graphics FAQ into your config as `AAPL,ig-platform-id`, make sure to convert it to little Endian first using the converter listed above. The inverted principle applies when trying to find info about a framebuffer you are using in your config.plist: convert it to Big Endian and then paste it as a search term into the Intel HD Graphics FAQ to find it.

## 2. Obtaining `AAPL,slot-name` for iGPU and GPU
In order to get the "GPU" Tab to display in macOS Ventura you need to add AAPL,slot-name to the DeviceProperties of the iGPU and dGPU. Follow either Method 1 or 2 to do so:

### Method 1: using Hackintool 

1. Start Hackintool
2. In the Toolbar, click on "PCIe":</br>![PCIe01](https://user-images.githubusercontent.com/76865553/177569617-13373bc4-7d6d-4a60-baf4-a486a4621c8a.png)
3. Next, click on the Export button at the bottom of the Window:</br>![PCIe02](https://user-images.githubusercontent.com/76865553/177569699-4b7eca90-091e-43ef-9a4a-9ad04543dad2.png)
4. This will create 4 new files on your Desktop: pcidevices.dsl, pcidevices.json, pcidevices.plist, pcidevices.txt. Open `pcidevices.plist`
5. Find the Device Properties of your iGPU located under `PciRoot(0x0)/Pci(0x2,0x0)`
6. Expand the entry and find the Key `AAPL,slot-name`:</br>![slotname01](https://user-images.githubusercontent.com/76865553/177569800-af6a2502-52a7-4586-bcf7-c884156ae9d5.png)
7. Copy the key to the clipboard
8. Open yoor config.plist
9. Under `DeviceProperties/Add` find `PciRoot(0x0)/Pci(0x2,0x0)`
10. Paste the `AAPL,slot-name` as a child. The resulting entry should like like this:</br>![slotname02a](https://user-images.githubusercontent.com/76865553/177569902-844f6663-1d6a-4619-ac8a-39b59ffd1ffc.png)
11. Alternatively you can set `AAPL,slot-name` to `build-in`: </br>![slotname02](https://user-images.githubusercontent.com/76865553/177569983-9c4602a7-acd7-42e8-b791-8141f88dbee1.png)
12. In case you haven't already, also add key `enable-metal` (DATA) `01000000` to the iGPU to enable Metal 3 support in macOS Ventura.
13. Repeat the same for the GPU. In the `pcidevices.plist`, search for the GPU Model (like "Radeon" or "GTX"). Since the PCI path for GPUs is not fixed and my differ from sysetm to system it's easier to find it this way,
14. Copy the `AAPL,slot-name` key of the GPU and paste it into the Device property entry for the GPU of the config.plist:</br>![slotname03](https://user-images.githubusercontent.com/76865553/177570223-cd78b7e5-197d-456f-b100-deaac61d084d.png)
15. Save the config.plist and reboot
16. Continue in Chapter 3

### Method 2: "calculating" `AAPL,slot-name` manually (Advanced Users)
If you are attentive, you may have noticed the similaries between the numbers used in the PCI path and the ones used in `AAPL,slotname`: whatever number is contained in the PCI path after `0x` becomes part ot the "Internal@" string:</br>![slotname04](https://user-images.githubusercontent.com/76865553/177570451-d0501d80-fac1-4dae-b646-0bfbf881788c.png)

- For iGPUs `AAPL,slot-name`, use: `internal@0,2,0` or `built-in` (both work)
- For the dGPU, you have to calculate it based on it's PCI path. In my case it's `Internal@0,1,0/0,0`. You have to incorporate slashes as well if the PCI path contains additional "PCI" levels, which is the case for my GPU: `PciRoot(0x0)/Pci(0x1,0x0)/Pci(0x0,0x0)`

:warning: **CAUTION**: Keep in mind, that the numbers used in PCI paths are hexadecimal. So you have to convert them to decimal (if they exceed `0x09`) before adding them to the `AAPL,slot-name` key. You can use the calculator provided by Hackintool to convert hex to dec.

**Example**: The `AAPL,slot-name` of **PciRoot(0x0)/Pci(0x17,0x0)** is **not** Internal@0,17,0 but **Internal@0,23,0**. That's because `17` in hex is `23` in decemal!

## 3. Verifying and Troubleshooting
After applying the chnages to the config and a reboot, open Activity Monitor and check if the Tab "GPU" is present. If it is present everything should be working correctly. But just to make sure, run the metalgpu script for macOS13:</br>![macOS13Metal](https://user-images.githubusercontent.com/76865553/177574170-8f5158ab-1222-433f-9937-861e62ef2342.png)

If the GPU Tab is missing from Activity Monitor, you need a different empty framebuffer. Depending on the CPU family you are using there might be more than one framebuffer to choose from. 

1. Visit Whatevergreen's [**Intel HD Graphics FAQ**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md)
2. Find the Frambuuffers for your CPU Family, in my case I have a Comet Lake CPU with [**Intel UHD 630**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#intel-uhd-graphics-610-655-coffee-lake-and-comet-lake-processors)
3. Only Framebuffers with `0` Connectors and `1 MB` Stolen Memory are applicable. In my case there are 6 possible Framebuffers. From my tests, I already know that the one suggested by the OpenCore Install Guide (`0300C89B`) does not work for this so only 5 possible candidats remain.
4. Copy the first one into memory. In this example: `0x3E920003`
5. Convert it from Big Endian to Little Endian Converter:</br>![Convert](https://user-images.githubusercontent.com/76865553/177570832-4198ba52-7ad6-4657-a0b0-2522718f3879.png)
6. Copy the converted Framebuffer (`0300923E` in this example) to the Clipboard
7. Open your config.plist
9. Under `DeviceProperties/Add` find `PciRoot(0x0)/Pci(0x2,0x0)`
10. Look for Key `AAPL,ig-platform-id`
11. Paste the new Framebuffer: `0300923E`
12. Save the config and reboot
13. If it is working, congrats. Otherwise test the remaining Framebuffers one by ome until you find a working one

## Credits
FirstCustomac for his [post](https://www.insanelymac.com/forum/topic/351969-pre-release-macos-ventura/?do=findComment&comment=2788030) showing the depency of GPU tab in Activity Monitor and AAPL,slot-name
ricoc90 and miliuco for for macOS 13 [GPU Testing Utility](https://www.insanelymac.com/forum/topic/351969-pre-release-macos-ventura/?do=findComment&comment=2787954) 
