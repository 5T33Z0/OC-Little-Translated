# Fixing USB issues

> **Warning** **Update** (2023-06-12): `XhciPortLimit` Quirk is working again since OpenCore 0.9.3 (commit [d52fc46](https://github.com/acidanthera/OpenCorePkg/commit/d52fc46ba650ce1afe00c354331a0657a533ef18)) for macOS Big Sur to Sonoma. Generating a USB Port Map kext is still recommended!

## Technical Background

In macOS, the number of available USB ports is limited to 15. But since modern motherboard with XHCI controllers (Extensible Host Controller Interface)  provide up to 26 ports (per controller), this becomes an issue when trying to get USB ports working properly in macOS. If the ports are not mapped correctly, internal and external USB devices will default to USB 2.0 speed or won't work at all. This is also true for Bluetooth since it's basically "wireless" USB 2.0 and therefore requires an internally assigned USB 2.0 port.

Since a physical USB 3 connector (the blue ones) actually supports two USB protocols, it requires 2 ports: one called "HS" for "High Speed" – which is actually USB 2.0 – and one called "SS" for "Super Speed", which is USB 3.0. So in reality, you can actually only map 7 USB 3.0 Ports, supporting USB 2.0 and 3.0 protocols and one that's either or – and that's about it. USB 3.2 is not supported by macOS via the USB protocol – Apple uses Thunderbolt for this. So you have to decide which ports you are going to use and map them accordingly.

## USB Specs

USB Standard | Speed | Controller | macOS support 
------------:|-------|:----------:|:---------------:
USB 1.1      | 12 Mbps | UHCI/OHCI |  ≤ macOS 12 (officially)</br>([**OCLP**](https://github.com/dortania/OpenCore-Legacy-Patcher/releases/tag/0.6.1) brings it to Ventura)
USB 2.0      | 480 Mbps |EHCI | OSX 10.2+ 
USB 3.0 (aka USB 3.1 Gen 1)| 5 Gbps | XHCI | OSX 10.6.6+
USB 3.1 Gen 2| 10 Gbps | XHCI | via Thunderbolt only
USB 4        | 40 Gbps | PCIe | via Thunderbolt only

**NOTE**: Instead of USB 3.1 Gen 2 and USB 4, Apple uses Thunderbolt 3 and 4 instead which provide similar transfer rates.

## Removing the USB port limit and mapping USB ports

The workaround is to lift the USB port limit and use additional tools to generate a codeless kext including a USB Port map with 15 ports of your choice. Prior to macOS Catalina, you could use the `XhciPortLimit` quirk to enable all 26 ports and you we're good. Since macOS Catalina, you need to map USB ports, so your peripherals work correctly. There are two methods to do this.

## Method 1: Mapping USB Ports with Tools
This method uses tools to create a codeless kext containing an info.plist with the desired USB port mapping which is injected into macOS during boot.

### Mapping USB ports in macOS
This method is applicable when using tools like [**USBMap**](https://github.com/corpnewt/USBMap) or [**Hackintool**](https://github.com/benbaker76/Hackintool)

- [**Update OpenCore**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/D_Updating_OpenCore) to the lates version (0.9.3 or newer is mandatory!)
- Enable Kernel Quirk `XchiPortLimit`
- Add Daliansky's variant of [**USBInjectAll.kext**](https://github.com/daliansky/OS-X-USB-Inject-All/releases) to EFI/OC/Kexts and your config.plist since it also supports the latest chipsets
- Save your config and reboot
- Follow Dortania's [**USB Port Mapping Guide**](https://dortania.github.io/OpenCore-Post-Install/usb/system-preparation.html)
- Once you're done with mapping the ports and have created your USBPort.kext, disable XhciPortLimitQuirk and disable/delete USBInjectAll.kext

> **Note**: If you decide to change your SMBIOS later, you have to adjust the `model` property inside the kext's info.plist – otherwise the mapping won't be applied!

### Mapping USB Ports in Windows
- Boot Into Windows from the BIOS boot menu (to bypass injections from OpenCore)
- Download the Windows version of [**USBToolBox**](https://github.com/USBToolBox/tool/releases)
- Run it and follow the [**instructions**](https://github.com/USBToolBox/tool#usage) to map your USB ports
- Export the `UTBMap.kext`
- Reboot into macOS and add the Kext to your `EFI\OC\Kexts` folder and config.

**NOTES**:

When using **USBToolBox** in macOS, there are 2 mapping options available which result to 2 different kexts:

- **Option 1** (default): Generates `UTBMap.kext` which has to be used in tandem with `USBToolBox.kext` to make the whole construct work. It has the advantage that the mapping is *SMBIOS-independent* so it can be used with any SMBIOS.
- **Option 2** (uses native Apple classes): Hit "C" to enter the settings and then "N" to enable native Apple classes (AppleUSBHostMergeProperties). This kext can only be used with the SMBIOS it was created with. If you decide to change your SMBIOS later, you have to adjust the `model` property inside the kext's info.plist – otherwise the mapping won't be applied!

## Method 2: Mapping USB Ports via ACPI
The best way to declare USB ports is via ACPI since this method is OS-agnostic (unlike USBPort kexts, which by default only work for the SMBIOS they were defined for). It's aimed at advanced users only who are experienced in working with ACPI tables already. 

You can follow [**this guide**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03_USB_Fixes/ACPI_Mapping_USB_Ports) to map your USB Ports via ACPI.

## Other Resources
- [**USBInjectAll.kext**](https://github.com/daliansky/OS-X-USB-Inject-All/releases) by daliansky. Updated version with IOKit Personalities for the latest SMBIOSes and USB Controllers, including 400 to 600-series mainboards.
- [**USBWakeFixup**](https://github.com/osy/USBWakeFixup) – Kext and SSDT for fixing USB Wake issues
