# F\_Desktop\_EFIs

[![OpenCore Version](https://img.shields.io/badge/Supported\_OpenCore\_Version-0.8.0+-success.svg)](https://github.com/acidanthera/OpenCorePkg)

## Pre-configured OpenCore Desktop Configs

### About

This section includes OpenCore configs for Intel CPUs based on the work of **Gabriel Luchina** who took a lot of time and effort to create EFI folders with configs for each CPU Family listed in Dortania's OpenCore install Guide. I took his base configs and modified them so they work out of the box (hopefully).

**No AMD?** Since setting-up an AMD systems requires a lot of custom entries in the MMIO Whitelist section, working with generic, pre-made config.plists is hit or miss. Based on this [**discussion**](https://github.com/ic005k/QtOpenCoreConfig/issues/88), I decided to remove AMD templates from the database. Fabiosun took care of the AMD templates since he has more experience in this field then me.

### New approach: generating EFIs from `config.plist`

Instead of downloading pre-configured and possibly outdated OpenCore EFI folders from the net or github, you can use OpenCore Auxiliary Tools ([**OCAT**](https://github.com/ic005k/OCAuxiliaryTools#readme)) to generate the whole EFI folder based on the config included in the App's database. This way, you always have the latest version of OpenCore, the config, kexts and drivers.

Included are about 40 configs for Intel CPUs, covering a wide range of supported Desktop CPUs, vendors and chipsets.

#### Included Files and Settings

* **Base configs** for Intel Desktop and High End Desktop CPUs with variations for Dell, Sony, HP and other Board/Chipsets
* **Required SSDT** Hotpatches for each CPU family (some are disabled – check before deployment!)
* **Necessary Quirks** for each CPU Family (also available as Presets inside of OCAT)
* **Device Properties** for each platform (mostly Framebuffer Patches for: iGPU only, iGPU+dGPU and GPU only)
* Base-set of **Kexts** (see chart below)
* `MinDate` and `MinVersion` for the APFS Driver set to `-1`, so all macOS versions are supported.

#### Included Kexts (universal, config-based)

| Kext                                                                        | Description                                                                                                         |
| --------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| [Lilu.kext](https://github.com/acidanthera/Lilu/releases)                   | Patch engine required for AppleALC, WhateverGreen, VirtualSMC and many other kexts.                                 |
| [VirtualSMC.kext](https://github.com/acidanthera/VirtualSMC/releases)       | Emulates the System Management Controller (SMC) found on real Macs. Without it macOS won't boot boot.               |
| [WhateverGreen.kext](https://github.com/acidanthera/WhateverGreen/releases) | Used for graphics patching, DRM fixes, board ID checks, framebuffer fixes, etc; all GPUs benefit from this kext.    |
| [AppleALC](https://github.com/acidanthera/AppleALC/releases)                | Kext for enabling native macOS HD audio for unsupported Audio CODECs without filesystem modifications.              |
| [CpuTscSync.kext](https://github.com/acidanthera/CpuTscSync/releases)       | For syncing TSC on Intel HEDT and Server mainboards. Without it, macOS may run extremely slow or won't boot at all. |

<details>

<summary><strong>Optional Kexts (click to reveal)</strong></summary>

#### Optional Kexts

Listed below, you'll find optional kexts for various features and hardware. Add as needed.

**CPU**

**Audio**

**Ethernet**

**WiFi and Bluetooth**

**Other Kexts**

### Generate EFI Folders using OpenCore Auxiliary Tools

#### 1. Generate a base EFI Folder for the CPU of your choice

* Run OCAuxiliaryTools (OCAT)
* Open the **Database**
* Double-click on a config of your choice
* An EFI Folder will be generated and placed on your Desktop including SSDTs, Kexts, Drivers, Themes and the `config.plist`.

#### 2. Modifying the `config.plist`

After the base EFI has been generated, the `config.plist` _maybe_ has to be modified based on the used CPU, GPU, additional hardware, peripherals and SMBIOS.

* Go to the Desktop
* Open the `config.plist` included in `\EFI\OC\` with **OCAT**
* Check the following Settings:
  * **ACPI > Add**: add additional ACPI Tables if your hardware configuration requires them. 2nd to 3rd Gen Intel Core CPUs require `SSDT-PM` (create in Post-Install)
  * **DeviceProperties**:
    * Check if the correct Framebuffer Patch is enabled in `PciRoot(0x0)/Pci(0x2,0x0)` (Configs for Intel Core CPUs usually contain two, one enabled)
    * Add additional PCI paths (if required for your hardware)
  * **Kernel > Add**: Add additional kexts required for your hardware and features (a base-set required for the selected system is already included)
  * **PlatformInfo > Generic**: Generate `SMBIOS` Data for the selected Mac model
  * **NVRAM > Add > 7C436110-AB2A-4BBB-A880-FE41995C9F82**: add additional boot-args if your hardware requires them (see next section)
* Save and deploy the EFI folder (put it on a FAT32 formatted USB flash drive and try booting from it)

#### 3. Post-Install: fixing CPU Power Management on Sandy and Ivy Bridge CPUs

2nd and 3rd Gen Intel CPUs use a different method for CPU Power Management. Use [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) to generate a `SSDT-PM.aml` in Post-Install, add it to your `EFI\OC\ACPI` folder and config to get proper CPU Power Management.

You can follow this [**guide**](https://dortania.github.io/OpenCore-Post-Install/universal/pm.html#sandy-and-ivy-bridge-power-management) to do so.

### Additional `boot-args`

Depending on the combination of CPU, GPU (iGPU and/or dGPU) and SMBIOS, additional `boot-args` may be required. These are not included in the configs and need to be added manually before deploying the EFI folder!

#### GPU-specific boot-args

#### Debugging

**NOTES**

* Open the config.plist in a Plist Editor to find additional info
* View Device Properties to check the included Framebuffer-Patches. Usually, 2 versions are included: one for using the iGPU for driving a Display and a 2nd one for using the iGPU for computational tasks only.
* Depending on your hardware configuration (CPU, Mainboard, Peripherals) you may have to add additional SSDT Hotpatches, boot-args, DeviceProperties and/or Kexts – check before deployment!
* Reference Dortania's OpenCore Install Guide for your CPU family if you are uncertain about certain settings
* For enabling Linux support, you can follow this [guide](https://github.com/5T33Z0/OC-Little-Translated/tree/main/G\_Linux).

### Manual Update

Althogh these configs are included in OCAT now, they are maintained and updated by me, so the latest versions will always be present in my [**repo**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/F\_Desktop\_EFIs).

To manually update the config plists, do the following:

* Download [**\_BaseConfigs.zip**](\_BaseConfigs.zip) and extract it
* Copy the Files to the Database Folder inside of the **OCAuxiliaryTools** App:
  * right-click the app and select "Show package contents"
  * browse to `/Contents/MacOS/Database/BaseConfigs/`
  * paste the files
  * restart OCAT

### References

* **OpenCore Auxiliary Tools**: https://github.com/ic005k/QtOpenCoreConfig
* **Base Configs**: https://github.com/luchina-gabriel?tab=repositories
* **OpenCore Install Guide**: https://dortania.github.io/OpenCore-Install-Guide
* **OpenCore Bootloader**: https://github.com/acidanthera/OpenCorePkg

</details>
