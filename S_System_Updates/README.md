# Fixing issues with System Update Notifications in macOS 11.3 and newer

## Problem Description

Under one of the following conditions (or combinations thereof), System Update Notifications won't work in Big Sur and newer, so you can't install any OTA System Updates/Upgrades:

1. When using `-no_compat_check` boot-arg. This disables System Updates *by design*
2. When adding Bit 5 "Allow Apple Internal" (and in some cases bit 12 "Allow Unauthenticated Root") to the `csr-active-config` value in macOS Big Sur and newer (&rarr; see chapter "[OpenCore Calculators](https://github.com/5T33Z0/OC-Little-Translated/tree/main/B_OC_Calculators)" for details)
3. When using an SMBIOS of Mac models with a T1/T2 security chip with `SecureBootModel` set to `Disabled` instead of using the correct value (in brackets):
	- MacBookPro15,1 (`J680`), 15,2 (`J132`), 15,3 (`J780`), 15,4 (`J213`)
	- MacBookPro16,1 (`J152F`), 16,2 (`J214K`), 16,3 (`J223`), 16,4 (`J215`)
	- MacBookAir8,1 (`J140K`), 8,2 (`J140A`)
	- MacBookAir9,1 (`J230K`)
	- Macmini8,1 (`J174`)
	- iMac20,1 (`J185`), 20,2 (`J185F`)
	- iMacPro1,1 (`J137`)
	- MacPro7,1 (`J160`)

Disabling `SecureBootModel` for the listed SMBIOSes is necessary when trying to run current versions of macOS (Big Sur+) with unsupported GPUs/iGPUs. This requires re-installing previously removed drivers back into macOS with OpenCore Legacy Patcher. But in order to do so, `System Integrity Protection` *and* `SecureBootModel` have to be disabled for installing and loading drivers for Intel HD 4000 as well as NVIDIA Kepler cards.

But re-installing (graphics) drivers breaks the security seal of the system volume. And since these drivers are unsigned, the system will crash on boot if `SecureBootModel` and `SIP` are enabled. So in this case it's a combination of 2 factors which break system updates.

## Fix

All of the issues can be eliminated in macOS 11.3+ by removing `-no_compat_check` and adding the Board-id VMM spoof to your config. This allows using an unsupported SMBIOS, have proper CPU Power Management and get System Updates. [**Follow the instructions here**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof) to add the necessary patches to your config. 

You only need the Booter patches not the Kernel patches, though! These can be substituted by the [**RestrictEvents.kext**](https://github.com/acidanthera/RestrictEvents) combined with boot-arg `revpatch=sbvmm` which enables the `VMM-x86_64` board-id, allowing OTA updates for unsupported models on macOS 11.3 and newer.

Instead of the `revpatch=sbvmm` boot-arg, you can also use an NVRAM variable:</br>![](https://user-images.githubusercontent.com/76865553/209689694-8b3fe03d-0eea-4261-bf68-1042e201f30b.png)

## Limitations

Since the fix utilizes virtualization capabilities only supported by macOS Big Sur 11.3 and newer (XNU Kernel 20.4.0+) you can't use it in macOS Catalina and older.

But this can simply be worked around by temporarily switching to a supported SMBIOS (&rarr; check the [**SMBIOS Compatibilty Chart**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/E_Compatibility_Charts) to find one) and disconnecting the system from the internet before installing macOS (otherwise you have to generate new serials, etc.)

Once macOS 11.3 or newer is installed, the board-id spoof is working works and you can revert back to the SMBIOS best suited for your CPU.

### What about Clover?

This fix also works in Clover but it requires a slightly different approach, since you  cannot apply OpenCore's Booter patches needed for the board-id skip with Clover. Therefore you need `-no_compat_check` to boot macOS using an unsupported SMBIOS/board-id – otherwise you will be greeted with the "forbidden" sign instead of the Apple logo. 

But as mentioned in the beginning, using `-no_compat_check` disables system updates. Therefore we add `RestrictEvents.kext` (and `revpatch=sbvmm` boot-arg) to force-enable the `VMM-x86_64` board-id and now you finally can get:

- Boot macOS with an unsupported SMBIOS/board-id,
- Have proper CPU Power Management since you can use the correct SMBIOS for your CPU and 
- Get System Updates with Clover – which was impossible before!

When I was booting macOS Ventura on my Ivy Bridge Laptop with Clover using SMBIOS `MacBookPro10,1`, `-no_compat_check`, `RestrictEvent.kext` and `revpatch=sbvmm`, I was offered System Updates, which is pretty damn cool.

## Credits
- Acidanthera for OCLP and RestrictEvents.kext
