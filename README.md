# OC-Little: ACPI Hotpatch Samples and Guides for OpenCore

[![OpenCore Version](https://img.shields.io/badge/Supported_OpenCore_Version:-≤1.0.3-success.svg)](https://github.com/acidanthera/OpenCorePkg) ![macOS](https://img.shields.io/badge/Supported_macOS:-≤15.2-white.svg) ![Last Update](https://img.shields.io/badge/Last_Update_(yy/mm/dd):-24.12.12-blueviolet.svg)</br>![maciasl](https://user-images.githubusercontent.com/76865553/179583184-5efe6546-9f3a-4899-bdc1-5e9ec5a2927e.png)

## TABLE of CONTENTS

**PREFACE**

* [**DISCLAIMER**](#disclaimer)
* [**About OC-Little Translated**](#about)
* [**About the translation**](#about-the-translation)

**MAIN**

* [**ACPI basics and guides**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00_ACPI)
* [**Adding/Enabling Devices and Features with SSDTs**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features#readme)
* [**Disabling Devices**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/02_Disabling_Devices)
* [**Fixing Graphics**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/11_Graphics) (integrated/discrete)
* [**Fixing USB**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03_USB_Fixes)
* [**Fixing Sleep and Wake Issues**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues)
* [**Fixing issues with peripherals**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/13_Peripherals)
* [**Laptop-specific Patches**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05_Laptop-specific_Patches)
* [**CMOS-related Fixes**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/06_CMOS-related_Fixes)
* [**BOOT Folder**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/07_BOOT_Folder#adding-and-configuring-contentflavour-and-contentvisibility)
* [**Quirks**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/08_Quirks)
* [**Board-ID Skip and VMM Spoof**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof)
* [**Kext Loading Sequence Examples**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/10_Kexts_Loading_Sequence_Examples#readme)
* [**MMIO Whitelist**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/12_MMIO_Whitelist)
* [**Fixing falsely reported RAM speed**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/15_RAM)

**SPECIAL**

* [**Using OpenCore-Patcher on Wintel machines**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/14_OCLP_Wintel#installing-newer-versions-of-macos-on-legacy-hardware) 

**APPENDIX**

* [**macOS 14.4 install workaround**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/W_Workarounds/README.md)
* [**Updating OpenCore**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/D_Updating_OpenCore#readme)
* [**Fixing issues with System Update Notifications**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/S_System_Updates#readme)
* [**Config Tips & Tricks**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A_Config_Tips_and_Tricks#readme)
* [**Compatibility Charts**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/E_Compatibility_Charts)
* [**Generating EFIs with OCAT**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/F_Desktop_EFIs#readme)
* [**Create/modify a Layout-ID for AppleALC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/L_ALC_Layout-ID#readme)
* [**Windows-related Guides**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/I_Windows)
* [**Enabling Linux Boot Entries**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/G_Linux#readme)
* [**Boot Arguments Explained**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/H_Boot-args#readme)
* [**OpenCore Calculators**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/B_OC_Calculators)
* [**Compiling slimmed-down variants of Kexts**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/J_Compiling_Kexts#readme)
* [**Debugging**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/K_Debugging#readme)
* [**OpenCore EFI Upload Checklist**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/M_EFI_Upload_Chklst#readme)
* [**Combining all SSDTs into one file (SSDT-ALL)**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/N_SSDT-ALL)
* [**Switching to NO_ACPI build of OpenCore**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/O_OC_NO_ACPI)
* [**Using Clover alongside OpenCore**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/R_BootloaderChooser#readme)
* [**Utilities and Resource**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/C_Utilities_and_Resources#readme)
* [**Featured OpenCanopy Themes**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/T_Themes)
* [**macOS Virtulization**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/V_Virtualization#virtualization)
* [**Terminal Commands**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/Terminal_Commands.md#readme)
* [**Creating a multi macOS USB Installer**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/U_USB_Multi_installer#readme)

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
