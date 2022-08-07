# OC-Little: ACPI Hotpatch Samples and Guides for OpenCore

[![OpenCore Version](https://img.shields.io/badge/Supported_OpenCore_Version-≤0.8.3-success.svg)](https://github.com/acidanthera/OpenCorePkg) [![macOS](https://img.shields.io/badge/Supported_macOS-≤13.0_beta-white.svg)](https://www.apple.com/macos/macos-ventura-preview/) ![Last Update](https://img.shields.io/badge/Last_Update_(yy/mm/dd):-22.08.07-blueviolet.svg)</br>![maciasl](https://user-images.githubusercontent.com/76865553/179583184-5efe6546-9f3a-4899-bdc1-5e9ec5a2927e.png)

## ABOUT
Compendium of Guides, ACPI Hotpatches and Binary Renames for use with the OpenCore Boot Manager based on [**OC-Little by Daliansky**](https://github.com/daliansky/OC-little) translated from Chinese. All Binary Renames, ACPI Hotpatches (containing `OCLT`in the table header) remain untouched except where indicated.

This repo provides additional ACPI hotpatches and guides complementary to the ones provided by the OpenCore Package and Dortania's OpenCore Install Guide. It covers all angles of modern hackintoshing. From adding and enabling devices and features, fixing USB and Sleep issues, laptop-specific fixes, GPU optimizations and more (check the TOC for details). Although aimed primarily at OpenCore users, all of the SSDTs and most of the guides/techniques can be applied using the Clover Boot Manager as well.

### DISCLAIMER
The methods and techniques presented in this repo are based on utilizing the official OpenCore release and its features alongside Kexts, SSDTs, Device Properties and other tools to enable/disable devices and features in macOS to get a *proper* working system which is ACPI conform!

**OC-Little Translated** does not consider patching the `DSDT` an *appropriate* measure to get a "Real Vanilla Hackintosh". In fact, it's quite the opposite, as discussed [here](https://www.insanelymac.com/forum/topic/352881-when-is-rebaseregions-necessary/?do=findComment&comment=2790870):

> MaLd0n's implications that you need a custom DSDT to add and remove (well, remove yes, but disabling is good enough in virtually all cases) devices is **incorrect**. Aside from those claims, most device rename changes (probably also things you considered „missing“) are also not needed, as they are performed by Lilu and its plug-ins. This approach is a lot safer than previous ACPI renames as dumb find-replace patches can yield false positives, the kext approach cannot. 

Therefore, **OC-Little Translated does not support nor promote patching DSDTs** (and the shady business practices behind it), as well as pre-patched ISOs and unofficial modified forks of OpenCore that prevent injecting ACPI tables into Windows, just because the guy running his "Real Vanilla Hackintosh" forum doesn't know how to write proper ACPI tables that don't cause a Blue Screen of Death!

<details>
<summary><strong>About the translation</strong> (click to reveal content)</summary>

## About the translation

- AI-based translation using deepL, google translator as well as manual copyediting.
- Restructured the repository into more plausible (sub-)sections and categories based on types of issues, components, methods, etc.
- Restructured Texts for better readability and comprehensibility
- Rewrote whole sections which were confusing/misleading (`ACPI` and `USB Port Mapping` for example)
- Added missing descriptions
- Added further explanations where necessary
- Added new content (added USB Port Mapping via ACPI to Chapter 3, Chapters 7 to 11 as well as the whole "Appendix" section)

**NOTE**: Due to the fact that I don't speak Chinese the translation might not be 100% accurate.
</details>

## TABLE of CONTENTS
**MAIN**

* [**ACPI Basics and Guides**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00_ACPI)
* [**Adding Fake Devices and enabling Features with SSDTs**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features#readme)
* [**Disabling Devices**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/02_Disabling_Devices)
* [**USB Port Mapping**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03_USB_Fixes)
* [**Fixing Sleep and Wake Issues**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues)
* [**Laptop-specific Patches**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05_Laptop-specific_Patches)
* [**CMOS-related Fixes**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/06_CMOS-related_Fixes)
* [**PCI BAR Size** (≥ OC 0.7.5)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/07_PCI_BAR_Size#readme)
* [**Quirks**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/08_Quirks)
* [**Board-ID Skip and VMM Spoof**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof)
* [**Kext Loading Sequence Examples**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/10_Kexts_Loading_Sequence_Examples#readme)
* [**Graphics**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/11_Graphics) (integrated/discrete)

**APPENDIX**

* [**Updating OpenCore**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/D_Updating_OpenCore#readme)
* [**Config Tips & Tricks**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A_Config_Tips_and_Tricks#readme)
* [**Compatibility Charts**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/E_Compatibility_Charts)
* [**Desktop EFIs**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/F_Desktop_EFIs#readme)
* [**Create/modify a Layout-ID for AppleALC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/L_ALC_Layout-ID#readme)
* [**Adding Windows to the boot menu GUI**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/I_Windows)
* [**Enabling Linux Boot Entries**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/G_Linux#readme)
* [**Boot Arguments Explained**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/H_Boot-args#readme)
* [**OpenCore Calculators**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/B_OC_Calculators)
* [**Compiling slimmed-down variants of Kexts**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/J_Compiling_Kexts#readme)
* [**Debugging**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/K_Debugging#readme)
* [**OpenCore EFI Upload Checklist**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/M_EFI_Upload_Chklst#readme)
* [**Combining all SSDTs into one file (SSDT-ALL)**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/N_SSDT-ALL)
* [**Utilities and Resource**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/C_Utilities_and_Resources#readme)
* [**Terminal Commands**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/Terminal_Commands.md#readme)

## CONTRIBUTIONS
If you would like to contribute to the information provided in this repo in order to improve/expand it, feel free to create an issue with a meaningful title, link to the chapter/section and describe what you like to add, change, correct or expand upon.

## 5T33Z0's 5H0UT 0UT5

- Thanks to the [**contributors**](https://github.com/5T33Z0/OC-Little-Translated/graphs/contributors) for improving and expanding the repo. Additional credits for contributors outside of the github realm are listed in the respective sections of the repo.
- sascha_77 for Kext Updater, ANYmacOS and helping me to unbrick my Lenovo T530 BIOS!
- Apfelnico for introducing me to ASL/AML Basics
- Bluebyte for having good conversations
- Cyberdevs from insanelymac for his Z170X Gaming 5 Guide and for being a prime example of a Moderator who treats others with respect!

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
