# Fixing USB Issues

## Overview

A guide to resolving USB issues in macOS and Hackintosh systems, covering USB port mapping, compatibility fixes, and troubleshooting.

> [!IMPORTANT]
> 
> On macOS Tahoe, the `XhciPortLimit` quirk requires OpenCore 1.0.7 or newer to work. This quirk is intended as a temporary workaround during port discovery, not as a replacement for a proper USB port map. Disable it once your port map is in place.

## Contents

1. [**Introduction to USB Port Mapping**](/Content/03_USB_Fixes/01_technical_background.md)
   - Why USB port mapping is necessary
   - Understanding the 15-port limit in macOS
   - USB controller types, protocols, and transfer speeds
   - USB port mapping methods: kext vs. ACPI

2. [**Method 1: USB Port Mapping with a Kext**](/Content/03_USB_Fixes/02_method1_tools.md)
   - Option 1: Mapping in Windows (recommended)
   - Option 2: Mapping in macOS
     - Using USBMap
     - Using Hackintool

3. [**Method 2: USB Port Mapping via ACPI**](/Content/03_USB_Fixes/03_method2_acpi.md)
   - OS-agnostic USB port mapping using ACPI (advanced users)

4. [**macOS Tahoe Compatibility**](/Content/03_USB_Fixes/04_tahoe_compatibility.md)
   - Adapting USBMap kexts for macOS Tahoe

5. [**USB 3.x Compatibility: Do You Need `XHCI-unsupported.kext`?**](/Content/03_USB_Fixes/05_xhci_unsupported.md)

6. [**`GenericUSBXHCI.kext` and `GUX-RyzenXHCIFix`**](/Content/03_USB_Fixes/06_GenericUSBXHCI.md)

7. [**Additional Resources**](/Content/03_USB_Fixes/07_resources.md)
   - Useful tools and kexts
   - External guides and documentation

## Which Method Should I Use?

- **First-time users:** Start with the [**Introduction to USB Port Mapping**](/Content/03_USB_Fixes/01_technical_background.md) to understand the basics. Then follow [**Method 1: USB Port Mapping with a Kext**](/Content/03_USB_Fixes/02_method1_tools.md), which covers the recommended workflow using dedicated mapping tools.

- **Advanced users:** Consider [**Method 2: USB Port Mapping via ACPI**](/Content/03_USB_Fixes/03_method2_acpi.md) if you prefer an ACPI-based solution that does not depend on a USB port-mapping kext.

- **Users with existing USB maps:** Consult [**macOS Tahoe Compatibility**](/Content/03_USB_Fixes/04_tahoe_compatibility.md) when adapting an existing configuration to Tahoe.

- **Users troubleshooting specific controllers:** See the sections on [`XHCI-unsupported.kext`](/Content/03_USB_Fixes/05_xhci_unsupported.md) and [GenericUSBXHCI.kext](/Content/03_USB_Fixes/06_GenericUSBXHCI.md) for controller-specific compatibility issues.
