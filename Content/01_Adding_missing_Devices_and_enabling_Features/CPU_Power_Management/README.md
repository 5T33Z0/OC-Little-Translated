# Enabling CPU Power Management
- [Overview](#overview)
- [Available SSDTs](#available-ssdts)
- [About CPU Power Management in macOS](#about-cpu-power-management-in-macos)
  - [ACPI CPU Power Management](#acpi-cpu-power-management)
  - [XCPM (= XNU CPU Power Management)](#xcpm--xnu-cpu-power-management)
    - [macOS Monterey](#macos-monterey)
    - [macOS Ventura+, `XCPM` and ACPI CPU Power Management](#macos-ventura-xcpm-and-acpi-cpu-power-management)
  - [macOS Sonoma+](#macos-sonoma)
- [Further Resources](#further-resources)

---

## Overview

This chapter contains guides for enabling (and optimizing) CPU Power Management for Intel and AMD CPUs in macOS. 

## Available SSDTs

Clicking on an SSDT's name in the table below takes you to the corresponding guide or file to enable CPU power management for the listed CPU family.

CPU Family | Used Plugin | SSDT | Additional Requirements and Notes
:---------:|:-----------:|:----:|-----------------------------------
**12th/13th Gen Intel** (Alder/Raptor Lake) | **`X86PlatformPlugin`** | [**SSDT-PLUG-ALT**](/Content/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(SSDT-PLUG)#11th-gen-intel-and-newer)| <ul> <li> Requires Fake CPUID (Comet Lake) </br> <li> Enable Kernel Quirk `ProvideCurrentCpuInfo` </br> <li> Add [**CPUFriend**](https://github.com/acidanthera/CPUFriend) and use [**CPUFriendFriend**](https://github.com/corpnewt/CPUFriendFriend) to generate a Data Injector kext to optimize CPU Power Management <li> Add [**CpuToplogyRebuild**](https://github.com/b00t0x/CpuTopologyRebuild) kext to configure usage of heterogeneous CPU cores (experimental)
**11th Gen Intel** (Ice/Rocket Lake)| **`X86PlatformPlugin`**| [**SSDT-PLUG**](/Content/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(SSDT-PLUG)#11th-gen-intel-and-newer)| <ul><li> Not needed in macOS 12+ <li> Requires Fake CPUID (Comet Lake) </br><li> Optional: Add [**CPUFriend**](https://github.com/acidanthera/CPUFriend) kext and use [**CPUFriendFriend**](https://github.com/corpnewt/CPUFriendFriend) to generate a Data Injector kext to optimize CPU Power Management
**4th to 10th Gen Intel** (Haswell to Comet Lake) | **`X86PlatformPlugin`**| [**SSDT-PLUG**](/Content/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(SSDT-PLUG)#readme)| <ul> <li> Not needed in macOS 12+ <li> Optional: Add [**CPUFriend**](https://github.com/acidanthera/CPUFriend) and use [**CPUFriendFriend**](https://github.com/corpnewt/CPUFriendFriend) to generate a Data Injector kext to optimize CPU Power Management
≤ 3rd Gen Intel (Ivy Bridge and older) | **`ACPI_SMC_PlatformPlugin`** | [**SSDT-PM**](/Content/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(Legacy)#readme)| <ul><li> Plugin dropped from macOS 13 <li> [**Re-enable ACPI CPU Power Management**](/Content/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(Legacy)#re-enabling-acpi-power-management-in-macos-ventura) for proper CPU Power Management in macOS 13+
**AMD (17h)**| **N/A**|[**SSDT-CPUR**](/Content/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(SSDT-PLUG)#what-about-amd) | :bulb: `SSDT-CPUR` is only needed for B550 and A520 mainboards!</br> <ul><li> Enable `DummyPowerManagement` (Kernel/Emulate) <li> Add [**AMDRyzenCPUPowerManagement**](https://github.com/trulyspinach/SMCAMDProcessor) kext (AMD Ryzen only)<li> Add [**SMCAMDProcessor**](https://github.com/trulyspinach/SMCAMDProcessor) kext (optional). Publishes CPU readings to VirtualSMC, which enables macOS applications like iStat to display sensor data. <li> Enable Kernel Quirk `ProvideCurrentCpuInfo` to apply AMD-specific [**Kernel Patches**](https://github.com/AMD-OSX/AMD_Vanilla) 

## About CPU Power Management in macOS

Up to macOS Big Sur, macOS uses 2 different kexts for handling CPU Power Management: 

- `ACPI_SMC_PlatformPlugin` (Legacy plugin used on Ivy Bridge and older)
- `X86PlatformPlugin` (used for Haswell and newer)

The **ACPI_SMC_PlatformPlugin** provides support for ACPI and the System Management Controller (SMC). It allows macOS to interact with the SMC and access information about the hardware components it controls. It loads `AppleIntelCPUPowerManagement.kext`, which handles the actual ACPI CPU Power Management.

The **X86PlatformPlugin** provides support for the x86 architecture on Apple computers. It allows the operating system to interact with the hardware components of the system such as the processor, memory, and mainboard.

In summary, the ACPI_SMC_PlatformPlugin kext is used to manage hardware components in the system through the SMC, while the X86PlatformPlugin kext is used to interact with x86-based hardware components in the system.

### ACPI CPU Power Management

For Ivy Bridge(-E) and older, you have to create an SSDT containing the power and turbo states of the CPU which are then injected into macOS via ACPI so that the `ACPI_SMC_PlatformPlugin` has the correct data to work with. That's why this method is also referred to as "ACPI CPU Power Management". If this plugin is selected (plugin-type 0) it loads the actual `AppleIntelCPUPowerManagement.kext` which then handles the CPU Power Management on Ivy Bridge and older Intel CPUs.

You have to use **ssdtPRGen** to generate this table, which is now called `SSDT-PM`. In the early days of hackintoshing, when running macOS required a patched DSDT (because hotpatching via Boot Loader wasn't possible), this table was simply referred to as "SSDT" since it was the only other table injected into the system besides the DSDT. You can still find references to this in Clover's configuration file which has a dedicated "SSDT" sub-section for configuring CPU Power Management.

Although **ssdtPRGen** supports Sandy Bridge to Kabylake CPUs, it's only used for 2nd and 3rd Gen Intel CPUs nowadays. It might still be useful on Haswell and newer when working with unlocked, overclockable "k" variants of Intel CPUs which support the `X86PlatformPlugin` to optimize performance.

### XCPM (= XNU CPU Power Management)

In OSX 10.11 and older, boot-arg `-xcpm` could be used to force-enable [**XCPM**](https://pikeralpha.wordpress.com/2013/10/05/xnu-cpu-power-management/) in macOS (3rd Gen Intel Core and newer).

Since macOS Sierra, this boot-arg does no longer work. Instead, you have to add [***SSDT-PLUG***](/Content/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/Enabling_XCPM_on_Ivy_Bridge_CPUs#readme) to select the `X86PlatformPlugin.kext`, which takes care of CPU Power Management on Haswell and newer Intel CPUs based on the `FrequencyVectors` stored in the selected SMBIOS (or more specifically, the board-id). These Frequency Vectors can be modified to optimize the performance and CPU Power Management for your CPU model using [**CPUFriendFriend**](https://github.com/corpnewt/CPUFriendFriend) to generate a `CpuFriendDataProvider.kext` which must be injected alongside [**CPUFriend**](https://github.com/acidanthera/CPUFriend) into macOS. 

Although the **Ivy Bridge** CPU family is capable of utilizing **XCPM**, it has been disabled in macOS for a long time (since macOS 10.12). You can [**force-enable**](/Content/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/Enabling_XCPM_on_Ivy_Bridge_CPUs) it but its not recommended since the CPU does not perform as well afterwards than using legacy CPU Power Management.

Since Apple dropped Intel CPU support after 10th Gen Comet Lake, newer Intel CPUs also require a fake CPUID ("impersonating" a Comet Lake CPU) in order to run macOS.

#### macOS Monterey

In macOS 12 (Monterey), Apple disabled the plugin-type check for CPU Power Management, so the `X86PlatformPlugin` (plugin-type `1`) is loaded by default. Prior to macOS 12, plugin-type `0` was the default, that's why `SSDT-PLUG` was required to select the `X86PlatformPlugin`. This is great for users of Haswell and newer: now they don't need `SSDT-PLUG` any more. But for Ivy Bridge and older, `SSDT-PM` is now required to select plugin-type to `0` which then loads the `AppleIntelCPUPowerManagement.kext`. So ACPI CPU Power Management can still be utilized in macOS 12. For macOS Ventura it's a different story…

#### macOS Ventura+, `XCPM` and ACPI CPU Power Management

In macOS 13 (Ventura), Apple deleted the actual *binary* from the `ACPI_SMC_PlatformPlugin.kext` – it's an empty stub now. So selecting plugin-type `0` with SSDT-PM doesn't work. On top of that, `AppleIntelCPUPowerManagement.kext` was deleted as well. So ACPI CPU Power Management is basically non-existent in macOS 13 and newer.

For Ivy Bridge and older that's a problem. In order to get proper CPU Management on Ivy Bridge and older you have 2 options now:

- **Option 1**: [**Re-enable ACPI CPU Power Management**](/Content/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(Legacy)#re-enabling-acpi-power-management-in-macos-ventura) (Highly Recommended)
- **Option 2**: [**Force-enable `XCPM`**](/Content/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/Enabling_XCPM_on_Ivy_Bridge_CPUs) (Ivy Bridge only. Doesn't work well)

### macOS Sonoma+
- Requires Kaby Lake and newer
- More changes &rarr; See [Sonoma Notes](https://github.com/5T33Z0/OCLP4Hackintosh/blob/main/docs/Sonoma_Notes.md)

## Further Resources

- Check OpenCore's documentation for unlocking the **MSR 0xE2** register (&rarr; see [**Chapter 7.8**](https://dortania.github.io/docs/latest/Configuration.html#quirks-properties2): "AppleCpuPmCfgLock").
- [**CPU Support list**](https://dortania.github.io/OpenCore-Install-Guide/macos-limits.html#cpu-support) by Dortania
