# Fixing USB issues

**INDEX**

- [Technical Background](#technical-background)
  - [USB Specs](#usb-specs)
  - [Removing the USB port limit and mapping USB ports](#removing-the-usb-port-limit-and-mapping-usb-ports)
- [Method 1: Mapping USB Ports with Tools](#method-1-mapping-usb-ports-with-tools)
  - [Option 1: Mapping USB ports in Microsoft Windows (recommended)](#option-1-mapping-usb-ports-in-microsoft-windows-recommended)
  - [Option 2: Mapping ports in macOS](#option-2-mapping-ports-in-macos)
    - [Using USBMap (recommended)](#using-usbmap-recommended)
    - [Using Hackintool (outdated, inconvenient but prevalent)](#using-hackintool-outdated-inconvenient-but-prevalent)
- [Adjusting USBMap Kexts for macOS Tahoe Compatibility](#adjusting-usbmap-kexts-for-macos-tahoe-compatibility)
- [Method 2: Mapping USB Ports via ACPI](#method-2-mapping-usb-ports-via-acpi)
- [Additional Resources](#additional-resources)

---

## Technical Background

> **Update** (2023-06-12): `XhciPortLimit` Quirk is working again since OpenCore 0.9.3 (commit [d52fc46](https://github.com/acidanthera/OpenCorePkg/commit/d52fc46ba650ce1afe00c354331a0657a533ef18)) for macOS Big Sur and newer. Generating a USB port injector kext or mapping ports via ACPI is still highly recommended!

In macOS, the system imposes a strict limit of 15 available USB ports. This restriction poses a challenge for modern motherboards equipped with XHCI (Extensible Host Controller Interface) controllers, which can support up to 26 ports per controller. When USB ports are not properly mapped in macOS, both internal and external USB devices may default to USB 2.0 speeds or fail to function entirely. This issue extends to devices like Bluetooth, which operates as a "wireless" USB 2.0 connection and requires an internally assigned USB 2.0 port. Similarly, built-in laptop cameras depend on correct port mapping to work as intended.

A single physical USB 3 connector (typically the blue one) supports two distinct USB protocols, requiring two port assignments: "HS" (High Speed) for USB 2.0 and "SS" (Super Speed) for USB 3.0. Given macOS's 15-port limit, this effectively means you can map only seven USB 3.0 ports—each supporting both USB 2.0 and USB 3.0 protocols—plus one additional port for either HS or SS, and that's the maximum. Notably, macOS does not support USB 3.2 via the USB protocol; Apple relies on Thunderbolt for higher-speed connections instead. As a result, hackintosh users must carefully select and map their desired ports to ensure optimal functionality.

### USB Specs

| USB Version | Year | Signaling Rate | Current Name | Marketing Name | Controller | Notes |
|:-----------:|:----:|:--------------:|:------------:|:--------------:|:----------:|:-----|
| USB 1.0/1.1 | 1996 | 1.5 Mbps <br>12 Mbps | USB 1.0/1.1 | Low-Speed <br>Full-Speed | UHCI/OHCI | Dropped from macOS Ventura+. Critical for legacy keyboards and mice. [Workaround](https://dortania.github.io/OpenCore-Legacy-Patcher/VENTURA-DROP.html#usb-1-1-ohci-uhci-support). |
| USB 2.0     | 2000 | 480 Mbps       | USB 2.0     | High-Speed     | EHCI       | Requires USB port-mapping (via Kext or ACPI) for macOS compatibility. Backward compatible with USB 1.x. |
||
| USB 3.0     | 2008 | 5 Gbps         | USB 3.2 Gen 1x1 | USB 5Gbps | XHCI       | Requires USB port-mapping (via Kext or ACPI). Backward compatible with USB 2.0. |
| USB 3.1     | 2013 | 10 Gbps        | USB 3.2 Gen 2x1 | USB 10Gbps | XHCI       | Requires USB port-mapping (via Kext or ACPI). Backward compatible with USB 3.2 Gen 1x1 and USB 2.0. |
| USB 3.2     | 2017 | 20 Gbps        | USB 3.2 Gen 2x2 | USB 20Gbps | XHCI       | Requires USB-C port and cable. Port-mapping and patched Thunderbolt controller may be needed for full functionality. Backward compatible with lower USB versions. |
||
| USB4        | 2019 | Up to 40 Gbps  | USB4 Gen 3x2 | USB4 40Gbps | TB/PCIe    | Not natively supported in macOS. Requires Thunderbolt 3/4 or PCIe controller. Supports USB-C, backward compatible with USB 3.2 and USB 2.0. Optional tunneling for PCIe and DisplayPort. |
| USB4v2      | 2022 | Up to 80 Gbps  | USB4 Gen 4x2 | USB4 80Gbps | TB/PCIe    | Not natively supported in macOS. Requires USB-C and specific controllers (Thunderbolt 4 or PCIe). Supports asymmetric 120 Gbps (80 Gbps one direction, 40 Gbps other). Backward compatible with USB4, USB 3.2, and USB 2.0. |

> [!NOTE]
>
> 1. **Naming Conventions**: The USB-IF simplified naming in 2019, emphasizing performance-based marketing names (e.g., USB 5Gbps, USB 10Gbps) over version numbers to reduce confusion. The "Current Name" reflects technical designations (e.g., USB 3.2 Gen 1x1), while "Marketing Name" uses the consumer-friendly speed-based names.
> 2. **USB4 and USB4v2**: USB4 Gen 3x2 (40 Gbps) and USB4 Gen 4x2 (80 Gbps) are clarified with their technical names. USB4v2 introduces asymmetric bandwidth (up to 120 Gbps in one direction), but 80 Gbps is the standard bidirectional rate.
> 3. **Controllers**: USB4 and USB4v2 rely on Thunderbolt/PCIe controllers, with USB4 requiring Thunderbolt 3/4 compatibility for full features. XHCI remains standard for USB 3.x.
> 4. **macOS Support**: USB4 and USB4v2 lack native macOS support, requiring specific hardware and drivers.
> 5. **Backward Compatibility**: All versions maintain backward compatibility, but performance is limited to the lowest common denominator of connected devices, cables, and ports.

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

- [**Update OpenCore**](/Content/D_Updating_OpenCore) to the latest version (0.9.3 or newer is mandatory!)
- Enable Kernel Quirk `XchiPortLimit`
- Save your config and reboot
- Follow the [**instructions**](https://github.com/corpnewt/USBMap#general-mapping-process) to map your USB ports and generate a `USBPort.kext`
- Add the `USBPort.kext` to `EFI/OC/Kexts` and your config.plist. 
- Disable the `XhciPortLimit` Quirk again.
- Save your config.plist and reboot
- Enjoy working USB ports!

#### Using Hackintool (outdated, inconvenient but prevalent)
This method is applicable when using [**Hackintool**](https://github.com/benbaker76/Hackintool). Although wide-spread, using Hackintool for mapping USB ports is a bit antiquated, requires a lot more prepwork and is unreliable in terms of detecting *internal* USB ports. You also need a USB 2 and a USB 3 flash drive to detept/map ports!

- [**Update OpenCore**](/Content/D_Updating_OpenCore) to the latest version (0.9.3 or newer is mandatory!)
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
> **Example**:<br><img width="1170" height="369" alt="infoplist" src="https://github.com/user-attachments/assets/16f32ea8-5858-48b1-9573-d87834cad196" />

## Adjusting USBMap Kexts for macOS Tahoe Compatibility

In order for USBMap kexts to work in macOS Tahoe, the `info.plist` inside the kext needs to be adjusted. &rarr; [Instructions](https://github.com/5T33Z0/OCLP4Hackintosh/blob/main/Enable_Features/USB_Tahoe.md)

## Method 2: Mapping USB Ports via ACPI
Declaring USB ports is via ACPI is the "gold standard" since this method is OS-agnostic (unlike USBPort kexts, which by default only work for the SMBIOS they were defined for). It's aimed at advanced users only who are experienced in working with ACPI tables already. 

Check the &rarr; [**Mapping USB Ports via ACPI**](/Content/03_USB_Fixes/ACPI_Mapping_USB_Ports) section to find out more.

## Additional Resources
- [**USBInjectAll.kext**](https://github.com/daliansky/OS-X-USB-Inject-All/releases) by daliansky. Updated version with IOKit Personalities for the latest SMBIOSes and USB Controllers, including 400 to 700-series mainboards. Its `info.plist` contains about 9.300 lines of code while the original by Rehabman is from 2018 and "only" contains about 6.800!
- [**Hackintool Port Mapping Guide**](https://chriswayg.gitbook.io/opencore-visual-beginners-guide/step-by-step/install-postinstall/usb-port-mapping) by chriswayg. A bit outdated but informative. Just ignore the stuff about `XhciPortLimit` Quirk and blocking ports via NVRAM!
- [**USBWakeFixup**](https://github.com/osy/USBWakeFixup) – Kext and SSDT for fixing USB Wake issues
- [**GUX-RyzenXHCIFix**](https://github.com/RattletraPM/GUX-RyzenXHCIFix) – `GenericUSBXHCI.kext` variant for fixing USB 3 issues on some APU-based Ryzentoshes running macOS 11.0 or newer.
- [**ACE: Apple Type-C Port Controller Secrets**](https://web.archive.org/web/20211023034503/https://blog.t8012.dev/ace-part-1/) (archived)
