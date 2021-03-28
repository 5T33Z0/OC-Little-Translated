# Counterfeit Devices

## Overview

Among the many `SSDT` patches, a significant number of them can be categorized as spoofed device patches, such as

- Some devices do not exist in ACPI, but are required by the MAC system. Patches that correctly describe these devices can load device drivers. For example, "05-2-PNLF Injection Method", "Adding Missing Parts", "Spoofing Ethernet", etc.
- EC issues. Such as "Counterfeit EC".
- For some special devices, using a method that prohibits the original device from impersonating it again will make it easier for us to adjust the patch. Such as "OCI2C-TPXX Patching Method".
- A device is disabled for some reason, but the MAC system needs it to work. See `this chapter` for an example.
- In most cases, devices can also be enabled using the Binary Renaming and Preset Variables.

## Counterfeit Devices

- Features
  
  - The impersonated device already exists in ACPI, and is relatively short, small, and self-contained in code.  
  - The original device has a canonical `_HID` or `_CID`.
  - Even if the original device is not disabled, patching with a counterfeit device will not harm ACPI.
  
- Requirements

  - The counterfeit device name is **different** from the original device name of ACPI.
  - Patch content and original device main content **identical**.
  - The ``_STA`` section of the counterfeit patch should include the following to ensure that windows systems use the original ACPI.

    ```Swift
        Method (_STA, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                ...
                Return (0x0F)
            }
            Else
            {
                Return (Zero)
            }
        }
    ```
  
- Example
  - ***SSDT-RTC0*** - Counterfeit RTC
  - Original device name: RTC
  - _HID: PNP0B00

    **Note** : The `LPCB` name should be the same as the original ACPI name.
