# Enabling Power and Sleep Buttons (`SSDT-PWRB/SLPB`)

## Instructions

In **DSDT**, search for:

- Search for `PNP0C0C` and add ***SSDT-PWRB*** if it is missing. Adds Power Button Device
- Search for `PNP0C0E` and add ***SSDT-SLPB*** if missing, this part is needed for the `PNP0C0E Sleep Correction Method`.
- In some cases (like HP or Lenovo), the `SLPB` is present in the `DSDT`, but may be disabled:

    ```
    Scope (_SB)
    {
        Device (SLPB)
        {
            Name (_HID, EisaId ("PNP0C0E") / * Sleep Button Device * /) // _HID: Hardware ID
            Name (_STA, Zero) // _STA: Status
        }
    }
    ```
    This is resolved with SSDT-SLPB_STA0B :
    
    ```
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            \_SB.SLPB._STA = 0x0B
        }
    }
    ```

**CAUTION:** When using the any of the included SSDTs, ensure that the PCI paths are consistent with the ones used in the original DSDT!
