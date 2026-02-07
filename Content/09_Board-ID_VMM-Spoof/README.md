# Using unsupported Board-IDs with macOS 11.3 to 26

## Introduction
**OpenCore Legacy Patcher** (OCLP) 0.3.2 introduced a set of Booter and Kernel patches that allow using unsupported/dropped SMBIOSes in newer versions of macOS while still being able to receive OTA system updates. This is achieved in two stages: first, the board id check is skipped and in the 2nd stage, kernel patches are applied that report a special board-id to Apples update servers that indicate, that the system is running inside a Virtual Machine:

> Parrotgeek1's VMM patch set would force `kern.hv_vmm_present` to always return `True`. With hv_vmm_present returning True, both **`OSInstallerSetupInternal`** and **`SoftwareUpdateCore`** will set the **`VMM-x86_64`** board-id while the rest of the OS will continue with the original ID.
>
> - Patching `kern.hv_vmm_present` over manually setting the VMM CPUID allows for native features such as CPU and GPU power management.

**Source**: [**OCLP issue 543**](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/543)

This construct allows installing and receiving OTA system updates for macOS 11.3 and newer on otherwise unsupported Board-IDs/CPUs. Although OCLP's primary aim is to install OpenCore and macOS on legacy Macs, these patches can be utilized on Hackintoshes as well while using the "native", designated SMBIOS for a given CPU family which improves CPU and GPU Power Management - especially on Laptops.

Although installing macOS on systems with an unsupported SMBIOS was possible long before these patches existed (via boot-arg `-no_compat_check`), receiving OTA system updates is impossible if this boot-arg is active.

> [!IMPORTANT]
>
> - With the release of `RestrictEvents.kext` v1.1.3, the Kernel Patches were implemented into the kext itself, so adding them is no longer necessary. If your `config.plist` still contains these [Kernel Patches](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Config/config.plist#L2163-L2282), please disable/delete them! 
> - Prior to the release of `RestrictEvents.kext`, the kernel patches had negative effects on Bluetooth since enabling the VMM Board-ID skipped loading firmware of Bluetooth devices. This has been resolved now (&rarr; [more details](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/1076)).

## System Requirements
**Minimum macOS**: Big Sur 11.3 or newer (Darwin Kernel 20.4+) is ***mandatory***!

**Intel CPU families**:

- 1st Gen Intel Core CPUs (req. [SurPlus Kernel Patches](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Config/config.plist#L2103-L2162))
- Sandy Bridge (req. [SurPlus Kernel Patches](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Config/config.plist#L2103-L2162))
- Ivy Bridge
- Haswell/Broadwell
- Skylake (to continue using SMBIOS `iMac17,1` on macOS 13+). Requires additional [iGPU spoof](https://github.com/5T33Z0/OC-Little-Translated/tree/main/11_Graphics/iGPU/Skylake_Spoofing_macOS13) so the Intel HD 530 can be used.
- Kaby Lake (required for intstalling/booting macOS 26)
- Coffee Lake (required for installing/booting macOS 26)

> [!NOTE]
>
> 10th Gen Intel Core CPUs (Comet Lake) don't need this spoof since they are still supported by macOS 26 Tahoe.

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

Normally, macOS wouldn't be able to receive System Update Notifications (and therefore wouldn't be able to download OTA System Updates) under the following conditions:

1. Using a [`csr-active-config` bitmask](/Content/B_OC_Calculators/SIP_Flags_Explained.md) containing the flags "Allow Apple Internal" and "Allow unauthenticated Root" to lower `System Integrity Protection` (SIP). Lowering SIP is mandatory for [applying root-patches with OCLP](https://dortania.github.io/OpenCore-Legacy-Patcher/PATCHEXPLAIN.html#on-disk-patches) to the system volume to re-enable legacy hardware since it cannot be enabled by injecting settings and kexts via OpenCore alone alone. But if these 2 SIP flags are active, you won't receive System Update Notifications any longer. Since re-installing files on the system partition also breaks its security seal, `SecureBootModel` has to be disabled in order to boot the system afterwards.
2. Using an SMBIOS of one of the Mac models listed above in combination with `SecureBootModel` set to `Disabled` (instead of using the correct "J" value).
3. Using boot-arg `-no_compat_check` which allows booting with an unsupported board-id but it also disables system updates.

In conclusion: in order to be able to boot the system with the designated SMBIOS, patched-in drivers ***and*** receive system updates, the Board-ID VMM spoof is the only workaround.
	
## Instructions
- Mount your EFI
- Open your `config.plist` with ProperTree
- Copy the "Skip Board ID check" patch from OCLP's [**`Booter/Patch`**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Config/config.plist#L220-L243) section to your `config.plist` and **enable** it. 
- Add [**`RestrictEvent.kext`**](https://github.com/acidanthera/RestrictEvents/releases) 1.1.3 or newer to your `EFI/OC/Kext` folder and `config.plist`
- Delete `-no_compat_check` boot-arg (if present)
- Add `revpatch=sbvmm` to boot-args or as as an NVRAM variable: <br> ![revpatch](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/a1ee759c-ced4-4669-97b4-9be8833fe57b)
- Optional (but recommended): Under `PlatformInfo/Generic`, pick the designated [SMBIOS](/Content/14_OCLP_Wintel/CPU_to_SMBIOS.md) and generate new serials, etc (with OCAT or GenSMBIOS for example) 
- Save your config and reboot.
- Install macOS 12 or newer.

<details>
<summary><strong>Proof that the spoof is working</strong> (Click to reveal)</summary>

## Proof
I tested the Board-id vmm spoof on my Lenovo T530 Notebook (Ivy Bridge), using the `MacBookPro10,1` SMBIOS, which is officially not compatible with macOS Monterey. After rebooting, the system started without using `-no_compat_check` boot-arg, as you can see here:

![Proof01](https://user-images.githubusercontent.com/76865553/139529766-87daac84-126e-4dfc-ac1d-37e4730e0bbf.png)

Terminal shows the currently used Board-ID which belongs to the `MacBookPro10,1` SMBIOS as you can see in Clover Configurator. Usually, running macOS 12+ would require SMBIOS `MacBookPro11,4` which uses a different Board-ID:

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
- For getting macOS Ventura and newer to work on unsupported platforms, check the [**OCLP Wintel**](/Content/14_OCLP_Wintel/README.md) section for detailed configuration guides (1st to 6th Gen Intel Core CPUs).

## Credits
- [**VMM Usage Notes**](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/543#issuecomment-953441283)
- Dortania for [**OpenCore Legacy Patcher**](https://github.com/dortania/OpenCore-Legacy-Patcher)
- parrotgeek1 for [**VMM Patches**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/4a8f61a01da72b38a4b2250386cc4b497a31a839/payloads/Config/config.plist#L1222-L1281)
- reenigneorcim for [**SurPlus**](https://github.com/reenigneorcim/SurPlus)
