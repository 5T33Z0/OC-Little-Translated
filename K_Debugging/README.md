# Debugging

## Debugging ACPI Tables
See Section &rarr; [ACPI Debugging](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00_About_ACPI/ACPI_Debugging#readme)

## Using OpenCore's `SysReport` feature
When using the "Debug" version of OpenCore (replace the `OpenCore.efi`), you can enable the `Misc/Debug/SysReport` feature in the config.plist to generate dumps of ACPI tables, Audio CODEC information (requires an additional driver), CPU, SMBIOS and PCI devices:

![SysReport](https://user-images.githubusercontent.com/76865553/168154869-30725020-0247-4e9f-95fc-e27d733b9ef6.png)

Unfortubately, these System Reports can only be generated during boot, which means you need an already working `config.plist`. This makes the whole idea of using `SysReport` for actual "debbugging" kind of pointless. Nevertheless, it's still useful for refining your system.

When it comes to dumping ACPI tables on a system without an already working config.plist, Clover is still the better option for obtaining thoes.

### Analyzing`PCIInfo.txt`
Besides analyzing ACPI tales such as the `DSDT`, the `PCIInfo.txt` located in the `PCI` folder included useful information about hardware components which can help to figure out which additional kext sor SSDTs you may need. Although Hackintool shows a list of some PCI devices, the PCIInfo.txt shows all. The example below is fro my Lenovo T530 Notebook.

**Hackintool lists 16 Devices**:

![Hackintool](https://user-images.githubusercontent.com/76865553/168154904-febf908f-f0b1-41e0-94eb-cb13585c5bc9.png)

<details>
<summary><strong>While PCIInfo contains 18 Devices</strong> (click to reveal)</summary>

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
</details>

With the python scripe [**PCILookup**](https://github.com/dreamwhite/PCILookup) we can convert that list into a more legible forn:

- Install Python
- Download and upack the Script
- Run Terminal
- Typce `cd`, hit space
- Drop the PCILookup-master folder in the terminal window and hit enter 
- Next, enter `python3 main.py` and hit space
- Drag in the `PCIInfo.txt` and hit enter

The resulting output will be much easier to read:

```
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
As you can see, devices 12 and 18 don't have a valid Vendor ID and that's the reason why they're not listed by Hackintool. So as far as PCI is concerned you are better off using Hackintool, imo.

To be continued…

## CREDITS
@dreamwhite for PCILookup
