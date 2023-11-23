# ACPI Device IDs

Plug and Play ID | Description
-----------------|------------
`PNP0C08` | **ACPI**. Not declared in ACPI as a device. This ID is used by OSPM for the hardware resources consumed by the ACPI fixed register spaces, and the operation regions used by AML code. It represents the core ACPI hardware itself.
`PNP0A05` | **Generic Container Device**. A device whose settings are totally controlled by its ACPI resource information, and otherwise needs no device or bus-specific driver support. This was originally known as Generic ISA Bus Device. This ID should only be used for containers that do not produce resources for consumption by child devices. Any system resources claimed by a PNP0A05 device’s `_CRS` object must be consumed by the container itself.
`PNP0A06`| **Generic Container Device**. This device behaves exactly the same as the PNP0A05 device. This was originally known as Extended I/O Bus. This ID should only be used for containers that do not produce resources for consumption by child devices. Any system resources claimed by a PNP0A06 device’s `_CRS` object must be consumed by the container itself.
`PNP0C09`| **Embedded Controller Device**. A host embedded controller controlled through an ACPI-aware driver.
`PNP0C0A` | **Control Method Battery**. A device that solely implements the ACPI Control Method Battery functions. A device that has some other primary function would use its normal device ID. This ID is used when the devices primary function is that of a battery.
`PNP0C0B` | **Fan**. A device that causes cooling when “on” (D0 device state).
`PNP0C0C` | **Power Button Device******. A device controlled through an ACPI-aware driver that provides power button functionality. This device is only needed if the power button is not supported using the fixed register space.
`PNP0C0D`| **Lid Device**. A device controlled through an ACPI-aware driver that provides lid status functionality. This device is only needed if the lid state is not supported using the fixed register space.
`PNP0C0E`| **Sleep Button Device**. A device controlled through an ACPI-aware driver that provides power button functionality. This device is optional.
`PNP0C0F`| **PCI Interrupt Link Device**. A device that allocates an interrupt connected to a PCI interrupt pin. See Section 6.2.13 for more details.
`PNP0C80`| **Memory Device.** This device is a memory subsystem.
`ACPI0001`| **SMBus 1.0 Host Controller.** An SMBus host controller (SMB-HC) compatible with the embedded controller-based SMB-HC interface (see Section 12.9), and implementing the SMBus 1.0 Specification.
`ACPI0002`|Smart Battery Subsystem. The Smart battery Subsystem specified in Section 10, “Power Source Devices.”
`ACPI0003`|**Power Source Device.** The Power Source device specified in Section 10, “Power Source Devices.” This can represent either an AC Adapter (on mobile platforms) or a fixed Power Supply.
`ACPI0004`| **Module Device**. This device is a container object that acts as a bus node in a namespace. A Module Device without any of the `_CRS`, _PRS and `_SRS` methods behaves the same way as the Generic Container Devices (PNP0A05 or PNP0A06). If the Module Device contains a `_CRS` method, only these resources described in the `_CRS` are available for consumption by its child devices. Also, the Module Device can support `_PRS` and `_SRS` methods if `_CRS` is supported.
`ACPI0005`| **SMBus 2.0 Host Controller**. An SMBus host controller (SMB-HC compatible with the embedded controller-based SMB-HC interface (see Section 12.9), and implementing the SMBus 2.0 Specification.
`ACPI0006`|**GPE Block Device**. This device allows a system designer to describe GPE blocks beyond the two that are described in the FADT.
`ACPI0007`|**Processor Device**. This device provides an alternative to declaring processors using the processor ASL statement. See Section 8.4 for more details.
`ACPI0008`|Ambient Light Sensor Device. This device is an ambient light sensor. See Section 9.3.
`ACPI0009`| **I/OxAPIC Device**. This device is an I/O unit that complies with both the APIC and SAPIC interrupt models.
`ACPI000A`|**I/O APIC Device**. This device is an I/O unit that complies with the APIC interrupt model.
`ACPI000B`|**I/O SAPIC Device**. This device is an I/O unit that complies with the SAPIC interrupt model.
`ACPI000C`|**Processor Aggregator Device**. This device provides a control point for all processors in the platform. See Section 8.5.
`ACPI000D`|**Power Meter Device**. This device is a power meter. See Section 10.4.
`ACPI000E`|**Time and Alarm Device**. This device is a control method-based real-time clock and wake alarm. See Section 9.17.
`ACPI000F`|**User Presence Detection Device**. This device senses user presence (proximity). See Section 9.15)
`ACPI0010`|**Processor container device**. Used to declare hierarchical processor topologies (see Section 8.4.2, and Section 8.4.2.1).
`ACPI0011`|**Generic Buttons Device**. This device reports button events corresponding to Human Interface Device (HID) control descriptors (see Section 9.18).
`ACPI0012`|**NVDIMM Root Device.** This device contains the NVDIMM devices. See Section 9.19 and Table 5.126.
`ACPI0013`|**Generic Event Device**. This device maps Interrupt-signaled events. See Section 5.6.9.
`ACPI0014`|**Wireless Power Calibration Device**. This device uses user presence and notification.
`ACPI0015`| **USB4 host interface device**. See Links to ACPI-Related Documents under the heading “USB4 Host Interface Specification”
`ACPI0016`| **Compute Express Link Host Bridge**. This device is a Compute Express Link Host bridge.
`ACPI0017`| **Compute Express Link Root Object**. This device represents the root of a CXL capable device hierarchy. It shall be present whenever the platform allows OSPM to dynamically assign CXL endpoints to a platform address space.
`ACPI0018` | **Audio Composition Device**. This is an ACPI-enumerated device that describes audio component logical connection information within a system.

**SOURCE**: [**ACPI Specs**](https://uefi.org/specifications), **Chpt. 5.6.7**: "Device Class-Specific Objects"
