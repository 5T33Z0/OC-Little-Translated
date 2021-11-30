# Add missing parts
Although adding any of the missing parts listed below may improve performance, they can only be regarded as a refinement. They are not a necessity for getting your Hackintosh to work, except for `PMCR` which may be a requirement for Z390 Chipsets.

## Instructions

In **DSDT**, search for:

- Search for `PNP0C0C` and add ***SSDT-PWRB*** if it is missing. Adds Power Button Device
- Search for `PNP0C0E` and add ***SSDT-SLPB*** if missing, this part is needed for the `PNP0C0E Sleep Correction Method`.
- In some cases (some HP, Lenovo my experiences)the SLPB device may be present in DSDT Origin, but the same may be turned off.

In DSDT Origin :
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
This is resolved with SSDT-SLPB_STA0B

**CAUTION:** When using the any of the patches, note that `\SB` name should be consistent with the name used in the original ACPI.
