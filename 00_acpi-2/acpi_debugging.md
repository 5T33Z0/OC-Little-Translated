# ACPI Debugging
## Description
By adding debug code to ***SSDT-xxxx*** Hotpatches, it is possible to check the working status of an ACPI table on the console for debugging.

## Requirements
To enable ACPI Debugging, do the following:

- Add `SSDT-RMDT.aml` to `OC\ACPI` &rarr; injects `RMDT` (RehabMan Debug Trace) device.
- Add `ACPIDebug.kext` to `OC\Kexts` 
- Add debugging code for parameters you want to check the behavior to your SSDT(s). 
- Update your config.plist and reboot

**Config NOTES**: 

- Depending on the amount of parameters/arguments you want to debug, you need to reference either Method P1 (for 1 Argument) to Method P7 (for 7 Arguments)
- Check `SSDT-BKeyQxx-Debug.dsl` for examples.

## Debugging process
- Open **Console** 
- Search for the **`keyword`** defined in the debug section of your SSDT(s), in this example `ABCD-`
- Check the console output

## Example
To observe `_PTS` and `_WAK` of `ACPI` receiving `Arg0` after the machine sleeps and wakes up.

- ***SSDT-PTSWAK*** &rarr; This patch has built-in parameter passing variables `\_SB.PCI9.TPTS`, `\_SB.PCI9.TWAK`, which are convenient for other patches. See [**PTSWAK Sleep and WakeFix**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/PTSWAK_Sleep_and_Wake_Fix).
- ***SSDT-BKeyQxx-Debug*** &rarr; Debug code is added within the patch to be able to execute debug code after key response. You can specify the brightness shortcut key, or other keys when you actually use it.
- Complete the sleep and wake up process once
- Open the Console and search for `ABCD-`
- Observe the Console output
- Press the key specified by ***SSDT-BKeyQxx-Debug*** and observe the console output results. In general, the following results are displayed:
	```
	13:19:50.542733+0800 kernel ACPIDebug: { "ABCD-_PTS-Arg0=", 0x3, }
	13:19:55.541826+0800 kernel ACPIDebug: { "ABCD-_WAK-Arg0=", 0x3, }
	```
The result shown above is the value of `Arg0` after the last sleep and wake cycle.

## Notes and Credits
- The debugging kext and SSDT were developed by [**RehabMan**](https://github.com/RehabMan/OS-X-ACPI-Debug)
- Debug code can be diversified, such as `\RMDT.P1`, `\RMDT.P2`, `\RMDT.P3` and so on, see ***SSDT-RMDT.dsl*** for details
