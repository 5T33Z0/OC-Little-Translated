# AC Adapter Fix for Laptops
The fix presented in this chapter link an AC Adapter existing in a system's `DSDT` to the `AppleACPIACAdapter` in IOReg of macOS which helps with controlling sleep etc. Applicable to all Laptop SMBIOSes (MacBook, MacBookAir and MacBookPro).

## Checking if you need this fix
- In `DSDT`, search for `ACPI0003` and the device it belongs to (either `AC`, `AC0`, `ADP`, `ADP1` or `ACAD`). 
- In this example, it's present and located under `\SB.PCI0.LPC.EC.AC`: 
	![Bildschirmfoto 1](https://user-images.githubusercontent.com/76865553/139686755-00929243-000b-459d-9d02-5ab9b0f720c6.png)
- Next, run **IORegistryExplorer** and find either of this devices: `AC`, `AC0`, `ADP0`, `ADP1` or `ACAD` (it should be located near the top ofthe list)
- Check if `AppleACPIACAdapter` is loaded. If it's present (as in this example) you don't need the fix: ![AppleACPIACAdapter_present](https://user-images.githubusercontent.com/76865553/139686991-d0104672-31f1-4ccf-949b-cd44ff9a4537.png)
- If `AppleACPIACAdapter` is missing, you need a fix: ![AppleACPIACAdapter_missing](https://user-images.githubusercontent.com/76865553/139687029-acdd7853-6d7c-43fc-b421-f2c718af45c2.png)

## Applying the patch
There are 2 possible methods for applying this patch: via kext or via SSDT. Use only one of them, not both!

### Method 1: Using a Kext (easy)
- Add `ACPIBatteryManager.kext` by [Rehabman](https://bitbucket.org/RehabMan/os-x-acpi-battery-driver/downloads/) to your EFI's kext folder and config. It includes the necessary fix to link the AC Adapter to the `AppleACPIACAdapter` service. Additionally it also applies some settings related to power managemnt and attaches `BAT0` to `AppleSmartBatteryManger` in IOReg
- Disable `SMCBatteryManager.kext` (if present).
- Save and reboot

### Method 2: Use a SSDT (for advanced users)
If `AppleACPIACAdapter` is not loaded, you can use the included SSDT hotpatch to connect it to the AC Adapter device. Do the following, to figure out which SSDT is applicable:

- Open the SSDT corresponding to your AC device's name in maciASL and adjust the PCI path according to the path used in your `DSDT`.
- In this example, `SSDT-AC.dsl` is used and modified, so it looks like this: ![SSDT_mod](https://user-images.githubusercontent.com/76865553/139687058-6fad207b-019a-4253-a91e-c87011f17922.png)</br>
- Export the file as an `.aml` file (.aml = ACPI Machine Language Binary)
- Put it the ACPI Folder, add it to your config.plist and enable it.
- Save and reboot.

## Verifying the patch
After rebooting, open IORegestryExplorer again and check if `AppleACPIACAdapter` is present:

![ACAdaptr](https://user-images.githubusercontent.com/76865553/146288651-24a88e8a-fc8e-4354-b54f-7e96de2e6cfd.png)

If you use the kext, it also links the battery to `AppleSmartBatteryManager`:

![Bat0](https://user-images.githubusercontent.com/76865553/146288737-8284846d-8fc1-489b-96f6-bb5b804828ab.png)

If it's not present, then you did something wrong, so start over.

## Notes and Credits
- SSDT Patches by [**Baio 1977**](https://github.com/Baio1977/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/AC%20Adapter%20FIX%20(SSDT-AC%5CAC0%5CADP0%5CADP1%5CACAD))
- When using this patch, make sure that the name ot the Low Pin Connector Bus (`LPC`/`LPCB`) is consistent with the name used in the original `DSDT`.
- Rehabman for `ACPIBatteryManager.kext`.
- In Clover you can use `FixADP1` instead.
