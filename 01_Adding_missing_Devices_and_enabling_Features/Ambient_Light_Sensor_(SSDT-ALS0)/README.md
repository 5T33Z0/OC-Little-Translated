# Enabling an Ambient Light Sensor (`ALSD`) or adding a fake one (`ALS0`)

## Overview
Starting with macOS Catalina, Laptops either require a fake ambient light sensor device (`ALS0`) or if the Laptop has one, `ALSD` needs to be enabled for macOS for storing the current brightness/auto-brightness level. Otherwise, the brightness returns to maximum after each reboot.

**NOTE**: The official OpenCore package contains a pre-compiled `SSDT-ALS0.aml` under "Docs". So in case you're not sure what to do you could also use it instead.

## Usage
There are two possible cases: 

1. `DSDT` has an ambient light sensor (usually called `ALSD`) 
2. `DSDT` doesn't have one (we add a fake `ALS0`)

In the `DSDT`, search for `ACPI0008`. If the device – usually named `ALSD` – exists, follow the instruction for "Case 1", if it doesn't exist follow the instructions for "Case 2".

### Case 1: Ambient Light Sensor device interface exists
As you can see in the code snippet below, Device `ALSD` exist in the system's `DSDT`:

```swift
Device (ALSD)
{
  Name (_HID, "ACPI0008" /* Ambient Light Sensor Device */)  // _HID: Hardware ID
  Method (_STA, 0, NotSerialized)  // _STA: Status
  {
    If ((ALSE == 0x02))
    {
      Return (0x0B)
    }

    Return (Zero)
  }

  Method (_ALI, 0, NotSerialized)  // _ALI: Ambient Light Illuminance
  {
    Return (((LHIH << 0x08) | LLOW))
  }

  Name (_ALR, Package (0x05)  // _ALR: Ambient Light Response
  {
    Package (0x02)
    {
      0x46,
      Zero
    },

    Package (0x02)
    {
      0x49,
      0x0A
    },

    Package (0x02)
    {
      0x55,
      0x50
    },

    Package (0x02)
    {
      0x64,
      0x012C
    },

    Package (0x02)
    {
      0x96,
      0x03E8
    }
  })
```
In this case, `ALS0` can be enabled by using `_STA` method to return `0x0B` to enable the ambient sensor devices present in the original `ACPI`, as follows (use `SSDT-ALSD`):

```swift
DefinitionBlock ("", "SSDT", 2, "OCLT", "ALSD", 0)
{
    External (ALSE, IntObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            ALSE = 2       
        }
    }
}
```
### 2. No Ambient Light Sensor device interface exists
In this case, we need a fake `ALS0` device:

```swift
DefinitionBlock ("", "SSDT", 2, "ACDT", "ALS0", 0)
{
    Scope (_SB)
    {
        Device (ALS0)
        {
            Name (_HID, "ACPI0008")
            Name (_CID, "smc-als")
            Name (_ALI, 0x012C)
            Name (_ALR, Package (0x01)
            Name (_ALR, Package (0x01)) {
                Package (0x02)
                {
                    0x64,
                    0x012C
                }
            })
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
        }
    }
}
```
## NOTES
- It's okay to add a fake `ALS0`, even if an ambient light sensor exists in the original `ACPI`.
- The corrected `Variable` may exist in multiple places and correcting it may affect other components while achieving our desired effect.
- When there is an ambient light sensor device in the original `ACPI`, the name may not be `ALSD`, although no other name has been found yet. If so, adjust the path in the SSDT accordingly.
- If an ambient light sensor device exist in the original `DSDT` that you want to force-enable, you need to pay attention to `_SB.INI`. If it exists, please use method 2 to add a fake `ALS0`.
