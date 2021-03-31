# ACPI Debugging

## Description

By adding debug code to the ***SSDT-xxxx*** patch, it is possible to see the patch or ACPI working process on the console for debugging.

## Requirements

- **Driver**:
  - Install ***ACPIDebug.kext*** to `OC\Kexts` and update the config.plist.
- **Patches**:
  - Add the main patch ***SSDT-RMDT*** to `OC\ACPI` and update the config.plist.
  - Add ***Custom Patch*** to `OC\ACPI` and add the patch list.

Reboot

## Debugging

- Open **Console** and search for **`keyword`** (**`keyword`** from **custom patch***)
- Observe the console output

## Example

- Purpose

  - To observe `_PTS` and `_WAK` of `ACPI` receiving `Arg0` after the machine sleeps and wakes up.

- Drivers and patches

  - ***ACPIDebug.kext*** - see previous article
  - ***SSDT-RMDT*** -- see previous
  - ***SSDT-PTSWAK*** -- The patch has built-in parameter passing variables `\_SB.PCI9.TPTS`, `\_SB.PCI9.TWAK`, which are convenient for other patches. See "PTSWAK Comprehensive Extension Patch"
  - ***SSDT-BKeyQxx-Debug*** - This patch is just an example. Debug code is added within the patch to be able to execute debug code after key response. You can specify the brightness shortcut key, or other keys when you actually use it.

    **Note**: The name change required by the above patch is in the comments of the corresponding patch file.

- Observe the console output results

  - Open the console and search for `ABCD-`
  - Complete the sleep and wake up process once
  - Press the key specified by ***SSDT-BKeyQxx-Debug*** and observe the console output results. In general, the following results are displayed.

    ```
    13:19:50.542733+0800 kernel ACPIDebug: { "ABCD-_PTS-Arg0=", 0x3, }
    13:19:55.541826+0800 kernel ACPIDebug: { "ABCD-_WAK-Arg0=", 0x3, }
    ```

	The result shown above is the value of `Arg0` after the last sleep and wakeup.

## Remarks

- Debug code can be diversified, such as `\RMDT.P1`, `\RMDT.P2`, `\RMDT.P3` and so on, see ***SSDT-RMDT.dsl*** for details
- The above drivers, major patches are from [@RehabMan](https://github.com/rehabman)
