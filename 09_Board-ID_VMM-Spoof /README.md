# Using unsupported Board-IDs with macOS Monterey
A set of Booter and Kernel patches which allow installing, booting and updatimg macOS Monterey on unsupported Board-IDs.

## System requirements
**Minimum macOS requirement**: Big Sur using XNU Kernel 20.4.0 or newer!

## How it works
The latest version of [**OpenCore Legacy Patcher**](https://github.com/dortania/OpenCore-Legacy-Patcher) (OCLP) introduced a new set of booter and kernel patches which make use of macOS Monterey's virtualization capabilities (VMM) to spoof a supported Board-ID reported to Software Update.

These patches skip the Board ID check of the used hardware, redirecing it to OpenCore which then spoofs a supported Board ID via VMM to the Update Servers via Kernel patches. 

This allows using the correct SMBIOS for a given CPU family even if it is not officially supported by macOS Monterey. This not only improves CPU Powermanagement - especially on Laptops – it also allows installing, booting and updating macOS Monterey with otherwise unsupported hardware:

> Parrotgeek1's VMM patch set would force kern.hv_vmm_present to always return True. With hv_vmm_present returning True, both OSInstallerSetupInternal and SoftwareUpdateCore will set the VMM-x86_64 board ID while the rest of the OS will continue with the original ID.
> 
- Patching kern.hv_vmm_present over manually setting the VMM CPUID allows for native features such as CPU and GPU power management

> **Source**: https://github.com/dortania/OpenCore-Legacy-Patcher/issues/543

The patching consists of two stages:

1. Skipping the Board-ID check and rerouting the Hardware Board-ID to OpenCore (Booter Patches)
2. In the 2nd stage, Kernel patches are used to make Update Servers believe that macOS Monterey is running as a Virtual Machine with a supported Board-ID

I had a look at the [**config.plist**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/4a8f61a01da72b38a4b2250386cc4b497a31a839/payloads/Config/config.plist) included in OCLP, copied the relevant patches Booter and Kernel patches (and a few others) into my config and tested them.

The attached plist contains these patches to make this work and a few more.

## Applying the Patches
Before you do the following make sure you have a working backup of your EFI stored on a FAT32 formatted USB stick to boot your PC from just in case something goes wrong!

- Download the attached .plist
- Open it with a plist editor
- Copy the patches located under Booter > Patch into clipboard and paste them into your OpenCore config at the same location
- Do the same for the Kernel Patches. Enable additional patches if requires (for Sandy Brige for example)
- Save config 
- Reboot.

Enjoy macOS Monterey with the correct SMBIOS for your CPU and Updates!

### About the Kernel Patches
In the .plist, only 3 of the 9 kernel patches are enabled by default. Enable additional one as needed. Here's what they do:

- **Patches 0-2**: Enable board ID spoof via VMM in macOS 12.0.1 (active) >> Allows booting, installing and updating macOS 12.x with unsupported Board-ID and SMBIOS
- **Patch 3:** seems to be related to Apple's SMC Controller in real Macs (disabled)
- **Patch 4**: disables [Library Validation Enforcement](https://www.naut.ca/blog/2020/11/13/forbidden-commands-to-liberate-macos/). (disabled)
- **Patches 5-6**:[ SurPlus fixes](https://github.com/reenigneorcim/SurPlus) for Race Condition Fix on Sandy Bridge and older CPUs. Fixes issues for macOS 11.3 onward, where newer Big Sur builds often wouldn't boot with SMBIUIS MacPro5,1. (disabled)
- **Patches 7-8**: Experimental [RDRAND Patches](https://github.com/dortania/OpenCore-Legacy-Patcher/commit/c6b3aaaeb78d56f98a94d7991fd3019190b48dd3) to re-enable Sandy Bridge CPU support in Monterey 12.1 beta (disabled)

<details>
<summary><strong>Background Info: My test</strong> (Click to show content!)</summary>

## Testing the Patches

I tested the patches on my Lenovo T530 Notebook, which uses and Ivy Bridge CPU with `MacBookPro10,1` SMBIOS, which is officialy not supported by macOS Monterey. After rebooting, the system started without `-no_compat_check` boot-arg using, as you can see here:

![](/Users/kl45u5/Desktop/BoardIDSkip/Proof01.png)

Terminal shows the currnetly used Board-ID which belongs to SMBIOS of `MacBookPro10,1` as you can see in Clover Configurator. Usually, running macOS would require using MacBookPro11,4 which uses a different Board-ID as you can see in the Clover Configuratos snippet:

![](/Users/kl45u5/Desktop/BoardIDSkip/Proof02.png)

Next, I checked for updates – I was offered macOS 12.1 beta:

![](/Users/kl45u5/Desktop/BoardIDSkip/Proof03.png)

Which I installed…

![](/Users/kl45u5/Desktop/BoardIDSkip/Proof04.png)

Installation went smoothly and macOS 12.1 booted without issues:

![](/Users/kl45u5/Desktop/BoardIDSkip/About.png)
</details>



