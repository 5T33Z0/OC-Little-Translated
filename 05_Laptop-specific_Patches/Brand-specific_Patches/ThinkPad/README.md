# Fixing `HWAC` Bitfield in Lenovo ThinkPads

## About
On many modern ThinkPads, there are often accesses to the 16-bit EC-field `HWAC`, which are not covered by battery-patches (i.e. those currated by OC-Little). Those accesses are (mostly) located in the `_OWAK` and/or `_L17` methods of the system's DSDT.
 
The method `OWAK` gets called by `_WAK` on wake and crashes when trying to access the 16-bit `HWAC`, leaving the machine in an undefined/unknown hw-state as the regular ACPI-wakeup-method, which reinstates the hardware after exiting S3 sleep, can't run to its end.
 
This issue is often not clearly visible as the kernel-ringbuffer (`msgbuf`) is, by default, only 4 kb in size and is flooded on wake by many messages. This can be mitigated (up to 16 kb) via the `msgbuf` boot-arg or patched with [**`DebugEnhancer.kext`**](https://github.com/acidanthera/DebugEnhancer) by Acidanthera. You can check the size of your msgbuf with `sysctl -a kern.msgbuf`.

## How this fix works 
This fix consists of 2 components: a binary rename that changes `HWAC` to `XWAC` form the EC and then redefines it in `SSDT-HWAC`. It splits the original `HWAC` frield from 16 bit into two 8 bit fields (`WAC0` & `WAC1`) and hands them over to macOS to fix all accesses to the Embedded Cnntroller's `HWAC` field at once. For any other Operating System `HWAC` is used to ensure full compliance with ACPI

**Technical Background**:
> Later releases of `AppleACPIPlatform` are unable to correctly access fields within the EC (Embedded Controller). […] `DSDT` must be changed to comply with the limitations of Apple's `AppleACPIPlatform`. 
> In particular, any fields in the EC larger than 8-bit, must be changed to be accessed 8-bits at one time. This includes 16, 32, 64, and larger fields.
> 
> - [**How to patch DSDT for working battery status**](https://www.tonymacx86.com/threads/guide-how-to-patch-dsdt-for-working-battery-status.116102/) by Rehabman

## Do I need this fix?
With the release of [**`ECEnabler.kext`**](https://github.com/1Revenger1/ECEnabler/releases) in 2021, which enables reading Embedded Controller fields over 1 byte long in macOS, this fix might be obsolete. 

Because with ECEnabler, most (not all) ThinkPads no longer require any Battery Patches since their main purpose was to split battery-related EC fields from 16 bit into 2x8 bit so macOS could read the data. Since the HWAC fix works the same it's most likely not required as well.

But if you don't use this kext to fix the EC in macOS and `HWAC` is present in your system's `DSDT` and it's not covered by your battery fix already, you should add it.

## Instructions

- Open `SSDT-HWAC.dsl` in maciASL
- Export it as `SSDT-HWAC.aml` (ACPI Machine Language)
- Add it to `EFI/OC/ACPI` and your `config.plist` (under `ACPI/Add`)
- Add the following rename to the `ACPI/Patch` section:
	```text
	COMMENT: Change HWAC to XWAC EC Reads, pair with SSDT-HWAC
	FIND: 45435F5F 48574143
	REPLACE: 45435F5F 58574143
	TableSignature: 44534454
	```
- Save your config and reboot 	

## Credits

- Sniki for `SSDT-HWAC.dsl`
	