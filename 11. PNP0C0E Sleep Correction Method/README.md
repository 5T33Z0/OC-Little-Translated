## Fixing PNP0C0E Sleep Method

- ACPI Specification:

  `PNP0C0E` - Sleep Button Device  
  `PNP0C0D` - Lid Device

  Please refer to the ACPI specification for details on `PNP0C0E` and `PNP0C0D`.

- `PNP0C0E` Sleep conditions:

  - Execute `Notify(***.SLPB, 0x80)`. `SLPB` is the `PNP0C0E` device name.
  
- `PNP0C0D` Sleep condition

  - `_LID` returns `Zero` . `_LID` is the current state of the `PNP0C0D` device.
  - Execute `Notify(***.LID0, 0x80)`. `LID0` is the `PNP0C0D` device name.

## Problem description

Some machines provide a sleep button (small moon button), e.g. `Fn+F4` for some ThinkPads, Fn+Insert for Dell, etc. When this button is pressed, the system performs `PNP0C0E` sleep. However, ACPI incorrectly passes shutdown parameters to the system instead of sleep parameters, which causes the system to crash. Even if it is able to sleep it wakes up normally and the system's working state is destroyed.

One of the following methods can fix this problem:

- Intercept the parameter passed by ACPI and correct it.
- Convert `PNP0C0E` sleep to `PNP0C0D` sleep.

## Solution

### 3 Associated Patches

- ***SSDT-PTSWAKTTS***: Defines `FNOK` and `MODE` variables to capture the change of `FNOK`. See the PTSWAK Integrated Extension Patch.

	`FNOK` indicates keystroke status  
	`FNOK` = 1: Sleep button is pressed  
	`FNOK` = 0: Sleep button is pressed again or after the machine is woken up  
	`MODE` sets the sleep mode  
	`MODE` = 1: `PNP0C0E` sleep  
	`MODE` = 0: `PNP0C0D` sleep

  **Note**: Set `MODE` according to your needs, but do not change `FNOK`.

- ***SSDT-LIDpatch*** : Capture `FNOK` changes

  	If `FNOK` = 1, the current state of the cover device returns `Zero`.  
  	If `FNOK` = 0, the current state of the lid device returns to the original value

  **Note**: `PNP0C0D` device name and path should be consistent with ACPI.

- ***Sleep Button Patch***: When the button is pressed, make `FNOK` = `1` and perform the corresponding operation according to different sleep modes

**Note**: `PNP0C0D` device name and path should be the same as ACPI.

#### Description of the two Sleep Modes

- `MODE` = 1: When the sleep button is pressed, ***Sleep button patch*** sets `FNOK=1`. ***SSDT-PTSWAK*** captures `FNOK` as `1` and forces `Arg0=3` (otherwise `Arg0=5`). Restore `FNOK=0` after wakeup. A complete `PNP0C0E` sleep and wakeup process is finished.

- `MODE` = 0: When the sleep button is pressed, in addition to completing the above process, ***SSDT-LIDpatch*** also pounces on `FNOK=1`, causing `_LID` to return to `Zero` and executing `PNP0C0D` sleep. Resume `FNOK=0` after wakeup. A complete `PNP0C0D` sleep and wake-up process is completed.

The following are the main contents of ***SSDT-LIDpatch***:

```
Method (_LID, 0, NotSerialized)
{
    if(\_SB.PCI9.FNOK==1)
    {
        Return (0) /* Return Zero, one of the PNP0C0D sleep conditions is met */
    }
    Else
    {
        Return (\_SB.LID0.XLID()) /* Return the original value */
    }
}
```
Here are the main contents of the ***Sleep Button Patch***:

```
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


### Name change and patch combination examples

#### Example 1: Dell Latitude 5480

- **ACPI Renames**:
  - PTSWAK renamed: `_PTS` to `ZPTS`, `_WAK` to `ZWAK`
  - Cover state renaming: `_LID` to `XLID`
  - Functionm Key rename: `BTNV` to `XTNV` (Dell-Fn+Insert)

- **Patch combination**:
  - ***SSDT-PTSWAK***: Combined patch. Set `MODE` according to your needs.
  - ***SSDT-LIDpatch***: Cover status patch.
  - ***SSDT-FnInsert_BTNV-dell***: Sleep button patch.

#### Examples 2: ThinkPad X1C5th

- **ACPI Renames**:
	- PTSWAK renames: `_PTS` to `ZPTS` and `_WAK` to `ZWAK`
	- Cover Status rename: `_LID` to `XLID`
	- Function Key rename: `_Q13 to XQ13` (TP-Fn+F4)
  
- **Patch combination**:
  
  - ***SSDT-PTSWAK***: Combined patch. Set `MODE` according to your needs.
  - ***SSDT-LIDpatch***: Cover status patch. Modify `LID0` to `LID` within the patch.
  - ***SSDT-FnF4_Q13-X1C5th***: Sleep button patch.
  
  **Note 1**: The Sleep Button on X1C5th is `Fn+4`, on other ThinkPads it can be`Fn+F4`  
  **Note 2**: On ThinkPads the `LPC` controller name could be `LPC` or `LPCB`.

### Fix `PNP0C0E` Sleep on other machines

- Use patch: ***SSDT-PTSWAK***; rename `_PTS` to `ZPTS` and `_WAK` to `ZWAK`. See "PTSWAK Comprehensive Extension Patch" for more details.

  Modify `MODE` to suit your needs.

- Use patch: ***SSDT-LIDpatch***; rename: `_LID` to `XLID` .

  Note: `PNP0C0D` device name and path should be the same as ACPI.

- Find the location of the sleep button and make a ***Sleep button patch***.

  - Normally, the sleep button is `_Qxx` under `EC`, and this `_Qxx` contains the `Notify(***.SLPB,0x80)` instruction. If you can't find it, DSDT searches for `Notify(***.SLPB,0x80)`, finds its location, and gradually works its way up to the initial location.
  - Refer to the example to create the sleep button patch and the necessary name change.

  Note 1: SLPB is the `PNP0C0E` device name. If it is confirmed that there is no `PNP0C0E` device, add the patch: SSDT-SLPB (located in Adding Missing Parts).

  Note 2: `PNP0C0D` device name and path should be the same as ACPI.

### `PNP0C0E` Sleep characteristics

- The sleep process is slightly fast.
- The sleep process cannot be terminated.

### `PNP0C0D` Sleep characteristics

- Sleep process is terminated immediately by pressing the sleep button again.

- When connected to external display, after pressing the sleep button, the working screen is external display (internal screen is off); press the sleep button again, the internal screen and external display are normal.

## Caution

- `PNP0C0E` and `PNP0C0D` device name and path should be consistent with ACPI.
