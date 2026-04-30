# OC-Little Translated: ACPI Hotpatch Samples and Guides for OpenCore

[![OpenCore Version](https://img.shields.io/badge/Supported_OpenCore_Version:-≤1.0.7-success.svg)](https://github.com/acidanthera/OpenCorePkg)
![macOS](https://img.shields.io/badge/Supported_macOS:-≤26.3-white.svg)
![Last Update](https://img.shields.io/badge/Last_Update_\(yy/mm/dd\):-26.04.30-blueviolet.svg)

![maciasl](https://user-images.githubusercontent.com/76865553/179583184-5efe6546-9f3a-4899-bdc1-5e9ec5a2927e.png)

---

## 🧰 Introduction

**OC-Little Translated** is a collection of ACPI hotpatches, binary renames, and guides for OpenCore, translated from [Daliansky's OC-Little](https://github.com/daliansky/OC-little) but expanded to reflect the latest developments of the Hackintosh scene. It complements Dortania's OpenCore Guides and covers topics like ACPI basics, device enabling, USB mapping, graphics fixes, and more. While tailored for OpenCore, most SSDTs and techniques are applicable to Clover bootloader as well.

### 📌 Disclaimer

1. **🚫 Not an Installation or Configuration Guide**
   
   This is *not* a macOS installation nor OC Configuration guide. For setting up OpenCore for macOS usage on a Wintel System, use the [**OpenCore Install Guide**](https://dortania.github.io/OpenCore-Install-Guide/).  OC-Little focuses primarily on **post-install tuning** and **hardware enablement**.

3. **✅ ACPI-Compliant Methods Only**

   This project avoids DSDT patching and other invasive mods. It adheres to the philosophy of a **clean, vanilla Hackintosh** using only **ACPI hotpatching**.
   For more on this philosophy, see [this InsanelyMac thread](https://www.insanelymac.com/forum/topic/352881-when-is-rebaseregions-necessary/#comment-2790870).

### 🌍 About the Translation

- **Translation Process**: Uses AI-based tools (DeepL, Google Translate) with manual copyediting for accuracy.
- **Restructuring**: Organized the repo into logical sections based on issue types, components, and methods.
- **Improvements**: Rewritten confusing sections (e.g., ACPI, USB Port Mapping), added missing descriptions, and included new content (e.g., USB Port Mapping via ACPI, Chapters 7–14, and the Appendix).
- **Accuracy Note**: As the translator does not speak Chinese, minor inaccuracies may exist.

## 🔧 Core Configuration & Patching

### 📄 ACPI & Devices

* 🧠 [ACPI Basics and Guides](/Content/00_ACPI/README.md)
* ➕ [Adding Missing Devices (SSDTs)](/Content/01_Adding_missing_Devices_and_enabling_Features/README.md)
* ➖ [Disabling Devices](/Content/02_Disabling_Devices/README.md)
* 🧩 [Populating the MMIO Whitelist](/Content/12_MMIO_Whitelist/README.md)
* 🧷 [Merging SSDTs into one table](Content/00_ACPI/SSDT-ALL)

### 🛠️ System Fixes

* :computer: [Fixing CPU Power Management](https://github.com/5T33Z0/OC-Little-Translated/tree/main/Content/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management)
* 🎮 [Fixing Graphics (iGPU/dGPU)](/Content/11_Graphics/README.md)
* 🔌 [Fixing USB](/Content/03_USB_Fixes/README.md)
* 😴 [Fixing Sleep & Wake](/Content/04_Fixing_Sleep_and_Wake_Issues/README.md)
* 🔄 [Fixing OTA System Updates](/Content/S_System_Updates/OTA_Updates.md)
* 🖱️ [Fixing issues with peripherals](/Content/13_Peripherals/README.md)
* 🧮 [Fixing RAM Speed Reporting](/Content/15_RAM/README.md)
* 🔋 [CMOS-Related Fixes](/Content/06_CMOS-related_Fixes/README.md)
* 🛠️ [macOS 14.4+ Install Workaround](/Content/W_Workarounds/README.md)

### 💻 Laptop-Specific

* 💻 [Laptop Patches (Battery, FN keys, etc.)](/Content/05_Laptop-specific_Patches/README.md)
* 🖥️ [Modifying Framebuffer Patch for detecting External Displays](/Content/11_Graphics/iGPU/Framebuffer_Patching)

## ⚙️ Boot & Kexts

* ⚙️ [Boot-Args Explained](/Content/H_Boot-args/README.md)
* 📦 [Kext Loading Order Examples](/Content/10_Kexts_Loading_Sequence_Examples/README.md)
* 📡 [Sensor Plugins for Monitoring](/Content/17_SysMon)
* 🧬 [Compiling Slimmed-Down Kexts](/Content/J_Compiling_Kexts/README.md)
* 🗂️ [BOOT Folder Configuration](/Content/07_BOOT_Folder/README.md)

## 🧠 Advanced Configuration

### 🧩 OpenCore Setup

* 💡 [Config Tips & Tricks](/Content/A_Config_Tips_and_Tricks/README.md)
* 🎛️ [Quirks Explained](/Content/08_Quirks/README.md)
* 📋 [EFI Upload Checklist](/Content/M_EFI_Upload_Chklst/README.md)
* 🧮 [OpenCore Calculators](/Content/B_OC_Calculators/README.md)
* 🎨 [Featured OpenCanopy Themes](/Content/T_Themes/README.md)
* 🧠 [Tips for working with ProperTree](/Content/Y_ProperTree_Secrets)

### 🛠️ OpenCore Auxiliary Tools (OCAT)

* 🔄 [Updating OpenCore with OCAT](/Content/D_Updating_OpenCore/Updating_OC.md)
* 💡 [OCAT Tips & Tricks](/Content/D_Updating_OpenCore/OCAT_Bonus.md)
* 🧰 [Generating EFIs with OCAT](/Content/F_Desktop_EFIs/README.md)
* 🚫 [Switching to NO\_ACPI Build](/Content/O_OC_NO_ACPI/README.md)

## 🍏 macOS Topics

* 📊 [macOS Compatibility Charts](/Content/E_Compatibility_Charts/README.md)
* 💿 [Multi-macOS USB Installer](/Content/U_USB_Multi_installer/README.md)
* 💻 [macOS Virtualization](/Content/V_Virtualization/README.md)

## 🪟 Other OSes

* 🪟 [Windows-Specific Fixes](/Content/I_Windows/README.md)
* 🐧 [Adding Linux Boot Entries](/Content/G_Linux/README.md)

## 🧪 Special Topics

* 🧼 [Using OCLP on Wintel PCs](/Content/14_OCLP_Wintel/README.md)
* 🧰 [Generating EFIs with OpCore Simplify](/Content/P_OpCore_Simplify/README.md)
* 🎧 [Creating a custom AppleALC Layout-ID](/Content/L_ALC_Layout-ID/README.md)
* 🔀 [Using Clover & OpenCore Together](/Content/R_BootloaderChooser/README.md)
* 🧃 [Utilities & Resources](/Content/C_Utilities_and_Resources/README.md)

## Troubleshooting and Config Optimization
* 💻 [List of helpful Terminal Commands](/Terminal_Commands.md#readme)
* 🖥️ [AI-Assisted OpenCore Bootlog Analysis & Config Optimization](/Content/18_Troubleshooting/Config_Tweaks_AI.md)
* 📄 [Converting Spindumps to Text for Further Analysis](/Content/18_Troubleshooting/Converting_Spindumps.md)
* 🐛 [Debugging with SysReport](/Content/K_Debugging/README.md)

## 📈 Repo Stats

<a href="https://star-history.com/#5T33Z0/OC-Little-Translated&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=5T33Z0/OC-Little-Translated&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=5T33Z0/OC-Little-Translated&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=5T33Z0/OC-Little-Translated&type=Date" />
 </picture>
</a>

## 🙏 Acknowledgments

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
