# CMOS Reset Fix

- Some machines will report a **"Boot Self Test Error"** when shutting down or rebooting, due to a CMOS Reset triggered by macOS.
- When using Clover, checking `ACPI/DSDT/Fixes/FixRTC` will resolve this issue.
- When using OpenCore, there are 2 Methods available – use either or.

## Method 1: Using a Kext and a Kernel Patch 
This is the official method suggested by the OpenCore developers.

- Add [**RTCMemoryFixup.kext**](https://github.com/acidanthera/RTCMemoryFixup) to `EFI/OC/Kexts` and `config.plist`
- Enable `Kernel\Patch` for **Disable RTC wake scheduling** (copy it over from the `Sample.plist` included in the OpenCore package if it's missing.)
- Save and reboot. 

The problem should be gone, the next time you reboot or shutdown the system.

## Method 2: Fixing the Real Time Clock via SSDT 
This approach uses an SSDT hotfix to solve the CMOS reset issue. It adds a fake `RTC` device for macOS to play with (see [**SSDT-RTC0**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-RTC0)) for details).

## Instructions

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

## Patch: `SSDT-RTC0-NoFlags`

- Disables the original **RTC** device
- If **RTC** does not include the `_STA` method, disable **RTC** using the following:
  
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

## NOTES
- The device name and path in the patch must match the one used in your system's `DSDT`.
- If the `RTC` of your systems is disabled by for some reason, a fake RTC is required for it to work properly. In the case that a **"Boot self-test error"** occurs, remove the interrupt from the SSDT:
  ```asl
    IRQNoFlags () /* delete this line */
        {8} /* Delete this line */
  ```

**Thanks** @Chic Cheung, @Noctis for all your hard work!
