# ThinkPad Battery Patch

## About the ThinkPad Battery System

The ThinkPad Battery system consists of 2 categories: `single` and `dual`  battery systems.

- A single battery system is a machine equipped with one battery and only one battery in defined in ACPI.
- A dual battery system is a machine is equipped with up to two batteries. The second battery is optional and can be installed later. A dual battery system may have one battery or two batteries.

For example, the T470/T470s belongs in the dual battery systems category wherea the T470P belongs in the single battery category. On the other hand the T430 series belongs to the dual battery systems, although the machine itself has only one battery, but a second battery can be installed through the optical drive bit.

## Instructions
In order to get your battery percentage indicator working correctly, you have to do the following: 

1. Determine if you have a single or dual battery system:

	* Single battery systems only have `BAT0` in ACPI, no `BAT1`
	* Dual battery systems have both `BAT0` and `BAT1` in ACPI

2. Combine the correct name changes and Battery Patch(es) required for yoursystem. See the samples below for more details.

**CAUTION**: Make sure the `Battery Path` used in the SSDT patch matches the one used in the DSDT.  
It's either`\_SB.PCI0.`**`LPC`**`.EC.BAT0` or `\_SB.PCI0.`**`LPCB`**`.EC.BAT0`, ***never*** both!

### Example 1: Single-cell Battery

- Required Name Changes:
  - TP Battery Basic Rename
  - TP Battery `Mutex` Place `0` Rename
- Requirres SSDT Patch
  - `Main Battery` Patch  ***SSDT-OCBAT0-TP******

### Example 2: Dual battery system with one physical battery

- Required Name Changes:
  - TP Battery Basic Rename
  - TP Battery `Mutex` Place `0` Rename
  - `BAT1` Disable renaming `_STA to XSTA` 
  
    **Note**: Please use `Count`, `Skip`, `TableSignature` correctly and verify the correct location of `_STA to XSTA` by system-DSDT.

- Required Patches:
  
  - `Main Battery` patch -- ***SSDT-OCBAT0-TP****** 
  - `BAT1` disable patch -- ***SSDT-OCBAT1-disable-`LPC`*** [or ***SSDT-OCBAT1-disable-`LPCB`***]

### Example 3: Dual battery system with two physical batteries

- Name Change
  - TP Battery Basic Rename
  - TP Battery `Mutex` Place `0` Rename
  - `Notify` rename
- Required Patches:
  - `Main Battery` Patch -- ***SSDT-OCBAT0-TP******
  - `BATC` patch -- ***SSDT-OCBATC-TP-`LPC`*** [or ***SSDT-OCBATC-TP-`LPCB`*** , ***SSDT-OCBATC-TP-`_BIX`***]
  - `Notify` patch -- ***SSDT-Notify-`LPC`*** [or ***SSDT-Notify-`LPCB`***]
   
  **NOTE**:
  - When `BATC` patch is selected, use ***SSDT-OCBATC-TP-`_BIX`*** for Gen 7+ machines 
    - When you select the `Notify` patch, you should **Check carefully** if the `_Q22`, `_Q24`, `_Q25`, `_Q4A`, `_Q4B`, `_Q4C`, `_Q4D`, `BATW`, `BFCC`, etc. in the patch are consistent with the original `ACPI` counterparts, if not, please fix the patch accordingly. If not, please fix the corresponding content of the patch. For example: the content of `_Q4C` of Gen 3 machine is different from the sample content; Gen 4, Gen 5, Gen 6, Gen 7 machines do not have `_Q4C`; Gen 7+ machines have `BFCC`. Wait for ....... Sample file ***SSDT-Notify-`LPCB`*** for T580 only .
- Loading order:
  - `Main Battery` patch
  - `BATC` patch
  - `Notify` patch

### Precautions

- ***SSDT-OCBAT0-TP****** is the `Main Battery` patch. Select the corresponding patch according to the machine model when selecting.
- When selecting the patch, you should pay attention to the difference between `LPC` and `LPCB`.
- If you want to change the name of `TP Battery Mutex to 0`, try it yourself.

## `Notify` patch example [Only `Method (_Q22`, ... Part]

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

