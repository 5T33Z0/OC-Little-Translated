# Pre-configured OpenCore Desktop EFI Folders
## About
This section includes OpenCore configs based on the work of **Gabriel Luchina** who took a lot of time and effort to create EFI folders with configs for each CPU Family listed in Dortania's OpenCore install Guide. I took his base configs and modified them so they work out of the box (hopefully).

## New approach: generating EFIs from `config.plist`
Instead of downloading pre-configured and possibly outdated OpenCore EFI folders from the net or github, you can use OpenCore Auxiliary Tools (OCAT) to generate the whole EFI folder based on the config included in the App's database. This way, you always have the latest version of OpenCore, the config, kexts and drivers.

Included are about 60 configs for AMD and Intels CPUs, covering a wide range of supported Desktop CPUs, vendors and chipsets.

### Included Files and Settings
- Base configs for AMD and Intel Desktop and High End Desktop CPUs with variations for Dell, Sony, HP and other Board/Chipsets
- Required SSDT Hotpatches for each CPU family (some are disabled – check before deployment!)
- Neccessary Quirks for each CPU Family
- Necessary Kernel Patches for AMD CPUs
- Necessary Device Properties for each platform (mostly Framebuffer Patches)
- Base-set of Kexts (see chart below)
- `MinDate` and `MinVersion` for the APFS Driver set to `-1`, so all macOS versions are supported.

#### Mandatory Kexts (universal)
Kext|Description
:----|:----
[Lilu.kext](https://github.com/acidanthera/Lilu/releases)|Patch engine required for AppleALC, WhateverGreen, VirtualSMC and many other kexts.
[VirtualSMC.kext](https://github.com/acidanthera/VirtualSMC/releases)|Emulates the System Management Controller (SMC) found on real Macs. Without it macOS won't boot boot.
[WhateverGreen.kext](https://github.com/acidanthera/WhateverGreen/releases)|Used for graphics patching, DRM fixes, board ID checks, framebuffer fixes, etc; all GPUs benefit from this kext.
|[AppleALC](https://github.com/acidanthera/AppleALC/releases)|Kext for enabling native macOS HD audio for unsupported Audio CODECs without filesystem modifications.


#### AMD-specific Kexts
Kext|Description
:----|:----
[AMDRyzenCPUPowerManagement.kext](https://github.com/trulyspinach/SMCAMDProcessor/releases)|For [AMD Power Gadget](https://github.com/trulyspinach/SMCAMDProcessor).
[SMCAMDProcessor.kext](https://github.com/trulyspinach/SMCAMDProcessor/releases)|For [AMD Power Gadget](https://github.com/trulyspinach/SMCAMDProcessor).
[AppleMCEReporterDisabler.kext](https://github.com/acidanthera/bugtracker/files/3703498/AppleMCEReporterDisabler.kext.zip)|Useful starting with Catalina to disable the AppleMCEReporter kext which will cause kernel panics on AMD CPUs and dual-socket systems.
[XLNCUSBFix.kext](https://cdn.discordapp.com/attachments/566705665616117760/566728101292408877/XLNCUSBFix.kext.zip)|Fixes USB in AMD FX Processors.

#### Intel-specific Kexts
Kext|Description
:----|:----
|SMCProcessor.kext|For temperature monitoring for Intel CPUs (Pennryn and newer). Included in [VirtualSMC](https://github.com/acidanthera/VirtualSMC)
|SMCSuperIO.kext|For Fan Speed Monitoring. Included in [VirtualSMC](https://github.com/acidanthera/VirtualSMC)

## Generate EFI Folders using OpenCore Auxiliary Tools

### 1. Generate a base EFI Folder for the CPU of your choice
- Run OCAuxiliaryTools (OCAT)
- Open the **Database**
- Double-click on a config of your choice
- An EFI Folder will be generated and placed on your Desktop including SSDTs, Kexts, Drivers, Themes and the `config.plist`.

### 2. Modifying the `config.plist` 
After the base EFI has been generated, the `config.plist` *maybe* has to be modified based on the used CPU, GPU, additional hardware, peripherals and SMBIOS.

- Go to the Desktop
- Open the `config.plist` included in `\EFI\OC\` with **OCAT**
- Check the following Settings:
	- **ACPI > Add**: add additional ACPI Tabels if your hardware configuration requires them. 2nd to 3rd Gen Intel Core CPUs require `SSDT-PM` (create in Post-Install)
	- **DeviceProperties**:
		- Check if the correct Framebuffer Patch is enabled in `PciRoot(0x0)/Pci(0x2,0x0)` (Configs for Intel Core CPUs usually contain two, one enabled)
		- Add additional PCI paths (if required for your hardware)
	- **Kernel > Add**: Add additional kexts rquired for your hardware and features (a base-set required for the selected system is already included)
	-  **Kernel > Patch**: AMD-only. See chapter "AMD: adjusting CPU Core Count" 
	- **PlatformInfo > Generic**: Generate `SMBIOS` Data for the selected Mac model
	- **NVRAM > Add > 7C436110-AB2A-4BBB-A880-FE41995C9F82**: add additional boot-args if your hardware requires them (see next section)
- Save and deploy the EFI folder (put it on a FAT32 formatted USB flash drive and try booting from it)

### Additional `boot-args`
Depending on the combination of CPU, GPU (iGPU and/or dGPU) and SMBIOS, additional `boot-args` may be required. These are not included in the configs and need to be added manually before deploying the EFI folder!

#### GPU-Specific `boot-args`
Parameter|Description
:----|:----
**agdpmod=pikera**|Disables Board-ID checks on Navi GPUs (**RX 5000 Series**). Without it, you'll get a black screen. **Don't use if you don't have a Navi GPU** (ie. Polaris or Vega).
**nvda_drv_vrl=1**|For enabling Nvidia Web Drivers on Maxwell and Pascal cards in Sierra and High Sierra.

#### General purpose `boot-args`
Parameter|Description
:----|:----
**npci=0x2000** or **npci=0x3000**| Disables PCI debugging related to `kIOPCIConfiguratorPFM64`. Alternatively, use `npci=0x3000` which also disables debugging of `gIOPCITunnelledKey`.<br>Required when getting stuck at `PCI Start Configuration` as there are IRQ conflicts related to your PCI lanes. **Not needed if `Above4GDecoding` can be enabled in BIOS**

#### AMD-specific settings: adjusting CPU Core Count 
- In config.plist, search for `algrey - Force cpuid_cores_per_package` 
- There should be 3 Patches with the same name (for various versions of macOS)
- In the `Replace` field, find:
	- B8 **00** 0000 0000 (for macOS 10.13, 10.14)
	- B8 **00** 0000 0000 (for macOS 10.15, 11)
	- BA **00** 0000 0090 (for macOS 12)
	- Replace the **3rd** and **4th** digit with the correct Hex value from the table below:

		|Core Count |Hex Value|
		|:--------:|:-------:|
		| 4 Cores  | `04` |
		| 6 Cores  | `06` |
		| 8 Cores  | `08` |
		| 12 Cores | `0C` |
		| 16 Cores | `10` |
		| 24 Cores | `18` |
		| 32 Cores | `20` |
	- Example: for a 6-Core AMD Ryzen 5600X, the resulting `Replace` value for the 3 patches would be:
		- B8 **06** 0000 0000 (for macOS 10.13, 10.14)
		- BA **06** 0000 0000 (for macOS 10.15, 11)
		- BA **06** 0000 0090 (for macOS 12)

### Intel-specific settings: Fixing CPU Power Management on Sandy and Ivy Bridge CPUs
2nd and 3rd Gen Intel CPUs use a different method for CPU Power Management. Use [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) to generate a `SSDT-PM.aml` in Post-Install, add it to your `EFI\OC\ACPI` folder and config to get proper CPU Power Management.

You can follow this [**guide**]( https://dortania.github.io/OpenCore-Post-Install/universal/pm.html#sandy-and-ivy-bridge-power-management) to do so.

**NOTES**:

- Open the config.plist in a Plist Editor to find additional info
- View Device Properties to check the included Framebuffer-Patches. Usually, 2 versions are included: one for using the iGPU for driving a Display and a 2nd one for using the iGPU for computational tasks only.
- Depending on your hardware configuration (CPU, Mainboard, Peripherals) you may have to add additional SSDT Hotpatches, boot-args, DeviceProperties and/or Kexts – check before deployment!
- Reference Dortania's OpenCore Install Guide for your CPU family if you are uncertain about certain settings

## Included Configs

### AMD
- **AMD Ryzen and Threadripper**
	- AMD_Ryzen_iMac14,2_Kepler+
	- AMD_Ryzen_iMacPro1,1_RX_Polaris
	- AMD_Ryzen_MacPro6,1_R5/R7R9
	- AMD_Ryzen_MacPro7,1_RX_Polaris
	- AMD_Threadripper_iMac14,2_Kepler+_A520+B550
	- AMD_Threadripper_iMac14,2_Kepler+
	- AMD_Threadripper_iMacPro1,1_RX_Polaris_A520+B550
	- AMD_Threadripper_iMacPro1,1_RX_Polaris
	- AMD_Threadripper_MacPro6,1_R5/R7/R9_A520+B550
	- AMD_Threadripper_MacPro6,1_R5/R7/R9
	- AMD_Threadripper_MacPro7,1_RX_Polaris
 	- AMD_Threadripper_MacPro7,1_RX_Polaris_A520+B550
- **AMD Bulldozer and A-Series**
	- AMD_Bulldozer+Jaguar_iMacPro1,1_Polaris
	- AMD_Bulldozer+Jaguar_MacPro6,1_R5R7R9
	- AMD_Bulldozer+Jaguar_MacPro7,1_Polaris
	- AMD_Bulldozer+Jaguar_MacPro14,2_Kepler+

### INTEL
#### High End Desktop
- **X299 Cascade Lake X/W**
	- HEDT_X299_Skylake-X/W_Cascade_Lake-X/W_Dell
	- HEDT_X299_Skylake-X/W_Cascade_Lake-X/W_HP
	- HEDT_X299_Skylake-X/W_Cascade_Lake-X/W
- **X99 Haswell-E and Broadwell-E**
	- HEDT_X99_Haswell-E_iMacPro1,1
	- HEDT_X99_Broadwell-E_iMacPro1,1
- **X79 Sandy Bridge-E and Ivy Bridge-E**
	- HEDT_X79_SandyBridge+IvyBridge-E_iMac6,1_Dell
	- HEDT_X79_SandyBridge+IvyBridge-E_iMac6,1_HP
	- HEDT_X79_SandyBridge+IvyBridge-E_iMac6,1
- **X59 Nehalem and Westmere**
	- HEDT_X59_Nehalem+Westmere_MacPro5,1_Dell
	- HEDT_X59_Nehalem+Westmere_MacPro5,1_HP
	- HEDT_X59_Nehalem+Westmere_MacPro5,1
	- HEDT_X59_Nehalem+Westmere_MacPro6,1_Dell
	- HEDT_X59_Nehalem+Westmere_MacPro6,1_HP
	- HEDT_X59_Nehalem+Westmere_MacPro6,1

#### Intel Core i5/i7/i9
- **11th Gen Rocket Lake**
 	- Desktop_11thGen_Rocket_Lake_iMacPro1,1
 	- Desktop_11thGen_Rocket_Lake_MacPro7,1
- **10th Gen Comet Lake**
	- Desktop_10thGen_Comet_Lake_iMac20,1
	- Desktop_10thGen_Comet_Lake_iMac20,2
- **8th and 9th Gen Coffee Lake**
	- Desktop_8th-9thGen_Coffee_Lake_iMac18,1
	- Desktop_8th-9thGen_Coffee_Lake_iMac18,3
	- Desktop_8th-9thGen_Coffee_Lake_iMac19,1
	- Desktop_8th-9thGen_Coffee_Lake_iMac19,1_Z390
	- Desktop_8th-9thGen_Coffee_Lake_iMac19,2
	- Desktop_8th-9thGen_Coffee_Lake_iMac19,2_Z390
- **7th Gen Kaby Lake**
	- Desktop_7thGen_Kaby_Lake_iMac18,1
	- Desktop_7thGen_Kaby_Lake_iMac18,3 
- **6th Gen Skylake**
	- Desktop_6thGen_Skylake_iMac17,1 
- **5th Gen Broadwell**
	- Desktop_5thGen_Broadwell_iMac16,2
	- Desktop_5thGen_Broadwell_iMac17,1
- **4th Gen Broadwell**
	- Desktop_4thGen_Haswell_iMac14,4
	- Desktop_4thGen_Haswell_iMac15,1 
- **3rd Gen Ivy Bridge**
	- Desktop_3rdGen_Ivy_Bridge_iMac13,1
	- Desktop_3rdGen_Ivy_Bridge_iMac13,2
	- Desktop_3rdGen_Ivy_Bridge_iMac14,4
	- Desktop_3rdGen_Ivy_Bridge_iMac15,1
	- Desktop_3rdGen_Ivy_Bridge_MacPro6,1 
- **2nd Gen Sandy Bridge**
	- Desktop_2ndGen_Sandy_Bridge_iMac12,2
	- Desktop_2ndGen_Sandy_Bridge_MacPro6,1
- **1st Gen Lynnfield and Clarkdale**:
	- Desktop_1stGen_Clarkdale_iMac11,2
	- Desktop_1stGen_Lynnfield_iMac11,1
	- Desktop_1stGen_Lynnfield_Clarkdale_MacPro6,1

## Manual Update
Althogh these configs are included in OCAT now, they are maintained and updated by me, so the latest versions will always be present in my [**repo**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/F_Desktop_EFIs).

To manually update the config plists, do the following:

- Download [**_BaseConfigs.zip**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/F_Desktop_EFIs/_BaseConfigs.zip?raw=true) and extract it
- Copy the Files to the Database Folder inside of the **OCAuxiliaryTools** App:
	- right-click the app and select "Show package contents"
	- browse to `/Contents/MacOS/Database/BaseConfigs/`
	- paste the files
	- restart OCAT

## References
- **OpenCore Auxiliary Tools**: https://github.com/ic005k/QtOpenCoreConfig
- **Base Configs**: https://github.com/luchina-gabriel?tab=repositories
- **OpenCore Install Guide**: https://dortania.github.io/OpenCore-Install-Guide
- **OpenCore Bootloader**: https://github.com/acidanthera/OpenCorePkg
