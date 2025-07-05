# OpenCore EFI Upload Checklist

## About
So you've created your perfectly working config and want to share your EFI folder online for helping other users? That's great! 

But before you do, you should consider removing any personalized settings which are *not part of the stock configuration of your system/mainboard* to maximize compatibility with the stock config or the target system/mainboard. 

Besides removing usual suspects like sensitive data (SMBIOS Infos), there are a bunch of other settings which should be removed. This includes any SSDTs, DeviceProperties and Kexts for 3rd party components that are not part of the stock configuration of the system/mainboard to guarantee maximum compatibility.

Listed below, you find a checklist of config settings and parameters you should correct/revert before sharing your EFI and config.

## Checklist
**Work through the following list and adjust your config accordingly before sharing it**

| Section | Action
:------------------------:|-----------------------------------------
**ACPI/Add**               | <ul> <li> Deactivate non-essential and custom SSDTs, which were written for 3rd party devices that are not part of the mainboard/system the EFI is for. <li> Add proper comments!
**Booter/Quirks**          | Change `ResizeAppleGpuBars` to `-1` since you don't know which GPU the next user has.
**DeviceProperties**       | Delete properties for 3rd party devices that are not part of the stock configuration of the system/mainboard the EFI is for.
**Kernel/Add**             | <ul><li>Deactivate non-essential or optional kexts for 3rd party devices that are not part of the stock configuration of the mainboard/system. <li> Add `MinKernel` and `MaxKernel` Settings ([if available](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Kexts.md)) <li> Add proper descriptions in the "Comment" fields!
**Kernel/Quirks**          | Disable `IncreasePciBarSize` since you don't know which GPU will be used.
**Misc**                   | <ul><li> `/Security/ScanPolicy` &rarr; set it to `0` <li> `/Security/ApECID` &rarr; set it to `0` <li> `/Security/Vault` &rarr; set it to `Optional` <li> `/BlessOverride` &rarr; Delete entries <li> `/Entries` &rarr; Delete Custom entries <li> `/Security/SecureBootModel` &rarr; Set it to `Disabled`. > **Warning**: Disables Apple Secure Boot to avoid issues during installation. Point users of your EFI to re-enable it in Post-Install so System Updates work when using an SMBIOS of a Mac model with a T2 Security Chip!
**PlatformInfo/Generic**   | Delete Serials etc.
**UEFI/APFS**              | Change `MinDate` and `MinVersion` to `-1` &rarr; Enables backward compatibility with macOS Catalina and older. Otherwise, the APFS driver won't load and you won't see any drives in the Boot Picker.
**UEFI/Quirks**            | Change `ResizeAppleGpuBars` to `-1` since you don't know which GPU will be used.

## Notes
Dreamwhite wrote a Python Script which can do a lot of this automatically. It's called [**OC Anonymizer**](https://github.com/dreamwhite/OC-Anonymizer).
