# Comprehensive Sleep and Wake Patch

## Description

By renaming `_PTS` and `_WAK` methods and adding SSDT Patches, problems with sleep and wake can be fixed on certain machines.

The integrated patch is a framework that includes:

  - Masked Solo interface: `_ON`, `_OFF`
  - 6 extended patch interfaces: `EXT1`, `EXT2`, `EXT3`, `EXT4` , `EXT5` and `EXT6`
  - Defines forced Sleep pass parameters `FNOK` and `MODE`, see `PNP0C0E Sleep Correction Method` for details.
  - Defines debug parameters `TPTS` and `TWAK` for detecting and tracking `Arg0` changes during sleep and wake-up. 

For example, add the following code to the brightness shortcut patch:
   
```asl
/* A keystroke: */
\RMDT.P2 ("ABCD-_PTS-Arg0=", \_SB.PCI9.TPTS)
\RMDT.P2 ("ABCD-_WAK-Arg0=", \_SB.PCI9.TWAK)
```
When pressing the brightness shortcut key, you can see the value of `Arg0` on the console after the previous sleep and wake up.

**Note**: To debug ACPI, you need to install the driver `ACPIDebug.kext`, add the patch `SSDT-RMDT`, and a custom debug patch. See **"ACPIDebug"** for details.

## Required Renames

The `_PTS` and `_WAK` must be renamed in order to use the integrated patch. Choose the correct name change based on the original DSDT content, e.g.

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

If `_TTS` exists in the DSDT, you need to rename it too; if it doesn't, you don't need to rename it. Choose the correct renaming based on the original DSDT content, e.g.

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

- ***SSDT-PTSWAKTTS*** – Integrated patch.

- ***SSDT-EXT1-FixShutdown*** – `EXT1` Extension patch. Fixes the shutdown to reboot problem caused by the XHC controller by setting `XHC.PMEE` to 0 when the parameter passed in `_PTS` is `5`. This patch has the same effect as Clover's `FixShutdown`. Some XPS / ThinkPad machines will require this patch.

- ***SSDT-EXT3-WakeScreen*** –`EXT3` Extension patch. Fixes the problem that some machines need to press any key to light up the screen after waking up. When using this patch, you should check if the `PNP0C0D` device name and path already exist in the patch file, such as `_SB.PCI0.LPCB.LID0`. If it does not exist add it yourself.

- ***SSDT-EXT5-TP-LED*** – `EXT5` extension patch. Fixes an issue on ThinkPads where the breathing light of the Power Button LED will not return to normal after waking up. Also fixes an issue where the <kbd>F4</kbd> microphone indicator status is not normal after waking up on older ThinkPad models.

- ***SSDT-ASUS-Shutdown*** – Shutdown Fix for ASUS systems. Combine with `_PTS` to `ZPTS` rename.

## Caution

Patches with the same extension name cannot be used at the same time. If there is a requirement to use them at the same time, they must be combined.
asl
