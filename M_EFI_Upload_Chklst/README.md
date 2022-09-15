## OpenCore EFI Upload Checklist

Before sharing your OpenCore EFI and config.plist with the world, you should remove any personalized settings which are not part of the stock configuration of the system/mainboard. This includes removing any SSDTs, DeviceProperties and Kexts for 3rd party components that are not part of the stock configuration of the system/mainboard to guarantee maximum compatibility.

**Work through the following checklist and adjust the settings accordingly:**

- `ACPI/Add` Section: 
	- Add proper comments!
	- Deactivate non-essential and custom SSDTs, which were written for 3rd party devices that are not part of the mainboard/system the EFI is for.
- `Booter/Quirks` &rarr; Set `ResizeAppleGpuBars` to `-1` since you don't know which GPU the next user has.
- `DeviceProperties` &rarr; Delete 3rd party devices that are not part of the stock configuration of the system/mainboard!
- `Kernel/Add` section:
	- Deactivate non-essential or optional kexts for 3rd party devices that are not part of the stock configuration of the mainboard/system.
	- Add proper descriptions in the "Comment" fields!
	- Add `MinKernel` and `MaxKernel` Settings ([if available](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Kexts.md)) 
- `Kernel/Quirks` &rarr; Disable `IncreasePciBarSize` (unless it's part of the stock config) 
- `Misc/Security/ScanPolicy` &rarr; set it to `0`
- `Misc/Security/ApECID` &rarr; set it to `0`
- `Misc/Security/Vault` &rarr; set it to `Optional`
- `Misc/BlessOverride` &rarr; Delete entries 
- `Misc/Entries` &rarr; Delete Custom entries
- `Misc/Security/SecureBootModel` &rarr; Set it to `Disabled`. :warning: Disables Apple Secure Boot to avoid issues during installation. Point users of your EFI to re-enable it in Post-Install so System Updates work when using an SMBIOS of a Mac model with a T2 Security Chip!
- `PlatformInfo/Generic` &rarr; Delete Serials etc.
- Change the follwing settings in `UEFI/APFS` to enable backward compatible with macOS Catalina and older. Otherwise the APFS driver won't load and you won't see any drives in the Boot Picker:	
	- `MinDate` = -1
	- `MaxDate` = -1
- `UEFI/Quirks` &rarr; change `ResizeAppleGpuBars` to `-1` since you don't know which GPU will be used

Dreamwhite wrote a Python Script which can do most of this automatically. It's called [**OC Anonymizer**](https://github.com/dreamwhite/OC-Anonymizer).
