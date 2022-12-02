# Enabling undetected AMD GPUs

## About

If your macOS-compatible AMD GPU works fine in Windows but is not detected by macOS it's possible that your `GFX0` device is sitting behind an intermediate PCI bridge without an ACPI device name assigned to it, as in this example:

![nobrigeeee](https://user-images.githubusercontent.com/76865553/198372013-932cb76e-842d-45ac-a4eb-3c77ee060cde.png)

In this case, you cannot you need to add `SSDT-BRG0` so that Properties for the devices behind the bridge can be assigned:  

> This table provides an example of creating a missing ACPI device to ensure early DeviceProperty application. In this example a GPU device is created for a platform having an extra PCI bridge in the path - PCI0.PEG0.PEGP.BRG0.GFX0: PciRoot(0x0)/Pci(0x1,0x0)/Pci(0x0,0x0)/Pci(0x0,0x0)/Pci(0x0,0x0)- Such tables are particularly relevant for macOS 11.0 and newer.

## Instructions

### Patching method 1: automated, using SSDTTime

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

### Patching method 2: manual patching

1. Run IORegistryExplorer
2. Switch View to `IODeviceTree` (<kbd>⌘</kbd><kbd>5</kbd>)
3. Search for `GFX0`
4. If it sits behind a `pci-bridge@…` then you need a fix
5. Open `SSDT-BRG0.dsl`
6. Copy the raw text into maciASL
7. Adjust the ACPI path to your needs
8. Export it as `.aml`
9. Add it to `EFI/OC/ACPI` and your `config.plist`
10. Save and reboot

## Notes, Credits and Resources
- Lorys89 for `SSDT-BRG0`
- CorpNewt for SSDTTime
- You may need to incorporate the `BRG0` device into other GPU-related SSDTs, such as the 
ones in the "AMD Radeon Tweaks" section.
- More in-depth explanations: https://github.com/acidanthera/bugtracker/issues/1569
