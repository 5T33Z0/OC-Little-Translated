# AC Adapter Fix for Laptops
The included SSDTs add an AC Adapter device to your Notebook, if missing.
>Credits: Original Patches by [**Baio 1977**](https://github.com/Baio1977/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/AC%20Adapter%20FIX%20(SSDT-AC%5CAC0%5CADP0%5CADP1%5CACAD))

## Checking if you need this fix
- In `DSDT`, search for `ACPI0003` or `Device (AC)` and its location. In this case it's present and located under `\SB.PCI0.LPC.EC.AC`: 
	![Bildschirmfoto 1](https://user-images.githubusercontent.com/76865553/139686755-00929243-000b-459d-9d02-5ab9b0f720c6.png)
- In IORegistryExplorer, search for `AC`, `AC0`, `ADP0`, `ADP1` or `ACAD`
- Check if `AppleACPIACAdapter` is loaded. if it's present (as in this example) you don't need a fix: ![AppleACPIACAdapter_present](https://user-images.githubusercontent.com/76865553/139686991-d0104672-31f1-4ccf-949b-cd44ff9a4537.png)
- If `AppleACPIACAdapter` is missing, you need a fix: ![AppleACPIACAdapter_missing](https://user-images.githubusercontent.com/76865553/139687029-acdd7853-6d7c-43fc-b421-f2c718af45c2.png)

## Applying the patch
If `AppleACPIACAdapter` is not loaded, you can use a SSDT hotpatch to connect it to the AC Adapter device. Do the following, to figure out which SSDT is applicable:

- Open the SSDT corresponding to your AC device in maciASL and adjust the PCI path according to the device path in your `DSDT`.
- In this example, SSDT-AC.dsl is used and modifier, so it looks like this: ![SSDT_mod](https://user-images.githubusercontent.com/76865553/139687058-6fad207b-019a-4253-a91e-c87011f17922.png)

- Export the file as SSDT-AC.aml (ACPI Machine Language Binary)
- Put it the ACPI Folder, add it to your config.plist and enable it.
- Save and reboot.

## Checking if the fix works
After rebooting, open IORegestryExplorer again and check if `AppleACPIACAdapter` is present:
![fixed](https://user-images.githubusercontent.com/76865553/139687129-42f54d03-7f49-45f4-9eae-ae29f7a8d5ee.png)

If it's not present, then you did something wrong so start over.

## Notes
- When using this patch, make sure that the name ot the Low Pin Connector Bus (`LPC`/`LPCB`) is consistent with the name used in the original `DSDT`.
- Rehabman's old `ACPIBatteryManager.kext` integrates this fix, so if you use this kext you don't need this SSDT.
