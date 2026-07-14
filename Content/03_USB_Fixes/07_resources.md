# Additional Resources

## Essential Tools and Kexts

### Utilities
- [USBMap](https://github.com/corpnewt/USBMap) – Python script for mapping USB ports in macOS and creating a custom injector kext.
- [Hackintool](https://github.com/benbaker76/Hackintool) – Utility with various Hackintosh tools, including automatic USB port discovery and generation of compliant USB port maps.
- [USBToolBox](https://github.com/USBToolBox/tool) – Windows application for creating custom USB port maps.
- [WhatCable](https://github.com/darrylmorley/whatcable) – macOS menu bar utility that displays the capabilities of connected USB-C cables, including USB data rate, charging, DisplayPort Alt Mode, and Thunderbolt support.

### Kexts
#### USBToolBox Kexts
- [USBToolBox kexts](https://github.com/USBToolBox/kext) consist of two kexts:
  - `USBToolBox.kext` – The main kext.
  - `UTBDefault.kext` – A codeless kext that attaches USBToolBox to all PCIe USB controllers. `UTBDefault.kext` is intended for use **before** creating a USB port map, allowing all ports to function (provided the port limit is not enforced). It is **not required** if you create your port map from the beginning (for example, using the Windows [USBToolBox](https://github.com/USBToolBox/tool) application) and should be removed once a custom port map is in use.

#### USBInjectAll Kext
- [**USBInjectAll.kext**](https://github.com/daliansky/OS-X-USB-Inject-All/releases) by daliansky
  - Updated version with IOKit Personalities for the latest SMBIOSes and USB Controllers
  - Includes support for 400 to 700-series mainboards
  - Contains approximately 9,300 lines of code (vs. 6,800 in the original 2018 version by Rehabman)
  - Contains `XHCIUnsupported.kext` (Download "Source Code (zip)" tp get it)

#### XHCIUnsupported kext
- Included in [**USBInjectAll.kext**](https://github.com/daliansky/OS-X-USB-Inject-All/releases) by daliansky &rarr; Click on „Source Code (zip)" to get it
- Or use the [**copy**](https://github.com/5T33Z0/OC-Little-Translated/raw/refs/heads/main/Content/03_USB_Fixes/kext/XHCI-unsupported.kext_0.9.2.zip) in my repo

## Guides and Documentation

### USB Port Mapping Guides
- [**Hackintool Port Mapping Guide**](https://chriswayg.gitbook.io/opencore-visual-beginners-guide/step-by-step/install-postinstall/usb-port-mapping) by chriswayg
  - Comprehensive visual guide for USB port mapping
  - **Note**: Some information about `XhciPortLimit` Quirk and blocking ports via NVRAM may be outdated

## Specialized Kexts and Fixes

### USB Wake Issues
- [**USBWakeFixup**](https://github.com/osy/USBWakeFixup)
  - Kext and SSDT for fixing USB Wake issues
  - Resolves sleep/wake problems related to USB devices

### Unsupported XHCI Controllers
- [**GenericUSBXHCI.kext**](https://github.com/RehabMan/OS-X-Generic-USB3)
  - Generic XHCI driver for controllers not supported by Apple's `AppleUSBXHCIPCI`
  - Originally by Zenith432, maintained by RehabMan
  - Use as a last resort only — has known limitations on macOS 11+ (USB mass storage and composite devices may not work correctly)

### AMD Ryzen Systems
- [**GUX-RyzenXHCIFix**](https://github.com/RattletraPM/GUX-RyzenXHCIFix)
  - Fork of `GenericUSBXHCI.kext` for fixing a boot-hang during XHCI initialization on some Ryzen APU-based hackintoshes (primarily Picasso/Renoir) running macOS 11.0+
  - Not a general USB fix — only relevant if the system hangs during XHCI init at boot

## Advanced Topics

### USB-C and Type-C Controllers
- [**ACE: Apple Type-C Port Controller Secrets**](https://web.archive.org/web/20211023034503/https://blog.t8012.dev/ace-part-1/) (archived)
  - Deep dive into Apple's Type-C port controller implementation
  - Advanced technical information for USB-C troubleshooting

## Community Resources

For additional help and community support:
- Check the [Hackintosh subreddit](https://www.reddit.com/r/hackintosh/)
- Visit the [Dortania Discord](https://discord.gg/dortania)
- Browse [tonymacx86 forums](https://www.tonymacx86.com/)



---

[← Previous: GenericUSBXHCI](06_GenericUSBXHCI.md) | [Back to Overview](./README.md)
