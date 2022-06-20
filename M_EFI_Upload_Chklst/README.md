## OpenCore EFI Upload Checklist

Before sharing your OpenCore EFI and config.plist with the world, you should work through the following check list: 

- `ACPI/Add` Section: 
	- Add proper Comments!
	- Deactivate non-essential and custom SSDTs, which were written for 3rd party device that are not part of the mainboard the EFI is for.
- `PlatformInfo/Generic` &rarr; Delete Serials etc.
- `DeviceProperties` &rarr; Delete 3rd party devices that are not part of the mainboard!
- `Misc/Security/ScanPolicy` &rarr; set it to `0`
- `Misc/Security/ApECID` &rarr; set it to `0`
- `Misc/Security/Vault` &rarr; set it to `Optional`
- `Misc/Entries` &rarr; Delete Custom entries 
- `Misc/Security/SecureBootModel` &rarr;`Disabled`. Hint users to enabling it in Post-Install so System Updates work for SMBIOSes which use a T2 Security Chip!
- `Kernel` section:
	- Deactivate non-essential or optional kexts for 3rd party devices that are not part of your mainboard.
	- Add proper Descriptions in the Comment field!
	- Add `MinKernel` and `MaxKernel` Settings ([if available](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Kexts.md)) 
- UEFI/APFS
	- `MinDate` = -1
	- `Maxdate` = -1

There's also a Python script available which can do all this (and more): [Catone](https://github.com/dreamwhite/Catone)
