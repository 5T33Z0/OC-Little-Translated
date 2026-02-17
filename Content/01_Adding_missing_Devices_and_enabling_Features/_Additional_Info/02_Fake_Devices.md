## Properties of Virtual Devices
- **Features**:
  - The device already exists in the ACPI system, is relatively small and self-contained in code.  
  - The original device has a canonical **`_HID`** or **`_CID`** parameter.
  - Even if the original device is not disabled, adding a virtual device while macOS is running will not cause conflicts.
- **Requirements**:
  - The name of the fake/virtual device ***differs*** from the original device name used in the ACPI table.
  - Patch content and original device main content are **identical**.
  - The **`_STA`** method of the hotpatch must contain the [**`If (_OSI ("Darwin"))`**](https://uefi.org/specs/ACPI/6.4/05_ACPI_Software_Programming_Model/ACPI_Software_Programming_Model.html#osi-operating-system-interfaces) method to ensure that the patch is only applied to macOS (Darwin Kernel):
	```asl
	Method (_STA, 0, NotSerialized)
       {
            If (_OSI ("Darwin"))
            {
                Return (0x0F)
            }
            Else
            {
                Return (Zero)
            }
        }
	```
- **Example**: [**Fixing IRQ Conflicts**](/Content/01_Adding_missing_Devices_and_enabling_Features/IRQ_and_Timer_Fix_(SSDT-HPET))

> [!IMPORTANT]
>
> The name and path of the [**Low Pin Count Bus**](https://www.intel.com/content/dam/www/program/design/us/en/documents/low-pin-count-interface-specification.pdf) used in an `SSDT` – usually `LPC` or `LPCB` – must match the one used in the original ACPI tabled in order for a patch to work!

[←**Back to Overview**](./README.md) | [**Next: Obtaining ACPI Tables →**](03_Dump_ACPI.md)
