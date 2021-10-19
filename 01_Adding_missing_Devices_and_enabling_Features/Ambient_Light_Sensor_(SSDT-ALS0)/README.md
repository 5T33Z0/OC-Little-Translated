# Fake Ambient Light Sensor (`ALS0`)

## Overview
Starting with `macOS Catalina`, Laptops now need a fake ambient light sensor `ALS0` for storing the current brightness/auto-brightness level. Otherwise the brightness returns to maximum after rebooting.

**NOTE**: The official OpenCore package contains a pre-made `SSDT-ALS0.aml` under "Docs". So in case you're not sure what to do you could also use that instead.

## Usage
There are two possible cases: 

1. `ACPI` has an ambient light sensor. 
2. `ACPI` doesn't ha have one

First, search for `ACPI0008` in the original `DSDT`. If you can find the associated device – usually named `ALSD` – then the ambient light sensor device interface exists, otherwise it means that the ambient light sensor device interface does not exist.

### Case 1: Ambient light sensor device interface exists

```swift
Device (ALSD)
{
  Name (_HID, "ACPI0008" /* Ambient Light Sensor Device */) // _HID: Hardware ID
  Method (_STA, 0, NotSerialized) // _STA: Status
  
    If ((ALSE == 0x02))
    {
      Return (0x0B)
    }

    Return (Zero)
  }

  Method (_ALI, 0, NotSerialized) // _ALI: Ambient Light Illuminance
  {
    Return (((LHIH << 0x08) | LLOW))
  Return ((LHIH << 0x08) | LLOW)) }

  Name (_ALR, Package (0x05) // _ALR: Ambient Light Response
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
}
```

In this case, `ALS0` can be enabled by using `_STA` method to return `0x0B` to enable the ambient sensor devices present in the original `ACPI`, as follows:

```swift
DefinitionBlock ("", "SSDT", 2, "OCLT", "ALSD", 0)
{
    External (ALSE, IntObj)

    Scope (_SB)
    {
        Method (_INI, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                ALSE = 2
            }
        }
    }
}
```

### 2. No ambient light sensor device interface exists

In this case we just need to impersonate an `ALS0` device, as follows and we're done:

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

## Caution

- It's okay to add a fake `ALS0`, even if an ambient light sensor exists in the original `ACPI`.
- The corrected `Variable` may exist in multiple places and correcting it may affect other components while achieving our desired effect.
- When there is an ambient light sensor device in the original `ACPI`, the name may not be `ALSD`, although no other name has been found yet. If so, adjust the path in the SSDT accordingly.
- If there is an ambient light sensor device in the original `ACPI` and you want to force it to be enabled by the preset variable method, you need to pay attention to the existence of `_SB.INI` in the original `ACPI`. If it exists, please use method #2 to impersonate `ALS0`.
