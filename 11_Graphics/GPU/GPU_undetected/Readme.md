# Enabling undetected AMD GPUs

## About

If your macOS-compatible AMD GPU works fine in Windows but is not detected by macOS it's possible that your `GFX0` device is sitting behind an intermediate PCI bridge without an ACPI device name assigned to it, as in this example:

![](/Users/5t33z0/Desktop/nobrige.png)

In this case, you cannot you need to add `SSDT-BRG0` so that Properties for the devices behind the bridge can be assigned:  

> This table provides an example of creating a missing ACPI device to ensure early DeviceProperty application. In this example a GPU device is created for a platform having an extra PCI bridge in the path - PCI0.PEG0.PEGP.BRG0.GFX0: PciRoot(0x0)/Pci(0x1,0x0)/Pci(0x0,0x0)/Pci(0x0,0x0)/Pci(0x0,0x0)- Such tables are particularly relevant for macOS 11.0 and newer.

## Instructions
- Run IORegustryExplorer
- Switch View to `IODeviceTree` (⌘5)
- Search for `GFX0` Device
- If it sits behind a `pci-bridge@…` then you need a fix
- Open `SSDT-BRG0.dsl`
- Copy the raw text into maciASL
- Adjust the ACPI path to your needs
- Export it as .aml
- Add it to you EFI/OC/ACPI folder and Config
- Save and reboot

## Notes, Credits and Resources
- You may want to incorporate the `BRG0` device into other GPU-related SSDTs, such as the ones in the "AMD Radeon Tweaks" section.
- Acidanthera for `SSDT-BRG0`
- More in-depth explanations: https://github.com/acidanthera/bugtracker/issues/1569 
