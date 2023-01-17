# Enabling CPU Power Management
This chapter contains guides for enabling (and optimizing) CPU Power Management for Intel and AMD CPUs in macOS. 

## Available SSDTs
Clicking on an SSDT's name in the table below takes you to the corresponding guide or file to enable CPU power management for the listed CPU family.

CPU Family | Used Plugin | Required SSDT |Configuration Notes
----------------------|:-----------:|:-------------:|-----------
12th/13th Gen Intel (Alder/Raptor Lake) | **`X86PlatformPlugin`** | [**SSDT-PLUG-ALT**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(SSDT-PLUG)#11th-gen-intel-and-newer)| • Requires Comet Lake CPUID </br> • Enable Quirk `ProvideCurrentCpuInfo` </br> • [**CPUFriend**](https://github.com/acidanthera/CPUFriend) kext and [**CPUFriendFriend**](https://github.com/corpnewt/CPUFriendFriend) to optimize CPU Power Management </br> • Optional: [**CpuToplogyRebuild**](https://github.com/b00t0x/CpuTopologyRebuild) kext
11th Gen Intel (Ice/Rocket Lake)| **`X86PlatformPlugin`**| [**SSDT-PLUG**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(SSDT-PLUG)#11th-gen-intel-and-newer)| • Not needed in macOS 12+</br> • Requires Comet Lake CPUID </br>• Optional: [**CPUFriend**](https://github.com/acidanthera/CPUFriend) kext and [**CPUFriendFriend**](https://github.com/corpnewt/CPUFriendFriend) to optimize CPU Power Management
4th to 10th Gen Intel (Haswell to Comet Lake) | **`X86PlatformPlugin`**| [**SSDT-PLUG**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(SSDT-PLUG)#readme)| Not needed in macOS 12+ </br>• Optional: [**CPUFriend**](https://github.com/acidanthera/CPUFriend) kext and [**CPUFriendFriend**](https://github.com/corpnewt/CPUFriendFriend) to optimize CPU Power Management
≤ 3rd Gen Intel (Ivy Bridge and older) | **`ACPI_SMC_PlatformPlugin`**</br>**`AppleIntelCPUPowerManagement.kext`** | [**SSDT-PM**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(Legacy)#readme)| • Plugin dropped from macOS 13 <br>• [**Force-enable XCPM**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/Enabling_XCPM_on_Ivy_Bridge_CPUs) or [**Re-enable ACPI CPU Power Management**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(Legacy)#re-enabling-acpi-power-management-in-macos-ventura) for proper CPU Power Management in macOS 13
AMD (17h)| **N/A**|[**SSDT-CPUR**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(SSDT-PLUG)#what-about-amd)| :warning: Only needed for B550 and A520 mainboards!</br> • Enable `DummyPowerManagement` Quirk</br> • Add [**AMDRyzenCPUPowerManagement**](https://github.com/trulyspinach/SMCAMDProcessor) kext (AMD Ryzen only)

## About CPU Power Management in macOS

Up to macOS Big Sur, macOS uses 2 different kexts for handling CPU Power Management: 

- `ACPI_SMC_PlatformPlugin` (Legacy plugin used on Ivy Bridge and older)
- `X86PlatformPlugin` (used for Haswell and newer)

The **ACPI_SMC_PlatformPlugin** provides support for ACPI and the System Management Controller (SMC). It allows macOS to interact with the SMC and access information about the hardware components it controls. It loads `AppleIntelCPUPowerManagement.kext`, which handles the actual ACPI CPU Power Management.

The **X86PlatformPlugin** provides support for the x86 architecture on Apple computers. It allows the operating system to interact with the hardware components of the system such as the processor, memory, and nainboard.

In summary, the ACPI_SMC_PlatformPlugin kext is used to manage hardware components in the system through the SMC, while the X86PlatformPlugin kext is used to interact with x86-based hardware components in the system.

### ACPI CPU Power Management

For Ivy Bridge(-E) and older, you have to create an SSDT containing the power and turbo states of the CPU which are then injected into macOS via ACPI so that the `ACPI_SMC_PlatformPlugin` has the correct data to work with. That's why this method is also referred to as "ACPI CPU Power Management". If this plugin is selected (plugin-type 0) it loads the actual `AppleIntelCPUPowerManagement.kext` which then handles the CPU Power Management on Ivy Bridge and older Intel CPUs.

You have to use **ssdtPRGen** to generate this table, which is now called `SSDT-PM`. In the early days of hackintoshing, when you had to use a patched DSDT to run macOS since hotpatching wasn't a thing yet, this table was simply referred to as "SSDT.aml" since it usually was the only SSDT injected into the system besides the DSDT.

Although **ssdtPRGen** supports Sandy Bridge to Kabylake CPUs, it's only used for 2nd and 3rd Gen Intel CPUs nowadays. It might still be useful on Haswell and newer when working with unlocked, overclockable "k" variants of Intel CPUs which support the `X86PlatformPlugin` to optimize performance.

### XCPM (= XNU CPU Power Management)

In OSX 10.11 and older, boot-arg `-xcpm` could be used to enable [**XCPM**](https://pikeralpha.wordpress.com/2013/10/05/xnu-cpu-power-management/) for unsupported CPUs. 

Since macOS Sierra, this boot-arg does no longer work. Instead, you have to add [***SSDT-PLUG***](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/Enabling_XCPM_on_Ivy_Bridge_CPUs#readme) to select the `X86PlatformPlugin.kext`, which takes care of CPU Power Management on Haswell and newer Intel CPUs based on the `FrequencyVectors` stored in the selected SMBIOS (or more specifically, the board-id). These Frequency Vectors can be modified to optimize the performance and CPU Power Management for your CPU model using [**CPUFriendFriend**](https://github.com/corpnewt/CPUFriendFriend) to generate a `CpuFriendDataProvider.kext` which must be injected alongside [**CPUFriend**](https://github.com/acidanthera/CPUFriend) into macOS. 

Although the **Ivy Bridge** CPU family is capable of utilizing **XCPM**, it has been disabled in macOS for a long time (since macOS 10.12). But you can [**force-enable**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/Enabling_XCPM_on_Ivy_Bridge_CPUs) it.

Since Apple dropped Intel CPU support after 10th Gen Comet Lake, newer Intel CPUs also require a fake CPUID ("impersonating" a Comet Lake CPU) in order to run macOS.

#### macOS Monterey

In macOS Monterey, Apple disabled the plugin-type check for CPU Power Management, so the `X86PlatformPlugin` (plugin-type `1`) is loaded by default. Prior to macOS 12, plugin-type `0` was the default, that's why `SSDT-PLUG` was required to select the `X86PlatformPlugin`. This is great for users of Haswell and newer: now they don't need `SSDT-PLUG` any more. But for Ivy Bridge and older, `SSDT-PM` is now required to select plugin-type to `0` which then loads the `AppleIntelCPUPowerManagement.kext`. So ACPI CPU Power Management can still be utilized in macOS 12. For macOS Ventura it's a different story…

#### macOS Ventura, `XCPM` and ACPI CPU Power Management

In macOS Ventura, Apple deleted the actual *binary* from the `ACPI_SMC_PlatformPlugin.kext` – it's an empty stub now. So selecting plugin-type `0` with SSDT-PM doesn't work. On top of that, `AppleIntelCPUPowerManagement.kext` was deleted as well. So ACPI CPU Power Management is basically non-existant in macOS 13+.

For Ivy Bridge and older that's a problem. In order to get proper CPU Manangement on Ivy Bridge and older you have 2 options now:

- **Option 1**: [**Force-enable `XCPM`**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/Enabling_XCPM_on_Ivy_Bridge_CPUs) (Ivy Bridge only. Doesn't work well) or
- **Option 2**: [**Re-enable ACPI CPU Power Management**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(Legacy)#re-enabling-acpi-power-management-in-macos-ventura) (Recommended. Requires CFG Lock to be disabled in BIOS)

If you cannot disable CFG Lock for your Ivy Bridge CPU in BIOS (or by flashing a custom BIOS with the MSR 0xE2 register unlocked), force-enabling `XCPM` is mandatory if you want to have decent CPU Power Management in macOS Ventura.

## Further Resources
- **CPU Support list**: https://dortania.github.io/OpenCore-Install-Guide/macos-limits.html#cpu-support
- Check the **Configuration.pdf** included in the OpenCorePkg for details about unlocking the MSR 0xE2 register (&rarr; Chapter 7.8: "AppleCpuPmCfgLock").
