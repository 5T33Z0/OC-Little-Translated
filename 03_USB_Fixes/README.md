# Fixing USB issues

- [Technical Background](#technical-background)
  - [USB Specs](#usb-specs)
  - [Removing the USB port limit and mapping USB ports](#removing-the-usb-port-limit-and-mapping-usb-ports)
- [Method 1: Mapping USB Ports with Tools](#method-1-mapping-usb-ports-with-tools)
  - [Option 1: Mapping USB ports in Microsoft Windows (recommended)](#option-1-mapping-usb-ports-in-microsoft-windows-recommended)
  - [Option 2: Mapping ports in macOS](#option-2-mapping-ports-in-macos)
    - [Using USBMap (recommended)](#using-usbmap-recommended)
    - [Using Hackintool (outdated, inconvenient but prevalent)](#using-hackintool-outdated-inconvenient-but-prevalent)
- [Method 2: Mapping USB Ports via ACPI](#method-2-mapping-usb-ports-via-acpi)
- [Additional Resources](#additional-resources)

---

## Technical Background

> **Update** (2023-06-12): `XhciPortLimit` Quirk is working again since OpenCore 0.9.3 (commit [d52fc46](https://github.com/acidanthera/OpenCorePkg/commit/d52fc46ba650ce1afe00c354331a0657a533ef18)) for macOS Big Sur and newer. Generating a USB port injector kext or mapping ports via ACPI is still highly recommended!

In macOS, the number of available USB ports is limited to 15. But since modern mainboards with `XHCI` (Extensible Host Controller Interface) controllers provide up to 26 ports (per controller), this becomes an issue when trying to get USB ports working properly in macOS. If the ports are not mapped correctly, internal and external USB devices will default to USB 2.0 speed or won't work at all. This is also relevant for Bluetooth since it's basically "wireless" USB 2.0 and therefore requires an internally assigned USB 2.0 port. The same applies to built-in cameras in Laptop computers.

Since a physical USB 3 connector (the blue one) actually supports two USB protocols, it requires 2 ports: one called "HS" for "High Speed" (= USB 2.0) and one called "SS" for "Super Speed" (= USB 3.0). So in reality, you can actually only map 7 USB 3.0 Ports, supporting USB 2.0 and 3.0 protocols and one that's either or – and that's about it. USB 3.2 is not supported by macOS via the USB protocol – Apple uses Thunderbolt for this. So you have to decide which ports you are going to use and map them accordingly.

### USB Specs

| USB Version | Year | Signaling rate | Current Name | Marketing name | Controller | Notes |
|:-----------:|------|:--------------:|-------------:|---------------:|:----------:|-------|
| USB 1.0/1.1 | 1996 | 1.5 Mbps <br>12 Mbps | USB 1.0/1.1 | Low-Speed <br>Full-Speed | UHCI/OHCI | Dropped from macOS Ventura+. Important for driving keyboards and mice. [Workaround](https://dortania.github.io/OpenCore-Legacy-Patcher/VENTURA-DROP.html#usb-1-1-ohci-uhci-support). |
| USB 2.0     | 2000 | 480 Mbps         | USB 2.0 | High-Speed         | EHCI | Requires USB port-mapping (via Kext or ACPI)  |
| USB 3.0     | 2008 | 5 Gbps | USB 3.2 Gen 1x1 | USB 5 Gbps | XHCI | Requires USB port-mapping (via Kext or ACPI)    |
| USB 3.1     | 2013 | 10 Gbps | USB 3.2 Gen 2x1 | USB 10 Gbps | XHCI | Requires USB port-mapping (via Kext or ACPI)  |
| USB 3.2     | 2017 | Up to 20 Gbps | USB 3.2 Gen 2x2 | USB 20 Gbps | TB/PCIe | **Requirements**: <ul><li> USB-C port and cable (mandatory) <li> Port-mapping <li> Patched Thunderbolt controller |
| USB4        | 2019 | Up to 40 Gbps    | USB4 1.0 | USB4 40 Gbps | TB/PCIe | N/A in macOS |
| USB4v2      | 2022 | Up to 80 Gbps    | USB4 2.0 | USB4 80 Gbps | TB/PCIe‚ | N/A in macOS |

> [!NOTE]
> 
> Apple uses Thunderbolt 3 to for USB 3.2. USB4 is not implemented in macOS yet.

### Removing the USB port limit and mapping USB ports

The workaround is to lift the USB port limit and use additional tools to generate a codeless kext containing a USB Port map with 15 ports of your choice. Prior to macOS Catalina, you could use the `XhciPortLimit` quirk to enable all 26 ports and you we're good. Since macOS Catalina, you need to map USB ports, so your peripherals work correctly. There are two methods to do this.

## Method 1: Mapping USB Ports with Tools

This method uses tools to create a codeless kext containing an info.plist with the desired USB port mapping which is injected into macOS during boot.

> [!CAUTION]
>
> If your desktop mainboard has an LED-controller for driving RGB fans mapped via USB, you should disable these ports in macOS. There have been reports that these ports can cause shutdown/reboot issues under macOS, especially on ASRock boards ([A520m](https://github.com/5T33Z0/OC-Little-Translated/issues/121) and [B550M](https://www.reddit.com/r/hackintosh/comments/1flewc3/reboot_and_shutdown_problem_on_asrock_boards_with/) chipsets).

### Option 1: Mapping USB ports in Microsoft Windows (recommended)

- Boot into Windows from the BIOS boot menu (to bypass injections from OpenCore)
- Download the Windows version of [**USBToolBox**](https://github.com/USBToolBox/tool/releases)
- Run it and follow the [**instructions**](https://github.com/USBToolBox/tool#usage) to map your USB ports
- Export the `UTBMap.kext`
- Reboot into macOS and add the Kext to your `EFI\OC\Kexts` folder and config.

> [!NOTE]
> 
> When using **USBToolBox** in macOS, there are 2 mapping options available which results in 2 different types of kexts:
> 
> - **Option 1** (default): Generates `UTBMap.kext` which has to be used in tandem with `USBToolBox.kext` to make the whole construct work. It has the advantage that the mapping is *SMBIOS-independent* so it can be used with *any* SMBIOS.
> - **Option 2** (uses native Apple classes): Hit "C" to enter the settings and then "N" to enable native Apple classes (`AppleUSBHostMergeProperties`). This kext can only be used with the SMBIOS it was created with. If you decide to change your SMBIOS later, you have to adjust the `model` property inside the kext's `info.plist` – otherwise the mapping won't be applied!

### Option 2: Mapping ports in macOS
Since the `XhciPortLimit` quirk has been fixed since OC 0.9.3, it can be used again to map USB ports in macOS 11.4 and newer!

#### Using USBMap (recommended)
The following method is applicable when using [**USBMap**](https://github.com/corpnewt/USBMap).

- [**Update OpenCore**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/D_Updating_OpenCore) to the latest version (0.9.3 or newer is mandatory!)
- Enable Kernel Quirk `XchiPortLimit`
- Save your config and reboot
- Follow the [**instructions**](https://github.com/corpnewt/USBMap#general-mapping-process) to map your USB ports and generate a `USBPort.kext`
- Add the `USBPort.kext` to `EFI/OC/Kexts` and your config.plist. 
- Disable the `XhciPortLimit` Quirk again.
- Save your config.plist and reboot
- Enjoy working USB ports!

#### Using Hackintool (outdated, inconvenient but prevalent)
This method is applicable when using [**Hackintool**](https://github.com/benbaker76/Hackintool). Although wide-spread, using Hackintool for mapping USB ports is a bit antiquated, requires a kot more prepworkd and is unreliable in terms of detecting *internal* USB ports. You also need 2 different kinds of USB flash drives for mapping ports: a USB 2 and a USB 3 stick!

- [**Update OpenCore**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/D_Updating_OpenCore) to the latest version (0.9.3 or newer is mandatory!)
- Mount your EFI
- Add Daliansky's variant of [**USBInjectAll.kext**](https://github.com/daliansky/OS-X-USB-Inject-All/releases) to `EFI/OC/Kexts` and your `config.plist` since it also supports the latest chipsets
- [**Prepare your system**](https://dortania.github.io/OpenCore-Post-Install/usb/system-preparation.html) for mapping by renaming USB controllers.
- Enable Kernel Quirk `XchiPortLimit`
- Save your config and reboot
- Run Hackintool
- Click on the "USB" Tab
- Click on the Brush icon to clear the screen
- Click on the Recycle icon to detect injected ports
- Put your USB 2 and USB 3 sticks into the ports of your system. Detected ports will turn green.
- Built-in Bluetooth/Cameras: make sure to change the detected port for Bluetooth devices and/or build-in cameras to "internal" to avoid sleep issues. Use IORegistryExplorer to figure out which port these devices are using if Hackintool doesn't detect them (or use Windows' Device Manager >> Details >> Property dropdown-menu >> BIOS path)
- Map up to 15 ports. If you have more, decide which ones you need and delete the other ones.
- Once you're done with mapping, click on "Export" (arrow pointing out of the box).
- `USBPorts.kext` (among other files) will be stored on your Desktop
- Add the `USBPorts.kext` to `EFI/OC/Kexts` and your config.plist. 
- Disable the `USBInjectAll.kext` and the `XhciPortLimit` Quirk.
- Save your config and reboot.
- Enjoy working USB ports!

> [!IMPORTANT]
> 
> If you decide to change the SMBIOS later, you have to adjust the `model` property inside the kext's `info.plist` – otherwise the mapping won't be applied!
> 
> **Example**:<br> ![USBremap](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/4386daf7-fc63-480d-8922-9632425c3c57)

## Method 2: Mapping USB Ports via ACPI
Declaring USB ports is via ACPI is the "gold standard" since this method is OS-agnostic (unlike USBPort kexts, which by default only work for the SMBIOS they were defined for). It's aimed at advanced users only who are experienced in working with ACPI tables already. 

You can follow [**this guide**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03_USB_Fixes/ACPI_Mapping_USB_Ports) to map your USB Ports via ACPI.

## Additional Resources
- [**USBInjectAll.kext**](https://github.com/daliansky/OS-X-USB-Inject-All/releases) by daliansky. Updated version with IOKit Personalities for the latest SMBIOSes and USB Controllers, including 400 to 700-series mainboards. Its `info.plist` contains about 9.300 lines of code while the original by Rehabman is from 2018 and "only" contains about 6.800!
- [**Hackintool Port Mapping Guide**](https://chriswayg.gitbook.io/opencore-visual-beginners-guide/step-by-step/install-postinstall/usb-port-mapping) by chriswayg. A bit outdated but informative. Just ignore the stuff about `XhciPortLimit` Quirk and blocking ports via NVRAM!
- [**USBWakeFixup**](https://github.com/osy/USBWakeFixup) – Kext and SSDT for fixing USB Wake issues
- [**GUX-RyzenXHCIFix**](https://github.com/RattletraPM/GUX-RyzenXHCIFix) – `GenericUSBXHCI.kext` variant for fixing USB 3 issues on some APU-based Ryzentoshes running macOS 11.0 or newer.
- [**ACE: Apple Type-C Port Controller Secrets**](https://web.archive.org/web/20211023034503/https://blog.t8012.dev/ace-part-1/) (archived)