# Enabling macOS OTA Updates on Hackintoshes

## Introduction

With macOS 14.4, Apple introduced stricter requirements for OTA (over-the-air) system updates that affect most modern Hackintosh configurations. A recent development, **iBridged.kext** ([GitHub](https://github.com/Carnations-Botanica/iBridged)), introduces a cleaner way to restore OTA updates on **vanilla Hackintosh systems** using Secure Boot.

iBridged complements existing solutions such as **RestrictEvents.kext** and **board-ID skip**, which remain relevant for systems that rely on root patches or unsupported SMBIOS configurations. Together, these kexts and patches cover the main OTA update scenarios on modern Hackintoshes.

---

## Technical Background

Starting with macOS 14.4, Apple tightened OTA update validation by enforcing hardware assumptions that were previously left unchecked. During update preparation, macOS now expects the presence of a **BridgeOS/T2 coprocessor** when using **Secure Boot-capable SMBIOS profiles**.

On real Intel Macs equipped with a T2 chip, this coprocessor is present. Hackintosh systems lack the physical hardware, which can cause OTA updates to fail despite an otherwise valid configuration.

Traditionally, this limitation was addressed using a combination of a Booter Patch (board-ID check skip), **RestrictEvents.kext**, and NVRAM parameters that enable specific kernel patches. The `revpatch=sbvmm` boot argument enables the `VMM-x86_64` board ID, making macOS treat the system as virtualized so that OTA updates can be offered. This approach remains relevant for **root-patched systems** or **unsupported SMBIOS configurations**.

**iBridged.kext** provides an alternative by simulating the expected T2-coprocessor interface directly, allowing OTA updates to proceed without virtualization-based workarounds. However, **incremental OTA system updates with iBridged require a T2-equipped SMBIOS**. This is why **RestrictEvents.kext remains necessary for older systems**, essentially those using pre-2020 SMBIOS profiles without T2 support.

> [!TIP]
> 
> If you are using RestrictEvents with the `revpatch=sbvmm` boot argument and OTA updates stopped working after macOS 14.3.1, check your `config.plist`. You may be missing the [Booter Patch](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Config/config.plist#L214-L243) that skips the board-ID check.

---

## SMBIOS impact on OTA updates

| Mac Model | SMBIOS | T2 / BridgeOS | Affected by OTA update check | Notes |
| --------- | ------ | :-----------: | :--------------------------: | ----- |
| **Intel Macs with T2** | MacBookPro15,x<br>MacBookPro16,x<br>MacBookAir8,x / 9,1<br>iMac20,x<br>iMacPro1,1<br>Macmini8,1<br>MacPro7,1 | Yes | **Yes** | Requires iBridged (vanilla) or RestrictEvents + `revpatch=sbvmm` (patched systems) |
| **Intel Macs without T2** | MacBookPro14,x and earlier<br>iMac19,x and earlier<br>Macmini7,1 and earlier | No | No | Not affected by T2 checks, but may be unsupported by newer macOS versions |

---

### SMBIOS and `SecureBootModel` on macOS Tahoe

macOS Tahoe supports a more limited selection of Intel Mac SMBIOS profiles than previous macOS releases. The following supported models and their corresponding SecureBootModel identifiers are relevant:

| SecureBootModel | Associated SMBIOS |
| --------------- | ----------------- |
| `j160` | `MacPro7,1` |
| `j152f` | `MacBookPro16,1` |
| `j214k` | `MacBookPro16,2` |
| `j223` | `MacBookPro16,3` |
| `j215` | `MacBookPro16,4` |
| `j185` | `iMac20,1` |
| `j185f` | `iMac20,2` |

#### How `SecureBootModel = Default` behaves

According to Dortania's OpenCore Install Guide, `Default` currently resolves to `x86legacy`. However, the OpenCore Configuration Reference describes it as *"Matching model for current SMBIOS"*.

My own tests indicate that `Default` selects the Secure Boot model associated with the configured SMBIOS, if one is available. For example, with `MacBookPro15,2`, OpenCore resolves `Default` to `j132`.

This distinction matters in macOS Tahoe. An older SMBIOS may resolve to a Secure Boot model for which the corresponding signed Boot Kernel Collection manifest is no longer available in the Tahoe Preboot environment.

#### Example: Lenovo ThinkPad T490

On my ThinkPad T490, using `MacBookPro15,2` as the SMBIOS, the board-ID check skip allows macOS Sequoia to boot without issues. Tahoe, however, behaves differently:

- `SecureBootModel = Default` resolves to `j132` (associated with `MacBookPro15,2`).
- macOS attempts to load `BootKernelExtensions.kc.j132ap.im4m`.
- The boot log reports `Err(0xE)` while opening the manifest, followed by a Secure Boot verification failure and a reset.
- Explicitly setting `SecureBootModel = j152f` (associated with `MacBookPro16,1`) allows Tahoe to boot without changing the SMBIOS.

The log indicates that the failure occurs during the Apple booter's Secure Boot verification stage, before the kernel starts. The missing model-specific manifest is a likely explanation for this behavior, although this should not be treated as a confirmed universal rule for every unsupported SMBIOS.

> [!IMPORTANT]
> 
> `SecureBootModel` and SMBIOS are separate settings. Selecting a different Secure Boot model does not change `SystemProductName`. If `Default` resolves to an identifier that fails to boot Tahoe, explicitly selecting an identifier associated with a supported model may be a workaround. These results are based on testing and should be validated on other hardware and configurations.

---

## iBridged vs. RestrictEvents

| Aspect | **iBridged.kext** | **RestrictEvents.kext + `revpatch=sbvmm`** |
| ---------------------------- | ------------------------------------------ | ------------------------------------------ |
| Primary purpose | Simulates BridgeOS/T2 coprocessor presence | Bypasses update checks via virtualization |
| macOS versions | 14.4+ | 11.3+ |
| Intended use case | **Vanilla Hackintosh** | **Root-patched / unsupported SMBIOS** |
| Works with OCLP root patches | No | Yes |
| SecureBootModel | `Default` | `Disabled` |
| SIP required | Can be fully enabled | Must be partially or fully disabled |
| Board-ID skip | Not compatible | Commonly required |
| SSV integrity | Preserved | Broken or bypassed |
| Update method | Native OTA | OTA via workaround |
| Long-term cleanliness | High | Medium |

---

## Choosing the right OTA Update Path

Use this section to quickly identify the correct setup for your system.

### Use **iBridged** if:

- Your system is fully vanilla.
- You use a supported, T2-era Intel SMBIOS.
- You don't need the board-ID skip Booter Patch to boot macOS.
- You want Secure Boot and SIP enabled.

> [!TIP]
>
> If your CPU belongs to the T2-era Mac generation but its corresponding SMBIOS is not supported by macOS Tahoe, try the following combination to enable working incremental OTA updates:
>
> **Native SMBIOS** matching your CPU family + **board-ID check skip** Booter Patch + **SecureBootModel spoof** using a Tahoe-compatible model + SIP fully enabled (`csr-active-config = 00000000`) + **iBridged.kext**.


### Use **RestrictEvents** if:

- Your SMBIOS is unsupported or spoofed.
- You need the board-ID skip Booter Patch to boot macOS.
- You rely on OCLP root patches.
- Secure Boot must be disabled to boot macOS.

### OTA Update Flowchart

The following flowchart helps with the decision-making:

<img width="1725" height="808" alt="OTA_Updates" src="https://github.com/user-attachments/assets/e496f0e8-7730-43b5-a722-d55acae8b110" />

---

## OTA Update Scenarios

### Scenario 1: Vanilla Hackintosh (No Root Patches)

#### Problem

- macOS checks for a BridgeOS/T2 coprocessor during OTA updates.
- With Secure Boot enabled, OTA updates can fail if the expected coprocessor interface is missing.

#### Solution

1. Set `Misc/SecureBootModel` to `Default`.
2. Install **iBridged.kext** (Lilu plugin).
3. Use a supported SMBIOS for your macOS version.
4. Use standard Hackintosh kexts (Lilu, WhateverGreen, VirtualSMC, etc.).

**Result:** OTA updates work with Secure Boot and SIP intact.

> [!TIP]
> See the reference configuration: [`iBridged_path.plist`](/Content/S_System_Updates/configs/ibridged_path.plist)

---

### Scenario 2: Root-Patched Hackintosh / Unsupported SMBIOS

This is a common scenario, especially for users relying on **OCLP root patches** for legacy GPUs, Wi-Fi, Bluetooth, or audio on newer macOS releases.

#### Problem

1. **Root patches break the Signed System Volume (SSV)**
   - System volume or kernel modifications invalidate the SSV and interfere with native OTA updates.

2. **Unsupported or spoofed SMBIOS**
   - Model validation checks can prevent OTA updates on unsupported configurations.

#### Solution

1. Add the **Skip Board-ID Check** Booter Patch to your config.plist (you can copy it from the [**Restrict_Events_path.plist**](/Content/S_System_Updates/configs/restrict_events_path.plist))
2. Add [**RestrictEvents.kext**](https://github.com/acidanthera/RestrictEvents) to `OC/EFI/Kexts` and `config.plist` 
3. Set `Misc/SecureBootModel` to `Disabled`.
4. Remove the `-no_compat_check` boot-arg (if present)
5. Add boot-arg `revpatch=sbvmm` (&rarr; [Additional Info](/Content/09_Board-ID_VMM-Spoof))
6. Save and reboot
7. Check for System Updates

> [!TIP]
>
> Instead of using the `revpatch=sbvmm` boot-arg, you can also use an NVRAM variable. Make sure to also add an entry for `revpatch` to the `NVRAM/Delete` section as well, so new/different values can be written to it:<br><img width="731" height="257" alt="sbvmm" src="https://github.com/user-attachments/assets/f154421a-bd86-4162-8e81-48c6027a7748" />

---

## Key Takeaways

- **iBridged** enables OTA updates on vanilla systems with Secure Boot enabled.
- **RestrictEvents + board-ID skip** remain relevant for root-patched or unsupported systems.
- Secure Boot and full SIP are generally only possible on vanilla configurations.
- On macOS Tahoe, the SMBIOS-to-SecureBootModel mapping can affect whether the system boots with Secure Boot enabled. An explicit SecureBootModel may be necessary when `Default` selects an identifier that fails verification.
- Always create backups before applying OTA updates, especially on patched systems.
