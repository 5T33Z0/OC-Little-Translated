# Introduction to USB Port Mapping

USB port mapping is an essential step when configuring macOS on non-Apple hardware. It ensures that macOS correctly identifies the available USB ports, uses the appropriate transfer speeds, and handles internal and external USB devices reliably.

This chapter introduces the concepts behind USB port mapping, explains the limitations imposed by macOS, and outlines the available mapping methods. The following documents cover the tools and procedures required to create and implement a port map.

## Why USB Port Mapping Is Necessary

Unlike Windows, macOS does not automatically discover and configure every USB port on arbitrary PC hardware. It relies on the USB controllers and port topology presented to it by the platform firmware and its own drivers. On a Hackintosh, the selected SMBIOS and ACPI configuration help define the hardware environment macOS expects.

As a result, some physical ports may not work correctly, USB 3 devices may fall back to USB 2 speeds, or internal USB devices may stop functioning as expected.

USB port mapping explicitly defines which ports macOS should expose under the relevant USB controller, ensuring that the configuration matches the actual hardware and stays within macOS's port limit.

**Correct mapping helps ensure that**:

- USB 2 and USB 3 devices operate at their intended speeds.
- All required physical ports remain functional.
- Internal USB devices, such as Bluetooth modules and built-in webcams, are assigned correctly.
- USB devices behave reliably across reboots and sleep/wake cycles.
- The configuration stays within macOS's USB port limit.

## Understanding the USB Port Limit

macOS imposes a limit of **15 USB ports per USB controller** in the relevant USB port-mapping architecture. Modern XHCI controllers can expose more ports than this, so a motherboard may have more ports available than macOS can use without a proper configuration.

The limit applies to the logical ports exposed to macOS, not simply to the number of physical USB connectors on the motherboard.

### Physical connectors vs. logical ports

A physical USB 3 connector generally provides two logical port entries:

- **HS (High-Speed):** Handles USB 2.0 and slower USB devices.
- **SS (SuperSpeed):** Handles USB 3.x devices.

For example, connecting a USB 2 device to a USB 3 connector uses its HS path, while connecting a USB 3 device uses its SS path. Both entries count toward the 15-port limit, even though they share one physical connector.

This is why a motherboard with eight USB 3 connectors can require 16 logical port entries before accounting for any additional USB 2-only connectors or internal devices.

A port map must therefore prioritize the ports that are actually needed. Unused ports can be excluded to keep the configuration within the limit.

> [!IMPORTANT]
> The `XhciPortLimit` quirk is not a substitute for a proper port map. Although its behavior has varied across macOS releases and OpenCore versions, it should not be relied upon as a permanent solution. A correctly configured USB port map is the recommended approach.

## USB Controllers, Protocols and Speeds

Before mapping ports, it helps to understand three related but distinct concepts:

- **USB controller:** The hardware that manages USB communication.
- **USB protocol and speed:** The communication standard and data rate supported by a device and its connection.
- **USB port:** A connection exposed by a controller to which a device can be attached.

The controller determines which ports are available to macOS, while the protocol and speed determine how connected devices communicate.

### USB controller types

Most modern Intel-based Hackintosh systems use XHCI controllers. Older hardware may also use UHCI, OHCI or EHCI controllers.

| Controller | Protocol support | macOS support | Relevance to port mapping |
|---|---|---|---|
| UHCI | USB 1.0/1.1 — Low-Speed and Full-Speed | Legacy support; USB 1.1 controller support was removed in macOS Ventura 13 | Primarily relevant to older hardware |
| OHCI | USB 1.0/1.1 — Low-Speed and Full-Speed | Legacy support; USB 1.1 controller support was removed in macOS Ventura 13 | Primarily relevant to older hardware |
| EHCI | USB 2.0 — High-Speed; slower devices may use companion controllers or hubs | Supported on compatible hardware | Common on older systems |
| XHCI | USB 1.1, USB 2.0 and USB 3.x, depending on implementation | Supported on compatible hardware | The primary focus of modern USB port mapping |
| VHCI | Virtual USB; capabilities depend on implementation | Implementation-dependent | Generally outside the scope of physical motherboard port mapping |
| USB4 host router | USB4 transport and protocol tunneling | Depends on hardware and macOS support | A separate architecture; not a replacement for ordinary XHCI port mapping |

For most modern Hackintosh systems, the important controller is **XHCI**. A single XHCI controller can expose both USB 2 and USB 3 logical ports.

Controller names such as `XHC`, `XHC0` or `XHCI` are commonly found in ACPI tables and IORegistry. The actual controller and port topology should be verified on the target system rather than inferred from the motherboard's physical connectors alone.

### USB protocols and transfer speeds

| USB generation | Maximum signaling rate | Common controller | Notes |
|---|---:|---|---|
| USB 1.0/1.1 | 1.5 / 12 Mbps | UHCI / OHCI | Legacy Low-Speed and Full-Speed devices |
| USB 2.0 | 480 Mbps | EHCI / XHCI | High-Speed devices; also supports slower USB 1.x devices |
| USB 3.0 / USB 3.2 Gen 1 | 5 Gbps | XHCI | SuperSpeed |
| USB 3.1 / USB 3.2 Gen 2 | 10 Gbps | XHCI | SuperSpeedPlus |
| USB 3.2 Gen 2x2 | 20 Gbps | XHCI, where supported | Requires compatible hardware, connection and cable |
| USB4 | Up to 40 Gbps in common implementations | USB4 host router and related controller architecture | Supports tunneling of USB and other protocols |
| USB4 Version 2.0 | Up to 80 Gbps, with an optional asymmetric 120 Gbps mode | Compatible USB4 host router | Requires supporting hardware and connections |

The USB generation alone does not guarantee a particular speed. The controller, device, port, cable and connection mode must all support the required capability.

> [!NOTE]
> USB4 and Thunderbolt involve additional controller and tunneling architectures. They are not simply higher-speed XHCI ports, and their functionality should be evaluated separately from conventional USB 2/3 port mapping.

---

## Choosing a USB Port Mapping Method

There are two principal approaches to USB port mapping on macOS. Both methods serve the same fundamental purpose: exposing the intended ports to macOS within the applicable limits. Neither eliminates the need to identify the correct controller and verify the actual port topology:

### USB port mapping with a kext

A USB port-mapping kext, typically generated with a dedicated mapping tool, defines the ports that macOS should expose through the relevant USB controller. This is a widely used approach and is suitable for many Hackintosh configurations. However, the mapping is associated with the relevant controller and USB configuration, and USB maps commonly depend on the selected SMBIOS.

### ACPI-based USB port mapping

An ACPI-based port map declares the relevant USB ports in an SSDT, allowing the port definitions to be provided through ACPI rather than a dedicated USB port-mapping kext. This approach can be useful when you want to keep the mapping in ACPI and avoid tying the port map to a particular SMBIOS in the same way as a conventional kext-based map.

The following documents explain how to identify the available ports, choose a mapping method, and implement and verify the resulting configuration.

---

[← Back to Overview](./README.md) | [Next: Method 1 – Kext →](02_method1_tools.md)
