# Fixing `PNP0C0E` Sleep

## Problem description

Some machines have an extra sleep button (half moon symbol) or a keyboard shortcut for entering sleep state, e.g. `Fn+F4` on some ThinkPads, `Fn+Insert` for Dell, etc. When this button/keyboard shortcut is pressed, the system enters what's called `PNP0C0E` sleep. However, on some machines ACPI incorrectly passes over shutdown parameters to the system instead, which causes it to crash/reset. Even if a system is able to enter sleep state it resets when trying to resume from sleep. 

To resolve this issue, the following fixes can be applied:

- Intercept the parameter passed over by ACPI and correct it.
- Convert `PNP0C0E` sleep to `PNP0C0D` sleep.

## `PNP0C0E`/`PNP0C0D` Sleep methods explained

- **ACPI Specifications**:
	- `PNP0C0E` &rarr; Hardware ID of Sleep Button Device `SLPB`
	- `PNP0C0D` &rarr; Hardware ID of Lid Device `LID0`
- `PNP0C0E` Sleep condition:
	- If the Sleep Button is pressed
	- `Notify(***.SLPB, 0x80)` is triggered
- `PNP0C0D` Sleep condition:
  - If the lid is closed, `_LID` method returns `Zero`. (`_LID` is the control method for the `PNP0C0D` device) on Laptops.
  - `Notify(***.LID0, 0x80)` is triggered

### `PNP0C0E` Sleep characteristics

- Entering sleep state is slightly faster than using `PNP0C0D` sleep.
- But it cannot be interrupted while entering sleep.
- Enabled by setting `MODE` = `1` in ***SSDT-PTSWAKTTS***

### `PNP0C0D` Sleep characteristics

- Entering sleep can be interrupred immediately by pressing the sleep button again.
- When connected to an external display, pressing the sleep button has the following effect:
	- Internal screen is switched off 
	- Main screen switches over to the external display
	- Pressing the sleep button again restores the previous state.
- Enabled by setting `MODE` = `0` (default) in ***SSDT-PTSWAKTTS***

**NOTE**: Please refer to the ACPI specification for more details about `PNP0C0E` and `PNP0C0D`.

## Solution

3 Associated Patches:

1. ***SSDT-PTSWAKTTS***: defines variables `FNOK` and `MODE` to capture changes in `FNOK` and trigger the preferred sleep state. See [**PTSWAK Comprehensive Patch**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/PTSWAK_Sleep_and_Wake_Fix) for details.
	- `FNOK` indicates the key state:  
		- `FNOK` = `1`: Sleep button is pressed
		- `FNOK` = `0`: After pressing the sleep button/waking the machine again
	- `MODE` sets the sleep mode:
		- `MODE` = `1`: `PNP0C0E` sleep
		- `MODE` = `0`: `PNP0C0D` sleep

	:bulb: **NOTE**: Set `MODE` according to your needs, but do not change `FNOK`!

2. ***SSDT-LIDpatch***: Captures `FNOK` changes

	- If `FNOK` = `1`, the current state of the lid device returns `Zero`.  
	- If `FNOK` = `0`, the current state of the lid device returns to the original value.

3. ***Sleep Button Patch***: When the sleep button is pressed, `FNOK` is set to `1`, resulting in triggering the selected sleep `MODE`.

### Description of the two Sleep Modes

#### `MODE` = `1`: `PNP0C0E` sleep. 
When the sleep button is pressed, ***Sleep button patch*** sets `FNOK=1`, ***SSDT-PTSWAK*** captures `FNOK` as `1` and forces `Arg0=3` (otherwise `Arg0=5`). After waking the system, `FNOK=0` is restored, thus completing the `PNP0C0E` sleep/wake cylce.

#### `MODE` = `0`: `PNP0C0D` sleep
When the sleep button is pressed, in addition to triggering the process above, ***SSDT-LIDpatch*** catches `FNOK=1`, and in return sets `_LID` to `Zero`, triggering `PNP0C0D` sleep. After waking up, `FNOK = 0` is restored, completing the `PNP0C0D` sleep/wake cycle.

The following are the main contents of ***SSDT-LIDpatch***:

```asl
Method (_LID, 0, NotSerialized)
{
    if(\_SB.PCI9.FNOK==1)
    {
        Return (0) /*If FNOK is 1, the Return Value is 0, so the PNP0C0D sleep conditions is met*/
    }
    Else
    {
        Return (\_SB.LID0.XLID()) /*Returns the original value*/
    }
}
```
Here are the main contents of the ***Sleep Button Patch***:

```asl
If (\_SB.PCI9.MODE == 1) /* PNP0C0E sleep */
{
    \_SB.PCI9.FNOK =1 /* Press sleep button */
    \_SB.PCI0.LPCB.EC.XQ13() /* Sleep button location (after binary rename). Example is from a Lenovo ThinkPad*/
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
  - PTSWAK renames: `_PTS` to `ZPTS`, `_WAK` to `ZWAK`
  - Lid Method rename: `_LID` to `XLID`
  - Function Key rename: `BTNV` to `XTNV` (Dell-Fn+Insert)

- **Patch combination**:
  - ***SSDT-PTSWAK***: Combined patch. Set `MODE` according to your needs.
  - ***SSDT-LIDpatch***: Lid status patch. Adjust ACPI paths for Lid device and `_LID` control method as needed
  - ***SSDT-FnInsert_BTNV-dell***: Sleep button patch.

### Example 2: ThinkPad X1C5th
- **ACPI Renames**:
	- PTSWAK renames: `_PTS` to `ZPTS` and `_WAK` to `ZWAK`
	- Lid Method rename: `_LID` to `XLID`
	- Function Key rename: `_Q13 to XQ13` (TP-Fn+F4)
- **Patch combination**:
  - ***SSDT-PTSWAK***: Combined patch. Set `MODE` according to your needs.
  - ***SSDT-LIDpatch***: Lid status patch. Adjust ACPI paths for Lid device and `_LID` control method as needed.
  - ***SSDT-FnF4_Q13-X1C5th***: Sleep button patch.

**NOTES**:

- The Sleep Button on X1C5th is `Fn+4`, on other ThinkPads it can be`Fn+F4`  
- On ThinkPads, the `LPC` bus name can also be `LPCB`.

## Fixing `PNP0C0E` Sleep on other machines

- Add ***SSDT-PTSWAKTTS*** 
	- rename `_PTS` to `ZPTS` and `_WAK` to `ZWAK`. See [**PTSWAK Sleep and Wake Fix**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/PTSWAK_Sleep_and_Wake_Fix) for instructions. 
	- Modify `MODE` to suit your needs.
- Use patch: ***SSDT-LIDpatch***; rename: `_LID` to `XLID`.
	- Note: `PNP0C0D` device name and path should be the same as ACPI.
- Find the location of the sleep button and make a ***Sleep button patch***.
  - Usually, the sleep button is `_Qxx` under `EC`, and this `_Qxx` contains the `Notify(***.SLPB,0x80)` instruction. If you can't find it, search for `Notify(***.SLPB,0x80)` in the `DSDT`, find its location, and gradually work its way up to the initial location.
  - Refer to the examples to create the sleep button patch and the necessary name change.

## Caution
- If your DSDT doen't contain sleep button device `SLPB` (`PNP0C0E`), add [**SSDT-SLPB**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Power_and_Sleep_Button_(SSDT-PWRB:SSDT-SLPB)).
- `PNP0C0E` and `PNP0C0D` device names and paths should be consistent with the paths used in your `DSDT`.