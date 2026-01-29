# Enabling macOS OTA Updates on Hackintoshes

## Introduction

With macOS 14.4, Apple introduced stricter requirements for OTA (over-the-air) updates that affect most modern Hackintosh configurations. A recent development, **iBridged.kext** ([GitHub](https://github.com/Carnations-Botanica/iBridged)), introduces a new and cleaner way to restore OTA updates on **vanilla Hackintosh systems** using Secure Boot.

iBridged complements existing solutions such as **RestrictEvents.kext** and **board-ID skip**, which remain essential for systems that rely on root patches or unsupported SMBIOS configurations. Together, these tools now cover all relevant OTA update scenarios on modern Hackintoshes.

---

## Technical Background

Starting with macOS 14.4, Apple tightened OTA update validation by enforcing hardware assumptions that were previously left unchecked. During update preparation, macOS now expects the presence of a **BridgeOS/T2 coprocessor** when using **Secure Boot–capable SMBIOS profiles**.

On real Intel Macs, this coprocessor is always present. On Hackintosh systems, it is not, which causes OTA updates to fail despite otherwise valid configurations.

Traditionally, this limitation was addressed using **RestrictEvents.kext**, which works around the checks by making macOS and Apple’s update services treat the system as running inside a virtual machine. This approach remains necessary for **root-patched systems** or **unsupported SMBIOS configurations**.

**iBridged** introduces an alternative path for **fully vanilla systems** by simulating the expected coprocessor interface directly, allowing OTA updates to proceed without virtualization-based workarounds.

---

### SMBIOS impact on OTA updates
| Mac Model | SMBIOS | T2 / BridgeOS | Affected by OTA update Check | Notes |
| --------- |------- | :-----------: | :--------------------------: | ----- |
| **Intel Macs with T2** | MacBookPro15,x<br>MacBookPro16,x<br>MacBookPro17,1<br>MacBookAir8,x / 9,1<br>iMac19,x / 20,x / 21,x<br>iMacPro1,1<br>Macmini8,1<br>MacPro7,1 | Yes | **Yes**                           | Requires iBridged (vanilla) or RestrictEvents + `revpatch=sbvmm` (patched systems)|
| **Intel Macs without T2 (pre-2018)** | MacBookPro14,x and earlier<br>iMac18,x and earlier<br>Macmini7,1 and earlier | No | No | Not affected by T2 checks, but often unsupported by newer macOS  | | **Apple Silicon Macs** | MacBookPro18,x<br>MacBookAir10,x<br>MacStudio1,x<br>MacPro8,1                                                                                | N/A (integrated Secure Enclave) | No| Not usable on Hackintosh systems |

---

## iBridged vs. RestrictEvents

| Aspect                       | **iBridged.kext**                          | **RestrictEvents.kext + `revpatch=sbvmm`** |
| ---------------------------- | ------------------------------------------ | ------------------------------------------ |
| Primary purpose              | Simulates BridgeOS/T2 coprocessor presence | Bypasses update checks via virtualization  |
| macOS versions               | 14.4+                                      | 11.3+                                      |
| Intended use case            | **Vanilla Hackintosh**                     | **Root-patched / unsupported SMBIOS**      |
| Works with OCLP root patches | No                                         | Yes                                        |
| SecureBootModel              | `Default`                                  | `Disabled`                                 |
| SIP required                 | Can be fully enabled                       | Must be partially or fully disabled        |
| Board-ID skip                | Not compatible                             | Commonly required                          |
| SSV integrity                | Preserved                                  | Broken or bypassed                         |
| Update method                | Native OTA                                 | OTA via workaround                         |
| Long-term cleanliness        | High                                       | Medium                                     |

---

## Choosing the right OTA Update Path

Use this section to quickly identify the correct setup for your system.

### Use **iBridged** if:

* Your system is fully vanilla
* You use a supported, T2-era Intel SMBIOS
* You want Secure Boot and SIP enabled

### Use **RestrictEvents** if:

* You rely on OCLP root patches
* Your SMBIOS is unsupported or spoofed
* You need board-ID skip
* Secure Boot must be disabled

### OTA Update Flowchart

The following flowchart helps you with the decision-making:

![](https://github.com/user-attachments/assets/94ad649f-9c63-4e19-a71b-c7c62bda8d48)

---

## OTA Update Scenarios

### Scenario 1: Vanilla Hackintosh (No Root Patches)

#### Problem

* macOS checks for a BridgeOS/T2 coprocessor during OTA updates.
* With Secure Boot enabled, OTA updates fail if the coprocessor is missing.

#### Solution

1. Set `Misc/SecureBootModel` to `Default`.
2. Install **iBridged.kext** (Lilu plugin).
3. Use a supported SMBIOS for your macOS version.
4. Use standard Hackintosh kexts (Lilu, WhateverGreen, VirtualSMC, etc.).

✅ **Result:** OTA updates work with Secure Boot and SIP intact.

> [!TIP]
> 
> See the reference configuration: [`iBridged_path.plist`](/Content/S_System_Updates/configs/ibridged_path.plist)

---

### Scenario 2: Root-Patched Hackintosh / Unsupported SMBIOS

This is the most common scenario, especially for users relying on **OCLP root patches** for legacy GPUs, Wi-Fi, Bluetooth, or audio on newer macOS releases.

#### Problem

1. **Root patches break the Signed System Volume (SSV)**

   * System volume or kernel modifications invalidate the SSV and block OTA updates.

2. **Unsupported or spoofed SMBIOS**

   * Model validation checks prevent OTA updates on unsupported configurations.

#### Solution

1. Add **board-ID skip**

   * Allows using the native SMBIOS without switching models.
   * Works with OCLP to bypass installer model checks early.

2. Add **RestrictEvents.kext** with `revpatch=sbvmm`

   * Enables the `VMM-x86_64` board-ID.
   * Makes macOS treat the system as virtualized.
   * Enables OTA updates on macOS 11.3+.

3. Set `Misc/SecureBootModel` to `Disabled`.

4. Apply OCLP root patches if required.

✅ **Result:** OTA updates succeed, Secure Boot is disabled, SMBIOS switching is no longer required.
iBridged is **not applicable** in this scenario.

> [!TIP]
> 
> See the reference configuration: [`Restrict_Events_path.plist`](/Content/S_System_Updates/configs/restrict_events_path.plist)

---

## Key Takeaways

* **iBridged** enables OTA updates on vanilla systems with Secure Boot enabled.
* **RestrictEvents + board-ID skip** remain mandatory for root-patched or unsupported systems.
* Secure Boot and full SIP are only possible on vanilla configurations.
* Always create backups before applying OTA updates, especially on patched systems.
