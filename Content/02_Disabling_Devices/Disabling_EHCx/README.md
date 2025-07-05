# Disabling `EHCx` USB Controllers

**INDEX**

- [About](#about)
- [Use cases](#use-cases)
- [System Requirements](#system-requirements)
- [Patch](#patch)
- [Technical Background: `EHCI` and `XHCI`](#technical-background-ehci-and-xhci)
  - [USB Specs](#usb-specs)
- [Notes](#notes)

---

## About
SSDTs for disabling `EHC1` and `EHC2` USB 2.0 Controllers used in 1st to 5th Gen Intel systems.

## Use cases

`EHC1` and `EHC2` controller can be disabled in one of the following cases:

- The DSDT contains `EHC1` and/or `EHC2` controllers but the machine does not have the associated hardware.
- The DSDT contains `EHC1` and/or `EHC2`, the actual hardware controllers exist but no ports are mapped to it (externally or internally).

## System Requirements

- Machines prior to Skylake: if you cannot enable `XHCI Mode`in BIOS and the conditions of the **use cases** are met, use the patches listed below.
- For 7th Gen Intel Core or newer with macOS 10.11 or higher (if `EHC1`/`EHC2` is present in the DSDT)
- ***SSDT-EHC1_OFF*** and ***SSDT-EHC2_OFF*** cannot be used together.
- The patch adds `_INI` method under `Scope (\)`, if it clashes with `_INI` methods of other patches, the contents of `_INI` should be merged.

## Patch
- ***SSDT-EHC1_OFF***: Disables `EHC1`.
- ***SSDT-EHC2_OFF***: Disables `EHC2`.
- ***SSDT-EHCx_OFF***: Combined patch of ***SSDT-EHC1_OFF*** and ***SSDT-EHC2_OFF***.

## Technical Background: `EHCI` and `XHCI`

`EHCI` (Enhanced Host Controller Interface) is the host controller interface for USB 2.0. It was developed to enhance the capabilities of the original **USB 1.1** standard, which had a limited data transfer rate (see chart below). EHCI increased the data transfer rate with the **USB 2.0** standard. EHCI was supported from Nehalem (1st Gen Intel Core) up to Skylake (6th Gen Intel Core). 

From Ivy Bridge onward, EHCI was used in tandem with `XHCI` (eXtensible Host Controller Interface), allowing both USB 2.0 and **USB 3.0** devices to be connected simultaneously. EHCI was used to handle USB 2.0 devices, while XHCI was used for USB 3.0 devices.

With the release of the Skylake family, `EHCI` was dropped, since `XHCI` is backwards compatible and supports both USB 2.0 and 3.0 devices. 

### USB Specs

USB Standard | Speed | Controller | macOS support 
------------:|-------|:----------:|:---------------:
USB 1.1      | 12 Mbps | UHCI/OHCI |  ≤ macOS 12
USB 2.0      | 480 Mbps |EHCI | OSX 10.2+ 
USB 3.0 (aka USB 3.1 Gen 1)| 5 Gbps | XHCI | OSX 10.6.6+
USB 3.1 Gen 2| 10 Gbps | XHCI | –
USB 4        | 40 Gbps | PCIe | –

> [!NOTE]
> 
> Instead of USB 3.1 Gen 2 and USB 4, Apple uses Thunderbolt 3 and 4 which utilize the PCIe protocol to achieve these high transfer rates.

## Notes
- If your system is a pre 6th Gen Laptop and supports a docking station which offers additional USB 2 and USB 3 ports, it's most likely that both `EHCI` controllers are used on your machine so don't disable them!
- The official OpenCore Package contains a similar ACPI Patch called `SSDT-EHCx-DISABLE`.


