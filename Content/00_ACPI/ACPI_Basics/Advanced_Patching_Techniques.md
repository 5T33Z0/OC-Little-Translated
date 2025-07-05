# Advanced Patching Techniques

## Really hacky Binary Rename patches
A usual application of binary renames is to disable a `Device` or `Method` in the `DSDT` so macOS doesn't recognize it, so we can either modify or replace it via an SSDT. But besides that you can also use binary renames in rather unconventional ways to enable or disable devices by literally manipulating section(s) of the `DSDT` in such a way that only desired parts of the code is executed.

### Risks
Patching ACPI tables via binary renames apply system-wide. If done inappropriately, it might have negative affects on other Operating Systems when using OpenCore for booting. 

In Windows, for example, an incorrectly applied binary rename can cause Blue Screen errors during boot caused by an `ACPI_BIOS_ERROR`

### Example: Enabling `HPET`
Let's take enabling `HPET` for example. We want it to return `0x0F` for `_STA`. Here's the renaming rule:

**Find**: `00 A0 08 48 50` &rarr; "00 = {; A0 = If ......"</br>
**Replace**: `00 A4 0A 0F A3` &rarr; "00 = {; A4 0A 0F = Return (0x0F); A3 = Noop, added for completing the sequence of bytes, so both expressions have the same length.

**Original code**:

```asl
  Method (_STA, 0, NotSerialized)
  {
      If (HPTE)
      {
          Return (0x0F)
      }
      Return (Zero)
  }
```
**Code after find and replace rules have been applied**:

```asl
  Method (_STA, 0, NotSerialized)
  {
        Return (0x0F)
        Noop
        TE** ()
        Return (Zero)
  }
```
### Explanation
What happened here? There is an obvious error after applying the find and replace masks, but this error does not cause any harm. First, the content after `Return (0x0F)` will not be executed. Second, the error is located inside `{}` and does not affect the rest of the content. 

In practice, we should try our best to ensure the integrity of the grammar after the name change.

Here is an extended `Find` and `Replace` sequence. It's length determines the number of lines/levels that are affected by this `DSDT` patch.
  
**Find**: `00 A0 08 48 50 54 45 A4 0A 0F A4 00` &rarr; [48 50 54 45 = HPTE]</br>
**Replace**: `00 A4 0A 0F A3 A3 A3 A3 A3 A3 A3 A3` &rarr; [A3 = empty operation]

This transforms the original code into this:

```asl
  Method (_STA, 0, NotSerialized)
  {
      Return (0x0F)
      Noop // A3 (8x)
      Noop
      Noop
      Noop
      Noop
      Noop
      Noop
      Noop
  }
```
So basically, you overwrite everything undesirable in the method by `Noop` (A3).

### Requirements
- Unpatched `DSTD` (or other ACPI table you want to patch)
- `Find` uniqueness:
	- There should only be one match, unless your intent is to perform the same Find and Replace operation in multiple locations.
- Number of `Replace` bytes:
	- The number of `Find` and `Replace` bytes must be equal. For example, if `Find` contains 10 bytes, then `Replace` ***must*** also contain 10 bytes. If Replace is less than 10 bytes, fill it up with  pairs of `A3` (noop).

> [!WARNING] 
> If there's a mismatch in size between the `Find` and `Replace` sequence, you will be greeted by a "Patch is borked!" message from OpenCore and the machine won't boot. So create an OC Snapshot with ProperTree to check the config after creating such a binary patch!

## `Find` and `Replace` data lookup method utilizing Hex
Let's assume you want one specific parameter to be changed but the renaming rule you create doesn't target the specific location alone. This method combines viewing the `DSDT` in a text-based IDE like maciASL by finding surrounding data pattern in `Hex` to target a specific location to limit the reach of a binary rename. 

This approach is a bit outdated since we now have modifiers like `base` to specify exact locations where to apply a patch. 

**This is how it works**:

- Find the device, method or parameter you want to change in a `DSDT` in maciASL.
- View the `DSDT` as Hex code (Visual Studio Code has an extension for it) and find the corresponding section
- Look at the surrounding Code
- Select and incorporate a few characters left and right of what you actually want to change and use that as your `Find` mask – since it's in hex already you can just copy it over.
- Next, you change the "inside" of the mask (the parameter you actually want to change) and leave the surrounding code alone to create your unique `Replace` rule.
- Apply and test.

> [!NOTE]
> 
> You need to ensure that the sequence you want to change is a unique pattern, otherwise it will be applied in more than one section.

## Preset variable method techniques
The preset variable method is used to pre-assign some variables of ACPI to the `FieldUnitObj` to achieve the purpose of initialization. Although these variables are assigned values, they are not changed until their method is called. Modifying these variables through third-party patch Scope (\) files can achieve our expected patch effect.

### Risks
The variable being fixed may exist in multiple places, and fixing it may affect other components while achieving the desired effect. The corrected variable may be from hardware information that can only be read but not written. In this case, a binary rename and SSDT patch are required. It should be noted that the renamed variable may not be recovered when the OC boots another system. See Example 4.

### Example 1
A device's original `_STA` method:

```asl
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
Let's say, for some reason, we need to disable this device, so the `Return` of `_STA` is `Zero`. But as you can see, as long as `SDS1` is not equal to `0x07`, the return value `0x0F` is not triggered which in return triggers the second condition in this cascade, `Return (Zero)` Therefore, we cannot simply change the the return value to `Zero` – it wouldn't have any effect. Therefore, we need to change `SDS1` to `0` for macOS instead:

```asl
Scope (\)
{
    External (SDS1, FieldUnitObj)
    If (_OSI ("Darwin"))
    {
        SDS1 = 0
    }
}
```
This has the same effect as changing `Return` to `Zero` because it becomes true, which returns `0x0F` which results in Zero being returned.

### Example 2: `SSDT-AWAC`
The official patch `SSDT-AWAC` is for some 300+ series machines to force `RTC` to be enabled and `AWAC` to be disabled at the same time.

Code Snippet from `DSDT`:

```asl
Device (RTC)
{
    ...
    Method (_STA, 0, NotSerialized)
    {
            If ((STAS == One))
            {
                Return (0x0F)
            }
            Else
            {
                Return (Zero)
            }
    }
    ...
}
Device (AWAC)
{
    ...
    Method (_STA, 0, NotSerialized)
    {
            If ((STAS == Zero))
            {
                Return (0x0F)
            }
            Else
            {
                Return (Zero)
            }
    }
    ...
}
```
As can be seen from the original text, as long as `STAS=1`, `RTC` is enabled and `AWAC` is disabled. The preset variable method is used as follows:

**Official Patch `SSDT-AWAC`:**

```asl
External (STAS, IntObj)

Scope (_SB)
{
	Method (_INI, 0, NotSerialized)  /* _INI: Initialize */
	{
		If (_OSI ("Darwin"))
		{
			STAS = One
		}
	}
}
```
**Note**: The official patch introduces a path `_SB._INI`, and it should be confirmed that `DSDT` and other patches do not exist when using it. Therefore, using an `IntObj` is safer:

**Improved patch SSDT-AWAC**

```asl
External (STAS, IntObj)
	Scope (\)
	{
		If (_OSI ("Darwin"))
		{
			STAS = One
		}
	}
```
### Example 3: `GPIO` Patch
This patch is required for enabling the GPIO pin for using I2C Touchpads. See Chapter [Trackpad Patches](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05_Laptop-specific_Patches/Trackpad_Patches) for further details.

An original text:

```asl
Method (_STA, 0, NotSerialized)
{
    If ((GPEN == Zero))
    {
        Return (Zero)
    }
    Return (0x0F)
}
```

As you can see, `GPEN` is `0` can be enabled as long as is not equal to `GPIO`. The preset variable method is used as follows:

```asl
External(GPEN, FieldUnitObj)
Scope (\)
{
    If (_OSI ("Darwin"))
    {
        GPEN = 1
    }
}
```

### Example 4

When the variable read-only, the workaround is as follows:

1. Rename the original method
2. Redefine it with an SSDT and return back the required value

**For example:**

```asl
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
This translates as follows: unless `IM01` is not equal to `0x02`, the content of {...} cannot be executed. To correct the error use binary rename and SSDT patch:

1. **Binary Rename**:
	
	**Comment**: Change `IM01` rename `XM01`</br>
	**Find**: 49 4D 30 31 08 </br>
	**Replace**: 58 4D 30 31 08

2. **SSDT Patch**: 
	
 	```asl
	Name (IM01, 0x02)

	If (_OSI ("Darwin"))
	{
          ...
  	}	
	Else
	{
          IM01 = XM01 /* The same path as the original ACPI variable */
	}
	```

### Example 5
Change the enable bit of the device state using an assignment operation that references the device's original `_STA` method as an `IntObj`.

```asl
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
As shown in this example the `_STA` method contains only the enable bit to return the state of the device and the enable bit returned according to the conditions. If you don't want to use the rename rules you can also change the conditions of the preset variables via a custom SSDT which can directly refer to the `_STA` method as an `IntObj`.

**Example**:

```asl
External (_SB_.PCI0.XXXX._STA, IntObj)

\_SB.PCI0.XXXX._STA = Zero 
```

Please refer to the ASL basics for the specific setting of the enable bit of the `_STA` method.

The main reason why this method works in practice is that in the ACPI specification the `_STA` method has a higher priority than `_INI`, `_ADR` of `_HID` in the OS OSPM module for device state evaluation and initialization and the return value of `_STA` itself is an integer.

**Example** of an operation that cannot use this method:

```asl
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
    ^^^GFX0.CLKF = 0x03
    Return (Zero)
}
```
The original `_STA` method contains other operations besides setting the conditional device status enable bit so that's why this approach cna't be applied in this case.

**Risk**: `XM01` may not be recovered when OC boots other systems.
