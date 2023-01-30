[![OpenCore Version](https://img.shields.io/badge/Supported_OpenCore_Version-0.8.0+-success.svg)](https://github.com/acidanthera/OpenCorePkg)

# Pre-configured OpenCore Desktop Configs

**TABLE of CONTENTS**

- [About](#about)
- [New approach: generating EFIs from `config.plist`](#new-approach-generating-efis-from-configplist)
	- [Included Files and Settings](#included-files-and-settings)
	- [Included Kexts (universal, config-based)](#included-kexts-universal-config-based)
	- [Optional Kexts](#optional-kexts)
		- [CPU](#cpu)
		- [Audio](#audio)
		- [Ethernet](#ethernet)
		- [WiFi and Bluetooth](#wifi-and-bluetooth)
		- [Other Kexts](#other-kexts)
- [Generate EFI Folders using OpenCore Auxiliary Tools](#generate-efi-folders-using-opencore-auxiliary-tools)
	- [1. Generate a base EFI Folder for the CPU of your choice](#1-generate-a-base-efi-folder-for-the-cpu-of-your-choice)
	- [2. Modifying the `config.plist`](#2-modifying-the-configplist)
	- [3. Post-Install: fixing CPU Power Management on Sandy and Ivy Bridge CPUs](#3-post-install-fixing-cpu-power-management-on-sandy-and-ivy-bridge-cpus)
- [Addtional Configuration Notes](#addtional-configuration-notes)
	- [Additional `boot-args`](#additional-boot-args)
		- [GPU-specific boot-args](#gpu-specific-boot-args)
		- [Debugging](#debugging)
- [Updating the config Templates manually](#updating-the-config-templates-manually)
- [References](#references)

## About
This section includes OpenCore configs for Intel CPUs based on the work of **Gabriel Luchina** who took a lot of time and effort to create EFI folders with configs for each CPU Family listed in Dortania's OpenCore install Guide. I took his base configs, modified and improved them so they work out of the box (hopefully). However, you should consider them as starting points only for getting you up and running with OpenCore – that's why they are called *base* configs and not "the perfect config for every system ever"!

**No AMD?** Since configuring an AMD systems requires a lot of custom entries in the MMIO Whitelist section, working with generic, pre-made configs is hit or miss. Based on this [**discussion**](https://github.com/ic005k/QtOpenCoreConfig/issues/88), I decided to remove AMD templates from the database. Fabiosun took care of the AMD templates since he has more experience in this field than me.

## New approach: generating EFIs from `config.plist`
Instead of downloading pre-configured and possibly outdated OpenCore EFI folders from the net or github, you can use OpenCore Auxiliary Tools ([**OCAT**](https://github.com/ic005k/OCAuxiliaryTools#readme)) to generate the whole EFI folder based on the configs included in the app's database. This way, you always have the latest version of OpenCore, the config, kexts and drivers.

Included are about 40 configs for Intel CPUs, covering a wide range of supported Desktop CPUs, vendors and chipsets. Laptop configs are not inclused simply because there are way too many variables to consider which is beyond the scope of what's possible here.

### Included Files and Settings
- **Base configs** for Intel Desktop and High End Desktop CPUs with variations for Dell, Sony, HP and other Board/Chipsets (no Laptops!)
- **Required SSDT** Hotpatches for each CPU family (some are disabled – check before deployment!)
- **Necessary Quirks** for each CPU Family (also available as Presets inside of OCAT)
- **Device Properties** for each platform (mostly Framebuffer Patches for: iGPU only, iGPU+dGPU and GPU only)
- Base-set of **Kexts** (see chart below)
- `MinDate` and `MinVersion` for the APFS Driver set to `-1`, so all macOS versions are supported

### Included Kexts (universal, config-based)
Kext|Description
:----|:----
[Lilu.kext](https://github.com/acidanthera/Lilu/releases)|Patch engine required for AppleALC, WhateverGreen, VirtualSMC and many other kexts.
[VirtualSMC.kext](https://github.com/acidanthera/VirtualSMC/releases)|Emulates the System Management Controller (SMC) found on real Macs. Without it macOS won't boot boot.
[WhateverGreen.kext](https://github.com/acidanthera/WhateverGreen/releases)|Used for graphics patching, DRM fixes, board ID checks, framebuffer fixes, etc; all GPUs benefit from this kext.
|[AppleALC](https://github.com/acidanthera/AppleALC/releases)|Kext for enabling native macOS HD audio for unsupported Audio CODECs without filesystem modifications.
[CpuTscSync.kext](https://github.com/acidanthera/CpuTscSync/releases)|For syncing TSC on Intel HEDT and Server mainboards. Without it, macOS may run extremely slow or won't boot at all.

### Optional Kexts
Listed below, you'll find optional kexts for various features and hardware. Add as needed.

#### CPU
Kext|Description
:----|:----
|SMCProcessor.kext|For temperature monitoring for Intel CPUs (Pennryn and newer). Included in [VirtualSMC](https://github.com/acidanthera/VirtualSMC)
|SMCSuperIO.kext|For Fan Speed Monitoring. Included in [VirtualSMC](https://github.com/acidanthera/VirtualSMC)

#### Audio
Kext|Description
:----|:----
[AppleALC.kext](https://github.com/acidanthera/AppleALC/releases)|Used for AppleHDA patching, allowing support for the majority of on-board sound controllers.<br>AMD 15h/16h may have issues with this and Ryzen/Threadripper systems rarely have mic support.
[VoodooHDA.kext](https://sourceforge.net/projects/voodoohda/)|Audio for FX systems and front panel Mic+Audio support for Ryzen system, do not mix with AppleALC.<br>Audio quality is noticeably worse than AppleALC on Zen CPUs.

#### Ethernet
Kext|Description
:----|:----
[IntelMausi.kext](https://github.com/acidanthera/IntelMausi/releases)|Intel's 82578, 82579, I217, I218 and I219 NICs are officially supported.
[AtherosE2200Ethernet.kext](https://github.com/Mieze/AtherosE2200Ethernet/releases)|Required for Atheros and Killer NICs.<br>**Note**: Atheros Killer E2500 models are actually Realtek based, for these systems please use RealtekRTL8111 instead.
[RealtekRTL8111.kext](https://github.com/Mieze/RTL8111_driver_for_OS_X/releases)|For Realtek's Gigabit Ethernet.<br>Sometimes the latest version of the kext might not work properly with your Ethernet. If you see this issue, try older versions.
[LucyRTL8125Ethernet.kext](https://www.insanelymac.com/forum/files/file/1004-lucyrtl8125ethernet/)|For Realtek's 2.5Gb Ethernet.
[SmallTreeIntel82576.kext](https://github.com/khronokernel/SmallTree-I211-AT-patch/releases)| Required for I211 NICs, based off of the SmallTree kext but patched to support I211.<br>Required for most AMD boards running Intel NICs.

#### WiFi and Bluetooth
Kext|Description
:----|:----
[AirportItlwm](https://github.com/OpenIntelWireless/itlwm/releases)|Adds support for a large variety of Intel wireless cards and works natively in recovery thanks to IO80211Family integration.
[IntelBluetoothFirmware](https://github.com/OpenIntelWireless/IntelBluetoothFirmware/releases)|Adds Bluetooth support to macOS when paired with an Intel wireless card.
[AirportBrcmFixup](https://github.com/acidanthera/AirportBrcmFixup/releases)|Used for patching non-Apple/non-Fenvi Broadcom cards, will not work on Intel, Killer, Realtek, etc.<br>For Big Sur see [Big Sur Known Issues](https://dortania.github.io/OpenCore-Install-Guide/extras/big-sur#known-issues) for extra steps regarding AirPortBrcm4360 drivers.
[BrcmPatchRAM](https://github.com/acidanthera/BrcmPatchRAM/releases)|Used for uploading firmware on Broadcom Bluetooth chipset, required for all non-Apple/non-Fenvi Airport cards.

#### Other Kexts
Kext|Description
:----|:----
[NVMeFix](https://github.com/acidanthera/NVMeFix/releases)|Used for fixing power management and initialization on non-Apple NVMe.
[SATA-Unsupported](https://github.com/khronokernel/Legacy-Kexts/blob/master/Injectors/Zip/SATA-unsupported.kext.zip)|Adds support for a large variety of SATA controllers, mainly relevant for laptops which have issues seeing the SATA drive in macOS. Try without it first to see if your system needs it. 
[AppleMCEReporterDisabler](https://github.com/acidanthera/bugtracker/files/3703498/AppleMCEReporterDisabler.kext.zip)|Useful starting a to disable the AppleMCEReporter kext on macOS Catalina and newer which will cause kernel panics on AMD CPUs. Also recommended for dual-socket systems (ie. Intel Xeon).
[RestrictEvents](https://github.com/acidanthera/RestrictEvents/releases)|Better experience with unsupported processors like AMD, disables memory warnings when using SMBIOS `MacPro7,1`. Can also [fix issues with System Update notifications](https://github.com/5T33Z0/OC-Little-Translated/tree/main/S_System_Updates) (requires boot-arg `revpatch=sbvmm`)

## Generate EFI Folders using OpenCore Auxiliary Tools

### 1. Generate a base EFI Folder for the CPU of your choice
- Run OCAuxiliaryTools (OCAT)
- Open the **Database**
- Double-click on a config of your choice
- An EFI Folder will be generated and placed on your Desktop including SSDTs, Kexts, Drivers, Themes and the `config.plist`.

### 2. Modifying the `config.plist` 
After the base EFI has been generated, the `config.plist` has to be modified based on the used CPU, GPU, additional hardware, peripherals and SMBIOS.

- Go to the Desktop
- Open the `config.plist` included in `\EFI\OC\` with **OCAT** or **ProperTree**
- Check the following Sections and Settings:
	Section |Setting
	--------|---------
	**ACPI/Add** |Add extra ACPI Tables if your hardware configuration requires them. 2nd to 3rd Gen Intel Core CPUs require `SSDT-PM` (create in Post-Install)
	**DeviceProperties**| `PciRoot(0x0)/Pci(0x2,0x0)`: check if the correct [**Framebuffer Patch**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/iGPU/iGPU_DeviceProperties.md) is enabled for your hardware configuration and adjust it accordingly (the `model` property for details). Entries with a `#` are disabled (&rarr; see "Additional Configuration Notes").
	**Kernel/Add** | Add extra kexts required for your hardware and features (WiFi and Bluetooth come to mind). A base-set required for the selected system is already included.
	**PlatformInfo/Generic** |Generate `SMBIOS` Data for the selected Mac model
	**NVRAM/Add/7C436110-AB2A-4BBB-A880-FE41995C9F82**| Add additional boot-args if your hardware requires them (&rarr; see "Additional Configuration Notes").
- Save the config.plist
- Copy the EFI folder to a FAT32 formatted USB flash drive
- Reboot from the flash drive and test if it works
- If it does, mount your system's EFI and put the EFI folder in there.
- If it doesn't you have to check the config again, following Dortania's [OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/).
- If all settings are correct, check the [troubleshooting guide](https://dortania.github.io/OpenCore-Install-Guide/troubleshooting/troubleshooting.html)
- If you find a config error in the config template itself, please create an issue report and I will fix it.

### 3. Post-Install: fixing CPU Power Management on Sandy and Ivy Bridge CPUs
2nd and 3rd Gen Intel CPUs use a different method for CPU Power Management. Use [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) to generate a `SSDT-PM.aml` in Post-Install, add it to your `EFI\OC\ACPI` folder and config to get proper CPU Power Management.

You can follow [**my guide**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(Legacy)) to do so.

## Addtional Configuration Notes
Before deploying your newly generated EFI folder, check the following:

- Open the `config.plist` in a Plist Editor to find additional info and notes
- View `DeviceProperties` to check the included Framebuffer-Patches. Usually, 2 Frambuffer Patches are included ([**List ofavailable Framebuffer Patches**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/iGPU/iGPU_DeviceProperties.md)):
	- One for using the iGPU for driving a Display 
	- One for using the iGPU for computational tasks only (if a supported discrete GPU is present). 
- Depending on your hardware configuration (CPU, iGPU, dGPU, Mainboard, other peripherals) you may have to add additional SSDT Hotpatches, boot-args, DeviceProperties and/or Kexts!
- Cross-Reference with Dortania's OpenCore Install Guide for your CPU family to double-check and verify the config.
- For Troubleshooting, please consult Dortania's [**OC Troubleshooting Guide**](https://dortania.github.io/OpenCore-Install-Guide/troubleshooting/extended/kernel-issues.html#stuck-on-eb-log-exitbs-start)

### Additional `boot-args`
Depending on the combination of CPU, GPU (iGPU and/or dGPU) and SMBIOS, additional `boot-args` may be required. These are not included in the configs and need to be added manually before deploying the EFI folder!

#### GPU-specific boot-args
|Boot-arg|Description|
|:------:|-----------|
**`agdpmod=pikera`**|Disables Board-ID checks on AMD Navi GPUs (RX 5000 & 6000 series). Without this you'll get a black screen. Don't use on Navi Cards (i.e. Polaris and Vega).
**`-igfxvesa`**|Disables graphics acceleration in favor of software rendering. Useful if iGPU and dGPU are incompatible or if you are using an NVIDIA GeForce Card and the WebDrivers are outdated after updating macOS, so the display won't turn on during boot.
**`-wegnoegpu`**|Disables all external/discrete GPUs except integrated graphics. Use if your GPU is incompatible with macOS. Doesn't work all the time.
**~~`nvda_drv=1`~~**|Enables Web Drivers for NVIDIA Graphics Cards (supported up to macOS High Sierra only). In OpenCore you have to add the following key to **NVRAM/Add/7C436110-AB2A-4BBB-A880-FE41995C9F82** instead:</br>![](/Users/5t33z0/Desktop/webdrv.png)
**`nv_disable=1`**|Disables NVIDIA GPUs (***don't*** combine this with `nvda_drv=1`)

#### Debugging
|Boot-arg|Description|
|:------:|-----------|
**`-v`**|_V_erbose Mode. Replaces the progress bar with a terminal output with a bootlog which helps resolving issues. Combine with `debug=0x100` and `keepsyms=1`
**`debug=0x100`**|Disables macOS'es watchdog. Prevents the machine from restarting on a kernel panic. That way you can hopefully glean some useful info and follow the breadcrumbs to get past the issues.
**`keepsyms=1`**|Companion setting to `debug=0x100` that tells the OS to also print the symbols on a kernel panic. That can give some more helpful insight as to what's causing the panic itself.
**`dart=0`**|Disables VT-x/VT-d. Nowadays, `DisableIOMapper` Quirk is used instead.
**`cpus=1`**|Limits the number of CPU cores to 1. Helpful in cases where macOS won't boot or install otherwise.
**`npci=0x2000`**/**`npci=0x3000`**|Disables PCI debugging related to `kIOPCIConfiguratorPFM64`. Alternatively, use `npci=0x3000` which also disables debugging of `gIOPCITunnelledKey`. Required when stuck at `PCI Start Configuration` as there are IRQ conflicts related to your PCI lanes. **Not needed if `Above4GDecoding` can be enabled in BIOS**
**`-no_compat_check`**|Disables macOS compatibility check. For example, macOS 11.0 BigSur no longer supports iMac models introduced before 2014. Enabling this allows installing and booting macOS on otherwise unsupported SMBIOS. Downside: you can't install system updates if this is enabled.

## Updating the config Templates manually
Although these configs are included in OCAT now, they are maintained and updated by me, so the latest versions will always be present in my [**repo**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/F_Desktop_EFIs).

To manually update the config templates, do the following:

- Download [**BaseConfigs.zip**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/F_Desktop_EFIs/BaseConfigs.zip?raw=true) and extract it
- Copy the Files to the Database Folder inside of the **OCAuxiliaryTools** App:
	- Right-click the app and select "Show package contents"
	- browse to `/Contents/MacOS/Database/BaseConfigs/`
	- Paste the files
	- Restart OCAT

**NOTE**: Although I tried to set up each config with the utmost precision in mind there might be errors in them. If you find one, please create an issue report and I will fix it and update the template.

## References
- **OpenCore Bootloader**: https://github.com/acidanthera/OpenCorePkg
- **OpenCore Auxiliary Tools**: https://github.com/ic005k/QtOpenCoreConfig
- **Base Configs**: https://github.com/luchina-gabriel?tab=repositories
- **OpenCore Install Guide**: https://dortania.github.io/OpenCore-Install-Guide
- **OpenCore Troubleshooting Guide**: https://dortania.github.io/OpenCore-Install-Guide/troubleshooting/troubleshooting.html#table-of-contents
