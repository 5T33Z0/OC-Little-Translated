# macOS Sequoia Notes
This section covers the current status of OpenCore Legacy Patcher development for macOS Sequoia.

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
- With the release of Sequoia beta 5, MountEFI stopped working because Apple changed something in the way FAT32 partitions are handeled. You can use [Mount-MS-DOS-Partition](https://github.com/chris1111/Mount-MS-DOS-Partition) in the meantime to mount the EFI partiton. This issue has been fixeed since beta 6
- Most kexts require `-lilubetaall` to load
- Intel Bluetooth doesn't work yet
- Intel WiFi works using `Itlwm.kext`!

> [!CAUTION]
>
> Don't upgrade to macOS Sequoia on legacy systems that require root patches! There is not ETA for OpenCore Legacy Patcher with macOS 15 support available yet.

## OCLP Update Status
- **September 2nd, 2024**: OCLP Development branch been merged with OCLP master branch &rarr; see [Changelog](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/CHANGELOG.md#200) for details
- **September 2nd, 2024**: New nightly build of OpenCore Legacy Patcher 1.6.0 based on Sequoia Development branch is [avaialble here](https://github.com/dortania/OpenCore-Legacy-Patcher/pull/1137#issuecomment-2295376562) which can re-enable Ivy Bridge iGPUs and NVDIA Kepler Cards
- **August 18th, 2024**: [Early macOS Sequoia support available](https://github.com/dortania/OpenCore-Legacy-Patcher/pull/1137#issuecomment-2295376562). Things look bad for: Sandy Bridge, Ivy Bridge, Haswell, Nvidia cards, AMD Terascale
- **June 28th, 2024**: [AMFIPass.kext updated to 1.4.1](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/sequoia-development/payloads/Kexts/Acidanthera/AMFIPass-v1.4.1-RELEASE.zip)
- OCLP v. 1.6.0 added to [Changelog](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/CHANGELOG.md#opencore-legacy-patcher-changelog)
- **June 10th, 2024**: A [development branch](https://github.com/dortania/OpenCore-Legacy-Patcher/compare/main...sequoia-development ) of OCLP for macOS Sequoia has been created
- **May 30th, 2024**: [**OCLP v1.50**](https://github.com/dortania/OpenCore-Legacy-Patcher/releases/tag/1.5.0) released
	- OCLP now has a .pkg installer which is the new recommended method for installing OpenCore Legacy Patcher (on real Macs)
	- New Privileged Helper Tool which removes requirement of password prompts for installing patches, creating installers, etc.
