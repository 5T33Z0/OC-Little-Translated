# Fixing issues with System Update Notifications in macOS 11.3 and newer

## Problem Description
Under one of the following conditions (or combinations thereof), System Update Notifications won't work in Big Sur and newer, so you can't install any OTA System Updates/Upgrades:

1. When using `-no_compat_check` boot-arg. This disables System Updates *by design*
2. When adding flag(s) "Allow Apple Internal" and/or "Allow Unauthenticated Root" to the `csr-active-config` value in macOS Big Sur and newer (&rarr; see chapter [OpenCore Calculators](/Content/B_OC_Calculators) for details)
3. When using an SMBIOS of Mac models with a T1/T2 security chip with `SecureBootModel` set to `Disabled` instead of using the correct value (in brackets):
	- MacBookPro15,1 (`J680`), 15,2 (`J132`), 15,3 (`J780`), 15,4 (`J213`)
	- MacBookPro16,1 (`J152F`), 16,2 (`J214K`), 16,3 (`J223`), 16,4 (`J215`)
	- MacBookAir8,1 (`J140K`), 8,2 (`J140A`)
	- MacBookAir9,1 (`J230K`)
	- Macmini8,1 (`J174`)
	- iMac20,1 (`J185`), 20,2 (`J185F`)
	- iMacPro1,1 (`J137`)
	- MacPro7,1 (`J160`)
 	- Any (other) model (`Default`)

Disabling `SecureBootModel` for the listed SMBIOSes is necessary when trying to run macOS Big Sur and newer with unsupported GPUs/iGPUs. This requires re-installing previously removed drivers back into macOS with OpenCore Legacy Patcher. But in order to do so, `System Integrity Protection` *and* `SecureBootModel` have to be disabled for installing and loading drivers for Intel integrated graphics as well as NVIDIA Kepler cards.

Re-installing (graphics) drivers onto the system partition breaks the security seal of the system volume. And since these drivers are unsigned, the system will crash on boot if `SecureBootModel` and `SIP` are enabled. So in this case it's a combination of two factors which break system updates.

## Fix
1. Remove `-no_compat_check` boot-arg (if present)
2. Add the [**Skip Board-ID Check**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Config/config.plist#L214-L243) from OCLPs config and enable it.
3. Add [**RestrictEvents.kext**](https://github.com/acidanthera/RestrictEvents) combined with boot-arg `revpatch=sbvmm` which enables the `VMM-x86_64` board-id, allowing OTA updates for unsupported models on macOS 11.3 and newer. This also allows using the "native" SMBIOS for the used CPU which improves CPU and GPU power management while macOS identifies itself to the update servers as running in a virtual machine.

Instead of the `revpatch=sbvmm` boot-arg, you can also use an NVRAM variable. Make sure to also add an entry for `revpatch` to the `NVRAM/Delete` section as well, so new/different values can be written to it:

![NVRAM_parms](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/2a6466eb-97b5-4548-943b-caf10e65351b)

## Limitations
Since this fix utilizes virtualization capabilities only supported by macOS Big Sur 11.3 and newer (XNU Kernel 20.4.0+), you can't utilize it in macOS Catalina or older. This can be worked around by temporarily switching to a supported SMBIOS (&rarr; check the [**SMBIOS Compatibilty Chart**](/Content/E_Compatibility_Charts/SMBIOS_Compat_Short.pdf) to find one) and disconnecting the system from the internet before installing macOS (otherwise you have to generate new serials, etc.). Once macOS 11.3 or newer is installed, the board-id spoof is working and you can revert back to the SMBIOS best suited for your CPU.

### What about Clover?
This fix also works in Clover but it requires a slightly different approach, since Clover cannot apply OpenCore's Booter patches needed for the board-id skip. Therefore you need `-no_compat_check` to boot macOS with an unsupported Board-id – otherwise you will be greeted with the "forbidden" sign instead of the Apple logo. Installing macOS still requires a supported SMBIOS, though.

But as mentioned earlier, using `-no_compat_check` disables system updates. Therefore we add `RestrictEvents.kext` (and `revpatch=sbvmm` boot-arg) to force-enable the `VMM-x86_64` which somehow cancels out the side-effects of no_compat_check. So now you can:

1. Boot macOS with an unsupported SMBIOS/board-id,
2. Get proper CPU Power Management (XCPM) with the correct/native SMBIOS for your CPU. (Enabling legacy [ACPI CPU Power Management in macOS 13](/Content/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(Legacy)#re-enabling-acpi-power-management-in-macos-ventura) requires additional measures)
3. Receive OTA System Updates with Clover – which was impossible before!

When I was booting macOS Ventura on my Ivy Bridge Laptop with Clover using SMBIOS `MacBookPro10,1`, `-no_compat_check`, `RestrictEvent.kext` and `revpatch=sbvmm`, I was offered System Updates, which is pretty damn cool.

## Notes
- [**Reducing the download size of OTA Updates**](/Content/S_System_Updates/OTA_Updates.md)
- Find out more about the [origin of this fix](/Content/09_Board-ID_VMM-Spoof)

## Credits
- Dortania for OCLP 
- Acidanthera and RestrictEvents.kext
