# Fixing the System Clock (SSDT-AWAC)

Hotpatch to force-enable `RTC` and disabling `AWAC` at the same time. Required For 300-series chipsets and newer, since `AWAC` is not supported by macOS.

## Automated SSDT generation: using SSDTTime
With the python script **SSDTTime**, you can generate the following SSDTs from analyzing your system's `DSDT`:

* ***SSDT-AWAC*** &rarr; Context-Aware AWAC and Fake RTC
* ***SSDT-EC*** &rarr; OS-aware fake EC for Desktops and Laptops
* ***SSDT-PLUG*** &rarr; Sets plugin-type to `1` on `CPU0`/`PR00` to enable the X86PlatformPlugin for CPU Power Management
* ***SSDT-HPET*** &rarr; Patches out IRQ and Timer conflicts to enable on-board Sound Cards
* ***SSDT-PMC*** &rarr; Enables native NVRAM on True 300/400/500/600-Series Mainboards

**HOW TO:**

1. Download [**SSDTTime**](https://github.com/corpnewt/SSDTTime) and run it
2. Pres "D", drag in your system's DSDT and hit "ENTER"
3. Generate all the SSDTs you need.
4. The SSDTs will be stored under `Results` inside of the `SSDTTime-master`Folder along with `patches_OC.plist`.
5. Copy the generated `SSDTs` to EFI > OC > ACPI and your Config using OpenCore Auxiliary Tools
6. Open `patches_OC.plist` and copy the the included patches to your `config.plist` (to the same section, of course).
7. Save and Reboot. Done. 

**NOTE**
If you are editing your config using [**OpenCore Auxiliary Tools**](https://github.com/ic005k/QtOpenCoreConfig/releases), OCAT it will update the list of .kexts and .aml files automatically, since it monitors the EFI folder.

## Manual patching methods
Besides using SSDTTime to generate `SSDT-AWAC.aml`, there are other methods for disabling AWAC. Depending on the results in your DSDT you can use different methods. Here are some examples.

Original Code in `DSDT` for "Device (RTC)" and "Device (AWAC)":

```swift
Device (RTC)
{
    ...
    Method (_STA, 0, NotSerialized)
    {
            If ((STAS == One)) // If STAS = 1
            {
                Return (0x0F) // Turn RTC ON
            }
            Else 			  // if STAS ≠ 1
            {
                Return (Zero) // Turn RTC OFF
            }
    }
    ...
}
Device (AWAC)
{
    ...
    Method (_STA, 0, NotSerialized)
    {
            If ((STAS == Zero))	// If STAS = 0
            {
                Return (0x0F) 	// enable AWAC
            }
            Else				// if STAS ≠ 0
            {
                Return (Zero)	// disable AWAC
            }
    }
    ...
}
```
As you can see, you can enable RTC and disable AWAC at the same time if `STAS=1`, using one of the following methods/hotpatches.

### Method 1: using `SSCT-AWAC`
```swift
External (STAS, IntObj)
Scope (\)
{
    If (_OSI ("Darwin"))
    {
        STAS = One
    }
}
``` 
**Explanation**: This will set `STAS` to `One` for macOS, which will enable Device `RTC`, since the following conditions are met: if `STAS` is `One` enable RTC (set it to `0x0F`). On the other hand, changing `STAS` to `One` will disable `AWAC`. Becaus `STAS` is *not* `Zero`, the Else condition is met: *"if the value in `STAS` is anything but Zero, return `Zero`* – in other words, turn off `AWAC`.

### Method 2: using `SSDT-AWAC2_ARTC` ('new' Disable RTC + Disable Awac + Disable HPET + Add ARTC Device) 

```swift
    External (_SB_.PCI0.LPCB, DeviceObj)
    External (HPTE, IntObj)
    External (STAS, IntObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            STAS = 0x02
            HPTE = Zero
        }
    }

    Scope (\_SB.PCI0.LPCB)
    {
        Device (ARTC)
        {
            Name (_HID, EisaId ("PNP0B00") /* AT Real-Time Clock */)  // _HID: Hardware ID
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                IO (Decode16,
                    0x0070,             // Range Minimum
                    0x0070,             // Range Maximum
                    0x01,               // Alignment
                    0x02,               // Length
                    )
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }
    }
``` 

**Applicable to**: Systems with an active AWAC Clock using SMBIOS `MacBookAir8,1/MacBookAir9,1`, `MacBookPro15,1`, `iMac19,x`, `iMac20,x` and `iMacPro1,1`</br>
**Procedure**: 

- In `DSDT`, search for `ACPI000E`. 
- If present, check if it belongs to `Device (AWAC)`. 
- If so, check if the `STAS` == `Zero` (refer to the code example from the beginning).
- If all above condistions are met, you can add `SSDT-AWAC2_ART.dsl`

**Explanation**: This SSDT actually makes use of AWAC Device by attaching it to the ARTC (Apple Realtime Clock) with EisaID `PNP0B00`. So if AWAC is active in your `DSDT` (and RTC is disabled), you can use this. Although the PCI Paths used in the file should work universally, better check if they work for you by comparing it with the location of `AWAC` in your `DSDT`. If the OS is not macOS Method `_STA` returns zero which enables the AWAC clock again.

### Method 3: using `SSDT-AWAC_STA0` (if method 3 fails)
Disables AWAC where `SSDT-AWAC-DISABLE` has no effect. Add `SSDT-AWAC_STA0` to ACPI folder and config, then reboot. Check for AWAC in [IORegistryExplorer](https://github.com/utopia-team/IORegistryExplorer/releases) and make sure it is not present. Example for disabling AWAC on systems with 8th Gen Intel Core CPU or newer:

```swift
External (_SB_.AWAC._STA, IntObj)
Scope (\)
  {
      If (_OSI ("Darwin"))
      {
          \_SB.AWAC._STA = Zero
          
      }
  }
```
**NOTE**: These methods only works if RTC is enabled in the original DSDT. A lot of 300-series chipsets like Z390 have RTC disabled though, so you have to add a fake RTC first –see chapter "System_Clock_(SSDT-RTC0)".

<details>
<summary><strong>Old Methods (kept for documentary purposes)</strong></summary>

# Binary Name Change

## Description

The method described in this article is not a renaming of `Device` or `Method` in the usual sense, but a binary renaming to enable or disable a device.

## Risks

ACPI binary renaming may affect other systems when OC is introduced to other systems.

## Example

Let's take the example of enabling `HPET`. We want it to return `0x0F` for `_STA`.

Binary renaming.

**Find**: `00 A0 08 48 50` "Note: `00` = `{`; `A0` = `If` ......  
**Replace**: `00 A4 0A 0F A3` `Note: `00` = `{`; `A4 0A 0F` = `Return(0x0F)`; `A3` = `Noop` for completing the number of bytes`

- Original Code:

  ```Swift
    Method (_STA, 0, NotSerialized)
    {
        If (HPTE)
        {
            Return (0x0F)
        }
        Return (Zero)
    }
  ```

- Code after name change:

  ```Swift
    Method (_STA, 0, NotSerialized)
    {
          Return (0x0F)
          Noop
          TE** ()
          Return (Zero)
    }
  ```

	**Explanation**: There is an obvious error after renaming, but this error is not harmful. First, the contents after `Return (0x0F)` will not be executed. Second, the error is located inside `{}` and does not affect the rest of the content.

	As a practical matter, we should ensure the integrity of the renamed syntax as much as possible. Here is the complete `Find`, `Replace` data:
  
  **Find**:`00 A0 08 48 50 54 45 A4 0A 0F A4 00`  
  **Replace**: `00 A4 0A 0F A3 A3 A3 A3 A3 A3 A3 A3 A3 A3 `
  
  Complete `Replace` post-code:
  
  ```Swift
    Method (_STA, 0, NotSerialized)
    Return (0x0F)
        Return (0x0F)
        Noop
        Noop
        Noop
        Noop
        Noop
        Noop
        Noop
        Noop
    }
  ```

## Request

- ***ACPI*** original file

  The `Find` binary file must be the ***ACPI*** original file, which cannot have been modified or saved by any software, i.e. it must be the original binary file provided by the machine.

- `Find` uniqueness, correctness

   There is only one number of `Find`, **unless** we intend to perform the same `Find` and `Replace` operations on multiple locations.

   **Special Note**: Any rewriting of a piece of code to find confirmed binary data from it is highly implausible!

- Number of `Replace` bytes

  The number of `Find`, `Replace` bytes must be equal. For example, if `Find` is 10 bytes, then `Replace` is also 10 bytes. If `Replace` is less than 10 bytes, use `A3` (null operation) to make up for it.

## `Find` Data lookup method

Usually, you can open the same `ACPI` file with binary software (e.g. `010 Editor`) and `MaciASL.app`, and `Find` the relevant content in binary data and text, and observe the context, so you can quickly determine the `Find` data.

## `Replace` content

When `Find` is stated in the Requirements, [any rewriting of a piece of code to find confirmed binary data from it is highly implausible! However, `Replace` can do this. Following the example above, we write a piece of code.

```Swift
    DefinitionBlock ("", "SSDT", 2, "hack", "111", 0)
    {
        Method (_STA, 0, NotSerialized)
        {
            Return (0x0F)
        }
    }
```

After compiling and opening with binary software, I found: `XX ... 5F 53 54 41 00 A4 0A 0F`, where `A4 0A 0F` is `Return (0x0F)`.

Note: `Replace` content should follow the ACPI specification and ASL language requirements.

## Caution

Updating BIOS may cause the name change to be invalid. The higher the number of `Find` & `Replace` bytes, the higher the possibility of failure.

### Attachment: TP-W530 Disable BAT1

**Find**: `00 A0 4F 04 5C 48 38 44 52`  
**Replace**: `00 A4 00 A3 A3 A3 A3 A3 A3 A3`

- Original code

  ```Swift
    Method (_STA, 0, NotSerialized)
    {
          If (\H8DR)
          {
              If (HB1A)
              {
              ...
    }
  ```

- Code after name change

  ```Swift
    Method (_STA, 0, NotSerialized)
    {
          Return (Zero)
          Noop
          Noop
          Noop
          Noop
          Noop
          Noop
          If (HB1A)
          ...
    }
  ```

# Preset variable method

## Description

- The **preset variables method** is to preassign values to some variables of ACPI (type `Name` and type `FieldUnitObj`) for the purpose of initialization. [Although these variables are assigned at the time of definition, they are not changed until `Method` calls them.
- Fixing these variables within `Scope (\)` through a third-party patch file can achieve the patching effect we expect.

## Risks

- The `variable` being fixed may exist in multiple places, and fixing it may affect other components while achieving our desired effect.
- The corrected `variable` may come from hardware information that can only be read but not written. This situation requires a combination of **binary renaming** and **SSDT patch**. It should be noted that it may not be possible to recover the renamed `variable` when the OC boots another system. See **Example 4**.

### Example 1

A device _STA Original.

```Swift
Method (_STA, 0, NotSerialized)
{
    ECTP (Zero)
    If ((SDS1 == 0x07))
    {
        Return (0x0F)
    }
    Return (Zero)
}
```

We need to disable this device for some reason, and for that purpose `_STA` should return `Zero`. From the original text, we can see that as long as `SDS1` is not equal to `0x07`. Using the **prefix variable method**, we can do the following.

```Swift
Scope (\)
{
    External (SDS1, FieldUnitObj)
    If (_OSI ("Darwin"))
    {
        SDS1 = 0
    }
}
```
 
### Example 2

When using the I2C patch, you may need to enable `GPIO`. See ***SSDT-OCGPI0-GPEN*** of the OCI2C-GPIO Patch.

An original article.

```Swift
Method (_STA, 0, NotSerialized)
{
    If ((GPEN == Zero))
    {
        Return (Zero)
    }
    Return (0x0F)
}
```

As you can see from the original, `GPIO` can be enabled as long as `GPEN` is not equal to `0`. Using the **prefix variable method** as follows.

```Swift
External(GPEN, FieldUnitObj)
Scope (\)
{
    If (_OSI ("Darwin"))
    {
        GPEN = 1
    }
}
```
### Example 3

When the `variable` is a read-only type, the solution is as follows.

- Change the name of the original `variable`.
- Redefine a `variable` with the same name in the patch file

E.g., an original

```Swift
OperationRegion (PNVA, SystemMemory, PNVB, PNVL)
Field (PNVA, AnyAcc, Lock, Preserve)
{
    ...
    IM01, 8,
    ...
}
...
If ((IM01 == 0x02))
{
    ...
}
```

Actual case `IM01` is not equal to 0x02, { ...} cannot be executed. To correct the error, **Binary rename** and **SSDT patch** are used.

**rename**: `IM01` rename `XM01`

```text
Find: 49 4D 30 31 08
Replace: 58 4D 30 31 08
```

**Patch**.

```Swift
Name (IM01, 0x02)
If (_OSI ("Darwin"))
{
    ...
}
Else
{
      IM01 = XM01 /* Same path as the original ACPI variable */
}
```
### Example 4

Change the enable bit of the device state using the assignment of the device's original `_STA` method (Method) referenced as `IntObj` to it.

Example of how this method can be used

```Swift
Method (_STA, 0, NotSerialized)
{
    If ((XXXX == Zero))
    {
        Return (Zero)
    }
    Return (0x0F)
}

Method (_STA, 0, NotSerialized)
{
    Return (0x0F)
}

Name (_STA, 0x0F)

```
It can be seen that the above example of `_STA` method contains only the enable bit to return the device state and the enable bit returned according to the conditions, if you want to not use the rename and change the conditions of the preset variables in the custom SSDT can be directly referenced to `_STA` method as `IntObj`

Example of operation to disable a device:

```Swift
External (_SB_.PCI0.XXXX._STA, IntObj)

\_SB.PCI0.XXXX._STA = Zero 

```
Please refer to **ASL Language Fundamentals** for the details of the `_STA` method's enable bit setting. 

The main reason why this method works in practice is that in the ACPI specification the `_STA` method has a higher priority than `_INI _ADR _HID` in the OS OSPM module for device state evaluation and initialization and the return value of `_STA` itself is an integer `Integer`.

An example of an operation that does not use this method:

```Swift
Method (_STA, 0, NotSerialized)
{
    ECTP (Zero)
    If (XXXX == One)
    {
        Return (0x0F)
    {
    
    Return (Zero)
}

Method (_STA, 0, NotSerialized)
{
    ^^^^GFX0.CLKF = 0x03
    Return (Zero)
}
```
From the above example, we can see that the original `_STA` method contains other operations `Method call ECTP (Zero)` and `Assignment operation ^^^GFX0.CLKF = 0x03`, in addition to setting the conditional device state enable bit.
Using this method will result in an error (non-ACPI Error) by invalidating other references and operations in the original `_STA` method

**Risk**: `XM01` may not be recovered when OC boots other systems.
</details>

## Credits
- **Acidanthera** for `SSDT-AWAC-Disable.dsl`
- **daliansky** for `SSDT-AWAC_N_RTC_Y.dsl`
- **Baio1977** for `SSDT-AWAC_STA0.dsl` and `SSDT-AWAC2_ARTC`
