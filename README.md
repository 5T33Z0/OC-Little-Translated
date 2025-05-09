# OC-Little: ACPI Hotpatch Samples and Guides for OpenCore

[![OpenCore Version](https://img.shields.io/badge/Supported_OpenCore_Version:-≤1.0.5-success.svg)](https://github.com/acidanthera/OpenCorePkg) ![macOS](https://img.shields.io/badge/Supported_macOS:-≤15.5-white.svg) ![Last Update](https://img.shields.io/badge/Last_Update_(yy/mm/dd):-25.05.09-blueviolet.svg)</br>![maciasl](https://user-images.githubusercontent.com/76865553/179583184-5efe6546-9f3a-4899-bdc1-5e9ec5a2927e.png)

**TABLE of CONTENTS**
## PREFACE

* [**DISCLAIMER**](#disclaimer)
* [**About OC-Little Translated**](#about)
* [**About the translation**](#about-the-translation)

## MAIN

* [**ACPI basics and guides**](/00_ACPI/README.md)
* [**Adding/Enabling Devices and Features with SSDTs**](/01_Adding_missing_Devices_and_enabling_Features/README.md)
* [**Disabling Devices**](/02_Disabling_Devices/README.md)
* [**Fixing Graphics**](/11_Graphics/README.md) (integrated/discrete)
* [**Fixing USB**](/03_USB_Fixes/README.md)
* [**Fixing Sleep and Wake Issues**](04_Fixing_Sleep_and_Wake_Issues/README.md)
* [**Fixing issues with peripherals**](/13_Peripherals/README.md)
* [**Laptop-specific Patches**](/05_Laptop-specific_Patches/README.md)
* [**CMOS-related Fixes**](/06_CMOS-related_Fixes/README.md)
* [**BOOT Folder**](/07_BOOT_Folder/README.md)
* [**Kext Loading Sequence Examples**](/10_Kexts_Loading_Sequence_Examples/README.md)
* [**MMIO Whitelist**](/12_MMIO_Whitelist/README.md)
* [**Fixing falsely reported RAM speed**](/15_RAM/README.md)

## SPECIAL
* [**Using OpenCore-Patcher on Wintel machines**](/14_OCLP_Wintel/README.md)
* [**Board-ID Skip and VMM Spoof**](/09_Board-ID_VMM-Spoof/README.md)
* [**Utilities and Resource**](/C_Utilities_and_Resources/README.md)

## APPENDIX

### Config-related
* [**Config Tips & Tricks**](/A_Config_Tips_and_Tricks/README.md)
* [**Boot Arguments Explained**](/H_Boot-args/README.md)
* [**Quirks**](/08_Quirks/README.md)
* [**EFI Upload Checklist**](/M_EFI_Upload_Chklst/README.md)
* [**Generating OpenCore EFIs with OpCore Simplify**](/P_OpCore_Simplify/README.md)

### Guides for OpenCore Auxiliary Tools (OCAT)
* [**Updating OpenCore**](/D_Updating_OpenCore/README.md)
* [**OpenCore Calculators**](/B_OC_Calculators/README.md)
* [**Switching to NO_ACPI build of OpenCore**](/O_OC_NO_ACPI/README.md)
* [**Generating EFIs with OCAT**](/F_Desktop_EFIs/README.md)

### macOS-related
* [**Terminal Commands**](/Terminal_Commands.md#readme)
* [**Compatibility Charts**](/E_Compatibility_Charts/README.md)
* [**Fixing issues with System Update Notifications**](/S_System_Updates/README.md)
* [**macOS 14.4 install workaround**](/W_Workarounds/README.md)
* [**Creating a multi macOS USB Installer**](/U_USB_Multi_installer/README.md)

### Other OSes
* [**Windows-related Guides**](/I_Windows/README.md)
* [**Enabling Linux Boot Entries**](/G_Linux/README.md)
* [**macOS Virtualization**](/V_Virtualization/README.md)

### Miscellaneous
* [**Featured OpenCanopy Themes**](/T_Themes/README.md)
* [**Create/modify a Layout-ID for AppleALC**](/L_ALC_Layout-ID/README.md)
* [**Compiling slimmed-down variants of Kexts**](/J_Compiling_Kexts/README.md)
* [**Debugging with SysReport**](/K_Debugging/README.md)
* [**Combining all SSDTs into one file (`SSDT-ALL`)**](/N_SSDT-ALL/README.md)
* [**Using Clover alongside OpenCore**](/R_BootloaderChooser/README.md)

___

## DISCLAIMER
1. OC-Little Translated is not an installation guide for getting your system up and running with macOS – use Dortania's excellent [**OpenCore Install Guide**](https://dortania.github.io/OpenCore-Install-Guide/) for that! Instead, it's a supplementary resource that offers guides and fixes for various issues related to hackintosh systems, along with explanations and context about how they work. It is regularly updated to reflect the latest discoveries and developments of the hackintosh community.
2. The material presented in this repo is designed to empower users to create a *proper* working system running macOS without breaking ACPI-compliancy! Therefore, **OC-Little Translated** does not support methods which do not hold up to this premise – such as patching the `DSDT` – since it's not an *appropriate* measure to get the "Real Vanilla Hackintosh" experience. In fact, it's quite the opposite, [**as discussed on insanelymac**](https://www.insanelymac.com/forum/topic/352881-when-is-rebaseregions-necessary/#comment-2790870).
	
## ABOUT
Collection of guides, ACPI Hotpatches and Binary Renames for use with the OpenCore Boot Manager based on [**OC-Little by Daliansky**](https://github.com/daliansky/OC-little) translated from Chinese.

Besides the original translated guides, this repo contains additional guides complementary to the ones provided by the OpenCore Package and Dortania's OpenCore Guides. It covers a wide range of hackintosh-related topics, including: 

- ACPI basics
- Enabling devices and features
- Fixing sleep/wake and other power-related issues
- Guides for Mapping USB Ports
- Fixing Laptop-specific issues
- Fixing graphics-related issues
- Config-related tips
- Guides for using OpenCore Legacy Patcher on Wintel Systems

Check the table of contents for more. Although aimed primarily at OpenCore users, all of the SSDTs and most of the guides/techniques are applicable to Clover as well.

### About the translation
- AI-based translation using deepL, google translator as well as manual copyediting.
- Restructured the repository into more plausible (sub-)sections and categories based on types of issues, components, methods, etc.
- Restructured Texts for better readability and comprehensibility
- Rewrote whole sections which were confusing/misleading (`ACPI` and `USB Port Mapping` for example)
- Added missing descriptions
- Added further explanations where necessary
- Added new content (USB Port Mapping via ACPI, Chapters 7 to 14 as well as the whole "Appendix" section)

> [!NOTE]
>
> Due to the fact that I don't speak Chinese the translation might not be 100% accurate.

## CONTRIBUTIONS
If you would like to contribute to the information provided in this repo in order to improve/expand it, feel free to create an issue with a meaningful title, link to the chapter/section and describe what you like to add, change, correct or expand upon.

## STAR HISTORY

<a href="https://star-history.com/#5T33Z0/OC-Little-Translated&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=5T33Z0/OC-Little-Translated&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=5T33Z0/OC-Little-Translated&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=5T33Z0/OC-Little-Translated&type=Date" />
 </picture>
</a>

## 5T33Z0's 5H0UT 0UT5

- Thanks to al the [**contributors**](https://github.com/5T33Z0/OC-Little-Translated/graphs/contributors) for improving and expanding the repo! Additional credits for contributors outside of the github realm are listed in the respective chapters/sections.
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
> 	- @冬瓜-X1C5th
> 	- @OC-xlivans
> 	- @Air 13 IWL-GZ-Big Orange (OC perfect)
> 	- @子骏oc IWL
> 	- @大勇-小新air13-OC-划水小白
> 	- @xjn819
> 	- Acidanthera for maintaining OpenCorePkg
</details>
