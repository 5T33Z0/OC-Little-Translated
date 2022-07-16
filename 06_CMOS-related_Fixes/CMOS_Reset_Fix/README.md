# CMOS Reset Fix

## Description

- Some machines will report a  **"Boot Self Test Error"** when shutting down or rebooting, due to a CMOS Reset.
- When using Clover, checking `ACPI\FixRTC` will resolve this issue.
- When using OpenCore however, the following official solution is provided, see ***Sample.plist***.
  - Install **RTCMemoryFixup.kext**
  - `Kernel\Patch` patch: **__ZN11BCM5701Enet14getAdapterInfoEv**
- This chapter provides an SSDT patch method to solve the above problem. This SSDT patch is essentially an impersonation of the RTC, see the section "01. Adding Fake Devices".

## Solution

- Remove the **interrupt number** from **RTC `PNP0B00`** part `_CRS`.

  ```asl
  Device (RTC)
  {
      Name (_HID, EisaId ("PNP0B00"))
      Name (_CRS, ResourceTemplate ()
      Name (_CRS, ResourceTemplate ()) {
          IO (Decode16,
              0x0070,
              0x0070,
              0x01,
              0x08, /* or 0x02, test to be sure */
              )
          IRQNoFlags () /* Delete this line */
              {8} /* Delete this line */
      })
  }
  ```

## Patch: SSDT-RTC0-NoFlags

- Disable the original part: **RTC**
  - If **RTC** does not exist ``_STA``, disable **RTC** using the following.
  
    ```asl
    External(_SB.PCI0.LPCB.RTC, DeviceObj)
    Scope (_SB.PCI0.LPCB.RTC)
    RTC) {
        Method (_STA, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                Return (Zero)
            }
            Else
            {
                Return (0x0F)
            }
        }
    }
    ```
  
  - If `_STA` is present in **RTC**, use the preset variable method to disable **RTC**. The variable in the example is `STAS` and should be used with care about the effect of `STAS` on other devices and components.
  
    ```asl
    External (STAS, FieldUnitObj)
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            STAS = 2
        }
    }
    ```

- Counterfeit **RTC0** , see sample.

## Notes
- The device name and path in the patch should be identical to the original ACPI.
- If the machine itself has disabled the RTC for some reason, an fake RTC is required for it to work properly. In the case that a **"Boot self-test error"** occurs, remove the interrupt number of the impersonation patch:

  ```asl
    IRQNoFlags () /* delete this line */
        {8} /* Delete this line */
  ```

**Thanks** @Chic Cheung, @Noctis for all your hard work!
