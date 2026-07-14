# Thunderbolt Support in macOS

> [!WARNING]
> 
> **Work in Progress**

## Introduction

This section collects useful resources for enabling and troubleshooting Thunderbolt on Hackintosh systems. Rather than being a complete guide, it serves as a reference to firmware repositories, patching tools, SSDTs, and utilities commonly used to achieve full Thunderbolt functionality under macOS.

Although macOS includes native support for Intel Thunderbolt controllers, retail PC implementations differ from those found in genuine Macs. Differences in controller firmware (NVM), ACPI implementation, security settings, and device initialization often prevent Thunderbolt from working as expected.

For many **Alpine Ridge** and **Titan Ridge** controllers, flashing an Apple-compatible or custom NVM firmware is required to unlock full functionality. Depending on the hardware, additional ACPI patches, SSDTs, or helper kexts may also be necessary.

Without the proper firmware and configuration, you may encounter one or more of the following issues:

- Thunderbolt devices are not detected
- Hot-plug is unavailable
- DisplayPort passthrough does not work
- USB-C functionality is limited or unavailable
- Thunderbolt Networking is unavailable
- PCIe tunneling is unavailable
- Sleep and wake behavior is unreliable

Because Thunderbolt support depends on both firmware and macOS compatibility, major macOS updates may require updated firmware, SSDTs, or helper tools.

---

## Further Resources

### Documentation & Guides

- **InsanelyMac – Thunderbolt Drivers**: [Forum Thread](https://www.insanelymac.com/forum/topic/323540-thunderbolt-drivers/)  
  Extensive discussion covering Thunderbolt support on Hackintosh systems, including Alpine Ridge and Titan Ridge controllers, firmware flashing, NVM modifications, hot-plug support, SSDTs, security settings, and troubleshooting.

- **EliteMacx86 – How to Enable Thunderbolt 3 Hotplug on macOS**: [Guide](https://elitemacx86.com/threads/how-to-enable-thunderbolt-3-hotplug-on-macos.462/)  
  Guide covering Thunderbolt hot-plug configuration and required macOS settings.

### Firmware

- **Thunderbolt Firmware Repository**: [GitHub Repository](https://github.com/utopia-team/Thunderbolt)  
  Collection of Apple and custom Thunderbolt NVM firmware for Alpine Ridge and Titan Ridge controllers.

### ACPI & Configuration

- **HackinDROM Thunderbolt SSDTs**: [HackinDROM](https://hackindrom.zapto.org/)  
  Collection of sample Thunderbolt SSDTs and ACPI examples for different controllers and motherboard configurations.

### Tools & Patches

- **ThunderboltReset**: [GitHub Repository](https://github.com/osy/ThunderboltReset)  
  Kext for disabling the Intel Connection Manager (ICM) on Alpine Ridge controllers, allowing macOS to initialize and manage the Thunderbolt controller.

- **ThunderboltPatcher**: [GitHub Repository](https://github.com/osy/ThunderboltPatcher)  
  Patching utility for improving compatibility of unsupported Thunderbolt controllers with macOS.
  
- **WhatPort**: [GitHub Repository](https://github.com/darrylmorley/whatport)  
  Lightweight macOS menu bar utility that displays real-time USB-C and Thunderbolt port information.
