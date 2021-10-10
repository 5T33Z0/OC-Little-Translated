# CMOS Related Patches

## CMOS Reset Patch

### Description

- Some machines will show **"Boot Self Test Error"** when shutting down or rebooting, which is caused by CMOS being reset.
- When using Clover, checking `ACPI > FixRTC` will fix the problem.
- When using OpenCore, do the following:
  - Install **RTCMemoryFixup.kext**
  - In config, enable `Kernel > Patch` **__ZN11BCM5701Enet14getAdapterInfoEv**

### Solution

See "CMOS Reset Fix" for details.

## **CMOS** Memory and RTCMemoryFixup

- When a conflict occurs between **AppleRTC** and **BIOS**, try using **RTCMemoryFixup** to emulate **CMOS** memory to avoid the conflict.
- **RTCMemoryFixup** download at <https://github.com/acidanthera/RTCMemoryFixup>

### **CMOS** Memory

- **CMOS** memory holds important data such as date, time, hardware configuration information, auxiliary setup information, boot settings, hibernation information, etc.
- Some **CMOS** memory space definitions.
  - Date, time: `00-0D`
  - Hibernation information storage interval: `80-AB`
  - Power management: `B0-B4`
  - Other

### Simulation **CMOS** memory method

See "CMOS Memory and RTCMemoryFixup" for details.
