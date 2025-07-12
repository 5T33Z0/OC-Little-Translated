# OC-Little: ACPI Hotpatch Samples and Guides for OpenCore

[![OpenCore Version](https://img.shields.io/badge/Supported_OpenCore_Version:-≤1.0.5-success.svg)](https://github.com/acidanthera/OpenCorePkg)
![macOS](https://img.shields.io/badge/Supported_macOS:-≤26b3-white.svg)
![Last Update](https://img.shields.io/badge/Last_Update_(yy/mm/dd):-25.07.07-blueviolet.svg)

![maciasl](https://user-images.githubusercontent.com/76865553/179583184-5efe6546-9f3a-4899-bdc1-5e9ec5a2927e.png)

## Overview

OC-Little is a comprehensive resource for OpenCore users, offering ACPI hotpatch samples, guides, and fixes to enhance macOS compatibility on hackintosh systems. This repository, based on [OC-Little](https://github.com/daliansky/OC-little) by Daliansky, provides translated and expanded content, focusing on achieving a "Real Vanilla Hackintosh" experience while maintaining ACPI compliance.

- [Disclaimer](#disclaimer)
- [About OC-Little](#about-oc-little)
- [Translation Notes](#translation-notes)

## Core Guides

### ACPI and Device Configuration
- [ACPI Basics and Guides](/Content/00_ACPI/README.md)
- [Adding Missing Devices and Enabling Features with SSDTs](/Content/01_Adding_missing_Devices_and_enabling_Features/README.md)
- [Disabling Devices](/Content/02_Disabling_Devices/README.md)
- [MMIO Whitelist](/Content/12_MMIO_Whitelist/README.md)
- [Merging SSDTs into a sigle file (`SSDT-ALL`)](Content/00_ACPI/SSDT-ALL)

### System Fixes
- [Fixing Graphics (Integrated/Discrete)](/Content/11_Graphics/README.md)
- [Fixing USB](/Content/03_USB_Fixes/README.md)
- [Fixing Sleep and Wake Issues](/Content/04_Fixing_Sleep_and_Wake_Issues/README.md)
- [Fixing Peripherals](/Content/13_Peripherals/README.md)
- [Fixing Falsely Reported RAM Speed](/Content/15_RAM/README.md)
- [CMOS-Related Fixes](/Content/06_CMOS-related_Fixes/README.md)

### Laptop-Specific
- [Laptop-Specific Patches](/Content/05_Laptop-specific_Patches/README.md)

### Boot and Kext Management
- [Boot Arguments Explained](/Content/H_Boot-args/README.md)
- [Kext Loading Sequence Examples](/Content/10_Kexts_Loading_Sequence_Examples/README.md)
- [Compiling Slimmed-Down Variants of Kexts](/Content/J_Compiling_Kexts/README.md)
- [BOOT Folder Configuration](/Content/07_BOOT_Folder/README.md)

## Advanced Configuration

### OpenCore Configuration
- [Config Tips & Tricks](/Content/A_Config_Tips_and_Tricks/README.md)
- [Quirks](/Content/08_Quirks/README.md)
- [EFI Upload Checklist](/Content/M_EFI_Upload_Chklst/README.md)
- [OpenCore Calculators](/Content/B_OC_Calculators/README.md)
- [Featured OpenCanopy Themes](/Content/T_Themes/README.md)
- [Board-ID check skip and VMM Spoof](/Content/09_Board-ID_VMM-Spoof/README.md)
- [ProperTree Secrets](/Content/Y_ProperTree_Secrets)

### OpenCore Auxiliary Tools (OCAT)
- [Updating OpenCore](/Content/D_Updating_OpenCore/README.md)
- [Switching to NO_ACPI Build of OpenCore](/Content/O_OC_NO_ACPI/README.md)
- [Generating EFIs with OCAT](/Content/F_Desktop_EFIs/README.md)

### macOS-Specific
- [Terminal Commands](/Terminal_Commands.md#readme)
- [Compatibility Charts](/Content/E_Compatibility_Charts/README.md)
- [Fixing System Update Notifications](/Content/S_System_Updates/README.md)
- [macOS 14.4 Install Workaround](/Content/W_Workarounds/README.md)
- [Creating a Multi-macOS USB Installer](/Content/U_USB_Multi_installer/README.md)
- [macOS Virtualization](/Content/V_Virtualization/README.md)

### Other Operating Systems
- [Windows-Related Guides](/Content/I_Windows/README.md)
- [Enabling Linux Boot Entries](/Content/G_Linux/README.md)

### Special Topics
- [Generating OpenCore EFIs with OpCore Simplify](/Content/P_OpCore_Simplify/README.md)
- [Using OpenCore-Patcher on Wintel Machines](/Content/14_OCLP_Wintel/README.md)
- [Creating/Modifying a Layout-ID for AppleALC](/Content/L_ALC_Layout-ID/README.md)
- [Debugging with SysReport](/Content/K_Debugging/README.md)
- [Using Clover Alongside OpenCore](/Content/R_BootloaderChooser/README.md)
- [Utilities and Resources](/Content/C_Utilities_and_Resources/README.md)

## Disclaimer

1. **Not an Installation Guide**: OC-Little is not a guide for installing macOS. For that, refer to [Dortania's OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/). This repository provides supplementary guides, fixes, and explanations for hackintosh systems.
2. **ACPI Compliance**: OC-Little emphasizes methods that maintain ACPI compliance, avoiding techniques like DSDT patching, which deviate from a "Real Vanilla Hackintosh" experience. See [this discussion on InsanelyMac](https://www.insanelymac.com/forum/topic/352881-when-is-rebaseregions-necessary/#comment-2790870) for more details.

## About OC-Little

OC-Little is a collection of ACPI hotpatches, binary renames, and guides for OpenCore, translated from [Daliansky's OC-Little](https://github.com/daliansky/OC-little). It complements Dortania's OpenCore Guides and covers topics like ACPI basics, device enabling, USB mapping, graphics fixes, and more. While tailored for OpenCore, most SSDTs and techniques are compatible with Clover.

## Translation Notes

- **Translation Process**: Uses AI-based tools (DeepL, Google Translate) with manual copyediting for accuracy.
- **Restructuring**: Organized into logical sections based on issue types, components, and methods.
- **Improvements**: Rewritten confusing sections (e.g., ACPI, USB Port Mapping), added missing descriptions, and included new content (e.g., USB Port Mapping via ACPI, Chapters 7–14, and the Appendix).
- **Accuracy Note**: As the translator does not speak Chinese, minor inaccuracies may exist.

## Contributions

To contribute, create an issue with a clear title, link to the relevant chapter/section, and describe your proposed additions, changes, or corrections.

## Star History

<a href="https://star-history.com/#5T33Z0/OC-Little-Translated&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=5T33Z0/OC-Little-Translated&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=5T33Z0/OC-Little-Translated&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=5T33Z0/OC-Little-Translated&type=Date" />
 </picture>
</a>

## OC Commits Over Time

The chart below shows commit frequency for Acidanthera's OpenCorePkg repository from 2019 to June 6, 2025:

![OC_Commits_over_time](https://github.com/user-attachments/assets/a0481685-3bd4-43a3-8719-66d739f35538)

## Acknowledgments

- **Contributors**: Thanks to all [contributors](https://github.com/5T33Z0/OC-Little-Translated/graphs/contributors) for improving this repo. Additional credits are listed in relevant chapters.
- **Special Thanks**:
  - **sascha_77**: For Kext Updater, ANYmacOS, and BIOS unbricking assistance.
  - **Apfelnico**: For introducing ASL/AML basics.
  - **Bluebyte**: For insightful discussions.
  - **Cyberdevs**: For the Z170X Gaming 5 Guide and exemplary moderation.
- **Daliansky's Original Credits**:
  - **XianWu**: For ACPI component patches.
  - **Bat.bat, DalianSky, athlonreg, iStar丶Forever**: For proofreading and finalization.
  - **Additional Credits**: 冬瓜-X1C5th, OC-xlivans, Air 13 IWL-GZ-Big Orange, 子骏oc IWL, 大勇-小新air13-OC-划水小白, xjn819, and Acidanthera for OpenCorePkg.
