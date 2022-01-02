# CMOS Related Patches
**CMOS** memory holds important data such as date, time, hardware configuration information, auxiliary setup information, boot settings, hibernation information, etc.

- Some **CMOS** memory space definitions are:
  - Date, time: `00-0D`
  - Hibernation information storage interval: `80-AB`
  - Power management: `B0-B4`
  - Other

## Method 1: CMOS Reset Patch

### Description

- Some machines will show the message **"Boot Self Test Error"** when shutting down or rebooting, which is triggered by CMOS being reset.
- When using Clover, checking `ACPI > FixRTC` will fix this issue.
- When using OpenCore, do the following:
  - Install **RTCMemoryFixup.kext**
  - In config, enable `Kernel > Patch` **__ZN11BCM5701Enet14getAdapterInfoEv**

## Method 2: CMOS Memory and RTCMemoryFixup kext

- If the conflict occurs between **AppleRTC** and **BIOS**, use **RTCMemoryFixup** kext to emulate **CMOS** memory to avoid the conflict instead.
- Download [**RTCMemoryFixup**](https://github.com/acidanthera/RTCMemoryFixup)
- Add the kext to your kext folder and config and reboot into macOS.
