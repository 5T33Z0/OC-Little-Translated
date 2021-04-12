# Binary Renames

The method described in this section is not about enabling or disabling a `Device` or `Method` in the traditional sense, but rather using binary code to do so.

## Problems and Risks

Since OpenCore injects all patches into the ACPI on boot globally, it consequently affects *all* other Operating Systems installed, which may cause issues when running them.

### Example

Let's take the example of enabling `HPET`. We want it to return `0x0F` for `_STA`.

**Binary renaming:**

- **Find**: `00 A0 08 48 50` "Note: `00` = `{`; `A0` = `If` ......  
- **Replace**: `00 A4 0A 0F A3` `Note: `00` = `{`; `A4 0A 0F` = `Return(0x0F)`; `A3` = `Noop` for completing the number of bytes`

- Original Code:

  ```swift
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

  ```swift
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
  
  ```swift
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

```swift
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

  ```swift
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

  ```swift
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

Original `_STA` Method:

```swift
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

```swift
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

Official patch ***SSDT-AWAC*** for some 300+ tethered machines to force RTC to be enabled and disable AWAC at the same time.

Note: Enabling RTC can also be done with ***SSDT-RTC0***, see Counterfeit Devices.

Original article.

```swift
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

As you can see from the original text, you can enable RTC and disable `AWAC` at the same time as long as `STAS`=`1`. Using the **preset variables method** as follows.

- Official patch ***SSDT-AWAC***

  ```swift
  External (STAS, IntObj)
  Scope (_SB)
  Scope (_SB) {
      Method (_INI, 0, NotSerialized) /* _INI: Initialize */
      {
          If (_OSI ("Darwin"))
          {
              STAS = One
          }
      }
  }
  ```

  Note: The official patch introduces the path `_SB._INI`, you should make sure that `_SB._INI` does not exist in DSDT and other patches when using it.

- Improved patch ***SSDT-RTC_Y-AWAC_N***

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

### Example 3

When using the I2C patch, you may need to enable `GPIO`. See ***SSDT-OCGPI0-GPEN*** of the OCI2C-GPIO Patch.

An original article.

```swift
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

```swift
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

When the `variable` is a read-only type, the solution is as follows.

- Change the name of the original `variable`.
- Redefine a `variable` with the same name in the patch file

E.g., an original

```swift
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

**Patch**:

```swift
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
### Example 5

Change the enable bit of the device state using the assignment of the device's original `_STA` method (Method) referenced as `IntObj` to it.

Example of how this method can be used

```swift
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

```swift
External (_SB_.PCI0.XXXX._STA, IntObj)

\_SB.PCI0.XXXX._STA = Zero 

```
Please refer to **ASL Language Fundamentals** for the details of the `_STA` method's enable bit setting. 

The main reason why this method works in practice is that in the ACPI specification the `_STA` method has a higher priority than `_INI _ADR _HID` in the OS OSPM module for device state evaluation and initialization and the return value of `_STA` itself is an integer `Integer`.

An example of an operation that does not use this method:

```swift
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