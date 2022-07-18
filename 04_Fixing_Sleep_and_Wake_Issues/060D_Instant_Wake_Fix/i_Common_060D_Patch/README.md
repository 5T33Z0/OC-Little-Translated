# 0D/6D Patch

## Description

If a system immeditely wakes after trying to enter sleep, macOS probably has an issue with the way the `_PRW` method is used in the system's DSDT. In order to fix this, a patch must be applied. PWR stands for Power Resources for Wake and defines the wakeup capability of a device. Its `Return` value consits of a packet with 2 or more bytes:

- The 1st byte of the `_PRW` packet is either `0D` or `6D`. Therefore, such patches are called `0D/6D Patches`. 
- The 2nd byte of the `_PRW` packet is either `03` or `04`. Changing this byte to `0` completes the `0D/6D Patch`.  

Different machines may define `_PRW` in different ways, and the contents and forms of their packets may also vary. The actual `0D/6D Patch` should be determined on a case-by-case basis. ~~But we expect that subsequent releases of OpenCore will address the `0D/6D` issue.~~

### Components that may require a `0D/6D Patch`

- **USB class devices**
  - `ADR` address: `0x001D0000`, part name: `EHC1`.
  - `ADR` address: `0x001A0000`, part name: `EHC2`.
  - `ADR` Address: `0x00140000`, Part Name: `XHC`, `XHCI`, `XHC1`, etc.
  - `ADR` address: `0x00140001`, part name: `XDCI`.
  - `ADR` address: `0x00140003`, part name: `CNVW`.

- **Ethernet**
  - Before Gen 6, `ADR` address: `0x00190000`, part name: `GLAN`, `IGBE`, etc.
  - Generation 6 and later, `ADR` address: `0x001F0006`, part name: `GLAN`, `IGBE`, etc.

- **Sound Cards**
  - Before Gen 6, `ADR` address: `0x001B0000`, part name: `HDEF`, `AZAL`, etc.
  - Generation 6 and later, `ADR` address: `0x001F0003`, part name: `HDAS`, `AZAL`, etc.

**Note 1**: Looking up the names of devices in the `DSDT` is unreliable. Search by `ADR address` or `_PRW` instead.  
**Note 2**: Newer machines may have new parts that require `0D/6D patch`.

## Diversity of `_PRW` and the corresponding patch method
```asl
Name (_PRW, Package (0x02)
    {
        0x0D, /* possibly 0x6D */
        0x03, /* possibly 0x04 */
        ...
    })
```  
Depending on your search results, pick either or of the following two `0D/6D` rename patches and copy the renames to your config.plist unter the same section (ACPI > Patch):

  1. Name-0D Rename.plist
    - `Name-0D-03` to `00`
    - `Name-0D-04` to `00`
    
  2. Name-6D rename.plist
    - `Name-6D-03` to `00`
    - `Name-6D-04` to `00`

- One of the `Method types`: `GPRW(UPRW)`

	```asl
	Method (_PRW, 0, NotSerialized)
    	{
      	Return (GPRW (0x6D, 0x04)) /* or Return (UPRW (0x6D, 0x04)) */
    	}
	```

  Most of the newer machines fall into this category. Just follow the usual method (rename-patch) as described.

  - ***SSDT-GPRW*** (patch file with binary rename data inside)
  - ***SSDT-UPRW*** (binary renaming data inside the patch file)

- `Method type` of two: `Scope`

  ```asl
    Scope (_SB.PCI0.XHC)
    {
        Method (_PRW, 0, NotSerialized)
        {
            ...
            If ((Local0 == 0x03))
            {
                Return (Package (0x02)
                {
                    0x6D,
                    0x03
                })
            }
            If ((Local0 == One))
            {
                Return (Package (0x02)
                {
                    0x6D,
                    One
                })
            }
            Return (Package (0x02)
            {
                0x6D,
                Zero
            })
        }
    }
  ```

  This is not a common case. For the example case, using the binary rename ***Name6D-03 to 00*** will work. Try other forms of content on your own.

- Mixed `Name type`, `Method type` approach

	For most ThinkPad machines, both `Name type` and `Method type` parts are required to complete the `0D/6D patch`. Just use the patch of each type. **It is important to note** that binary renaming patches should not be abused since some devices' `_PRW` methods do not require `0D/6D patches` or may may already be `0D` or `6D`. To prevent such errors, the system's DSDT` file should be extracted to verify and validate.

## :warning: Caution

- Whenever a binary name change is used, the `DSDT` file should be extracted and verified.
