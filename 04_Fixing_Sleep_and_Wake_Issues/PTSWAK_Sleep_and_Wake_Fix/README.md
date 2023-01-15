# Comprehensive Sleep and Wake Patch

## Description

By renaming the `_PTS` (Prepare to Sleep), `_WAK` (Wake) and `_TTS` (Transition to State) methods and redefining them via `SSDT-PTSWAKTTS`, problems with sleep and wake can be fixed on certain machines.

***SSDT-PTSWAKTTS*** is an integrated patch which provides a framework with the following features:

  - Controls for the dGPU: `_ON`, `_OFF`
  - 6 extended patch interfaces: `EXT1`, `EXT2`, `EXT3`, `EXT4`, `EXT5` and `EXT6` 
  - Defines forced Sleep pass parameters `FNOK` and `MODE` for switching between `PNP0C0E` and `PNP0C0D` sleep modes (&rarr; see [**PNP0C0E Sleep Correction Method**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/PNP0C0E_Sleep_Correction_Method) for details).
  - Defines debugging parameters `TPTS` and `TWAK` for tracking `Arg0` changes during sleep and wake. For example, add the following code to the brightness shortcut patch:  
	```asl
	/* A keystroke: */
	\RMDT.P2 ("ABCD-_PTS-Arg0=", \_SB.PCI9.TPTS)
	\RMDT.P2 ("ABCD-_WAK-Arg0=", \_SB.PCI9.TWAK)
	```
	When pressing the brightness shortcut key, you can trace changes for `Arg0` in the Console App after a previous sleep and wake cycle.

**NOTE**: To debug ACPI, you need to install `ACPIDebug.kext`, add the patch `SSDT-RMDT`, and a custom debug patch. See the chapter [**ACPI Debugging** ](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00_ACPI/ACPI_Debugging) for details.

## Required Renames

The `_PTS` and `_WAK` must be renamed in order to use the integrated patch (see `PTS-TTS-WAK_Renames.plist`). Choose the correct name change based on the original DSDT content, e.g.

- `_PTS` to `ZPTS(1,N)` for:

  ```asl
    Method (_PTS, 1, NotSerialized) /* _PTS: Prepare To Sleep */
    {
  ```

- `_WAK` to `ZWAK(1,N)` for:

  ```asl
    Method (_WAK, 1, NotSerialized) /* _WAK: Wake */
    {
  ```

- `_PTS` to `ZPTS(1,S)` for:

  ```asl
    Method (_PTS, 1, Serialized) /* _PTS: Prepare To Sleep */
    {
  ```

- `_WAK` to `ZWAK(1,S)` for:

  ```asl
    Method (_WAK, 1, Serialized) /* _WAK: Wake */
    {
  ```

If `_TTS` exists in the `DSDT`, you need to rename it too; if it doesn't, you don't need to rename it. Choose the correct renaming based on the original DSDT content, e.g.

- `_TTS` to `ZTTS(1,N)` for:

  ```asl
    Method (_TTS, 1, NotSerialized) /* _WAK: Wake */
    {
  ```

- `_TTS` to `ZTTS(1,S)` for:

  ```asl
    Method (_TTS, 1, Serialized) /* _WAK: Wake */
    {
  ```

## Patches
- ***SSDT-PTSWAKTTS*** – Integrated base patch. Required for the other Sleep/Wake fixes to work!
- ***SSDT-EXT1-FixShutdown*** – `EXT1` Extension patch. Fixes the reboot problem after shutfown caused by the `XHC` Controller by setting `XHC.PMEE` to `0` when the parameter passed in `_PTS` is `5`. This patch has the same effect as Clover's `FixShutdown`. Some Dell XPS and ThinkPads will require this patch.
- ***SSDT-EXT3-WakeScreen*** –`EXT3` Extension patch. Fixes the problem that some machines need to press any key to light up the screen after waking up. When using this patch, check if the `PNP0C0D` device name and path already exist in the patch file, such as `_SB.PCI0.LPCB.LID0`. If it does not exist, add it yourself.
- ***SSDT-EXT5-TP-LED*** – `EXT5` extension patch. Fixes an issue on ThinkPads where the breathing light of the Power Button LED will not return to normal after waking up. Also fixes an issue where the <kbd>F4</kbd> microphone indicator status is not normal after waking up on older ThinkPad models.
- ***SSDT-ASUS-Shutdown*** – Shutdown Fix for ASUS systems. Combine with `_PTS` to `ZPTS` rename.

## :warning: Caution

You cannot have more than one SSDT that uses the same extension (e.g. `EXT1`) at a time. If there is a need to patch 2 things using the same extension, then these patches must be integrated into the same SSDT.

## Notes
- For the relation between `_PTS`, `_TTS` and `_WAK` methods, refer to chapter 7.5 of the [**ACPI Specs**](https://uefi.org/specs/ACPI/6.5/07_Power_and_Performance_Mgmt.html#ospm-usage-of-pts-tts-and-wak)
