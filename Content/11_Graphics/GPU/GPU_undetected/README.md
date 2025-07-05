# Enabling undetected AMD GPUs

- [About](#about)
- [Instructions](#instructions)
	- [Prerequisites](#prerequisites)
	- [Method 1: automated fix, using SSDTTime](#method-1-automated-fix-using-ssdttime)
	- [Method 2: manual patching](#method-2-manual-patching)
		- [Find the PCI path of your GPU](#find-the-pci-path-of-your-gpu)
		- [Cross-reference in IO Registry](#cross-reference-in-io-registry)
	- [Adjusting `SSDT-BRG0`](#adjusting-ssdt-brg0)
- [Notes, Credits and Resources](#notes-credits-and-resources)

---

## About
If your macOS-compatible AMD GPU works fine in Windows but is not detected by macOS it's possible that your `GFX0` device is sitting behind an intermediate PCI bridge without an ACPI device name assigned to it, as in this example:

![nobrigeeee](https://user-images.githubusercontent.com/76865553/198372013-932cb76e-842d-45ac-a4eb-3c77ee060cde.png)

In this case, you cannot you need to add `SSDT-BRG0` so that Properties for the devices behind the bridge can be assigned:  

> This table provides an example of creating a missing ACPI device to ensure early DeviceProperty application. In this example a GPU device is created for a platform having an extra PCI bridge in the path - PCI0.PEG0.PEGP.BRG0.GFX0: PciRoot(0x0)/Pci(0x1,0x0)/Pci(0x0,0x0)/Pci(0x0,0x0)/Pci(0x0,0x0)- Such tables are particularly relevant for macOS 11.0 and newer.

## Instructions

### Prerequisites
* Add Lilu and WhateverGreen kexts (mandatory)
* Download [gfxutil](https://github.com/acidanthera/gfxutil/releases)
* Download [IORegistryExplorer](https://github.com/vulgo/IORegistryExplorer)
* Install [MaciASL](https://github.com/acidanthera/MaciASL)
* Install [ProperTree](https://github.com/corpnewt/ProperTree) or the plist editor of your choice (I use OCAT)

### Method 1: automated fix, using SSDTTime

Luckily the patching process can now be automated using **SSDTTime** which can generate  `SSDT-BRG0` for you by analyzing your system's `DSDT`.

**HOW TO:**

1. Download [**SSDTTime**](https://github.com/corpnewt/SSDTTime) and run it
2. Press <kbd>D</kbd>, drag in your system's DSDT and hit and hit <kbd>Enter</kbd>
3. Type <kbd>m</kbd> and press <kbd>Enter</kbd> to return to the main menu.
4. Select option <kbd>9</kbd> and hit <kbd>Enter</kbd>
5. Next, enter the PCI path of the PCI bridge device and hit <kbd>Enter</kbd>
6. The generated SSDT will be stored under `Results` inside the `SSDTTime-master` folder along with `patches_OC.plist`.
7. Copy it to `EFI/OC/ACPI`
8. Open `patches_OC.plist` and copy the included entries to the corresponding section(s) of your `config.plist`.
9. Save and Reboot.

### Method 2: manual patching

#### Find the PCI path of your GPU

- Run `gfxutil` (double-click)
- This will list all the addresses of plists it finds
- Look (or search) for `GFX0@0`. In this example it's listed in line `03:00.0 1002:73bf /PCI0@0/PEG1@1/PEGP@0/BRG0@0/GFX0@0 = PciRoot(0x0)/Pci(0x1,0x0)/Pci(0x0,0x0)/Pci(0x0,0x0)/Pci(0x0,0x0)`: </br> ![](https://github.com/TylerLyczak/Unsupported-6900XT-Hackintosh-Fix/blob/master/assets/gfxutil_pic.png?raw=true)
- Take note of the PCI path (delete the `@` and number). In this example, the GPU is pysically located at: **`PCI0/PEG1/PEGP/BRG0/GFX0`**

#### Cross-reference in IO Registry

1. Run IORegistryExplorer
2. Switch View to `IODeviceTree` (<kbd>⌘</kbd><kbd>5</kbd>)
3. Search for `GFX0`. In these cases, you will need an SSDT hotfix:
	* If the GPU has a different address than the one gfxutil provided
	* If the GPU sits behind a `pci-bridge@…` device

### Adjusting `SSDT-BRG0`
Now that you have found the correct PCI device path (here:`PCI0/PEG1/PEGP/BRG0/GFX0`) and figured out that it sits behind another PCI bridge, you can add SSDT-BRGO so macOS can use the GPU.

1. Open `SSDT-BRG0.dsl`
2. Copy the raw text into maciASL
3. Adjust the ACPI paths for `External`, `Scope` and `Device` so that they match the names/paths detected by gfxutil.
4. Export the files as `.aml` (=ACPI Machine Language)
5. Add it to `EFI/OC/ACPI` and your `config.plist`
6. Save and reboot. The card should work now.

## Notes, Credits and Resources
- Lorys89 for `SSDT-BRG0`
- CorpNewt for SSDTTime
- TylerLyczak for [his guide](https://github.com/TylerLyczak/Unsupported-6900XT-Hackintosh-Fix/blob/master/README.md)
- You may need to incorporate the `BRG0` device into other GPU-related SSDTs, such as the 
ones in the "AMD Radeon Tweaks" section.
- More in-depth explanations: https://github.com/acidanthera/bugtracker/issues/1569
