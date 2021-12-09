# 0D/6D Patch

## Description

There are some components which create conflicts between their `_PRW` and macOS that cause the machine to wake up immediately after a successful sleep. In order to solve the problem, a patch must be applied to these components. In order to do so, we need to understand how `_PRW` works.

`_PRW` defines the wake method of a component. Its `Return` is a packet of 2 or more bytes:

- The 1st byte of `_PRW` packet is either `0D` or `6D`. Therefore, such patches are called `0D/6D Patches`. 
- The 2nd byte of `_PRW` packet is either `03` or `04`, so fixing this byte to `0` completes the `0D/6D Patch`.  
See the ACPI Specs for further details on `_PRW`.

Different machines may define `_PRW` in different ways, and the contents and forms of their packets may also be diverse. The actual `0D/6D Patch` should be determined on a case-by-case basis. But we expect that subsequent releases of OpenCore will address the `0D/6D` issue.

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

- **Sound Card**

  - Before Gen 6, `ADR` address: `0x001B0000`, part name: `HDEF`, `AZAL`, etc.
  - Generation 6 and later, `ADR` address: `0x001F0003`, part name: `HDAS`, `AZAL`, etc.

**Note 1**: Looking up the names of devices in the DSDT is not reliable. Search by `ADR address` or `_PRW` instead.  
**Note 2**: Newly released machines may have new parts that require `0D/6D patch`.

## Diversity of `_PRW` and the corresponding patch method

```swift 
 Name (_PRW, Package (0x02)
    {
        0x0D, /* possibly 0x6D */
        0x03, /* possibly 0x04 */
        ...
    })
```
This type of `0D/6D patch` is suitable for fixing `0x03` (or `0x04`) to `0x00` using the binary renaming method. The documentation package provides.

  - Name-0D rename .plist
    - `Name-0D-03` to `00`
    - `Name-0D-04` to `00`
    
  - Name-6D change of name .plist
    - `Name-6D-03` to `00`
    - `Name6D-04` to `00`

- One of the `Method types`: `GPRW(UPRW)`

  ```swift
    Method (_PRW, 0, NotSerialized)
    {
      Return (GPRW (0x6D, 0x04)) /* or Return (UPRW (0x6D, 0x04)) */
    }
  ```
  Most of the newer machines fall into this case. Just follow the usual method (rename-patch). The documentation package provides.

  - ***SSDT-GPRW*** (patch file with binary rename data inside)
  - ***SSDT-UPRW*** (binary renaming data inside the patch file)

- ``Method type`` of two: ``Scope``

  ```swift
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

  For most ThinkPad machines, there are both `Name type` and `Method type` parts involved in `0D/6D patches`. Just use the patch of each type. **It is important to note** that binary renaming patches should not be abused, some parts `_PRW` that do not require `0D/6D patches` may also be `0D` or `6D`. To prevent such errors, the `System DSDT` file should be extracted to verify and validate.

### Caution

- The method described in this article applies to Hotpatch.
- Whenever a binary name change is used, the `System DSDT` file should be extracted and verified.
