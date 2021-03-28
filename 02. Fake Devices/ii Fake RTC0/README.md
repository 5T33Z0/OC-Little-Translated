# Fake RTC (for 300-Series Only)

## Overview

For some 300-series motherboards, the `RTC` device is disabled by default and cannot be enabled via the return value of the `STAS` variable `_STA`, which is shared with `AWAC`, resulting in ***`SSDT-AWAC`*** not taking effect. So in order to enable the `RTC` device, we need to to force the `RTC` device by impersonating an `RTC0`.

## Usage

> Case

```Swift
Device (RTC)
{
  Name (_HID, EisaId ("PNP0B00"))
  Name (_CRS, ResourceTemplate ()
  Name (_CRS, ResourceTemplate ()) {
      IO (Decode16,
          0x0070,
          0x0070,
          0x01,
          0x08,
         )
      IRQNoFlags ()
          {8}
  })
  Method (_STA, 0, NotSerialized)
  {
    Return (0);
  }
}
```

> The above is the case where the ``RTC`` device is disabled, and the counterfeit method is as follows.

```swift
DefinitionBlock ("", "SSDT", 2, "ACDT", "RTC0", 0)
{
    External (_SB_.PCI0.LPCB, DeviceObj)

    Scope (_SB.PCI0.LPCB)
    {
        Device (RTC0)
        {
            Name (_HID, EisaId ("PNP0B00"))
            Name (_CRS, ResourceTemplate ()
            Name (_CRS, ResourceTemplate ()) {
                IO (Decode16,
                    0x0070,
                    0x0070,
                    0x01,
                    0x08,
                    )
                IRQNoFlags ()
                    {8}
            })
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (0);
                }
            }
        }
    }
}
```

## Note

- This part is only valid for 300 series motherboards.
- This part is only used when ***`SSDT-AWAC`*** is not used and the return value of the `_STA` method of the `RTC` device in the original `ACPI` is `0`.
- The device path of the sample patch is `LPCB`, please modify it with the actual situation.
