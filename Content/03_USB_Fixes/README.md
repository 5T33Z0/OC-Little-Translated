# Fixing USB issues

## Overview
Comprehensive guide for resolving USB issues in macOS/Hackintosh systems, including port mapping, compatibility fixes, and troubleshooting.

> [!IMPORTANT]
>
> The XhciPortLimit Quirk is currently (OC v 1.0.7) not working in macOS Tahoe so you best use an older vesion of macOS for mapping USB Ports.

## Contents

1. [**Technical Background**](/Content/03_USB_Fixes/01_technical_background.md)
   - Understanding the 15-port USB limit in macOS
   - USB Specifications and controller types
   - Port mapping fundamentals

2. [**Method 1: Mapping USB Ports with Tools**](/Content/03_USB_Fixes/02_method1_tools.md)
   - **Option 1**: Mapping in Windows (recommended)
   - **Option 2**: Mapping in macOS
     - Using USBMap
     - Using Hackintool

3. [**Method 2: Mapping USB Ports via ACPI**](/Content/03_USB_Fixes/03_method2_acpi.md)
   - OS-agnostic ACPI-based USB port mapping (advanced users)

4. [**macOS Tahoe Compatibility**](/Content/03_USB_Fixes/04_tahoe_compatibility.md)
   - Adjusting USBMap kexts for macOS Tahoe
 
5. [**USB 3.0: determining if you need `XHCI-unsupported.kext`**](/Content/03_USB_Fixes/05_xhci_unsupported.md)

6. [**Additional Resources**](/Content/03_USB_Fixes/05_resources.md)
   - Useful tools and kexts
   - External guides and documentation

---

## Quick Start

- **New users**: Start with [Technical Background](/Content/03_USB_Fixes/01_technical_background.md) to understand USB port limitations, then proceed to [Method 1](/Content/03_USB_Fixes/02_method1_tools.md) for the easiest USB port mapping approach.

- **Advanced users**: Consider [Method 2 (ACPI)](/Content/03_USB_Fixes/03_method2_acpi.md) for an OS-agnostic solution.
