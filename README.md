# OC-Little: ACPI Hotpatch Samples and Guides for OpenCore
[![OpenCore Version](https://img.shields.io/badge/OpenCore-0.7.7-cyan.svg)](https://github.com/CloverHackyColor/CloverBootloader/releases)
![Last Update](https://img.shields.io/badge/Last_Update_(yy/mm/dd):-22.01.08-blueviolet.svg)
![](https://raw.githubusercontent.com/5T33Z0/OC-Little-Translated/main/A_Config_Tips_and_Tricks/maciasl.png)

## ABOUT
Compendium of ACPI Hotpatches and Binary Renames for use with the OpenCore Bootloader based on [**OC-Little by Daliansky**](https://github.com/daliansky/OC-little) translated from Chinese. All Binary Renames, ACPI Hotpatches (containing `OCLT`in the table header) remain untouched except where indicated.

This repo provides additional ACPI hotpatches and guides complementary to the ones provided by the OpenCore Package and Dortania's OpenCore Install Guide. It covers all angles of modern hackintoshing. From adding and enabling devices and features, fixing USB and Sleep issues, laptop-specific fixes, GPU optimizations and more (check the TOC for details). Although aimed primarily at OpenCore users, all of the SSDTs and most of the guides/techniques can be apllied using the Clover Bootloader as well.

<details>
<summary><strong>About the translation</strong> (click to reveal content)</summary>

## About the translation

- AI-based translation using deepL, google translator as well as manual copyediting.
- Restructured the repository into more plausible (sub-)sections and categories based on types of issues, components, methods, etc.
- Restructured Texts for better readability and comprehensibility
- Rewrote whole sections which were confusing/misleading (`ACPI` and `USB Port Mapping` for example)
- Added missing descriptions
- Added further explanations where necessary
- Added new content (USB Port Mapping via ACPI to Chapter 3, Chapters 7 to 10 and the whole Appendix section)

**NOTE**: Due to the fact that I don't speak Chinese the translation might not be 100% accurate.
</details>

## TABLE of CONTENTS
**MAIN**

* [**About ACPI and ACPI Debugging**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00_About_ACPI)
* [**Adding Fake Devices and enabling Features with SSDTs**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features)
* [**Disabling Devices**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/02_Disabling_Devices)
* [**USB Port Mapping**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03_USB_Fixes)
* [**Fixing Sleep and Wake Issues**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues)
* [**Laptop-specific Patches**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05_Laptop-specific_Patches)
* [**CMOS-related Fixes**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/06_CMOS-related_Fixes)
* [**PCI BAR Size** (≥ OC 0.7.5)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/07_PCI_BAR_Size)
* [**Quirks**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/08_Quirks)
* [**Board-ID Skip and VMM Spoof**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof)
* [**Kext Loading Sequence Examples**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/10_Kexts_Loading_Sequence_Examples)

**APPENDIX**

* [**Config Tips & Tricks**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A_Config_Tips_and_Tricks)
* [**Updating OpenCore**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/D_Updating_OpenCore)
* [**SMBIOS Compatibility**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/E_SMBIOS_Compatibility)
* [**Desktop EFIs**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/F_Desktop_EFIs)
* [**Enabling Linux Boot Entries**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/G_Linux)
* [**Boot Arguments Explained**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/H_Boot-args)
* [**OpenCore Calculators**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/B_OC_Calculators)
* [**Utilities and Resource**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/C_Utilities_and_Resources)


## CONTRIBUTIONS
If you would like to contribute to the information provided in this repo in order to improve/expand it, feel free to create an issue with a meaningful title, link to the chapter/section and describe what you like to add, change, correct or expand upon.

## 5T33Z0's 5H0UT 0UT5

- Thanks to [Baio1977](https://github.com/Baio1977) for his contributions to improve and expand this repo.
- sascha_77 for Kext Updater, ANYmacOS and helping me to unbrick my Lenovo T530 BIOS!
- Apfelnico for introducing me to ASL/AML Basics
- Bluebyte for having good conversations
- insanelymac.com for being a really nice community with kind mods

<details>
<summary><strong>Daliansky's original Credits</strong></summary>

> - Special credit to:
> 	- @XianWu write these ACPI component patches that useable to OpenCore
> 	- @Bat.bat, @DalianSky, @athlonreg, @iStar丶Forever their proofreading and finalization.
> - Credits and thanks to：
> 	-  @冬瓜-X1C5th
> 	- @OC-xlivans
> 	- @Air 13 IWL-GZ-Big Orange (OC perfect)
> 	- @子骏oc IWL
> 	- @大勇-小新air13-OC-划水小白
> 	- @xjn819
> 	- Acidanthera for maintaining OpenCorePkg
</details>
