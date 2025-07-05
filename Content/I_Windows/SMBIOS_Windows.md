# Prohibiting "Acidanthera" name injection into Windows

## About
You may have noticed that "Acidanthera" is used as Computer Name and Mother Board Model if you boot Windows via OpenCore.

That's due to the following settings (which are the defaults in the `sample.plist`): 

- `Kernel/Quirks/CustomSMBIOSGuid` &rarr; `Disabled`
- `PlatformInfo/Generic/SpoofVendor` &rarr; `Enabled` (should always be enabled when running macOS)
- `PlatformInfo/SMBIOS/UpdateSMBIOSMode` &rarr; `Create`

Besides the fact that it not only looks odd to have a mainboard manufactured by "Acidanthera" (with a Mac Board-ID attached to it), it can also cause issue with Windows Activation data on some systems.

## Solution
To prevent OpenCore from injecting it's SMBIOS data into Windows, change the following Settings in your config.plist:

- `Kernel/Quirks/CustomSMBIOSGuid` → `Enabled`
- `PlatformInfo/SMBIOS/UpdateSMBIOSMode` &rarr; `Custom`

## Resources
For more technical details about booting Windows via OpenCore check the explanations in [this guide](https://chriswayg.gitbook.io/opencore-visual-beginners-guide/advanced-topics/multi-boot-options#detailed-technical-differences-of-the-four-options).
