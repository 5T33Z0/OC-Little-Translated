# AC Adapter Fix for Laptops
The included SSDTs add an AC Adapter device to your Notebook, if missing.
>Credits: Original Patches by [**Baio 1977**](https://github.com/Baio1977/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/AC%20Adapter%20FIX%20(SSDT-AC%5CAC0%5CADP0%5CADP1%5CACAD))

## Checking if you need this fix
- In `DSDT`, search for `ACPI0003` or `Device (AC)` and its location: ![](/Users/kl45u5/Desktop/Bildschirmfoto 1.png) 
	In this case it's present and located under `\SB.PCI0.LPC.EC.AC` 
- Next, in IORegistry Explorer and search for `AC`, `AC0`, `ADP0`, `ADP1` or `ACAD`
- Check if `AppleACPIACAdapter` is loaded. if it's present (as in this example) you don't need a fix: ![](/Users/kl45u5/Desktop/AppleACPIACAdapter_present.png)
- If `AppleACPIACAdapter` is missing, you need a fix:![](/Users/kl45u5/Desktop/AppleACPIACAdapter_missing.png)

## Applying the patch
If `AppleACPIACAdapter` is not loaded, you can use a SSDT hotpatch to connect it to the AC Adapter device. Do the following, to figure out which SSDT is applicable:

- Open the SSDT corresponding to your AC device in maciASL and adjust the PCI path according to the device path in your `DSDT`.
- In this example, SSDT-AC.dsl is used and modifier, so it looks like this: ![](/Users/kl45u5/Desktop/SSDT_mod.png)
- Export the file as SSDT-AC.aml (ACPI Machine Language Binary)
- Put it the ACPI Folder, add it to your config.plist and enable it.
- Save and reboot.

## Checking if the fix works
After rebooting, open IORegestryExplorer again and check if `AppleACPIACAdapter` is present:
![](/Users/kl45u5/Desktop/fixed.png)
If present, the fix worked. If it's not present, then you did something wrong.

## Notes
- When using this patch, make sure that the name ot the Low Pin Connector Bus (`LPC`/`LPCB`) is consistent with the name used in the original `DSDT`.
- Rehabman's old `ACPIBatteryManager.kext` integrates this fix, so if you use this kext you don't need this SSDT.