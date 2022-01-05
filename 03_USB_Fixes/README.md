# Fixing USB issues

## Background

In macOS, the number of available USB ports is limited to 15. But since modern mainboards provide up to 26 ports per Controller, this can become a problem when trying to get USB pots working properly. If the ports are not assigned correctly, internal and external USB devices will default to USB 2.0 speed or won't work at all.

Since one physical USB 3 connector (the blue ones) actually supports 2 USB protocols, it requires 2 ports: one called "HS" for "high speed" – which is actually USB 2.0 – and one called "SS" for "super speed", which is USB 3.0. In other words: you can actually only map 7 USB 3.0 Ports, supporting USB 2.0 and 3.0 protocols – and that's about it. USB 3.2 is not even in the equation at this point as far as Apple is concerned. So you have to decide which ports you are going to use and map them manually.

## Removing the USB port limit and mapping USB ports

The workaround is to lift the USB port limit and use additional tools to generate a codeless kext including a USB Port map with 15 ports of your choice. Prior to macOS Catalina, you could use the `XhciPortLimit` quirk to enable 26 Ports and you were good. Since macOS Catalina, you need to map USB ports, so your peripherals work correctly. There are two methods to do this:

## Method 1: Mapping USB Ports with Tools (Intel only)

### Mapping USB ports in Windows or macOS 11.3+
Since the `XhciPortLimit` Quirk required for mapping the USB ports is no longer working past macOS 11.2, you need to take a different approach. The easiest method is to use Windows using **USBToolBox**.

#### Mapping USB Ports in Windows
- Boot Into Windows from the BIOS bootmenu (to bypass OpenCore injections)
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
- Now you have to decide which method to use for mapping ports. There are 2 options available which lead to 2 different kexts being generated:
	- **Option 1** (default): Generates `UTBMap.kext` which has to be used in tandem with `USBToolBox.kext` to make the whole construct work. It has the advantage that the mapping is SMBIOS-independent so it can be used with any SMBIOS.
	- **Option 2** (uses native Apple classes): Hit "C" to enter the settings and then "N" to enable native Apple classes (AppleUSBHostMergeProperties).
- Follow the [**instructions**](https://github.com/USBToolBox/kext#usage) to map your USB ports.
- Generate either `UTBMap.kext` (option 1, requires `USBToolBox.kext` as well to work) or `USBMap.kext` (option 2, no additional kext necessary) and add it to your `EFI\OC\Kexts` folder and config.
- Remove `UTBDefault.kext` from Kexts folder and config.
- Save and Reboot.

Enjoy your properly working USB ports!

### Mapping USB ports in macOS ≤ 11.2

Up to macOS 11.3, you can use tools to create a USBPorts.kext. To do so, follow the official Guide by Dortania: [**USB Port Mapping with USBMap**](https://dortania.github.io/OpenCore-Post-Install/usb/system-preparation.html).

Personally, I prefer [**Hackintool**](https://github.com/headkaze/Hackintool) for mapping. This method only works for Intel systems, though. But on AMD systems it's not really an issue, since these boards usually only have about 10 USB ports per controller which stays well within the limit of 15 ports per controller in macOS.

## Method 2: mapping USB Ports via ACPI (OS-independent). Advanced users only!
Since macOS Big Sur 11.3, the `XHCIPortLimit` Quirk which removes the USB port limit no longer works. This complicates the process of creating a `USBPorts.kext` with Tools like `Hackintool` or `USBMap`. 

So the best way to declare USB ports is via ACPI since this method is OS-agnostic (unlike USBPort kexts, which by default only work for the SMBIOS they were defined for).

Follow [**this guide**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03_USB_Fixes/ACPI_Mapping_USB_Ports) to map your USB Ports via SSDT Table.

## Other Resources
- Updated version of [USBInjectAll.kext](https://github.com/daliansky/OS-X-USB-Inject-All/releases) by daliansky with 400 to 600-series mainboard support. Only works up to macOS Big Sur ≤ 11.2 still.
- Kext and SSDT for fixing USB Wake issues: https://github.com/osy/USBWakeFixup.
