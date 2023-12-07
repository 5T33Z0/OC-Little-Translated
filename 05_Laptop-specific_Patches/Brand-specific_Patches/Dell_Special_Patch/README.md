# Special patches for Dell machines

## `DSDT` Requirements
Check if the following Devices and Methods exist in your `DSDT` and that the names match. Otherwise ignore this chapter.

  - **Device**: `ECDV` [HID `PNP0C09`]
  - **Device**: `LID0` [HID `PNP0C0D`]
  - **Method**: `OSID`
  - **Method**: `BTNV`
  - **Method**: `PNLF`

### Required rename for `SSDT-PNLF` hotfix
Some Dell machines use the variable `PNLF` in the `DSDT`, which may conflict with the brightness patch since it uses the same name, so we change it to `XNLF` to avoid naming conflicts:

```text
Find: 504E4C46
Replace: 584E4C46
Comment: Change PNLF to XNLF
```
### `SSDT-OCWork-dell`

The `OSID` method exists on most Dell machines. It includes two variables, `ACOS` and `ACSE`, which determine the machine's operating mode. For example, the ACPI brightness shortcut method only works if `ACOS` >= `0x20`. 

Following are some of the relationships between the 2 variables and the operating mode. For more details about the `OSID` method, please see DSDT's `Method (OSID…`:

- `ACOS` >= `0x20`, the brightness shortcut works
- `ACOS` = `0x80` and `ACSE` = `0` for win7 myode. In this case the breathing light blinks during machine sleep
- `ACOS` = `0x80`, `ACSE` = 1 for win8 mode. In this case the breathing light is off during the machine sleep
- The specific content of the 2 variables in the `OSID` method depends on the OS itself, you must use **OSID patch** or **this patch** to change these 2 variables to meet the requirements macOS expects.

## Patch combination for fixing `Fn`+`Insert` keyboard shortcut

- ***SSDT-PTSWAK*** &rarr; See [Comprehensive Sleep and Wake Patch](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/PTSWAK_Sleep_and_Wake_Fix)
- ***SSDT-EXT3-WakeScreen*** &rarr; See [Comprehensive Sleep and Wake Patch](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/PTSWAK_Sleep_and_Wake_Fix)
- ***SSDT-LIDpatch*** &rarr; See [Fixing `PNP0C0E` Sleep](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/PNP0C0E_Sleep_Correction_Method)
- ***SSDT-FnInsert_BTNV-dell*** &rarr; See [Fixing `PNP0C0E` Sleep](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/PNP0C0E_Sleep_Correction_Method)

## Enabling 4k output on Dell Optiplex 3070 and 7070
&rarr; [**Guide**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/05_Laptop-specific_Patches/Brand-specific_Patches/Dell_Special_Patch/Enable_4k_Dell_Optiplex.md)