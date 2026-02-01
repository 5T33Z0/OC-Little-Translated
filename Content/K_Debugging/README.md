# Using OpenCore's `SysReport` feature for debugging

## Overview

OpenCore’s `SysReport` feature is a powerful tool for Hackintosh users and developers. It allows you to generate detailed system dumps—including ACPI tables, Audio CODECs, CPU details, SMBIOS data, and PCI device information – directly from your EFI partition. These dumps are invaluable for troubleshooting boot issues, debugging hardware compatibility, and configuring macOS correctly on non-Apple hardware.

When enabled, `SysReport` stores these files in a `SysReport` folder inside the EFI partition:

![SysReport](https://user-images.githubusercontent.com/76865553/168154869-30725020-0247-4e9f-95fc-e27d733b9ef6.png)

The primary goal of `SysReport` is to provide a complete snapshot of your system’s hardware and firmware environment. This snapshot allows you to:

1. **Identify missing ACPI patches and SSDTs** required to make macOS recognize all devices.
2. **Verify CPU detection and configuration** (e.g., cores, threads, speedstaps, AppleProcessorType).
3. **Inspect PCI devices** for proper device IDs, paths, and potential conflicts.
4. **Examine audio hardware** to create AppleALC Layout-IDs or troubleshoot sound issues.
5. **Provide developers with SMBIOS and firmware data** for debugging and testing.

Essentially, `SysReport` removes the guesswork by giving you a detailed hardware profile without relying on macOS to boot fully.

## Preparation and dumping process
To generate a `SysReport`, you **must** use the Debug version of OpenCore and have the `SysReport` feature enabled in the `config.plist`. Typically, this also requires an existing working configuration. However, the Utopia-Team provides a pre-built [**OpenCore Debug EFI**](https://github.com/utopia-team/opencore-debug/releases) that can create a `SysReport` *without* a working config.

**Steps**:

1. Download and extract the Debug EFI.zip.
2. Copy the EFI folder to a FAT32-formatted USB flash drive.
3. Boot your system from the flash drive.
4. The dumping process starts automatically:<br>![Dumping Process](https://user-images.githubusercontent.com/46293832/168248420-128f8d51-30fd-49b6-87e1-7ef95e92abf7.jpg)
5. After reaching the OpenCore boot picker, remove the flash drive and reboot. The system dumps are stored on the USB drive.

## Understanding the dumped files

### ACPI

The ACPI folder contains all firmware tables (DSDT, SSDTs, etc.) that macOS reads. By analyzing these:

* You can identify missing devices or features that need custom [**SSDTs**](/Content/01_Adding_missing_Devices_and_enabling_Features#readme).
* Debug ACPI errors and verify patch effectiveness.

**More:** [ACPI Debugging](/Content/00_ACPI/ACPI_Debugging)

> [!TIP]
> 
>  Clover can dump ACPI tables from the GUI, making it easier for some users.

### Audio

With `AudioDxe.efi` driver enabled, OpenCore dumps the system’s Audio CODEC. While OpenCore and Clover dumps are helpful for basic troubleshooting, they do not provide detailed node-level schematics needed for AppleALC Layout-ID creation which are a priceless asset when [creating Layout-IDs for AppleALC](/Content//L_ALC_Layout-ID) since they show all the Nodes, Connectors and Routings, etc:

![codec_dump txt](https://user-images.githubusercontent.com/76865553/168449513-290186d6-3ada-4689-a438-eb268ffb18ad.svg)

Therefore, you need to create the CODEC dump in Linux.

To create a complete CODEC dump:

1. Boot a Linux ISO (e.g., Ubuntu) via a USB prepared with [Ventoy](https://www.ventoy.net/en/download.html).
2. In Linux, open Terminal and run:
	```bash
	cd ~/Desktop && mkdir CodecDump && for c in /proc/asound/card*/codec#*; do f="${c/\/*card/card}"; cat "$c" > CodecDump/${f//\//-}.txt; done && zip -r CodecDump.zip CodecDump
	```
3. Transfer `CodecDump.zip` to macOS and rename `card0-codec#0.txt` to `codec_dump.txt`. 

This dump is crucial for developers or advanced users creating custom audio layouts.

#### Dumping the Audio CODEC
1. Once Linux is up and running, open Terminal and enter: `cd ~/Desktop && mkdir CodecDump && for c in /proc/asound/card*/codec#*; do f="${c/\/*card/card}"; cat "$c" > CodecDump/${f//\//-}.txt; done && zip -r CodecDump.zip CodecDump`
2. Store the generated `CodecDump.zip` on a medium (HDD, other USB stick, E-Mail, Cloud) which you can access later from within macOS. You cannot store it on the Ventoy USB stick itself unfortunately, since it's formatted in ExFat which can't be accessed by Linux without additional measures.
3. Reboot into macOS
4. Extract `CodecDump.zip` to the Desktop
5. Rename `card0-codec#0.txt` located in the "CodecDump" folder to `codec_dump.txt`

### CPU

`CPUInfo.txt` contains:

* CPU name, frequency, cores, threads
* Speedstep/Power management info
* AppleProcessorType (useful for detection issues)

This allows precise CPU configuration and troubleshooting.

### PCI
`PCIInfo.txt` lists all PCI devices, including those not detected by macOS or Hackintool. Using [PCILookup](https://github.com/utopia-team/PCILookup), you can convert raw PCI info into a readable format with device names, IDs, and paths.

**The example below is from my Lenovo T530 Laptop**:

<details> <summary><strong>Hackintool lists 16 devices:</strong> (click to reveal)</summary> ![Hackintool](https://user-images.githubusercontent.com/76865553/168154904-febf908f-f0b1-41e0-94eb-cb13585c5bc9.png) </details>

<details><summary><strong>While PCIInfo contains 18:</strong> (click to reveal)</summary>

```txt
1. Vendor ID: 0x8086, Device ID: 0x1E26, RevisionID: 0x04, ClassCode: 0x0C0320, SubsystemVendorID: 0x17AA, SubsystemID: 0x21F6,
   DevicePath: PciRoot(0x0)/Pci(0x1D,0x0)
2. Vendor ID: 0x8086, Device ID: 0x1E2D, RevisionID: 0x04, ClassCode: 0x0C0320, SubsystemVendorID: 0x17AA, SubsystemID: 0x21F6,
   DevicePath: PciRoot(0x0)/Pci(0x1A,0x0)
3. Vendor ID: 0x8086, Device ID: 0x1E31, RevisionID: 0x04, ClassCode: 0x0C0330, SubsystemVendorID: 0x17AA, SubsystemID: 0x21F6,
   DevicePath: PciRoot(0x0)/Pci(0x14,0x0)
4. Vendor ID: 0x8086, Device ID: 0x1E10, RevisionID: 0xC4, ClassCode: 0x060400,
   DevicePath: PciRoot(0x0)/Pci(0x1C,0x0)
5. Vendor ID: 0x1180, Device ID: 0xE823, RevisionID: 0x04, ClassCode: 0x088001, SubsystemVendorID: 0x17AA, SubsystemID: 0x21F6,
   DevicePath: PciRoot(0x0)/Pci(0x1C,0x0)/Pci(0x0,0x0)
6. Vendor ID: 0x8086, Device ID: 0x0166, RevisionID: 0x09, ClassCode: 0x030000, SubsystemVendorID: 0x17AA, SubsystemID: 0x21F6,
   DevicePath: PciRoot(0x0)/Pci(0x2,0x0)
7. Vendor ID: 0x8086, Device ID: 0x1E55, RevisionID: 0x04, ClassCode: 0x060100, SubsystemVendorID: 0x17AA, SubsystemID: 0x21F6,
   DevicePath: PciRoot(0x0)/Pci(0x1F,0x0)
8. Vendor ID: 0x8086, Device ID: 0x1E12, RevisionID: 0xC4, ClassCode: 0x060400,
   DevicePath: PciRoot(0x0)/Pci(0x1C,0x1)
9. Vendor ID: 0x8086, Device ID: 0x1E03, RevisionID: 0x04, ClassCode: 0x010601, SubsystemVendorID: 0x17AA, SubsystemID: 0x21F6,
   DevicePath: PciRoot(0x0)/Pci(0x1F,0x2)
10. Vendor ID: 0x8086, Device ID: 0x0154, RevisionID: 0x09, ClassCode: 0x060000, SubsystemVendorID: 0x17AA, SubsystemID: 0x21F6,
   DevicePath: PciRoot(0x0)/Pci(0x0,0x0)
11. Vendor ID: 0x8086, Device ID: 0x1E3A, RevisionID: 0x04, ClassCode: 0x078000, SubsystemVendorID: 0x17AA, SubsystemID: 0x21F6,
   DevicePath: PciRoot(0x0)/Pci(0x16,0x0)
12. Vendor ID: 0xFFFF, Device ID: 0xFFFF, RevisionID: 0xFF, ClassCode: 0xFFFFFF, SubsystemVendorID: 0xFFFF, SubsystemID: 0xFFFF,
   DevicePath: PciRoot(0x0)/Pci(0x16,0x1)
13. Vendor ID: 0x8086, Device ID: 0x1E3D, RevisionID: 0x04, ClassCode: 0x070002, SubsystemVendorID: 0x17AA, SubsystemID: 0x21F6,
   DevicePath: PciRoot(0x0)/Pci(0x16,0x3)
14. Vendor ID: 0x8086, Device ID: 0x1502, RevisionID: 0x04, ClassCode: 0x020000, SubsystemVendorID: 0x17AA, SubsystemID: 0x21F3,
   DevicePath: PciRoot(0x0)/Pci(0x19,0x0)
15. Vendor ID: 0x8086, Device ID: 0x1E20, RevisionID: 0x04, ClassCode: 0x040300, SubsystemVendorID: 0x17AA, SubsystemID: 0x21F6,
   DevicePath: PciRoot(0x0)/Pci(0x1B,0x0)
16. Vendor ID: 0x14E4, Device ID: 0x43B1, RevisionID: 0x03, ClassCode: 0x028000, SubsystemVendorID: 0x1028, SubsystemID: 0x0017,
   DevicePath: PciRoot(0x0)/Pci(0x1C,0x1)/Pci(0x0,0x0)
17. Vendor ID: 0x8086, Device ID: 0x1E22, RevisionID: 0x04, ClassCode: 0x0C0500, SubsystemVendorID: 0x17AA, SubsystemID: 0x21F6,
   DevicePath: PciRoot(0x0)/Pci(0x1F,0x3)
18. Vendor ID: 0xFFFF, Device ID: 0xFFFF, RevisionID: 0xFF, ClassCode: 0xFFFFFF, SubsystemVendorID: 0xFFFF, SubsystemID: 0xFFFF,
   DevicePath: PciRoot(0x0)/Pci(0x1F,0x6)
```
</details>

With the python script [**PCILookup**](https://github.com/utopia-team/PCILookup), we can convert the PCIInfo.txt into a more legible form:

- Install Python
- Download and unpack the Script
- Run Terminal
- Type `cd`, hit space
- Drop the "PCILookup-master" folder in the terminal window and hit <kbd>Enter</kbd> 
- Next, type `python3 main.py` and hit <kbd>Spacebar</kbd>
- Drag in the `PCIInfo.txt` and hit <kbd>Enter</kbd>

<details>
<summary><strong>The resulting output is much easier to read and also includes device names:</strong></summary>

```txt
1: 7 Series/C216 Chipset Family USB Enhanced Host Controller #1
	Vendor ID: 8086
	Device ID: 1e26
	Device Path: PciRoot(0x0)/Pci(0x1D,0x0)
2: 7 Series/C216 Chipset Family USB Enhanced Host Controller #2
	Vendor ID: 8086
	Device ID: 1e2d
	Device Path: PciRoot(0x0)/Pci(0x1A,0x0)
3: 7 Series/C210 Series Chipset Family USB xHCI Host Controller
	Vendor ID: 8086
	Device ID: 1e31
	Device Path: PciRoot(0x0)/Pci(0x14,0x0)
4: 7 Series/C216 Chipset Family PCI Express Root Port 1
	Vendor ID: 8086
	Device ID: 1e10
	Device Path: PciRoot(0x0)/Pci(0x1C,0x0)
5: PCIe SDXC/MMC Host Controller
	Vendor ID: 1180
	Device ID: e823
	Device Path: PciRoot(0x0)/Pci(0x1C,0x0)/Pci(0x0,0x0)
6: 3rd Gen Core processor Graphics Controller
	Vendor ID: 8086
	Device ID: 0166
	Device Path: PciRoot(0x0)/Pci(0x2,0x0)
7: QM77 Express Chipset LPC Controller
	Vendor ID: 8086
	Device ID: 1e55
	Device Path: PciRoot(0x0)/Pci(0x1F,0x0)
8: 7 Series/C210 Series Chipset Family PCI Express Root Port 2
	Vendor ID: 8086
	Device ID: 1e12
	Device Path: PciRoot(0x0)/Pci(0x1C,0x1)
9: 7 Series Chipset Family 6-port SATA Controller [AHCI mode]
	Vendor ID: 8086
	Device ID: 1e03
	Device Path: PciRoot(0x0)/Pci(0x1F,0x2)
10: 3rd Gen Core processor DRAM Controller
	Vendor ID: 8086
	Device ID: 0154
	Device Path: PciRoot(0x0)/Pci(0x0,0x0)
11: 7 Series/C216 Chipset Family MEI Controller #1
	Vendor ID: 8086
	Device ID: 1e3a
	Device Path: PciRoot(0x0)/Pci(0x16,0x0)
12: No data available
	Vendor ID: ffff
	Device ID: ffff
	Device Path: PciRoot(0x0)/Pci(0x16,0x1)
13: 7 Series/C210 Series Chipset Family KT Controller
	Vendor ID: 8086
	Device ID: 1e3d
	Device Path: PciRoot(0x0)/Pci(0x16,0x3)
14: 82579LM Gigabit Network Connection (Lewisville)
	Vendor ID: 8086
	Device ID: 1502
	Device Path: PciRoot(0x0)/Pci(0x19,0x0)
15: 7 Series/C216 Chipset Family High Definition Audio Controller
	Vendor ID: 8086
	Device ID: 1e20
	Device Path: PciRoot(0x0)/Pci(0x1B,0x0)
16: BCM4352 802.11ac Wireless Network Adapter
	Vendor ID: 14e4
	Device ID: 43b1
	Device Path: PciRoot(0x0)/Pci(0x1C,0x1)/Pci(0x0,0x0)
17: 7 Series/C216 Chipset Family SMBus Controller
	Vendor ID: 8086
	Device ID: 1e22
	Device Path: PciRoot(0x0)/Pci(0x1F,0x3)
18: No data available
	Vendor ID: ffff
	Device ID: ffff
	Device Path: PciRoot(0x0)/Pci(0x1F,0x6)
```
</details>

As you can see, devices 12 and 18 don't have a known/valid Vendor ID (`ffff`). That's the reason why they're not listed by Hackintool. So as far analyzing PCI is concerned you are better off using Hackintool, if the system is already up and running.

>[!NOTE]
>
> Device-IDs of PCIInfo and Hackintool will differ whether you spoof Device-IDs via DeviceProperties or ACPI, to make a component work in macOS (iGPUs, dGPUS, SATA Controller or LAN Adapters come to mind).
 
### SMBIOS

This folder contains `.bin` files representing system firmware and SMBIOS data. Developers can use this for testing configurations or emulating hardware.

## Summary

OpenCore’s `SysReport` is an essential tool for:

* Debugging ACPI and device issues
* Troubleshooting audio and CPU problems
* Inspecting PCI devices and hardware compatibility
* Providing detailed system info for developers

By generating these dumps, you gain a clear, hardware-level picture of your Hackintosh, allowing precise fixes without relying on trial and error.

## Credits
- dreamwhite for PCILookup
- utopia-team for OpenCore Debug EFI
