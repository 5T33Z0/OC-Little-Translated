# Enabling undetected AMD GPUs

## About

If your macOS-compatible AMD GPU works fine in Windows but is not detected by macOS it's possible that your `GFX0` device is sitting behind an intermediate PCI bridge without an ACPI device name assigned to it, as in this example:

![nobrigeeee](https://user-images.githubusercontent.com/76865553/198372013-932cb76e-842d-45ac-a4eb-3c77ee060cde.png)

In this case, you cannot you need to add `SSDT-BRG0` so that Properties for the devices behind the bridge can be assigned:  

> This table provides an example of creating a missing ACPI device to ensure early DeviceProperty application. In this example a GPU device is created for a platform having an extra PCI bridge in the path - PCI0.PEG0.PEGP.BRG0.GFX0: PciRoot(0x0)/Pci(0x1,0x0)/Pci(0x0,0x0)/Pci(0x0,0x0)/Pci(0x0,0x0)- Such tables are particularly relevant for macOS 11.0 and newer.

## Instructions

### Patching method 1: automated, using SSDTTime

Luckily the patching process can now be automated using **SSDTTime** which can generate the following SSDTs by analyzing your system's `DSDT`:

* ***SSDT-AWAC*** – Context-aware AWAC and Fake RTC
* ***SSDT-BRG0*** – ACPI device for missing PCI bridges for passed device path
* ***SSDT-EC*** – OS-aware fake EC for Desktops and Laptops
* ***SSDT-USBX*** – Adds USB power properties for Skylake and newer SMBIOS
* ***SSDT-HPET*** – Patches out IRQ Conflicts
* ***SSDT-PLUG*** – Sets plugin-type to `1` on `CPU0`/`PR00` to enable the X86PlatformPlugin for CPU Power Management
* ***SSDT-PMC*** – Enables Native NVRAM on true 300-Series Boards and newer
* ***SSDT-PNLF*** – PNLF device for laptop backlight control
* ***SSDT-USB-Reset*** – Resets USB controllers to allow hardware mapping

**NOTE**: When used in Windows, SSDTTime also can dump the `DSDT`.

**HOW TO:**

1. Download [**SSDTTime**](https://github.com/corpnewt/SSDTTime) and run it
2. Press <kbd>D</kbd>, drag in your system's DSDT and hit and hit <kbd>Enter</kbd>
3. Generate all the SSDTs you need.
4. The SSDTs will be stored under `Results` inside the `SSDTTime-master` Folder along with `patches_OC.plist`.
5. Copy the generated SSDTs to `EFI/OC/ACPI`
6. Open `patches_OC.plist` and copy the included entries to the corresponding section(s) of your `config.plist`.
7. Save and Reboot.

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
