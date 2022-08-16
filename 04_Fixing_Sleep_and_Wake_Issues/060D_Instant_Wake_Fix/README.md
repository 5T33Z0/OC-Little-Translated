# 0D/6D Instant Wake Fix

## Description
There are some components (like USB, LAN, etc.) which can create conflicts between the sleep state values defined in their `_PRW` methods and macOS that cause the machine to instantly wake after attempting to enter sleep. This fix resolves this issue.

### Technical Background
The `DSDT` contains `_GPE` (General Purpose Events) which can be triggered by all sorts of things and actions: pressing the Power/Sleep Button, opening/closing the Lid, etc. Each even has it's own number. Although these are not standardized, `0x6D` is often used as an event in devices like Ethernet cards, USB Controllers or Soundcards. 

Some devices contain the method `_PRW` (Power Resource for Wake) which defines their wake method by using packages which return 2 power resource values if the corresponding `_GPE` is triggered. The `Return` value of `_PRW` is a packet consisting of 2 or more bytes:

- The 1st byte of the `_PRW` packet is either `0x0D` or `0x6D`. Therefore, such patches are called `0D/6D Patches`.
- The 2nd byte of `_PRW` packet is either `0x03` or `0x04`. But macOS expects `0x00` here in order to not wake. And that's what this patch does: it changes the 2nd byte to `0x00` if macOS is running – thus completing the `0D/6D Patch`. See the ACPI Specs for further details on `_PRW`.

Different machines may define `_PRW` in different ways, so the contents and forms of their packets may also be diverse. The actual `0D/6D Patch` should be determined on a case-by-case basis by analyzing the `DSDT`.

### Devices that may require a `0D/6D Patch`

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
  - Generation 6 and later, `ADR` address: `0x001F0003`, part name: `HDAS`, `AZAL`, `HDEF`, etc.

**NOTES**: 

- Looking up the names of devices in the DSDT is not a reliable approach. Search by `ADR address` or `_PRW` instead.  
- Newly released machines may have new parts that require `0D/6D patch`.

## Diversity of `_PRW` and the corresponding patch method
Your `DSDT` may contain code like this:

```asl 
 Name (_PRW, Package (0x02)
    {
        0x0D, /* possibly 0x6D */
        0x03, /* possibly 0x04 */
        ...
    })
```
For these packages, the 2nd byte needs to return `0x00`, so the system doesn't wake instantly. We can use `SSDT-XPRW.aml` or `SSDT-PRW0` to do so. Which one to use depends on the methods present in your `DSDT`: if either `GPRW` or `UPRW` are present, use `SSDT-XPRW`, if only `_PRW` is present, use `SSDT-PRW0`.

### Refined method using `SSDT-XPRW.aml`
This approach tries to minimze the amount of necessary binary renames, to correct the values of return packages. Instead of renaming them via DSDT patches, they are renamed via SSDT in macOS only, which is much cleaner. This fix requires method `GPRW` or `UPRW` to be present in your `DSDT`.

1. Open your `config.plist`
2. Add a binary rule to `ACPI/Patch`, depending on the method used in your `DSDT`: 
	- `GPRW to XPRW` or (see SSDT-XPRW.dsl for details)
	- `UPRW to XPRW` (see SSDT-XPRW.dsl for details)
	:bulb: You may want to limit its reach by specifiying an ACPI path in the `base` field – depends on the location of the device(s). In my case,I limit it to `_SB_.PCI0`.
3. Open `SSDT-XPRW.dsl` (located in the "i_Common_060D_Patch" folder) in maciASL 
4. Add the APCI paths of devices which require `0D/6D` patches and add them as "External" references, for example:
	```asl
	DefinitionBlock ("", "SSDT", 2, "ST33Z0", "XPRW", 0x00000000)
	{
    	External (_SB_.PCI0, DeviceObj)
    	External (_SB_.PCI0.EHC1, DeviceObj)
    	External (_SB_.PCI0.EHC2, DeviceObj)
    	External (_SB_.PCI0.SAT1, DeviceObj)
    	External (_SB_.PCI0.XHCI, DeviceObj)
    	External (XPRW, MethodObj)
	```	
5. Export the file as `SSDT-XPRW.aml`, add it to the `EFI/OC/ACPI` folder and your `config.plist`.
6. Save and reboot.

#### Testing and veryfing
- Reduce the time until the machine enters sleep automatically in the Energy Options to one minute
- Wait until the machine tries to enter sleep on its own. That's important to trigger the General Purpose Event.
- If the patch works, the system will enter and stay in sleep. 
- If it doesn't work, it will wake immedieately after entering sleep.
- In this case, try the "old method" explained below.

### New method using `SSDT-PRW0.aml` (no GPRW/UPRW)
In case your `DSDT` doesn't use the `GPRW` or `UPRW` method, we can simply modify the `_PWR` method by changing the 2nd byte of the package (package `[One]`) to `0` where necessary, as [suggested by antoniomcr96](https://github.com/5T33Z0/OC-Little-Translated/issues/2). All you need to do is list the PCI paths of the devices where a change is necessary, like this (no additional binary rename required):

```asl
// SSDT to set Package 1 (the 2nd byte of the packet) in _PRW method to 0 
// as required by macOS to not wake instantly.
// You need to reference all devices where _PRW needs to be modified.

DefinitionBlock ("", "SSDT", 2, "5T33Z0", "PRW0", 0x00000000)
{

    External (_SB_.PCI0.EHC1._PRW, PkgObj) // External Reference of Device and its _PRW method
    External (_SB_.PCI0.EHC2._PRW, PkgObj) // These References are only examples. Modify them as needed
    External (_SB_.PCI0.HDEF._PRW, PkgObj) // List every device where the 2nd byte of _PRW is not 0
    ...
    
 If (_OSI ("Darwin"))

        {
            _SB_.PCI0.EHC1._PRW [One] = 0x00 // Changes second byte in the package to 0
            _SB_.PCI0.EHC2._PRW [One] = 0x00
            _SB_.PCI0.HDEF._PRW [One] = 0x00
            ...
        }    
}
```
1. In your DSDT, search for `_PRW`
2. Look for matches for `_PRW` inside of Devices only
3. If the first byte of the package is either `0x0D` or `0x6D` but the second byte is not `0x00`, then add the device path to `SSDT-PRW0.dsl`. This would be a match: 
	```asl
	Device (HDEF)
	{
		...
		{
			0x0D, // (or 0x6D), 1st byte of the package
			0x04 // 2nd byte, should be 0x00
    	})
	```
5. Once you're finished adding the devices, export the file as `SSDT-PRW0.aml`, add it to the `EFI/OC/ACPI` folder and your `config.plist`.
6. Save and reboot.

#### Testing and veryfing
- Reduce the time until the machine enters sleep automatically in the Energy Options to one minute
- Wait until the machine tries to enter sleep on its own. That's important to trigger the General Purpose Event.
- If the patch works, the system will enter and stay in sleep. 
- If it doesn't work, it will wake immedieately after entering sleep.
- In this case, try the "old method" explained below.

### Old Method using binary renames (no longer required)
This type of `0D/6D patch` is suitable for fixing `0x03` (or `0x04`) to `0x00` using the binary renaming method. Two variants for each case are available:

  - Name-0D rename .plist
    - `Name-0D-03` to `00`
    - `Name-0D-04` to `00`
    
  - Name-6D rename .plist
    - `Name-6D-03` to `00`
    - `Name-6D-04` to `00`

- One of the `Method types`: `GPRW` or `UPRW`:

  ```asl
    Method (_PRW, 0, NotSerialized)
    	{
      		Return (GPRW (0x6D, 0x04)) /* or Return (UPRW (0x6D, 0x04)) */
    	}
  ```
  Most of the newer machines fall into this case. Just follow the usual method (rename-patch). Depending on which method is used in your DSDT, chose the corresponding SSDT: ***SSDT-XPRW*** (patch file with binary rename data inside). Depending on the method present in your DSDT (GPRW or UPRW), add the corresponding rename rule to the ACPI/Patch section of your config.plist.

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

**Caution**: Whenever a binary name change is used, the system's `DSDT` file should be extracted and analyzed before applying it.

## Other approaches

### Using `USBWakeFixup.kext`
Find out what's causing the wake by entering this in terminal:

``` pmset -g log | grep -e "Sleep.*due to" -e "Wake.*due to"```

If your wake issues are only caused by USB, you could try this combination of a kext and SSDT instead: https://github.com/osy/USBWakeFixup. This has been reported working on PCs at least. I doubt it'll work on Laptops but you could try.

### Removing the `_PRW` method from DSDT completely
The following approaches require using a patched DSDT which we are trying to avoid when using OpenCore, so they are not recommended. I also don't know if this causes negative side effects in other Operating System.

There have been [reports](https://www.reddit.com/r/hackintosh/comments/7hl68w/modified_dsdt_cleared_out_all_pwr_entries_sleep/) that removing the `_PRW` method from the `DSDT`completely solves this issue.

### Changing `_PRW` to specific return values
This approach (which also requires patching the `DSDT`) changes the power resource values for all occurrences of `_PRW` to the same values (`0x09`, `0x04`) instead of deleting the whole `_PRW` method. The guide can be found [here](https://github.com/grvsh02/A-guide-to-completely-fix-sleep-wake-issues-on-hackintosh-laptops).

## Resources
- `_PWR` (PowerResource for Wake) [Specifications](https://uefi.org/specs/ACPI/6.4/07_Power_and_Performance_Mgmt/device-power-management-objects.html#prw-power-resources-for-wake)
