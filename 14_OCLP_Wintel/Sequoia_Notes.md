# macOS Sequoia Notes

:construction: Under Construction

## (Officially) Supported Mac Models

![macos15_b](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/7e741e5b-64fc-4456-ac02-37b258d68216)

### Intel CPU requirements:

-  Kabey Lake-R or newer

## Features unavailable on Intel Systems

- Basically everything "AI", incuding:
	- Apple Intelligence
	- Siri 2.0 
	- Logic Pro 11s Stem Splitter, Mastering Assistant, etc.

## Observations
Listed below are things I noticed that are currently not working…

- Most kexts require `-lilubetaall` to load
- Intel Bluetooth (WiFi works using `Itlwm.kext`!)

> [!CAUTION]
>
> Don't upgrade to macOS Sequoia on legacy systems that require root patches! There is not ETA for OpenCore Legacy Patcher with macOS 15 support available yet.

## OCLP Update Status

- **May 30th, 2024**: [**OCLP v1.50**](https://github.com/dortania/OpenCore-Legacy-Patcher/releases/tag/1.5.0) released
	- OCLP now has a .pkg installer which is the new recommended method for installing OpenCore Legacy Patcher (on real Macs)
	- New Privileged Helper Tool which removes requirement of password prompts for installing patches, creating installers, etc.

