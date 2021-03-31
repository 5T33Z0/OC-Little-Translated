# ThinkPad Battery Patch

## Instructions

- Please read `Attachment` "ThinkPad Battery System".
- Make sure the `Main Battery` path is `\_SB.PCI0.`**`LPC`**`.EC.BAT0` or `\_SB.PCI0.`**`LPCB`**`.EC.BAT0`, not both, the contents of this chapter are for reference only.
- The following is divided into **three cases** to illustrate the use of battery patches.

### I. Single-cell system renaming and patching

- Name changes:
	- TP Battery Basic Rename
  	- TP Battery `Mutex` Place `0` Rename
- Patch:
  	- `Main Battery` Patch -- ***SSDT-OCBAT0-TP***

### II. Dual battery system one physical battery renamed and patched

- Name Changes:
	- TP Battery Basic Rename
  	- TP Battery `Mutex` Place `0` Rename
  	- `BAT1` Disable renaming `_STA to XSTA` 
  
    **Note**: Please use `Count`, `Skip`, `TableSignature` correctly and verify the correct location of `_STA to XSTA` by system-DSDT.
- Patches
  
  - `Main Battery` patch -- ***SSDT-OCBAT0-TP****** 
  - `BAT1` disable patch -- ***SSDT-OCBAT1-disable-`LPC`*** [or ***SSDT-OCBAT1-disable-`LPCB`***]

### III .Dual battery system two physical batteries renamed and patched

- Name Change
  - TP Battery Basic Rename
  - TP Battery `Mutex` Place `0` Rename
  - `Notify` rename
- Patch
  - `Main Battery` Patch -- ***SSDT-OCBAT0-TP******
  - `BATC` patch -- ***SSDT-OCBATC-TP-`LPC`*** [or ***SSDT-OCBATC-TP-`LPCB`*** , ***SSDT-OCBATC-TP-`_BIX`***]
  - `Notify` patch -- ***SSDT-Notify-`LPC`*** [or ***SSDT-Notify-`LPCB`***]
  
    **NOTE**.
  
    - When `BATC` patch is selected, use ***SSDT-OCBATC-TP-`_BIX`*** for Gen 7+ machines 
    - When you select the `Notify` patch, you should **Check carefully** if the `_Q22`, `_Q24`, `_Q25`, `_Q4A`, `_Q4B`, `_Q4C`, `_Q4D`, `BATW`, `BFCC`, etc. in the patch are consistent with the original `ACPI` counterparts, if they are not, please fix the patch accordingly. If not, please fix the corresponding content of the patch. For example: the content of `_Q4C` of Gen 3 machine is different from the sample content; Gen 4, Gen 5, Gen 6, Gen 7 machines do not have `_Q4C`; Gen 7+ machines have `BFCC`. Wait for ....... Sample file ***SSDT-Notify-`LPCB`*** for T580 only .
- Loading order
  - `Main Battery` patch
  - `BATC` patch
  - `Notify` patch

## Caution

- ***SSDT-OCBAT0-TP****** is the `Main Battery` patch. Select the corresponding patch according to the machine model when selecting.
- When selecting the patch, you should pay attention to the difference between `LPC` and `LPCB`.
- If you want to change the name of `TP Battery Mutex to 0`, try it yourself.

## `Notify` patch example [Only `Method (_Q22` ... Part]

> T580 original

```Swift
Method (_Q22, 0, NotSerialized) /* _Qxx: EC Query, xx=0x00-0xFF */
{
    CLPM ()
    If (HB0A)
    {
        Notify (BAT0, 0x80) /* Status Change */
    }

    If (HB1A)
    {
        Notify (BAT1, 0x80) /* Status Change */
    }
}
```

> Rewrite

```swift
/*
 * For ACPI Patch:
 * _Q22 to XQ22:
 * Find: 5f51 3232
 * Replace: 5851 3232
 */
Method (_Q22, 0, NotSerialized) /* _Qxx: EC Query, xx=0x00-0xFF */
{
    If (_OSI ("Darwin"))
    {
        CLPM ()
        If (HB0A)
        {
            Notify (BATC, 0x80) /* Status Change */
        }

        If (HB1A)
        {
            Notify (BATC, 0x80) /* Status Change */
        }
    }
    Else
    {
        \_SB.PCI0.LPCB.EC.XQ22 ()
    }
}
```

See `Notify` patch for details -- ***SSDT-Notify-`BFCC`*** 

> Verified machine is `ThinkPad T580`, patch and rename as follows.

- **SSDT-OCBAT0-TP_tx80_x1c6th** 
- **SSDT-OCBATC-TP-`LPCB`** 
- **SSDT-Notify-`LPCB`** 
- **TP battery basic renamed** 
- **Notify name change** 

### Attachment: ThinkPad Battery System

#### Overview

Thinkpad battery system is divided into single battery system and dual battery system.

- A dual battery system is when the machine is equipped with two batteries. The second battery is optional and can be installed later. A dual battery system may have one battery or two batteries.
- A single battery system is a machine equipped with one battery and only one battery ACPI.

- For example, the battery structure of T470, T470s belongs to the dual battery system, and the battery structure of T470P belongs to the single battery system. Then, for example, the T430 series belongs to the dual battery system, where the machine itself has only one battery, but a second battery can be installed through the optical drive bit.

#### single, dual battery system determination

- Dual battery system: there are both `BAT0` and `BAT1` in the ACPI
- Single battery system: only `BAT0` in ACPI, no `BAT1`
