# Fixing PNP0C0E Sleep

## Problem description

Some machines have a sleep button (half moon button), e.g. `Fn+F4` for some ThinkPads, `Fn+Insert` for Dell, etc. When this button is pressed, the system enters what's called `PNP0C0E` sleep. However, ACPI incorrectly passes shutdown instead of sleep parameters to the system, which causes it to crash/reset. Even if the system is able to sleep it resets on wake.

One of the following methods can fix this problem:

- Intercept the parameter passed by ACPI and correct it.
- Convert `PNP0C0E` sleep to `PNP0C0D` sleep.

## PNP0C0E/PNP0C0E Sleep method explained

- **ACPI Specifications**:
	- `PNP0C0E` &rarr; Hardware ID of Sleep Button Device `SLPB`
	- `PNP0C0D` &rarr; Hardware ID of Lid Device `LID0`
- `PNP0C0E` Sleep condition:
	- If the Sleep Button is pressed
	- `Notify(***.SLPB, 0x80)` is triggered
- `PNP0C0D` Sleep condition:
  - If the lid is closes, `_LID` method returns `Zero`. (`_LID` is the control method for the `PNP0C0D` device).
  - `Notify(***.LID0, 0x80)` is triggered

### `PNP0C0E` Sleep characteristics

- The sleep process is slightly faster.
- But it cannot be terminated/interrupted.
- Enabled by setting `MODE` = `1` in ***SSDT-PTSWAKTTS***

### `PNP0C0D` Sleep characteristics

- Sleep process is terminated immediately by pressing the sleep button again.
- When connected to an external display, pressing the sleep button does the following:
	- Internal screen is switched off 
	- Working screen siwtches to the external display
	- Pressing the sleep button again restores the previous state.
- Enabled by setting `MODE` = `0` (default) in ***SSDT-PTSWAKTTS***

**NOTE**: Please refer to the ACPI specification for more details about `PNP0C0E` and `PNP0C0D`.

## Solution

### 3 Associated Patches

- ***SSDT-PTSWAK***: define variables `FNOK` and `MODE` to capture changes in `FNOK`. See [**PTSWAK Comprehensive Patch**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/PTSWAK_Sleep_and_Wake_Fix) for details.
	- `FNOK` indicates the key state:  
		- `FNOK` = `1`: Sleep button is pressed
		- `FNOK` = `0`: After pressing the sleep button again or the machine is woken up
	- `MODE` sets the sleep mode:
		- `MODE` = `1`: `PNP0C0E` sleep
		- `MODE` = `0`: `PNP0C0D` sleep

:bulb: **NOTE**: Set `MODE` according to your needs, but do not change `FNOK`!

- ***SSDT-LIDpatch*** : Capture `FNOK` changes

  	If `FNOK` = `1`, the current state of the cover device returns `Zero`.  
  	If `FNOK` = `0`, the current state of the lid device returns to the original value

  **NOTE**: `PNP0C0D` device name and path should be consistent with ACPI.

- ***Sleep Button Patch***: When the button is pressed, make `FNOK` = `1` and perform the corresponding operation according to different sleep modes

**NOTE**: `PNP0C0D` device name and path should be the same as in the `DSDT`.

#### Description of the two Sleep Modes

- `MODE` = `1`: When the sleep button is pressed, ***Sleep button patch*** sets `FNOK=1` ***SSDT-PTSWAK*** captures `FNOK` as `1` and forces `Arg0=3` (otherwise `Arg0=5`). Restore `FNOK=0` after wakeup. A complete `PNP0C0E` sleep and wakeup process is finished.

- `MODE` = `0`: When the sleep button is pressed, in addition to completing the above process, ***SSDT-LIDpatch*** also catches `FNOK=1`, `_LID` return to `Zero` and executes `PNP0C0D` sleep. After waking up, `FNOK` returns to `0`, which completes the `PNP0C0D` sleep and wake cycle.

The following are the main contents of ***SSDT-LIDpatch***:

```asl
Method (_LID, 0, NotSerialized)
{
    if(\_SB.PCI9.FNOK==1)
    {
        Return (0) /* 返回 Zero, 满足 PNP0C0D 睡眠条件之一 */
    }
    Else
    {
        Return (\_SB.LID0.XLID()) /* 返回原始值 */
    }
}
```
Here are the main contents of the ***Sleep Button Patch***:

```asl
If (\_SB.PCI9.MODE == 1) /* PNP0C0E sleep */
{
    \_SB.PCI9.FNOK =1 /* Press sleep button */
    \_SB.PCI0.LPCB.EC.XQ13() /* Original sleep button position, example is TP machine */
}
Else /* PNP0C0D sleep */
{
    If (\_SB.PCI9.FNOK!=1)
    {
            \_SB.PCI9.FNOK =1 /* Press sleep button */
    }
    Else
    {
            \_SB.PCI9.FNOK =0 /* Press the sleep button again */
    }
    Notify (\_SB.LID, 0x80) /* Execute PNP0C0D sleep */
}
```

## Name change and patch combination examples

### Example 1: Dell Latitude 5480

- **ACPI Renames**:
  - PTSWAK renamed: `_PTS` to `ZPTS`, `_WAK` to `ZWAK`
  - Cover state renaming: `_LID` to `XLID`
  - Functionm Key rename: `BTNV` to `XTNV` (Dell-Fn+Insert)

- **Patch combination**:
  - ***SSDT-PTSWAK***: Combined patch. Set `MODE` according to your needs.
  - ***SSDT-LIDpatch***: Cover status patch.
  - ***SSDT-FnInsert_BTNV-dell***: Sleep button patch.

### Example 2: ThinkPad X1C5th
- **ACPI Renames**:
	- PTSWAK renames: `_PTS` to `ZPTS` and `_WAK` to `ZWAK`
	- Cover Status rename: `_LID` to `XLID`
	- Function Key rename: `_Q13 to XQ13` (TP-Fn+F4)
- **Patch combination**:
  - ***SSDT-PTSWAK***: Combined patch. Set `MODE` according to your needs.
  - ***SSDT-LIDpatch***: Cover status patch. Modify `LID0` to `LID` within the patch.
  - ***SSDT-FnF4_Q13-X1C5th***: Sleep button patch.

**NOTES**:

- The Sleep Button on X1C5th is `Fn+4`, on other ThinkPads it can be`Fn+F4`  
- On ThinkPads the `LPC` controller name could be `LPC` or `LPCB`.

## Fixing `PNP0C0E` Sleep on other machines

- Use patch: ***SSDT-PTSWAK***; 
	- rename `_PTS` to `ZPTS` and `_WAK` to `ZWAK`. See "PTSWAK Comprehensive Extension Patch" for more details. 
	- Modify `MODE` to suit your needs.
- Use patch: ***SSDT-LIDpatch***; rename: `_LID` to `XLID`.
	- Note: `PNP0C0D` device name and path should be the same as ACPI.
- Find the location of the sleep button and make a ***Sleep button patch***.
  - Usually, the sleep button is `_Qxx` under `EC`, and this `_Qxx` contains the `Notify(***.SLPB,0x80)` instruction. If you can't find it, search for `Notify(***.SLPB,0x80)` in the `DSDT`, find its location, and gradually work its way up to the initial location.
  - Refer to the examples to create the sleep button patch and the necessary name change.

**NOTES**:
- `SLPB` is the `PNP0C0E` device name. If it is confirmed that there is no `PNP0C0E` device, add the ***SSDT-SLPB*** (located in Chapter 1).
- `PNP0C0D` device name and path should be the same as in the `DSDT`.

## Caution

- `PNP0C0E` and `PNP0C0D` device name and path should be consistent with ACPI.
