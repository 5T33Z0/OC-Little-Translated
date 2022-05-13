# Debugging
This chapter covers the OpenCore's `SysReport` feature which can be used to gather useful information about the system.

## Using OpenCore's `SysReport` feature
When using the "Debug" version of OpenCore using this [generic prebuilt EFI](https://github.com/utopia-team/opencore-debug) which already has all the required files (such as `OpenCore.efi` and `OpenRuntime.efi` and `Misc/Debug/SysReport` enabled) it is possible to generate dumps of ACPI tables, the Audio CODEC (requires `AudioDxe.efi`), CPU details, SMBIOS and PCI devices:

![SysReport](https://user-images.githubusercontent.com/76865553/168154869-30725020-0247-4e9f-95fc-e27d733b9ef6.png)

When you reach OpenCore's boot menu, you can turn off the system without the need of booting anything, since these dumps occur right after the BIOS entry is selected.

![Dumping Process](https://user-images.githubusercontent.com/46293832/168248420-128f8d51-30fd-49b6-87e1-7ef95e92abf7.jpg)

### ACPI
With `SysReport` enabled, ACPI tables will be dumped which then can be further analyzed to see which [SSDTs](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features#readme) you might have to add in order to enable or add additional features.

#### Debugging ACPI Tables
See Section &rarr; [ACPI Debugging](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00_About_ACPI/ACPI_Debugging#readme)

### Audio
With `SysReport` and `AudioDxe.efi` driver enabled, OpenCore will create an Audio CODEC dump which can be useful in case you have to re-route the audio paths provided by the CODEC on your system and create your own ALC Layout-ID with it. But please don't ask me how to do this.

### CPU
In the CPU folder you'll find `CPUInfo.txt`, which contains all sorts of details about the CPU in use: Name, Frequency, Cores, Threads, Number of Speedstaps, AppleProcessorType (might be interesting if it's not detected correctly by macOS), etc.

### PCI
Besides analyzing ACPI tales such as the `DSDT`, the `PCIInfo.txt` located in the `PCI` folder includes useful information about hardware components which can help to figure out which additional kext sor SSDTs you may need. Although Hackintool shows a list of some PCI devices, the PCIInfo.txt shows all. The example below is from my Lenovo T530 Laptop.

Hackintool lists 16 devices:

![Hackintool](https://user-images.githubusercontent.com/76865553/168154904-febf908f-f0b1-41e0-94eb-cb13585c5bc9.png)

While PCIInfo contains 18 Devices:

```swift
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
With the python scripe [**PCILookup**](https://github.com/dreamwhite/PCILookup), we can restructure the PCIInfo.txt to a more legible form:

- Install Python
- Download and upack the Script
- Run Terminal
- Typce `cd`, hit space
- Drop the "PCILookup-master" folder in the terminal window and hit enter 
- Next, type `python3 main.py` and hit space
- Drag in the `PCIInfo.txt` and hit enter

The resulting output is much easier to read and also includes device names:

```swift
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
As you can see, devices 12 and 18 don't have a known/valid Vendor ID (`ffff`). That's the reason why they're not listed by Hackintool. So as far analyzing PCI is concerned you are better off using Hackintool, if the system is already up and running.

Note that Device-IDs between PCIInfo and Hackintool will differ whether you spoof Device-ID via DeviceProperties though `_DSM` via ACPI to make it work in macOS (iGPUs, dGPUS, SATA controllers, and LAN Adapters come to mind). 

### SMBIOS
This folder contains some .bins from the used system. Might be interesting for developers.

## CREDITS
@dreamwhite for PCILookup
