# OpenCore EFI Upload Checklist

## About
So you've created your perfectly working config and want to share your EFI folder online for helping other users? That's great! 

But before you do, you should consider removing any personalized settings which are *not part of the stock configuration of your system/mainboard* to maximize compatibility with the stock config or the target system/mainboard. 

Besides removing usual suspects like sensitive data like SMBIOS Infos, there are a bunch of other settings which should be removed. This includes any SSDTs, DeviceProperties and Kexts for 3rd party components that are not part of the stock configuration of the system/mainboard to guarantee maximum compatibility.

## Checklist
**Work through the following checklist and adjust your config and EFI accordingly**

- [ ] `ACPI/Add` Section: 
	- [ ] Add proper comments!
	- [ ] Deactivate non-essential and custom SSDTs, which were written for 3rd party devices that are not part of the mainboard/system the EFI is for.
- [ ] `Booter/Quirks` &rarr; Set `ResizeAppleGpuBars` to `-1` since you don't know which GPU the next user has.
- [ ] `DeviceProperties` &rarr; Delete 3rd party devices that are not part of the stock configuration of the system/mainboard!
- [ ] `Kernel/Add` section:
	- [ ] Deactivate non-essential or optional kexts for 3rd party devices that are not part of the stock configuration of the mainboard/system.
	- [ ] Add proper descriptions in the "Comment" fields!
	- [ ] Add `MinKernel` and `MaxKernel` Settings ([if available](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Kexts.md)) 
- [ ] `Kernel/Quirks` &rarr; Disable `IncreasePciBarSize` (unless it's part of the stock config) 
- [ ] `Misc/Security/ScanPolicy` &rarr; set it to `0`
- [ ] `Misc/Security/ApECID` &rarr; set it to `0`
- [ ] `Misc/Security/Vault` &rarr; set it to `Optional`
- [ ] `Misc/BlessOverride` &rarr; Delete entries 
- [ ] `Misc/Entries` &rarr; Delete Custom entries
- [ ] `Misc/Security/SecureBootModel` &rarr; Set it to `Disabled`. :warning: Disables Apple Secure Boot to avoid issues during installation. Point users of your EFI to re-enable it in Post-Install so System Updates work when using an SMBIOS of a Mac model with a T2 Security Chip!
- [ ] `PlatformInfo/Generic` &rarr; Delete Serials etc.
- [ ] Change the follwing settings in `UEFI/APFS` to enable backward compatible with macOS Catalina and older. Otherwise the APFS driver won't load and you won't see any drives in the Boot Picker:	
	- [ ] `MinDate` = -1
	- [ ] `MaxDate` = -1
- [ ] `UEFI/Quirks` &rarr; change `ResizeAppleGpuBars` to `-1` since you don't know which GPU will be used

Dreamwhite wrote a Python Script which can do most of this automatically. It's called [**OC Anonymizer**](https://github.com/dreamwhite/OC-Anonymizer).
