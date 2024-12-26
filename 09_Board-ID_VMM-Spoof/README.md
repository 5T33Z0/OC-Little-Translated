# Using unsupported Board-IDs with macOS 11.3 and newer

- [About](#about)
- [System Requirements](#system-requirements)
- [Use Cases](#use-cases)
- [Instructions](#instructions)
- [About the Patches](#about-the-patches)
- [Adding the Patches](#adding-the-patches)
	- [Booter Patches](#booter-patches)
	- [Kernel Patches](#kernel-patches)
- [Notes](#notes)
- [Credits](#credits)

---

## About
**OpenCore Legacy Patcher** (OCLP) 0.3.2 introduced a set of Booter and Kernel patches which utilize macOS'es virtualization capabilities (VMM) to trick it into "believing" that it's running inside a Virtual Machine:

> Parrotgeek1's VMM patch set would force `kern.hv_vmm_present` to always return `True`. With hv_vmm_present returning True, both **`OSInstallerSetupInternal`** and **`SoftwareUpdateCore`** will set the **`VMM-x86_64`** board-id while the rest of the OS will continue with the original ID.
>
> - Patching kern.hv_vmm_present over manually setting the VMM CPUID allows for native features such as CPU and GPU power management

**Source**: [**OCLP issue 543**](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/543)

This allows installing and receiving OTA system updates for macOS 11.3 and newer on otherwise unsupported Board-IDs/CPUs. Although OCLP's primary aim is to install OpenCore and macOS on legacy Macs, these patches can be utilized on Hackintoshes as well while using the "native", designated SMBIOS for a given CPU family which improves CPU and GPU Power Management - especially on Laptops. I am successfully using this spoof on my [Lenovo T530 ThinkPad](https://github.com/5T33Z0/Lenovo-T530-Hackinosh-OpenCore) for running macOS Sonoma.

Although installing macOS on systems with an unsupported SMBIOS was possible long before these patches existed (via boot-arg `-no_compat_check`), receiving OTA system updates was impossible with the boot-arg activated.

> [!IMPORTANT]
>
> With the release of `RestrictEvents.kext` 1.1.3, the Kernel Patches were included into the kext itself, so adding them to the config.plist is no longer required. So, if your config still contains the Kernel Patches, please disable them! Prior to the release of `RestrictEvents.kext`, the kernel patches had negative effects on Bluetooth somce enabling the VMM Board-ID skipped loading the Bluetooth firmware (&rarr; See "Previous Method" section for details). This has been resolved now.

## System Requirements
**Minimum macOS**: Big Sur 11.3 or newer (Darwin Kernel 20.4+) is **mandatory**!</br>
**Intel CPU families**:

- 1st Gen Intel Core CPUs (req. SurPlus Kernel Patches)
- Sandy Bridge (req. SurPlus Kernel Patches)
- Ivy Bridge
- Haswell/Broadwell
- Skylake (to continue using SMBIOS `iMac17,1` on macOS 13+). Requires additional [iGPU spoof](https://github.com/5T33Z0/OC-Little-Translated/tree/main/11_Graphics/iGPU/Skylake_Spoofing_macOS13) so the Intel HD 530 can be used.

> [!NOTE]
>
> 7th to 10 Gen Intel Core CPUs don't need this spoof (yet) since they are still supported by macOS.

## Use Cases
1. **Installing macOS 11.3+** on systems with unsupported CPUs and SMBIOSes/Board-IDs
2. **Enabling System Updates**. As a side effect, you can use these patches to workaround issues with System Updates in macOS 11.3 and newer when using an SMBIOS of a Mac model with a T1/T2 security chip, such as (value in brackets = `SecureBootModel`):

	- MacBookPro15,1 (`J680`), 15,2 (`J132`), 15,3 (`J780`), 15,4 (`J213`)
	- MacBookPro16,1 (`J152F`), 16,2 (`J214K`), 16,3 (`J223`), 16,4 (`J215`)
	- MacBookAir8,1 (`J140K`), 8,2 (`J140A`)
	- MacBookAir9,1 (`J230K`)
	- Macmini8,1 (`J174`)
	- iMac20,1 (`J185`), 20,2 (`J185F`)
	- iMacPro1,1 (`J137`)
	- MacPro7,1 (`J160`)

Under the following conditions you won't receive System Update Notifications and therefore you won't be able to download OTA System Updates:

1. Using a [`csr-active-config` bitmask](https://github.com/5T33Z0/OC-Little-Translated/blob/main/B_OC_Calculators/SIP_Flags_Explained.md) containing the flags "Allow Apple Internal" and "Allow unauthenticated Root" to lower/disable `System Integrity Protection` (SIP). 
2. Using an SMBIOS of one of the Mac models listed above in combination with `SecureBootModel` set to `Disabled` (instead of using the correct "J" value).
3. Using boot-arg `-no_compat_check` which allows booting with an unsupported board-id but it also disables system updates.

Lowering/disabling SIP is necessary in order to re-install [components which have been removed from macOS](https://dortania.github.io/OpenCore-Legacy-Patcher/PATCHEXPLAIN.html#on-disk-patches) because they cannot be injected by Bootloaders. But if these 2 SIP flags are set, you won't receive System Update Notifications any longer. Since re-installing files on the system partition also breaks its security seal, `SecureBootModel` has to be disabled to boot the system afterwards.

So, in order to be able to boot the system with patched-in drivers ***and*** receive system updates, the Board-ID VMM spoof is the only workaround.
	
## Instructions
- Mount your EFI
- Open your `config.plist` with ProperTree
- Copy the "Skip Board ID check" patch from OCLP's [**`Booter/Patch`**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Config/config.plist#L220-L243) section to your `config.plist` and **enable** it. 
- Add [**`RestrictEvent.kext`**](https://github.com/acidanthera/RestrictEvents/releases) 1.1.3 or newer to your `EFI/OC/Kext` folder and `config.plist`
- Delete `-no_compat_check` boot-arg (if present)
- Add `revpatch=sbvmm` to boot-args or as as an NVRAM variable: <br> ![revpatch](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/a1ee759c-ced4-4669-97b4-9be8833fe57b)
- Optional (but recommended): Under `PlatformInfo/Generic`, pick the correct/designated [SMBIOS for your CPU family/system](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/CPU_to_SMBIOS.md) and generate new serials, etc (with OCAT or GenSMBIOS for example) 
- Save your config and reboot.
- Install macOS 12 or newer.

<details>
<summary><strong>Previous method</strong> (obsolete)(Click to reveal)</summary>

## About the Patches
Following are the relevant Booter and Kernel Patches contained in the [**config.plist**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Config/config.plist) provided by OpenCore Legacy Patcher.

- **Booter Patches**
	- **"Skip Board ID check"** &rarr; Skips Hardware Board ID Check (enabled)
	- **"Reroute HW_BID to OC_BID"** &rarr; Reroutes Hardware Board-ID check to OpenCore (enabled)
	- Both patches in tandem allow to run/install macOS on systems using a unsupported SMBIOS/Board-ID (No longer required)
- **Kernel Patches** (see "Comment" section)
	- **"Reroute kern.hv_vmm_present patch (1)"**, **"Reroute kern.hv_vmm_present patch (2) Legacy"**, **"Reroute kern.hv_vmm_present patch (3) Ventura"** and **"Force IOGetVMMPresent"** &rarr; Set of Kernel patches to enable Board-ID spoof via VMM in macOS 11.3+ that allow booting, installing and updating macOS 12 and newer with an unsupported Board-ID and SMBIOS.
	- **"Disable Root Hash validation"** &rarr; Disables Cryptex hash verification in APFS.kext.
	- **"Force FileVault on Broken Seal"** &rarr; Mandatory if you are using FileVault since installing Drivers back into the system volume breaks its security seal. 
	- **"Disable Library Validation Enforcement"** &rarr; Library Validation Enforcement checks if an app's libraries are signed by Apple or the creator. Until recently, macOS apps could load code freely from foreign sources called code libraries. With macOS 10.15, apps are no longer allowed to load libraries that weren't originally packaged with it, unless they explicitly allow it. In this case it's needed because root patches for Non-Metal GPUs won't pass library validation tests otherwise.
	- **"Disable _csr_check() in _vnode_check_signature"** &rarr; Allows using AMFI enabled with root patches applied, this helps avoid issues that occur with AMFI disabled. Note that currently OCLP requires AMFI disabled when applying root patches but with this kernel patch you can re-enable AMFI afterwards.
	- **SurPlus Patches 1 and 2**: Race to condition fixes for Sandy Bridge and older. Fixes issues in macOS 11.3+, where Big Sur often won't boot when using SMBIOS `MacPro5,1` (disabled). These patches are now Included in the `sample.plist` (OC 0.7.7+).

> [!IMPORTANT]
> 
> RDRAND Patches for Sandy Bridge CPUs are no longer required since OpenCore 0.7.8 and must be disabled/deleted.

## Adding the Patches
> [!WARNING]
> 
> Before adding these patches to your config.plist, make sure you have a working backup of your EFI folder stored on a FAT32 formatted USB flash drive to boot your PC from just in case something goes wrong!

### Booter Patches
- Mount your EFI
- Open your config.plist with ProperTree
- Copy the entries from OCLPs [`Booter/Patch`](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Config/config.plist#L220-L267) section to your config.plist and enable them
- Leave ProperTree open an continue reading

> [!NOTE]
> 
> These Booter patches skip the board-id checks in macOS. They can only be applied using OpenCore. When using Clover you have to use boot-args `-no_compat_check`, `revpatch=sbvmm` and RestrictEvents.kext instead to workaround issues with System Update Notifications.

### Kernel Patches

Copy the following entries from OCLPs [`Kernel/Patch`](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Config/config.plist#L1636) section your to config.plist:

- **"Force FileVault on Broken Seal"** &rarr; Only required when using File Vault)
- **"Disable Library Validation Enforcement"** &rarr; Enable it!
- **"Reroute kern.hv_vmm_present patch (1)"** &rarr; Enable it!
- **"Reroute kern.hv_vmm_present patch (2) Legacy"** &rarr; For installing/running **macOS Monterey**. Enable it.
- **"Reroute kern.hv_vmm_present patch (2) Ventura"** &rarr; For installing/running **macOS Monterey** and newer. Enable it.
- **"Force IOGetVMMPresent"** &rarr; Enable it.
- **"Disable Root Hash validation"** &rarr; Enable it. **Note**: Not required when using [CryptexFixup](https://github.com/acidanthera/CryptexFixup) (IvyBridge and older only).
- Add and enable additional Kernel patches if required (SurPlus patches for Sandy Bridge CPUs for example).

To verify, enter `sysctl kern.hv_vmm_present` in Terminal. If it returns `1` the spoof is working (applies to option 1 only!). Remember: these patches have no effect below macOS 11.3.

Enjoy macOS Monterey and newer with the correct SMBIOS for your CPU with working System Updates!

> [!IMPORTANT]
> If you experience [issues with Bluetooth](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/1076) when using Broadcom cards in macOS Sonoma, then disable the Kernel Patches and use RestrictEvents.kext and boot-arg instead!
</details>

<details>
<summary><strong>Testing the spoof on my Laptop</strong></summary>

I tested these patches on my Lenovo T530 Notebook, using an Ivy Bridge CPU with `MacBookPro10,1` SMBIOS, which is officially not compatible with macOS Monterey. After rebooting, the system started without using `-no_compat_check` boot-arg, as you can see here:

![Proof01](https://user-images.githubusercontent.com/76865553/139529766-87daac84-126e-4dfc-ac1d-37e4730e0bbf.png)

Terminal shows the currently used Board-ID which belongs to the `MacBookPro10,1` SMBIOS as you can see in Clover Configurator. Usually, running macOS would require using `MacBookPro11,4` which uses a different Board-ID as you can see in the Clover Configurator snippet:

![boardid](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/79e6ae79-5c4b-4a41-b84e-29e4ac2d78b3)

Next, I checked for updates and was offered macOS 12.1 beta:

![Proof03](https://user-images.githubusercontent.com/76865553/139529788-d8ca770e-f8c2-49a8-a44e-908137f5e45c.png)
  
Which I installed…
  
![Proof04](https://user-images.githubusercontent.com/76865553/139529792-d92e52d3-5f91-4044-b788-730d603327b3.png)

Installation went smoothly and macOS 12.1 booted without issues:

![About](https://user-images.githubusercontent.com/76865553/139529802-3ea61297-7c7b-4369-8c21-4160b437f1a6.png)

</details>

## Notes
- After upgrading to macOS 12+, you have to re-install graphics drivers for legacy iGPUs/dGPUs that are no longer supported by macOS, such as: Intel HD Graphics (Ivy Bridge to Skylake), NVIDIA Kepler and AMD Vega, Polaris and GCN. To do so, you can use [**OpenCore Patcher GUI App**](https://github.com/dortania/OpenCore-Legacy-Patcher/releases)
- For getting macOS Ventura and newer to work on unsupported platforms, check the [**OCLP Wintel**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/14_OCLP_Wintel) section. It contains configuration guides for 1st to 6th Gen Intel Core CPUs.

## Credits
- [**VMM Usage Notes**](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/543#issuecomment-953441283)
- Dortania for [**OpenCore Legacy Patcher**](https://github.com/dortania/OpenCore-Legacy-Patcher)
- Chris1111 for [**GeForce Kepler Patcher**](https://github.com/chris1111/Geforce-Kepler-patcher) and [**Intel HD 4000 Patcher**](https://github.com/chris1111/Patch-HD4000-Monterey)
- parrotgeek1 for [**VMM Patches**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/4a8f61a01da72b38a4b2250386cc4b497a31a839/payloads/Config/config.plist#L1222-L1281)
- reenigneorcim for [**SurPlus**](https://github.com/reenigneorcim/SurPlus)
