# Technical Background

> **Update** (2023-06-12): `XhciPortLimit` Quirk is working again since OpenCore 0.9.3 (commit [d52fc46](https://github.com/acidanthera/OpenCorePkg/commit/d52fc46ba650ce1afe00c354331a0657a533ef18)) for macOS Big Sur and newer. Generating a USB port injector kext or mapping ports via ACPI is still highly recommended!

## Understanding the USB Port Limit

In macOS, the system imposes a strict limit of 15 available USB ports. This restriction poses a challenge for modern motherboards equipped with XHCI (Extensible Host Controller Interface) controllers, which can support up to 26 ports per controller. When USB ports are not properly mapped in macOS, both internal and external USB devices may default to USB 2.0 speeds or fail to function entirely. This issue extends to devices like Bluetooth, which operates as a "wireless" USB 2.0 connection and requires an internally assigned USB 2.0 port. Similarly, built-in laptop cameras depend on correct port mapping to work as intended.

A single physical USB 3 connector (typically the blue one) supports two distinct USB protocols, requiring two port assignments: "HS" (High Speed) for USB 2.0 and "SS" (Super Speed) for USB 3.0. Given macOS's 15-port limit, this effectively means you can map only seven USB 3.0 ports—each supporting both USB 2.0 and USB 3.0 protocols—plus one additional port for either HS or SS, and that's the maximum. Notably, macOS does not support USB 3.2 via the USB protocol; Apple relies on Thunderbolt for higher-speed connections instead. As a result, hackintosh users must carefully select and map their desired ports to ensure optimal functionality.

## USB Specs

| USB Version | Year | Signaling Rate | Current Name | Marketing Name | Controller | Notes |
|:-----------:|:----:|:--------------:|:------------:|:--------------:|:----------:|:-----|
| USB 1.0/1.1 | 1996 | 1.5 Mbps <br>12 Mbps | USB 1.0/1.1 | Low-Speed <br>Full-Speed | UHCI/OHCI | Dropped from macOS Ventura+. Critical for legacy keyboards and mice. [Workaround](https://dortania.github.io/OpenCore-Legacy-Patcher/VENTURA-DROP.html#usb-1-1-ohci-uhci-support). |
| USB 2.0     | 2000 | 480 Mbps       | USB 2.0     | High-Speed     | EHCI       | Requires USB port-mapping (via Kext or ACPI) for macOS compatibility. Backward compatible with USB 1.x. |
||
| USB 3.0     | 2008 | 5 Gbps         | USB 3.2 SuperSpeed Gen. 1 | USB 5Gbps | XHCI | Requires USB port-mapping (via Kext or ACPI). Backward compatible with USB 2.0. |
| USB 3.1     | 2013 | 10 Gbps        | USB 3.2 SuperSpeed+ Gen. 2 | USB 10Gbps | XHCI | Requires USB port-mapping (via Kext or ACPI). Backward compatible with USB 3.2 Gen 1x1 and USB 2.0. |
| USB 3.2     | 2017 | 20 Gbps        | USB 3.2 SuperSpeed+ Gen. 2x2 | USB 20Gbps | XHCI | Requires USB-C port and cable. Port-mapping and patched Thunderbolt controller may be needed for full functionality. Backward compatible with lower USB versions. |
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

## Removing the USB port limit and mapping USB ports

The workaround is to lift the USB port limit and use additional tools to generate a codeless kext containing a USB Port map with 15 ports of your choice. Prior to macOS Catalina, you could use the `XhciPortLimit` quirk to enable all 26 ports and you were good. Since macOS Catalina, you need to map USB ports, so your peripherals work correctly. There are two methods to do this.

---

[← Back to Overview](./README.md) | [Next: Method 1 - Tools →](02_method1_tools.md)
