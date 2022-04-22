# AC Adapter (`SSDT-AC`) (for Laptops)
This patch attaches an AC Adapter Device existing in a Laptop's `DSDT` to the `AppleACPIACAdapter` service in the I/O Registry of macOS. This is optional and mostly cosmetic – it doesn't make any difference in terms of functionality as explained [here](https://github.com/acidanthera/bugtracker/issues/1808).

If you are using **VirtualSMC** with the **SMCBatteryManager** plugin, you don't need to add this SSDT. Read the notes about **ACPIBatteryManager** vs. **SMCBatteryManager** below for more details.

**Applicable to**: MacBook, MacBookAir and MacBookPro SMBIOS. 

## Preparations
- In `DSDT`, search for `ACPI0003` and the device it belongs to: either `AC`, `AC0`, `ADP`, `ADP1` or `ACAD`. 
- In this example, it's present and located under `\SB.PCI0.LPC.EC.AC`: 
	![Bildschirmfoto 1](https://user-images.githubusercontent.com/76865553/139686755-00929243-000b-459d-9d02-5ab9b0f720c6.png)
- Next, run **IORegistryExplorer** and find either of these devices: `AC`, `AC0`, `ADP0`, `ADP1` or `ACAD` (it should be located near the top of the list)
- Check if `AppleACPIACAdapter` is loaded. If it's present (as in this example) you don't need the fix:</br> ![AppleACPIACAdapter_present](https://user-images.githubusercontent.com/76865553/139686991-d0104672-31f1-4ccf-949b-cd44ff9a4537.png)
- If `AppleACPIACAdapter` is missing, you can add a variant of `SSDT-AC` to fix it: </br>![AppleACPIACAdapter_missing](https://user-images.githubusercontent.com/76865553/139687029-acdd7853-6d7c-43fc-b421-f2c718af45c2.png)

## Applying the patch
There are 2 methods of applying this patch: either via kext or via SSDT. 

### Method 1: Using a Kext (easy but outdated)
- Add `ACPIBatteryManager.kext` to your EFI's kext folder and config. 
- Disable `SMCBatteryManager.kext` (if present).
- Save and reboot

`ACPIBatteryManager.kext` attaches the AC Adapter device to the `AppleACPIACAdapter` service. Additionally, it also applies some settings related to power management and attaches `BAT0` to `AppleSmartBatteryManger` in **IORegistryExplorer**.

#### ACPIBatteryManager vs. SMCBatteryManager
`SMCBatteryManager` acts as a fake controller, which implements a complete emulation layer of `AppleSmartBattery` of SMC and SMBus protocols. Although it is able to find all the AC Adapters and Batteries just fine, it just doesn't attach to them in I/O Registry like `ACPIBatteryManager` does. Basically, this is all just cosmetics. If you want to be on the safe side, just stay with SMCBatteryManager since it is in active development, whereas ACPIBatteryManager is from 2018 and pretty much deprecated.

### Method 2: Use a SSDT (for advanced users)
If `AppleACPIACAdapter` is not loaded, you can use one of the included SSDT hotpatches to attach it to the AC Adapter. Do the following, to figure out which SSDT is applicable:

- In your `DSDT`, search for `ACPI0003`. 
- Open the SSDT corresponding to your AC device's name in maciASL and adjust the PCI path according to the path used in your `DSDT`.
- In this example, `SSDT-AC.dsl` is used and modified, so it looks like this: ![SSDT_mod](https://user-images.githubusercontent.com/76865553/139687058-6fad207b-019a-4253-a91e-c87011f17922.png)</br>
- Export the file as an `.aml` file (ACPI Machine Language Binary)
- Put it the ACPI Folder, add it to your `config.plist` and enable it.
- Save and reboot.

## Verifying the patch
After rebooting, check if `AppleACPIACAdapter` is present in IORegistryExplorer:

![ACAdaptr](https://user-images.githubusercontent.com/76865553/146288651-24a88e8a-fc8e-4354-b54f-7e96de2e6cfd.png)

If you use the kext, it also links the battery to `AppleSmartBatteryManager`:

![Bat0](https://user-images.githubusercontent.com/76865553/146288737-8284846d-8fc1-489b-96f6-bb5b804828ab.png)

If it's not present, then you did something wrong, so start over.

## Notes
- When using the SSDT patches, make sure that the name of the LPC Bus (`LPC`/`LPCB`) is consistent with the name used in the original `DSDT`.
- In Clover, you can use the DSDT patch `FixADP1` instead to attach the AC device in IOReg.

## Credits
- SSDT Patches by [**Baio 1977**](https://github.com/Baio1977/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/AC%20Adapter%20FIX%20(SSDT-AC%5CAC0%5CADP0%5CADP1%5CACAD))
- `ACPIBatteryManager.kext` by [**RehabMan**](https://bitbucket.org/RehabMan/os-x-acpi-battery-driver/src/master/).
- `VirtualSMC` and `SMCBatteryManager` by [**Acidanthera**](https://github.com/acidanthera/VirtualSMC)

