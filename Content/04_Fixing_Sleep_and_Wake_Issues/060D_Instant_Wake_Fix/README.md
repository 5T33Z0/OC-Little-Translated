# 0D/6D Instant Wake Fix

- [Description](#description)
  - [Technical Background](#technical-background)
  - [What the fix does](#what-the-fix-does)
    - [Wake Capabilities](#wake-capabilities)
  - [Refined Fix](#refined-fix)
  - [Devices that may require a `0D/6D Patch`](#devices-that-may-require-a-0d6d-patch)
- [Diversity of `_PRW` and the corresponding patch method](#diversity-of-_prw-and-the-corresponding-patch-method)
  - [Method 1: using `SSDT-GPRW/UPRW`](#method-1-using-ssdt-gprwuprw)
    - [Testing and verifying](#testing-and-verifying)
  - [Method 2: using `SSDT-PRW0.aml` (no GPRW/UPRW)](#method-2-using-ssdt-prw0aml-no-gprwuprw)
    - [Testing and verifying](#testing-and-verifying-1)
  - [Old Method using binary renames (superseeded)](#old-method-using-binary-renames-superseeded)
- [Alternative Fixes](#alternative-fixes)
  - [Using `USBWakeFixup.kext`](#using-usbwakefixupkext)
  - [Using a patched `DSDT`](#using-a-patched-dsdt)
    - [Changing `_PRW` to specific return values](#changing-_prw-to-specific-return-values)
    - [Removing the `_PRW` method from the `DSDT` completely](#removing-the-_prw-method-from-the-dsdt-completely)
- [Notes and Resources](#notes-and-resources)

---

## Description
Some devices defined in the `DSDT` (e.g. USB Controllers, LAN cards, Audio Codecs, etc.) can contain sleep state values defined in the method `_PRW` (Power Resource for Wake) that can cause the machine to instantly wake after attempting to enter stand-by or sleep in macOS. This guide describes how to fix such instant wake issues.

### Technical Background
The `DSDT` contains `_GPE` (General Purpose Events) which can be used to trigger various types of events in the operating system, including power management events. `GPE` registers are memory locations which can be set or cleared to enable or disable specific events. GPEs can be triggered by pressing the Power/Sleep Button, opening/closing the lid of a laptop, etc. Each event has its own number assigned to it and can be triggered by different methods, such as `_PRW` (Power Resource for Wake).

Used in devices, the `_PRW` method describes the wake method by using packages which return two power resource values if the corresponding `_GPE` is triggered. The `Return` package consists of 2 bit-fields (Package Objects):

- The 1st bit-field of the `_PRW` package we are interested in is either `0x0D` or `0x6D`. That's where the name of the fix comes from.
- The 2nd bit-field of the `_PRW` package defines the wake capabilities of a device. If it's `0x03` (Wake on Mouse/Keybord) or `0x04` (Wake on LAN) then we are in trouble: macOS expects `0x00` (Wake disabled) here in order to *not* wake immediately.

### What the fix does
The fix changes the 2nd package in the `_PRW` method to `0x00` if macOS is running – thus completing the `0D/6D Patch`. Different machines may define `_PRW` in different ways, so the contents and forms of their packets may also be diverse. The actual `0D/6D Patch` should be determined ***on a case-by-case basis by analyzing the `DSDT`***. Refer to the ACPI specs for further details about the `_PRW` method. 

#### Wake Capabilities
Here is a list of the most common bit-fields that can be used to describe the wake capabilities of a device:

- `0x00`: Wake disabled
- `0x01`: Wake on power button
- `0x02`: Wake on mouse or keyboard input
- `0x03`: Wakes on power button, mouse or keyboard input (Bitmask combining `0x01` and `0x02`).
- `0x04`: Wake on LAN (WOL)
- `0x08`: Wake on RTC (real-time clock) alarm
- `0x10`: Wake on PCI (peripheral component interconnect) PME (power management event)
- `0x20`: Wake on USB (universal serial bus) PME
- `0x40`: Wake on fixed feature button
- `0x80`: Wake on power button or fixed feature button 

### Refined Fix
Previously, a lot of binary renames were necessary to fix instant-wake issues, which could cause problems in other Operating Systems. Since then, the fix has been refined, so that it requires only 1 binary rename (if at all), while the rest of it is handled by simple SSDTs which are easy to edit and replace the 2nd bit-field with `0x00` for macOS only.

### Devices that may require a `0D/6D Patch`

- **USB class devices**
  - `ADR` address: `0x001D0000`, part name: `EHC1`.
  - `ADR` address: `0x001A0000`, part name: `EHC2`.
  - `ADR` Address: `0x00140000`, part name: `XHC`, `XHCI`, `XHC1`, etc.
  - `ADR` address: `0x00140001`, part name: `XDCI`.
  - `ADR` address: `0x00140003`, part name: `CNVW`.
- **Ethernet**
  - Before Gen 6, `ADR` address: `0x00190000`, part name: `GLAN`, `IGBE`, etc.
  - Generation 6 and later, `ADR` address: `0x001F0006`, part name: `GLAN`, `IGBE`, etc.
- **Sound Card**
  - Before Gen 6, `ADR` address: `0x001B0000`, part name: `HDEF`, `AZAL`, etc.
  - Generation 6 and later, `ADR` address: `0x001F0003`, part name: `HDAS`, `AZAL`, `HDEF`, etc.

> [!NOTE]
>
> - Looking up the names of devices in the `DSDT` is not a reliable approach. If possible, Search by `ADR address` or `_PRW`.
> - Newly released machines may have new parts that require the `0D/6D patch`.

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
For these packages, the 2nd byte needs to return `0x00`, so the system doesn't wake instantly. We can use `SSDT-GPRW`/`SSDT-UPRW` or `SSDT-PRW0` to do so. Which one to use depends on the methods present in your `DSDT`:

-  if either `GPRW` or `UPRW` is present, follow **Method 1**, 
-  if only `_PRW` is present, use `SSDT-PRW0` and follow **Method 2**.

### Method 1: using `SSDT-GPRW/UPRW`
This approach minimizes the amount of necessary binary renames to one to correct the values of return packages. Instead of renaming them via `DSDT` patches, we only rename the used method (either `GPRW` or `UPRW`) and then redefine it via SSDT in a way that the values are only changed for macOS while other OSes get the original, unmodified values to work with.

1. In your `DSDT`, search for `Method (GPRW, 2` and `Method (UPRW, 2`. If either one exists, continue with the guide. If not, follow the instructions of ["Method 2"](#method-2-using-ssdt-prw0aml-no-gprwuprw) instead.
2. Depending on which method is used, either open `SSDT-GPRW.dsl` or `SSDT-UPRW.dsl`.
3. Export it as `.aml` and add it to `EFI/OC/ACPI` and your `config.plist`.
4. Add the corresponding binary rename to `ACPI/Patch` (see [**GPRW_UPRW-Renames.plist**](/Content/04_Fixing_Sleep_and_Wake_Issues/060D_Instant_Wake_Fix/i_Common_060D_Patch/GPRW_UPRW-Renames.plist)): 
	- Rename `GPRW to XPRW` or 
	- Rename `UPRW to XPRW`
5. Save and reboot.

#### Testing and verifying
- Reduce the time until the machine enters sleep automatically in the Energy Options to one minute.
- Wait until the machine enters sleep on its own. That's important to trigger the General Purpose Event.
- If the patch works, the system will enter and stay in sleep. 
- If it doesn't work, it will wake immediately after trying to enter sleep state.
- In this case, enter `pmset -g log | grep -e "Sleep.*due to" -e "Wake.*due to"` in Terminal to find the culprit for the instant wake.

### Method 2: using `SSDT-PRW0.aml` (no GPRW/UPRW)
In case your `DSDT` *doesn't* contain the `GPRW` or `UPRW` method, we can simply modify the `_PWR` method by changing the 2nd bit-field of the return package (package `[One]`) to `0x00` where necessary, as [suggested by antoniomcr96](https://github.com/5T33Z0/OC-Little-Translated/issues/2) – no additional binary renames are required. 

But in order to make it work, we need to list all the PCI paths of devices where the change is necessary, as shown in this example:

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

1. In your `DSDT`, search for `Name (_PRW`
2. Look for matches for `_PRW` inside of Devices only
3. If the first byte of the package is either `0x0D` or `0x6D` but the second byte is *not* `0x00`, then add the device path to `SSDT-PRW0.dsl`. This would be a match: 
	```asl
	Device (HDEF)
	{
		...
		{
			0x0D, // (or 0x6D), 1st byte of the package
			0x04  // 2nd byte, should be 0x00
    	})
	```
4. Once you're finished adding the devices, export the file as `SSDT-PRW0.aml`, add it to the `EFI/OC/ACPI` folder and your `config.plist`.
5. Add [**SSDT-PTSWAKTTS**](/Content/04_Fixing_Sleep_and_Wake_Issues/PTSWAK_Sleep_and_Wake_Fix) 
6. Save and reboot.

#### Testing and verifying
- Reduce the time until the machine enters sleep automatically in the Energy Options to one minute
- Wait until the machine tries to enter sleep on its own. That's important to trigger the General Purpose Event.
- If the patch works, the system will enter and stay in sleep. 
- If it doesn't work, it will wake immediately after entering sleep.
- In this case, try the "old method" explained below.

<details>
<summary><strong>Previous Method</strong> (Click to reveal)</summary>

### Old Method using binary renames (superseeded)
This type of `0D/6D patch` is suitable for fixing `0x03` (or `0x04`) to `0x00` using the binary renaming method. Two variants for each case are available:

  - Name-0D_Rename.plist
    - `Name-0D-03` to `00`
    - `Name-0D-04` to `00`
    
  - Name-6D_Rename.plist
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
</details>

## Alternative Fixes

### Using `USBWakeFixup.kext`
Find out what's causing the wake by entering this in terminal:

``` pmset -g log | grep -e "Sleep.*due to" -e "Wake.*due to"```

If your wake issues are caused by USB devices *only*, you could try [**USBWakeFixup**](https://github.com/osy/USBWakeFixup) intsead. It's combination of a kext and an SSDT. It has been reported as working on PCs at least. I doubt it'll work on Laptops but you could try your luck.

### Using a patched `DSDT`
The following approaches require injecting a patched `DSDT` file which is not recommended for reasons I won't go into details about here.

#### Changing `_PRW` to specific return values
This approach (which also requires patching the `DSDT`) changes the power resource values for all occurrences of `_PRW` to the same values (`0x09`, `0x04`) instead of deleting the whole `_PRW` method. The guide can be found [**here**](https://github.com/grvsh02/A-guide-to-completely-fix-sleep-wake-issues-on-hackintosh-laptops).

#### Removing the `_PRW` method from the `DSDT` completely
Instead of modifying the the return packages of the `_PRW` method, removing the method from the `DSDT` is also an option.

## Notes and Resources
- If you are using any of the SSDTs to change any of the `_PRW` bit-fields, these changes won't be reflected in the `DSDT` nor in IORegistryExplorer so you have to just test it.
- A handy Python script for finding Name Paths of Devices containing `_PRW` packages is [**ACPIRename**](https://github.com/corpnewt/ACPIRename)
- [**_PWR (Power Resource for Wake**)](https://uefi.org/specs/ACPI/6.5/07_Power_and_Performance_Mgmt.html#prw-power-resources-for-wake) in ACPI Specs
- You could try tp apply Method 2 for fixing DSDTs which use the `GPRE`/`UPRW` method as well. In this case you wouldn't need the `XPRW` rename. I have not tested this yet, so I cannot verify that it will work.
