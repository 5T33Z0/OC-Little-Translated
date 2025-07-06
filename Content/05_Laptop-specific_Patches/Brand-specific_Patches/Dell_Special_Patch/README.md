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
### Enabling brightness keyboard shortcuts with *SSDT-OCWork-dell.aml*

The `OSID` method exists on most Dell machines. It includes two variables, `ACOS` and `ACSE`. They determine the machine's operating mode. For example, the ACPI brightness shortcut method only works if `ACOS` ≥ `0x20`. 

Following are some of the relationships between the 2 variables and the operating mode. For more details about the `OSID` method, please see DSDT's `Method (OSID…`:

- If `ACOS` ≥ `0x20`, the brightness keyboard shortcuts work
- If `ACOS` = `0x80` and `ACSE` = `0`, enables Windows 7 operating mode. In this mode, the power LED pulses during sleep
- If `ACOS` = `0x80` and `ACSE` = `1`, enables Windows 8 operating mode. In this mode, the power LED is off during sleep

The values for the 2 variables in the `OSID` method are set dynamically, based on the detected version of Windows. If you add `SSDT-OCWork-dell.aml` to `EFI/OC/ACPI` and your `config.plist`, fixed values for `ACOS` (`0x80`) and `ACSE`  (`0`) are injected if macOS is running to make the brightness keyboard shortcuts work.

> [!NOTE]
> 
> If present, disable `SSDT-XOSI.aml` and any binary renames associated with it (e.g. `OSID to XSID` and/or `_OSI to XOSI`). Otherwise the patch might not work.

## Patch combination for fixing `Fn`+`Insert` keyboard shortcut

- ***SSDT-PTSWAK*** &rarr; See [Comprehensive Sleep and Wake Patch](/Content/04_Fixing_Sleep_and_Wake_Issues/PTSWAK_Sleep_and_Wake_Fix)
- ***SSDT-EXT3-WakeScreen*** &rarr; See [Comprehensive Sleep and Wake Patch](/Content/04_Fixing_Sleep_and_Wake_Issues/PTSWAK_Sleep_and_Wake_Fix)
- ***SSDT-LIDpatch*** &rarr; See [Fixing `PNP0C0E` Sleep](/Content/04_Fixing_Sleep_and_Wake_Issues/PNP0C0E_Sleep_Correction_Method)
- ***SSDT-FnInsert_BTNV-dell*** &rarr; See [Fixing `PNP0C0E` Sleep](/Content/04_Fixing_Sleep_and_Wake_Issues/PNP0C0E_Sleep_Correction_Method)

## Enabling 4k output on Dell Optiplex 3070 and 7070
&rarr; [**Guide**](/Content/05_Laptop-specific_Patches/Brand-specific_Patches/Dell_Special_Patch/Enable_4k_Dell_Optiplex.md)