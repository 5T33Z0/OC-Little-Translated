# Fixing USB issues

## Background

In macOS, the number of available USB ports is limited to 15. But since modern mainboards with XHIC controllers provide up to 26 ports (per controller), this can become an issue when trying to get USB ports working properly in macOS. If the ports are not mapped correctly, internal and external USB devices will default to USB 2.0 speed or won't work at all. This is also true for Bluetooth since it's basically "wireless" USB 2.0 and therefore depends on properly mapped USB ports.

Since a physical USB 3 connector (the blue ones) actually supports two USB protocols, it requires 2 ports: one called "HS" for "High Speed" – which is actually USB 2.0 – and one called "SS" for "Super Speed", which is USB 3.0. So in reality, you can actually only map 7 USB 3.0 Ports, supporting USB 2.0 and 3.0 protocols and one that's either or – and that's about it. USB 3.2 is not even in the equation at this point as far as Apple is concerned – they use Thunderbolt for this. So you have to decide which ports you are going to use and map them accordingly.

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

The workaround is to lift the USB port limit and use additional tools to generate a codeless kext including a USB Port map with 15 ports of your choice. Prior to macOS Catalina, you could use the `XhciPortLimit` quirk to enable all 26 ports and you were good. Since macOS Catalina, you need to map USB ports, so your peripherals work correctly. There are two methods to do this.

## Method 1: Mapping USB Ports with Tools

### Mapping USB ports in Windows or macOS 11.3+
Since the `XhciPortLimit` Quirk required for mapping the USB ports is no longer working past macOS 11.2, you need to take a different approach. The easiest method is to use Windows using **USBToolBox**.

#### Mapping USB Ports in Windows
- Boot Into Windows from the BIOS boot menu (to bypass OpenCore injections)
- Download the Windows version of [**USBToolBox**](https://github.com/USBToolBox/tool/releases)
- Run it, follow the [**instructions**](https://github.com/USBToolBox/tool#usage) to map your USB ports
- Export the `UTBMap.kext`
- Reboot into macOS and add the Kext to your `EFI\OC\Kexts` folder and config.

#### Mapping USB Ports in macOS 11.3+
- Download the macOS version of [**USBToolBox**](https://github.com/USBToolBox/tool/releases)
- Download this additional [**USBToolBox.kext**](https://github.com/USBToolBox/kext/releases)
- Unpack the zip package and add the 2 included kexts to your kext folder and config.
- Save and reboot
- Next, Run USBToolBox
- There are 2 options of mapping USB ports which lead to 2 different kexts being generated:
	- **Option 1** (default): Generates `UTBMap.kext` which has to be used in tandem with `USBToolBox.kext` to make the whole construct work. It has the advantage that the mapping is SMBIOS-independent so it can be used with any SMBIOS.
	- **Option 2** (uses native Apple classes): Hit "C" to enter the settings and then "N" to enable native Apple classes (AppleUSBHostMergeProperties).
- Follow the [**instructions**](https://github.com/USBToolBox/kext#usage) to map your USB ports.
- Generate either `UTBMap.kext` (option 1, requires `USBToolBox.kext` as well to work) or `USBMap.kext` (option 2, no additional kext necessary) and add it to your `EFI\OC\Kexts` folder and config.
- Remove `UTBDefault.kext` from Kexts folder and config.
- Save and Reboot.

Enjoy your properly working USB ports!

### Mapping USB ports in macOS ≤ 11.2

Up to macOS 11.2, you can use tools to create a USBPorts.kext. To do so, follow the official Guide by Dortania: [**USB Port Mapping with USBMap**](https://dortania.github.io/OpenCore-Post-Install/usb/system-preparation.html).

Personally, I prefer [**Hackintool**](https://github.com/headkaze/Hackintool) for mapping. This method only works for Intel systems, though. But on AMD systems it's not really an issue, since these boards usually only have about 10 USB ports per controller which stays well within the limit of 15 ports per controller in macOS.

## Method 2: [Mapping USB Ports via ACPI](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03_USB_Fixes/ACPI_Mapping_USB_Ports) (OS-independent). Advanced users only!
Since macOS Big Sur 11.3, the `XHCIPortLimit` Quirk which removes the USB port limit no longer works. This complicates the process of creating a `USBPorts.kext` with Tools like `Hackintool` or `USBMap`. 

So the best way to declare USB ports is via ACPI since this method is OS-agnostic (unlike USBPort kexts, which by default only work for the SMBIOS they were defined for).

Follow [**this guide**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03_USB_Fixes/ACPI_Mapping_USB_Ports) to map your USB Ports via SSDT Table.

## Other Resources
- [**USBInjectAll.kext**](https://github.com/daliansky/OS-X-USB-Inject-All/releases) by daliansky. Updated version with IOKit Personalities for the latest SMBIOSes and USB Controllers, including 400 to 600-series mainboards.
- [**USBWakeFixup**](https://github.com/osy/USBWakeFixup) – Kext and SSDT for fixing USB Wake issues
