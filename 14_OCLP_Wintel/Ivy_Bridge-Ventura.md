# Installing macOS Ventura on Ivy Bridge systems

**TABLE of CONTENTS**

- [Before you begin](#before-you-begin)
- [Preparations](#preparations)
	- [Adjusting the SMBIOS](#adjusting-the-smbios)
		- [When Upgrading from macOS Big Sur 11.3+](#when-upgrading-from-macos-big-sur-113)
		- [When Upgrading from macOS Catalina or older](#when-upgrading-from-macos-catalina-or-older)
- [macOS Ventura Installation](#macos-ventura-installation)
	- [Getting macOS](#getting-macos)
	- [Option 1: Upgrading from macOS 11.3 or newer](#option-1-upgrading-from-macos-113-or-newer)
	- [Option 2: Upgrading from macOS Catalina or older](#option-2-upgrading-from-macos-catalina-or-older)
- [Post-Install](#post-install)
	- [Installing Intel HD4000 Drivers](#installing-intel-hd4000-drivers)
	- [Installing Drivers for other GPUs](#installing-drivers-for-other-gpus)
	- [Verifying SMC CPU Power Management](#verifying-smc-cpu-power-management)
		- [Optimizing CPU Power Management](#optimizing-cpu-power-management)
	- [Removing/Disabling boot-args](#removingdisabling-boot-args)
- [OCLP and System Updates](#oclp-and-system-updates)
- [Notes](#notes)
- [Credits](#credits)

Although installing macOS Ventura on Ivy Bridge (and older) systems can be achieved with OpenCore and the OpenCore Legacy Patcher (OCLP), it's not officially supported nor documented for Wintel systems – only for legacy Macs by Apple. So there is no official guide on how to do it. The guide below is based on my experiences trying to get macOS 13 running on a Lenovo ThinkPad T530.

This guide allows you to: 
- Install or upgrade to macOS Ventura
- Re-Instal iGPU/GPU drivers in Post so Hardware Acceleration is working
- Use a native SMBIOS for Ivy Bridge CPUs (no more spoofing)
- Re-enabler SMC CPU Power Management and have proper CPU Power Management using `SSDT-PM`
- Allows installing of OTA updates which wouldn't be possible otherwise since the "Unrestricted Root" flag in SIP disables System Update Notifications.

> **Warning**
This guide is not for beginners! There are a lot of things to consider when trying to get newer versions of macOS working on unsupported hardware. DON'T upgrade from an existing working version of macOS. You won't be able to downgrade if something goes wrong. Perform a clean install on a spare internal disk or create a new volume on your current one. 

## Before you begin
- Make sure to have a backup of your working EFI folder stored on a FAT32 formatted USB Flash Drive to boot from – just in case something goes wrong.
- Before you start modifying your config and EFI, make sure to check if any peripherals you are using are still compatible with macOS Ventura (Wifi and BlueTooth come to mind).
- When using Broadcom Wifi/Bluetooth Cards, you will need different [combinations of kexts](https://github.com/5T33Z0/OC-Little-Translated/tree/main/10_Kexts_Loading_Sequence_Examples#example-7-broadcom-wifi-and-bluetooth) which need to be controlled via `MinKernel` and `MaxKernel` settings
- Same might be true for Intel Wireless Cards
- Check if your GPU is compatible with macOS Ventura. Drivers for Intel iGPU and GPU drivers for NVIDIA Kepler and AMD cards can be re-installed in Post using OpenCore Legacy Patcher ([supported cards](https://dortania.github.io/OpenCore-Legacy-Patcher/PATCHEXPLAIN.html#on-disk-patches))

## Preparations
I assume you already have a working OpenCore configuration for your Ivy Bridge system. Otherwise follow Dortania's [OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/prerequisites.html) to create one. The instructions below are only additional steps required to install and boot macOS Ventura. 

1. Update OpenCore to 0.9.2 or newer &rarr; Mandatory. Prior to OC 0.9.2, the required `AppleCpuPmCfgLock` Quirk is [skipped when macOS Ventura is running](https://github.com/acidanthera/OpenCorePkg/commit/77d02b36fa70c65c40ca2c3c2d81001cc216dc7c) so the system won't boot unless you have a BIOS where CFG Lock can be disabled.
2. `ACPI/Add`: Disable `SSDT-PLUG` or `SSDT-XCPM` if present
3. `Booter/Patch` Section (in your config.plist):
	- Add and enable both Booter Patches from OpenCore Legacy Patcher's [Board-ID VMM spoof](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof)
4. `Kernel/Add` Section and `EFI/OC/Kexts`:
	- Add [CryptexFixup](https://github.com/acidanthera/CryptexFixup) &rarr; Required for booting macOS Ventura (set `MinKernel` to `22.0.0`).
	- Add [RestrictEvents](https://github.com/acidanthera/RestrictEvents) &rarr; Forces VMM SB model, allowing OTA updates for unsupported models on macOS 11.3 or newer. Requires additional boot-arg/NVRAM parameter (Step 7).
	- Add [Kexts from OCLP](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Misc):
		- `AppleIntelCPUPowerManagement.kext` (set `MinKernel` to `22.0.0`)
		- `AppleIntelCPUPowerManagementClient.kext` (set `MinKernel` to `22.0.0`)
5. `Kernel/Patch` Section: 
	- Disable `_xcpm_bootstrap` (if present)
	- Add and enable the following Kernel Patches from the [Board-ID VMM spoof](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof):
		- **"Disable Library Validation Enforcement"** 
		- **"Disable _csr_check() in _vnode_check_signature"** 
6. `Kernel/Quirks` Section:
	- Enable `AppleCpuPmCfgLock` if it isn't already. Unnecessary if you can disable CFG Lock in BIOS.
	- Disable `AppleXcmpCfgLock` 
	- Disable `AppleXcpmExtraMsrs`
7. `Misc/Security`: 
	- Set `SecureBootModel` to `Disabled` (required when using root patches to re-install missing drivers, especially for NVIDIA GPUs)
8. `NVRAM/Add` Section: Add the following boot-args (or corresponding NVRAM parameters):
	- `revpatch=sbvmm,f16c` &rarr; for enabling OTA updates and addressing graphics issues in macOS 13
	- `ipc_control_port_options=0` 
	- `amfi_get_out_of_my_way=0x1` &rarr; Required for booting macOS 13 and applying Root Patches with OpenCore Legacy Patcher. Can cause issues with [granting 3rd party apps access to Mic/Camera](https://github.com/5T33Z0/OC-Little-Translated/blob/main/13_Peripherals/Fixing_Webcams.md)
	- `-amd_no_dgpu_accel` &rarr; **AMD GPUs only**. This option will be used temporarily so we can install root patches for GPU, afterwards it must be removed to get working hardware acceleration.
	- `nv_disable=1` &rarr; **NVIDIA GPUs only**. Disables hardware acceleration and puts the card in VESA mode so you have a picture and not a black screen. Once you've installed the GPU drivers in post, **delete the boot-arg**!
9. Change `csr-active-config` to `03080000` &rarr; Required for booting a system with patched-in drivers
10. Save and reboot

> **Note**: After OCLP's root patches are applied in Post-Install, you can remove `ipc_control_port_options=0` and `amfi_get_out_of_my_way=0x1` from boot-args if kernel patches **"Disable Library Validation Enforcement"** and **"Disable _csr_check() in _vnode_check_signature"** are enabled. This solves issues caused by disabling AMFI.

### Adjusting the SMBIOS
If your system reboots successfully, we need to edit the config one more time and adjust the SMBIOS depending on the macOS Version *currently* installed.

#### When Upgrading from macOS Big Sur 11.3+
When upgrading from macOS 11.3 or newer, we can use macOSes virtualization capabilities to trick it into thinking that it is running in a VM so spoofing a compatible SMBIOS is no longer a requirement.

Based on your system, use one of the following SMBIOSes for Ivy Bridge CPUs. Open your config.plist and change the SMBIOS in the `PlatformInfo/Generic` section.

- For Desktops: 
	- **iMac13,1** (Core i5), **iMac13,2** (Core i5) or **iMac13,3** (Core i3)
- For Laptops:
	- **MacBookPro10,1** (Core i7), **MacBookPro10,2** (Core i5) or
	- **MacBookPro9,1** (Core i7), **MacBookPro9,2** (Core i5)
- For NUCs:
	- **Macmini6,1** (Core i5), **Macmini6,2** (Core i7)
- Generate new Serials using [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS)
 	
#### When Upgrading from macOS Catalina or older
When upgrading from macOS Catalina or older, the Booter Patches don't work so changing to an SMBIOS supported by macOS Ventura temporarily is necessary in order to be able to install macOS Ventura – otherwise you will be greeted by the crossed-out circle instead of the Apple logo when trying to boot. 

Supported SMBIOSes:

- For Desktops: 
	- **iMac18,1** or newer
	- **MacPro7,1** (High End Desktops)
- For Laptops: **MacBookPro14,1** or **MacBookAir8,1**
- For NUCs: **Macmini8,1**
- Generate new Serials using [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS)

> **Note**: Once macOS Ventura is up and running, the VMM Board-ID spoof will work, so revert to an SMBIOS best suited for your Ivy Bridge CPU and reboot to enjoy all the benefits of a proper SMBIOS. You may want to generate a new [SSDT-PM](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(Legacy)) to optimize CPU Power Management.

## macOS Ventura Installation
With all the prep work out of the way you can now upgrade to macOS Ventura. Depending on the version of macOS you are coming from, the installation process differs.

### Getting macOS
- Download the latest release of [OpenCore Patcher GUI App](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) and run it
- Click on "Create macOS Installer"
- Click on "Download macOS Installer"
- Select macOS 13.x (whatever the latest available version is)  
- Once the download is finished the "Install macOS Ventura" app will be located in your "Programs" folder

> **Note**: OCLP can also create a USB Installer if you want to perform a clean install (highly recommended)

### Option 1: Upgrading from macOS 11.3 or newer 

Only applicable when upgrading from macOS 11.3+. If you are on macOS Catalina or older, use Option 2 instead.

- Run the "Install macOS Ventura" App
- There will be a few reboots
- Boot from the new macOS Partition until it's no longer present in the Boot Picker

Once the installation has finished and the system boots it will run without graphics acceleration if you only have an iGPU or if you GPU is not supported by macOS. We will address this in Post-Install.

### Option 2: Upgrading from macOS Catalina or older
When upgrading from macOS Catalina or older a clean install from USB flash drive is recommended To create a USB Installer, you can use OpenCore Legacy Patcher:

- Run Disk utility
- Create a new APFS Volume on your internal HDD/SSD or use a separate internal disk (at least 60 GB in size) for installing macOS 13 – DON'T install it on an external drive – it won't boot!
- Attach an empty USB flash drive for creating the installer (16 GB+)
- Run OCLP and follow the [**instructions**](https://dortania.github.io/OpenCore-Legacy-Patcher/INSTALLER.html#creating-the-installer)
- Once the USB Installer has been created, do the following:
	- Copy the OpenCore-Patcher App to the USB Installer
	- Add Optional tools (in case internet is not working): 
		- Add MountEFI
		- Add ProperTree
		- Add Python Installer
- Reboot 
- Select "Install macOS Ventura" from the BootPicker
- Install macOS Ventura on the volume you prepared earlier 
- There will be a few reboots during installation. Boot from the new "Install macOS" Partition until it's no longer present in the Boot Picker
- Once the macOS Ventura installation is finished, switch back to an SMBIOS best suited for your Ivy Bridge CPU mentioned earlier.

After the installation is completed and the system boots it will run without hardware graphics acceleration if you only have an iGPU or if you GPU is no longer supported by macOS. We will address this in Post-Install. 

## Post-Install
OpenCore Legacy patcher can re-install components which were from macOS, such as Graphics Drivers, Frameworks, etc. This is called "root patching". For Wintel systems We will make use of it to install iGPU and GPU drivers primarily.

### Installing Intel HD4000 Drivers
Once you reach the set-up assistant (where you select your language, time zone, etc), you will notice that the system feels super sluggish – that's normal because it is running in VESA mode without graphics acceleration, since the friendly guys at Apple removed the Intel HD 4000 drivers. 

To bring them back, do the following:

- Run the OpenCore Patcher App 
- In the OpenCore Legacy Patcher menu, select "Post Install Root Patch":</br>![menu](https://user-images.githubusercontent.com/76865553/181920348-21a3abad-311f-49c6-b4d9-25e6560b6150.png)
- Next, click on "Start Root Patching":</br>![menu2](https://user-images.githubusercontent.com/76865553/181920368-bdfff312-6390-40a5-9af8-8331569fbe17.png)
- The App has to relaunch with Admin Roots. Click Yes:</br>![yes](https://user-images.githubusercontent.com/76865553/181920381-2b6a4194-60c3-472e-81bb-c5478e3298f9.png)
- You will have to enter your Admin Password and then the installation will begin:</br>![Install](https://user-images.githubusercontent.com/76865553/181920398-38ddf7c5-0dfd-428e-9d7a-5646010d3c08.png)
- Once. it's done, you have to reboot and Graphics acceleration will work
- Continue with the Post-Install process as described in the Repo.

### Installing Drivers for other GPUs
- Works the same way as installing iGPU drivers
- OCLP detects GPUs and if it has drivers or a non-AVX2 patch for them, they can be installed. Afterwards, GPU Hardware Acceleration should work.
- After the drivers have been installed and before rebooting, do the following:
  - AMD GPUs: disable `-amd_no_dgpu_accel`  to get hardware acceleration (put a `#` in front of it: `#-amd_no_dgpu_accel`)
  - NVIDIA GPUs: Disable `nv_disable=1` to get hardware acceleration (put a `#` in front of it: `#-amd_no_dgpu_accel`)

> **Note**: Prior to installing macOS updates you probably have to re-enable boot-args for AMD and NVIDIA GPUs again to put them into VESA mode so you have a picture and not a black screen!

### Verifying SMC CPU Power Management
To verify that SMC CPU Power Management is working, enter the following command in Terminal:

```shell
sysctl machdep.xcpm.mode
```
If the output is `0`, the legacy `ACPI_SMC_PlatformPlugin` is used for CPU Power Management and everything is ok. If the output is `1`, the `X86PlatformPlugin` for `XCPM` is used, which is not good since XCPM doesn't work well on Ivy Bridge CPUs in macOS. In this case, check if the necessary kexts for SMC CPU Power Management were injected by OpenCore. Enter in Terminal:

```shell
kextstat | grep -v com.apple
```
The output should include:

```
com.apple.driver.AppleIntelCPUPowerManagement (222.0.0)
com.apple.driver.AppleIntelCPUPowerManagementClient (222.0.0) 
```
If the 2 kexts are not present. They were not injected. So check your config and EFI folder again. Also ensure that the `AppleCpuPmCfgLock` Quirk is enabled.

#### Optimizing CPU Power Management
Once you've verified that SMC CPU Power Management (plugin-type `0`) is working, monitor the behavior of the CPU using Intel Power Gadget. If it doesn't reach its maximum turbo frequency or if the base frequency is too high/low or if the idle frequency is too high, [generate an `SSDT-PM`](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(Legacy)#readme) to optimize CPU Power Management.

### Removing/Disabling boot-args
After macOS Ventura is installed and OCLP's root patches have been applied in Post-Install, remove or disable the following boot-args:

- `ipc_control_port_options=0`: ONLY when using a dedicated GPU. You still need it when using the Intel HD 4000 so Firefox and electron-based apps work.
- `amfi_get_out_of_my_way=0x1`: ONLY when using a dedicated GPU. If your system won't boot afterwards, re-enable it.
- Change `-amd_no_dgpu_accel` to `#-amd_no_dgpu_accel` &rarr; This disables the boot-arg. Disabling this boot-arg is a MUST when using AMD GPUs, since it disables the GPU's hardware acceleration if active.
- Change `nv_disable=1` to `#nv_disable=1` &rarr; This disables the boot-arg. Disabling this boot-arg is a MUST when using NVIDIA GPUs, since it disables the GPU's hardware acceleration if active.

> **Note**: Keep a backup of your currently working EFI folder on a FAT32 USB flash drive just in case your system won't boot after removing/disabling these boot-args!

## OCLP and System Updates
The major advantage of using OCLP over the previously used Chris1111s HD4000 Patcher is that it remains on the system even after installing System Updates. After an update, it detects that the graphics drivers are missing and asks you, if you want to to patch them in again:</br>![Notify](https://user-images.githubusercontent.com/76865553/181934588-82703d56-1ffc-471c-ba26-e3f59bb8dec6.png)

You just click on "Okay" and the drivers will be re-installed. After the obligatory reboot, everything will be back to normal.

## Notes
- Installing drivers on the system partition breaks its security seal. This affects System Updates: every time a System Update is available, the FULL Installer (about 12 GB) will be downloaded.
- After each System Update, the iGPU drivers have to be re-installed. OCLP will take care of this.
- ⚠️ You cannot install macOS Security Response Updates (RSR) on pre-Haswell systems. They will fail to install (more info [**here**](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/1019)). 

## Credits
- Acidanthera for OpenCore, OCLP and numerous Kexts
- Corpnewt for MountEFI, GenSMBIOS and ProperTree
- Dortania for OpenCore Legacy Patcher and Guide
