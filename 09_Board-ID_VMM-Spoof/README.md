# Using unsupported Board-IDs with macOS 11.3 and newer
A set of Booter and Kernel patches lifted from OCLP which allow installing, booting and updating macOS Monterey on otherwise unsupported Board-IDs/CPUs.

## Use Cases
1. Installing, running and updating macOS Monterey on systems with unsupported CPUs and their respective SMBIOS.
2. **Fixing update notifications**. As a side effect, you can use these patches to workaround issues with System Update Notifications in macOS 12, since OC reports a special Board-ID for VMs to Apple Update servers – especially when using a SMBIOS of Mac models with a T2 security chip, such as:

	- MacBookPro15,1 to 15,4
	- MacBookPro16,1 to 16,4
	- MacBookAir8,1/8,2
	- MacBookAir9,1
	- Macmini8,1
	- iMac20,1/20,2
	- iMacPro1,1
	- MacPro7,1

	The problem occurs when using one of the SMBIOSes listed above in combination with `SecureBootModel` set to `Disabled`. If you have to use GeForce Kepler Patcher (compatible up to macOS ≤ 12.4), you *have* to disable `SecureBootModel` in order to boot after you patched in the GPU Drivers in macOS Monterey. Otherwise the system crashes during boot. In this case, these patches are the only workaround to still receive System Updates when using OpenCore.
	
## System Requirements
**Minimum macOS**: Big Sur 11.3 or newer (Darwin Kernel 20.4+)</br>
**CPU**: Basically, every outdated SMBIOS that supports your CPU but is no longer supported by macOS Monterey. This affects processors of the following Intel CPU families (newer ones don't need this since they are still supported):

- Sandy Bridge (need additional SurPlus patches)
- Ivy Bridge
- Haswell (partially)

Since this is a pretty new approach, I have to look into a bit more, but I am successfully using them on my [Lenovo T530 ThinkPad](https://github.com/5T33Z0/Lenovo-T530-Hackinosh-OpenCore). 

## How it works
**OpenCore Legacy Patcher** (OCLP) v0.3.2 introduced a set of new booter and kernel patches which make use of macOS'es virtualization capabilities (VMM) to trick macOS into "thinking" it is running in a Virtual Machine:

> Parrotgeek1's VMM patch set would force `kern.hv_vmm_present` to always return `True`. With hv_vmm_present returning True, both **`OSInstallerSetupInternal`** and **`SoftwareUpdateCore`** will set the **`VMM-x86_64`** board ID while the rest of the OS will continue with the original ID.
>
> - Patching kern.hv_vmm_present over manually setting the VMM CPUID allows for native features such as CPU and GPU power management
>
> **Source**: [OCLP issue 543](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/543)

This is great, because it allows using the "native", designated SMBIOS for a given CPU family, even if it is not officially supported by macOS 12 or newer. This not only improves CPU Power Management - especially on Laptops – it also allows installing, running and updating macOS Montereay and newer on otherwise unsupported hardware.

I had a look at the [**config.plist**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/4a8f61a01da72b38a4b2250386cc4b497a31a839/payloads/Config/config.plist) included in OCLP, copied the relevant patches Booter and Kernel patches (and a few others) into my config and tested them. The attached plist contains the patches.

## Applying the Patches
:warning: Before applying the patches, make sure you have a working backup of your EFI folder stored on a FAT32 formatted USB flash drive to boot your PC from just in case something goes wrong!

- [**Download**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/09_Board-ID_VMM-Spoof/BoardIDSkip+VMMPatch.plist.zip?raw=true) and unzip the attached .plist.
- Open it with a plist Editor (e.g. ProperTree).
- Copy the patches located under Booter/Patch over to your OpenCore config to the same section.
- Do the same for the Kernel Patches. Enable additional patches if required (SurPlus patches for Sandy Bridge for example).
- Optional: add [**FeatureUnlock.kext**](https://github.com/acidanthera/FeatureUnlock) to enable [**Content Caching**](https://support.apple.com/en-ca/guide/mac-help/mchl9388ba1b/mac)
- Save the config.
- Reboot.
- Verify: enter `sysctl kern.hv_vmm_present` in Terminal. If it returns `1` the patch is working.

Enjoy macOS Monterey+ with the correct SMBIOS for your CPU and Updates!

## About the Patches

### Booter Patches
- **Patch 0**: Skips Hardware Board ID Check (enabled)
- **Patch 1**: Reroutes Hardware Board-ID check to OpenCore (enabled)

### Kernel Patches
In the .plist, only 3 of the 6 kernel patches are enabled by default. Enable additional one as needed. Here's what they do:

- **Patch 0**: disables [Library Validation Enforcement](https://www.naut.ca/blog/2020/11/13/forbidden-commands-to-liberate-macos/). (disabled)
- **Patches 1 and 2**: SurPlus patches for Race to condition Fix on Sandy Bridge and older. Fixes issues for macOS 11.3+, where Big Sur often wouldn't boot when using SMBIOS `MacPro5,1` (disabled). These patches are now Included in the `sample.plist` (OC 0.7.7+).
- **Patch 3 to 5**: Enable Board-ID spoof via VMM in macOS 12.0.1+ (enabled) &rarr; Allows booting, installing and updating macOS 12.x with unsupported Board-ID and SMBIOS

**NOTE**: RDRAND Patches for Sandy Bridge CPUs are no longer required since OpenCore 0.7.8 and must be disabled/deleted.

<details>
<summary><strong>Background Info: My test</strong> (Click to show content!)</summary>

## Testing
I tested these patches on my Lenovo T530 Notebook, using an Ivy Bridge CPU with `MacBookPro10,1` SMBIOS, which is officially not compatible with macOS Monterey. After rebooting, the system started without using `-no_compat_check` boot-arg, as you can see here:

![Proof01](https://user-images.githubusercontent.com/76865553/139529766-87daac84-126e-4dfc-ac1d-37e4730e0bbf.png)

Terminal shows the currently used Board-ID which belongs to the `MacBookPro10,1` SMBIOS as you can see in Clover Configurator. Usually, running macOS would require using `MacBookPro11,4` which uses a different Board-ID as you can see in the Clover Configurator snippet:

![Proof02](https://user-images.githubusercontent.com/76865553/139529778-6f82306a-22db-43dd-b594-c863af6e4ddd.png)
  
Next, I checked for updates and was offered macOS 12.1 beta:

![Proof03](https://user-images.githubusercontent.com/76865553/139529788-d8ca770e-f8c2-49a8-a44e-908137f5e45c.png)
  
Which I installed…
  
![Proof04](https://user-images.githubusercontent.com/76865553/139529792-d92e52d3-5f91-4044-b788-730d603327b3.png)

Installation went smoothly and macOS 12.1 booted without issues:

![About](https://user-images.githubusercontent.com/76865553/139529802-3ea61297-7c7b-4369-8c21-4160b437f1a6.png)
</details>

## Notes and Credits
- Dortania for [**OpenCore Legacy Patcher**](https://github.com/dortania/OpenCore-Legacy-Patcher)
- [**VMM Usage Notes**](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/543#issuecomment-953441283)
- parrotgeek1 for [**VMM Patches**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/4a8f61a01da72b38a4b2250386cc4b497a31a839/payloads/Config/config.plist#L1222-L1281)
- reenigneorcim for [**SurPlus**](https://github.com/reenigneorcim/SurPlus)
