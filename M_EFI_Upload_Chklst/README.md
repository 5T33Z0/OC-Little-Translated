## OpenCore EFI Upload Checklist

Before sharing your OpenCore EFI with the would, you should check the following things in your Config.plist and correct them: 

- `ACPI/Add` Section: 
	- Add proper Comments!
	- Deactivate non-essential and custom SSDTs, which were written for 3rd party device that are not part of the mainboard the EFI is for.
- `PlatformInfo/Generic` &rarr; Delete Serials etc.
- `DeviceProperties` &rarr; Delete 3rd party devices that are not part of the mainboard!
- `ScanPolicy` &rarr; set it to `0`
- `Misc/Entries` &rarr; Delete Custom entries 
- `SecureBootModel` &rarr;`Disabled`
- `Kernel`Section:
	- Deactivate non-essential or optional kexts for 3rd party device that are not part of your mainboard.
	- Add proper Descriptions in the Comment field!
	- Add `MinKernel` and `MaxKernel` Settings ([if avaialble](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Kexts.md)) 
