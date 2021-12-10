# Pre-configured OpenCore Desktop EFI Folders (Intel only)
## About
This section includes OpenCore configs based on the work of **Gabriel Luchina** who took a lot of time and effort to create EFI folders with configs for each CPU Family listed in Dortania's OpenCore install Guide. I took his base configs and modified them so they work out of the box (hopefully).

**No AMD?** Since setting-up AMD systems depends a lot on the used combination of CPU and mainboard a lot of customization around MMIO are neccessary. So based on this [discussion](https://github.com/ic005k/QtOpenCoreConfig/issues/88), I decided to remove AMD templates from the equation, since generating a working EFI based on generic templates seems unrealistic as of now.

## New approach: generating EFIs from `config.plist`
Instead of downloading pre-configured and possibly outdated OpenCore EFI folders from the net or github, you can use OpenCore Auxiliary Tools (OCAT) to generate the whole EFI folder based on the config included in the App's database. This way, you always have the latest version of OpenCore, the config, kexts and drivers.

Included are about 60 configs for AMD and Intels CPUs, covering a wide range of supported Desktop CPUs, vendors and chipsets.

### Included Files and Settings
- Base configs for Intel Desktop and High End Desktop CPUs with variations for Dell, Sony, HP and other Board/Chipsets
- Required SSDT Hotpatches for each CPU family (some are disabled – check before deployment!)
- Neccessary Quirks for each CPU Family
- Necessary Device Properties for each platform (mostly Framebuffer Patches for: iGPU only, iGPU+dGPU and GPU only)
- Base-set of Kexts (see chart below)
- `MinDate` and `MinVersion` for the APFS Driver set to `-1`, so all macOS versions are supported.

#### Mandatory Kexts (universal)
Kext|Description
:----|:----
[Lilu.kext](https://github.com/acidanthera/Lilu/releases)|Patch engine required for AppleALC, WhateverGreen, VirtualSMC and many other kexts.
[VirtualSMC.kext](https://github.com/acidanthera/VirtualSMC/releases)|Emulates the System Management Controller (SMC) found on real Macs. Without it macOS won't boot boot.
[WhateverGreen.kext](https://github.com/acidanthera/WhateverGreen/releases)|Used for graphics patching, DRM fixes, board ID checks, framebuffer fixes, etc; all GPUs benefit from this kext.
|[AppleALC](https://github.com/acidanthera/AppleALC/releases)|Kext for enabling native macOS HD audio for unsupported Audio CODECs without filesystem modifications.

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

### Intel-specific settings: Fixing CPU Power Management on Sandy and Ivy Bridge CPUs
2nd and 3rd Gen Intel CPUs use a different method for CPU Power Management. Use [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) to generate a `SSDT-PM.aml` in Post-Install, add it to your `EFI\OC\ACPI` folder and config to get proper CPU Power Management.

You can follow this [**guide**]( https://dortania.github.io/OpenCore-Post-Install/universal/pm.html#sandy-and-ivy-bridge-power-management) to do so.

**NOTES**:

- Open the config.plist in a Plist Editor to find additional info
- View Device Properties to check the included Framebuffer-Patches. Usually, 2 versions are included: one for using the iGPU for driving a Display and a 2nd one for using the iGPU for computational tasks only.
- Depending on your hardware configuration (CPU, Mainboard, Peripherals) you may have to add additional SSDT Hotpatches, boot-args, DeviceProperties and/or Kexts – check before deployment!
- Reference Dortania's OpenCore Install Guide for your CPU family if you are uncertain about certain settings
- For enabling Linux support, you can follow this [guide](https://github.com/5T33Z0/OC-Little-Translated/tree/main/G_Linux).

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
