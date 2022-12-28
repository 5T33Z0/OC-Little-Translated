# Fixing issues with System Update Notifications in macOS 11.3 and newer

## Problem Description

Under one of the following conditions (or combinations thereof), System Update Notifications won't work so you can't install any OTA System Updates/Upgrades:

1. When using `-no_compat_check` boot-arg. This disables System Updates *by design*
2. When adding Bit 5 "Allow Apple Internal" (and in some cases bit 12 "Allow Unathenticated Root") to the `csr-active-config` value in macOS Big Sur and newer (&rarr; see chapter "[OpenCore Calculators](https://github.com/5T33Z0/OC-Little-Translated/tree/main/B_OC_Calculators)" for details)
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

All of the issues can be eliminated in macOS 11.3+ by removing `-no_compat_check` and adding the Board-id VMM spoof to your config. This allows using an unsupported SMBIOS, have proper CPU Power Management and get System Updates. [**Follow the instructions here**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof).

Another option is to use [**RestrictEvents.kext**](https://github.com/acidanthera/RestrictEvents) with boot-arg `revpatch=sbvmm` which also enables the Board-id VMM spoof, allowing OTA updates for unsupported models on macOS 11.3 or newer.

Which approach to use is up to you, but for ease of use I would give the kext and boot-arg combo a try first.

## Limitations

Since the fix utilizes virtualization capabilies only supported by macOS Big Sur 11.3 and newer (XNU Kernel 20.4.0+) you can't use it in macOS Catalina and older.

But since the issue only started to occur on Big Sur and newer, it's not really an issue on older versions of macOS – unless you have to use `-no_compat_check` or added bit 5 to your `csr-active-config`, of course.

### What about Clover?

This fix only works partially in Clover since you can't add the Booter patches required for the board-id vmm spoof to work, which allows to run macOS with an unsupported SMBIOS/Board-id, so you will get the "forbidden" sign when attempting to boot macOS Big Sur or newer with an unsupported SMBIOS/Board-id.

For some reason, `RestrictEvents.kext` (and the `revpatch=sbvmm` boot-arg) doesn't fully enable the board-id spoof either, so you will get the "forbidden" sign in this case as well. You still have to use `-no_compat_check` to boot macOS with an unsupported board-id which normally disables system updates, of course.

However, when I was boooting macOS Ventura on my Ivy Bridge Laptop with Clover using SMBIOS `MacBookPro10,1`, `-no_compat_check`, `RestrictEvent.kext` and `revpatch=sbvmm`, I was offered System Updates, which left me happy but baffled at the same time because I have no real explanation for it. 

My hypothesis is: the kext can apply the kernel patches part of the board-id vmm spoof but not the booter patches since OpenCore is required to reroute and "obfuscate" the real board-id internally. This is the part that Clover cannot do, so you can't boot without `-no_compat_check`. But since the Kernel Patches *can be applied by the kext*, you are offered system updates anyway – even with `-no_compat_check` enabled – which is pretty cool.

## Credits
- Acidanthera for OCLP and RestricEvents.kext
