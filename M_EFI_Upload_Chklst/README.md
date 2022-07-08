## OpenCore EFI Upload Checklist

Before sharing your OpenCore EFI and config.plist with the world, you should work through the following check list: 

- `ACPI/Add` Section: 
	- Add proper comments!
	- Deactivate non-essential and custom SSDTs, which were written for 3rd party device that are not part of the mainboard the EFI is for.
- `PlatformInfo/Generic` &rarr; Delete Serials etc.
- `DeviceProperties` &rarr; Delete 3rd party devices that are not part of the mainboard!
- `Misc/Security/ScanPolicy` &rarr; set it to `0`
- `Misc/Security/ApECID` &rarr; set it to `0`
- `Misc/Security/Vault` &rarr; set it to `Optional`
- `Misc/Entries` &rarr; Delete Custom entries 
- `Misc/Security/SecureBootModel` &rarr; `Disabled`. Disables Apple Secure Boot hardware model to avoid issues during Installation. Re-enable it in Post-Install so System Updates work when using an SMBIOS of a Mac model with a T2 Security Chip.
- `Kernel` section:
	- Deactivate non-essential or optional kexts for 3rd party devices that are not part of your mainboard.
	- Add proper Descriptions in the Comment field!
	- Add `MinKernel` and `MaxKernel` Settings ([if available](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Kexts.md)) 
- Change the follwing settings in `UEFI/APFS` to enable backward compatible with macOS Catalina and older. Otherwise the APFS driver won't load and you won't see any drives in the Boot Picker:	
	- `MinDate` = -1
	- `Maxdate` = -1

**NOTE**: There's also a Python script which can do all of this automatically: [OC Anonymizer](https://github.com/5T33Z0/OC-Anonymizer)
