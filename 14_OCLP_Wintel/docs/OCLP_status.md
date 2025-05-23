# OCLP update status

| ⚠️ Important updates |
|:----------------------------|
| Nothing to report currently.

## Release History

### 2025
- **May 15th,2023**: OCLP 2.4.0 is [released](https://github.com/dortania/OpenCore-Legacy-Patcher/releases/tag/2.4.0) which primarily focuses on macOS 15.5 support. A mentiobable feature is reduced CPU usage in the User Interface thread.
- **March 31st, 2025**: OCLP 2.3.0 is [released](https://github.com/dortania/OpenCore-Legacy-Patcher/releases/tag/2.3.0), focussing on macOS 15.4 support.

### 2024
- **December 11th, 2024**: OCLP 2.2.0 is [released](https://github.com/dortania/OpenCore-Legacy-Patcher/releases/tag/2.2.0) and brings a lot of improvements for non-metal machines on Sonoma/Sequoia!
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
- **February 12th, 2024**: Updated [**IOSkywalkFamily.kext**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Wifi) for legacy WIFI. Required for macOS 14.4 beta.

### 2023
- **November 6th, 2023**: **OCLP 1.3.0 beta**. Fixes Intel HD 4000 and Kepler GPU Windowserver crashes in macOS 14.2 beta 3
- **November 6th, 2023**: **OCLP v1.2.0** is released and includes a long list of [changes](https://github.com/dortania/OpenCore-Legacy-Patcher/releases/tag/1.2.0)
- **October 23rd, 2023**: [**OCLP v1.1.0**](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) was released. Includes updated kexts, binaries for Non-Metal GPUs for macOS Sonoma and other improvements (&rarr; see changelog for details)
- **October 2nd, 2023**: [**OCLP v1.0.0:**](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) was released. It enables running macOS Sonoma on 83 previously unsupported Mac models. With it, they also switched the numbering of releases from a simple "counter" to Semantic Versioning.
- **OCLP 069**: [Nightly build](https://github.com/dortania/OpenCore-Legacy-Patcher/pull/1077#issuecomment-1646934494) 
	- Introduces kexts and root patching options to re-enable previously working Wifi Cards
- [**OCLP 068**](https://github.com/dortania/OpenCore-Legacy-Patcher/releases/tag/0.6.8): 
	- Fixes graphics acceleration patches in Sonoma
	- Introduces AMFIPass.kext which allows AMFI to work with lowered/disabled SIP settings, resolving issues with [granting 3rd party app access to peripherals](https://github.com/5T33Z0/OC-Little-Translated/blob/main/13_Peripherals/Fixing_Peripherals.md) like webcams and micreophones
- **OCLP 067**: currently not working (which was expected)

>[!TIP]
>
> The latest nightly builds of OpenCore Legacy Pater can be found in the [**Actions**](https://github.com/dortania/OpenCore-Legacy-Patcher/actions) section of the OCLP repository (requires Github-Account)

## Links

- [**Full OCLP Changelog**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/CHANGELOG.md) (by Dortania)
