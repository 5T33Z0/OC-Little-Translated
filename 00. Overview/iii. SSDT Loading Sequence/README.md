# SSDT Loading Sequence

Typically, SSDT patches are targeted at the machine's ACPI (either the DSDT or other SSDTs). Since the original ACPI is loaded prior to SSDT patches, there is no need for SSDTs in the `Add` list to be loaded in a specific order. But there is an exceptions to this rule…
    
For example, if you have 2 SSDTs (SSDT-X and SSDT-Y), where SSDT-X defines a `device` which SSDT-Y is "cross-referencing" via a `Scope`, then these the two patches have to be loaded in the correct order/sequence for the whole patch to work. Generally speaking, SSDTs being "scoped" into have to be loaded prior to the ones "scoping".

## Example

- **Patch 1**：***SSDT-XXXX-1.aml***
  
  ```swift
  External (_SB.PCI0.LPCB, DeviceObj)
  Scope (_SB.PCI0.LPCB)
  {
      Device (XXXX)
      {
          Name (_HID, EisaId ("ABC1111"))
      }
  }
  ```
  
- **Patch 2**：***SSDT-XXXX-2.aml***

  ```swift
  External (_SB.PCI0.LPCB.XXXX, DeviceObj)
  Scope (_SB.PCI0.LPCB.XXXX)
  {
        Method (YYYY, 0, NotSerialized)
       {
           /* do nothing */
       }
    }
  ```
  
- SSDT Loading Sequence in `config.plist` under `ACPI > Add`: 

  ```XML
  Item 1
            path    <SSDT-XXXX-1.aml>
  Item 2
            path    <SSDT-XXXX-2.aml>
  ```
  