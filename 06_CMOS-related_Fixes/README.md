# CMOS Related Patches
**CMOS** memory holds important data such as date, time, hardware configuration information, auxiliary setup information, boot settings, hibernation information, etc.

Some **CMOS** memory space definitions are:

- Date, time: `00-0D`
- Hibernation information storage interval: `80-AB`
- Power management: `B0-B4`
- Other

## Method 1: CMOS Reset Fix

Some machines will show the message **"Boot Self Test Error"** when shutting down or rebooting, which is triggered by CMOS being reset.

- When using Clover, enabling `FixRTC` in the `ACPI` section will resolve this issue.
- When using OpenCore, do the following:
  - Add [**RTCMemoryFixup.kext**](https://github.com/acidanthera/RTCMemoryFixup) to your OC/Kexts folder ond config
  - Under `Kernel/Patch`, enable __ZN11BCM5701Enet14getAdapterInfoEv 

If the patch is not present, copy it over from the `Sample.plist` included in the OpenCore Package.

## Method 2: CMOS Memory and RTCMemoryFixup kext

If an issue between **AppleRTC** and **BIOS** exists, use **RTCMemoryFixup** kext to emulate **CMOS** memory to avoid the conflict instead:

- Download [**RTCMemoryFixup**](https://github.com/acidanthera/RTCMemoryFixup)
- Add the kext to your kext folder and config and reboot into macOS.
