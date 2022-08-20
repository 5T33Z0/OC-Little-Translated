# Advanced Patching Strategies

## Really hacky Binary Rename patches
A usual application of using binary renams is to disable a `Device` or `Method` in the `DSDT` so macOS doesn't recognize it, so we can either modify or replace it via an SSDT. 
But besides that you can also use them in a rather unconventional way to enable or disable a device by literally breaking the section in such a way that only the desired parts of it remain intact. 

### Risks

ACPI binary renaming affects other Operating Systems when using OpenCore for booting.

### Example: Enabling HPET

Let's take enabling `HPET` for example. We want it to return `0x0F` for `_STA`. Here's the renaming rule:

**Find**: `00 A0 08 48 50` &rarr; "00 = {; A0 = If ......"</br>
**Replace**| `00 A4 0A 0F A3` &rarr; "00 = {; A4 0A 0F = Return(0x0F); A3 = Noop, added for completing the sequence of bytes, so both expressions have the same length.

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
**Code after find and replace has been applied**:

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

What happened here? There is an obvious error after renaming, but this error does not cause harm. First, the content after `Return (0x0F)` will not be executed. Second, the error is located inside `{}` and does not affect the rest of the content. 

In practice, we should try our best to ensure the integrity of the grammar after the name change.

Here is a extended `Find` and `Replace` sequence – the length of the sequence determines the number of lines/levels that are affected by this `DSDT` patch.
  
**Find**:    `00 A0 08 48 50 54 45 A4 0A 0F A4 00` &rarr; [48 50 54 45 = HPTE]</br>
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
**NOTE**: I (5T33Z0) have never come across in a config and also haven't fully grasped it yet. I wouldn't recommend this type of hack when using OpenCore.

### Requirements
- Unpatched `DSTD` (or other ACPI table you want to patch)
- `Find` uniqueness:
	- There should only be one match, unless your intent is to perform the same Find and Replace operation in multiple locations.
   - **Special Note**: Any rewriting of a piece of code to find confirmed binary data from is highly untrustworthy!
- Number of `Replace` bytes:
	- The number of `Find` and `Replace` bytes must be equal. For example, if `Find` is 10 bytes, then `Replace` ***must*** also contain 10 bytes. If Replace is less than 10 bytes, use A3 (empty operation) to make it up.
	- :warning: If there's a mismatch in the size between the `Find` and `Replace` sequence, you will be greeted by a "Patch is borked!" message from OpenCore and the machine won't boot.

## `Find` data lookup method
This method combines viewing the `DSDT` in a text-based editor like maciASL with finding data patterns by viewing the table as raw data in a Hex Editor (Visual Studio Code has an extension for that). This way, you can find the relevant content in binary data and text, observe the context, and you will soon be able to determine the `Find` data.

## Replace content

The Requirements state that when `Find` is done, [any rewriting of a piece of code to find confirmed binary data from it is highly implausible! However, Replace can work this way. Following the example above, we write a piece of code.

## Preset variable method techniques
The preset variable method is used to pre-assign some variables of ACPI to `FieldUnitObj` to achieve the purpose of initialization. Although these variables are assigned values, they are not changed until their method is called. Modifying these variables through third-party patch Scope (\) files can achieve our expected patch effect.

### Risks

The variable being fixed may exist in multiple places, and fixing it may affect other components while achieving thes desired effect. The corrected variable may be from hardware information that can only be read but not written. In this case, a binary rename and SSDT patch are required. It should be noted that the renamed variable may not be recovered when the OC boots another system. See Example 4.

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
Let's say, for some reason, we need to disable this device, so the `Return` of `_STA` is `Zero`. But as you can see, as long as `SDS1` is not equal to `0x07`, the return value `0x0F` is not triggered which in return triggers the second condition in this cascade, `Return (Zero)` Therefore, we cannot simply change the the return value to `Zero` – it wouldn't have any effect. Therefore we need to change `SDS1` to `0` for macOS insteead:

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

### Example 2: SSDT-AWAC
The official patch `SSDT-AWAC` is for some 300+ series machines to force `RTC` to be enabled and `AWAC` to be disabled at the same time.

original:

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
### Example 3: GPIO Patch
This patch is required for enabling the GPIO pin for using I2C Touchpads. See Chapter Trackpad Patches for details.

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

When the variabl read-only, the workaround is as follows:

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
	
	**Comment**: Change IM01 rename XM01</br>
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

Example:

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
It can be seen that the above example of the `_STA` method contains only the enable bit to return the state of the device and the enable bit returned according to the conditions, if you do not want to use the rename and change the conditions of the preset variables can be in the custom SSDT can directly refer to the `_STA` method as `IntObj`.

Example of operation to disable a device.

```asl
External (_SB_.PCI0.XXXX._STA, IntObj)

\_SB.PCI0.XXXX._STA = Zero 
```

Please refer to the ASL language basics for the specific setting of the enable bit of the `_STA` method.

The main reason why this method works in practice is that in the ACPI specification the `_STA` method has a higher priority than `_INI`, `_ADR` of `_HID` in the OS OSPM module for device state evaluation and initialization and the return value of `_STA` itself is an integer.

Example of an operation that cannot use this method:

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
From the above example, we can see that the original `_STA` method contains other operations besides setting the conditional device status enable bit.

**Risk**: XM01 may not be recovered when OC boots other systems.
