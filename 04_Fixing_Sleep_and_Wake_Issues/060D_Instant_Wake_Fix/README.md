# 0D/6D Instant Wake Fix

## Description
There are some components (often it's USB or LAN, etc.) which create conflicts between the sleep state values defined in their `_PRW` methods and macOS that cause the machine to instantly wake after attempting to enter sleep. This fix resolves this issue.

### Technical Backround
In ACPI, there are GPE (General Purpose Events) which can be triggered by all sorts of things and events: Power Buttons, Sleep Buttons, Lids, etc. Every event has it's own number. Although these are not standardized, 06D is often used for LAN and USB. Devices contain `_PRW` methods which define their wake method by using packages which return 2 values if the corresponding event is triggered.

The `Return` value of `_PRW` is a packet consisting of 2 or more bytes:

- The 1st byte of the `_PRW` packet is either `0D` or `6D`. Therefore, such patches are called `0D/6D Patches`.
- The 2nd byte of `_PRW` packet is either `03` or `04`. But macOS expects a `0` here in order to not wake. And that's what this patch does: it set's packet 2 to `0` if macOS is running – thus completing the `0D/6D Patch`. See the ACPI Specs for further details on `_PRW`.

Different machines may define `_PRW` in different ways, so the contents and forms of their packets may also be diverse. The actual `0D/6D Patch` should be determined on a case-by-case basis by analyzing the `DSDT`. But I ~~expect~~ hope that subsequent releases of OpenCore will address this issue.

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

**NOTES**: 

- Looking up the names of devices in the DSDT is not a reliable approch. Search by `ADR address` or `_PRW` instead.  
- Newly released machines may have new parts that require `0D/6D patch`.

## Diversity of `_PRW` and the corresponding patch method

```asl 
 Name (_PRW, Package (0x02)
    {
        0x0D, /* possibly 0x6D */
        0x03, /* possibly 0x04 */
        ...
    })
```
This type of `0D/6D patch` is suitable for fixing `0x03` (or `0x04`) to `0x00` using the binary renaming method. Two variants for each case are available:

  - Name-0D rename .plist
    - `Name-0D-03` to `00`
    - `Name-0D-04` to `00`
    
  - Name-6D change of name .plist
    - `Name-6D-03` to `00`
    - `Name-6D-04` to `00`

- One of the `Method types`: `GPRW` or `UPRW`:

  ```asl
    Method (_PRW, 0, NotSerialized)
    	{
      		Return (GPRW (0x6D, 0x04)) /* or Return (UPRW (0x6D, 0x04)) */
    	}
  ```
  Most of the newer machines fall into this case. Just follow the usual method (rename-patch). Depending on which method is used in your DSDT, chose the corresponding SSDT:

  - ***SSDT-GPRW*** (patch file with binary rename data inside)
  - ***SSDT-UPRW*** (patch file with binary rename data inside)

- ``Method type`` of two: ``Scope``

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

  For most ThinkPad machines, there are both `Name type` and `Method type` parts involved in `0D/6D patches`. Just use the patch of each type. **It is important to note** that binary renaming patches should not be abused, some parts `_PRW` that do not require `0D/6D patches` may also be `0D` or `6D`. To prevent such errors, the `System DSDT` file should be extracted to verify and validate.

**Caution**: Whenever a binary name change is used, the system's `DSDT` file should be extracted and analized before applying it.

## Other methods: using `USBWakeFixup.kext`
Find out what's causing the wake by entering this in terminal:

``` pmset -g log | grep -e "Sleep.*due to" -e "Wake.*due to"```

If your wake issues are only caused by USB, you could try this combination of a kext and SSDT instead: https://github.com/osy/USBWakeFixup. This has been reported working on PCs at least. I don't think this works for Laptops but you could try.

