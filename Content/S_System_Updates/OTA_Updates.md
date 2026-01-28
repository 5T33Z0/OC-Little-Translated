# Enabling macOS OTA Updates on Hackintoshes

## **Introduction**

A recent Hackintosh development has opened up a new path for enabling OTA updates on macOS 14.4 and later. The **iBridged.kext** ([GitHub link](https://github.com/Carnations-Botanica/iBridged)) allows Hackintosh users to bypass the T2/BridgeOS coprocessor check that normally blocks OTA updates when Secure Boot is enabled.

This new approach provides a simpler and more reliable method for keeping your Hackintosh up to date, particularly for systems that don’t require root patches or SMBIOS spoofing. Combined with the known methods like RestrictEvents.kext and board-ID skip, it completes the toolkit for safely applying OTA updates across a variety of Hackintosh configurations.

## **Overview**

There are two main OTA update scenarios:

1. **Vanilla Hackintosh (no root patches applied)**
2. **Root-patched Hackintosh / unsupported SMBIOS**

The solution depends on whether you want to use **Secure Boot** and whether your Hackintosh requires **low-level system patches.

## **Scenario 1: Vanilla Hackintosh (no root patches applied)**

### Problem

* macOS checks for Apple’s T2/BridgeOS coprocessor during OTA updates.
* With Secure Boot enabled (`SecureBootModel: Default`), OTA will fail if the coprocessor is missing.

### Solution

1. **Enable Secure Boot**: Set `SecureBootModel: Default` in your OpenCore `config.plist`.
2. **Install iBridged.kext**: This Lilu-based plugin injects the required `apple-coprocessor-version` property, satisfying macOS Secure Boot checks.
3. **Use a supported SMBIOS**: Choose a Mac model that matches your macOS version.
4. **Apply standard Hackintosh kexts**: Lilu, WhateverGreen, VirtualSMC, etc.

✅ Result: OTA updates work while maintaining Secure Boot protections.

> [!TIP]
> 
> Check the [iBridged_path](/Content/S_System_Updates/configs/ibridged_path.plist) plist file for reference.

---

## **Scenario 2: Root-Patched Hackintosh / Unsupported SMBIOS**

### Problem

* Root patches (OCLP) or unsupported/spoofed SMBIOSes break the Signed System Volume (SSV).
* Secure Boot (`SecureBootModel: Default`) will block OTA updates and may prevent boot.

### Solution

1. **Disable Secure Boot**: Set `SecureBootModel: Disabled` in OpenCore.
2. **Use RestrictEvents.kext + `revpatch=sbvmm` boot argument**: Bypasses kernel checks that prevent OTA updates on patched systems.
3. **Apply board-ID skip**:
   * Lets macOS accept your unsupported SMBIOS without switching models.
   * Works with OCLP to patch the booter early and bypass installer model checks.
4. **Apply OCLP root patches**: Enable legacy hardware support if needed.
5. **Apply standard Hackintosh kexts**: Lilu, WhateverGreen, VirtualSMC, etc.

✅ Result: OTA updates succeed, Secure Boot is disabled, and SMBIOS switching is no longer required. iBridged is not applicable in this scenario.

> [!TIP]
> 
> Check the [restrict_events_path](/Content/S_System_Updates/configs/restrict_events_path.plist) plist file for reference.

## **Flowchart: Paths to Enabling OTA Updates**

The flowchart below helps you to identify which configuration path is the correct one for your system.

<img width="1168" height="662" alt="OTA" src="https://github.com/user-attachments/assets/94ad649f-9c63-4e19-a71b-c7c62bda8d48" />

## **Key Takeaways**

* **iBridged** is only required when Secure Boot is enabled on a vanilla system.
* **Root patches / unsupported SMBIOS** require disabling Secure Boot; iBridged will not help.
* **Board-ID skip** and RestrictEvents kext allow OTA updates without switching SMBIOS models.
* Always have backups before applying OTA updates, especially when root patches are involved.

