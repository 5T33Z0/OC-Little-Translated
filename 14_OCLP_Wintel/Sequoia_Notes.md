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
 	- Live Audio Transcription in Notes
- Logic Pro 11: Stem Splitter, Mastering Assistant, etc.

## New issues
- **Dual Socket CPUs**
	- Systems with 1st Gen Xeon CPUs (Harpertown) are limited to using 4 cores in total, otherwise macOS panics. So macOS Sequoia is pretty much useless on Dual Socket Systems with more cores. This also means that the config has to be adjusted as well in order to boot these systems. 
 	- When building OpenCore for older OSes, this limitation can be disabled in Settings > Build > "MacPro3,1/Xserve2,1 Workaround".
- **Graphics support**
	- [Legacy-Metal](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/1008)
	- [Non-Metal](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/108)

## OCLP Update Status
- **September 14th, 2024**: OCLP 2.0.0 is officially [released](https://github.com/dortania/OpenCore-Legacy-Patcher/releases/tag/2.0.0)!
- **September 6th, 2024**: OCLP Development branch been merged with the master branch &rarr; see [Changelog](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/CHANGELOG.md#200) for details
- **September 2nd, 2024**: New nightly build of OpenCore Legacy Patcher 1.6.0 based on Sequoia Development branch is [avaialble here](https://github.com/dortania/OpenCore-Legacy-Patcher/pull/1137#issuecomment-2295376562) which can re-enable Ivy Bridge iGPUs and NVDIA Kepler Cards
- **August 18th, 2024**: [Early macOS Sequoia support available](https://github.com/dortania/OpenCore-Legacy-Patcher/pull/1137#issuecomment-2295376562). Things look bad for: Sandy Bridge, Ivy Bridge, Haswell, Nvidia cards, AMD Terascale
- **June 28th, 2024**: [AMFIPass.kext updated to 1.4.1](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/sequoia-development/payloads/Kexts/Acidanthera/AMFIPass-v1.4.1-RELEASE.zip)
- OCLP v. 1.6.0 added to [Changelog](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/CHANGELOG.md#opencore-legacy-patcher-changelog)
- **June 10th, 2024**: A [development branch](https://github.com/dortania/OpenCore-Legacy-Patcher/compare/main...sequoia-development ) of OCLP for macOS Sequoia has been created
- **May 30th, 2024**: [**OCLP v1.50**](https://github.com/dortania/OpenCore-Legacy-Patcher/releases/tag/1.5.0) released
	- OCLP now has a .pkg installer which is the new recommended method for installing OpenCore Legacy Patcher (on real Macs)
	- New Privileged Helper Tool which removes requirement of password prompts for installing patches, creating installers, etc.
