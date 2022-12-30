# Enabling CPU Power Management
This chapter contains guides for enabling CPU Power Management for Intel and AMD CPUs in macOS.

## CPU Power Managegement in macOS

Up to macOS Big Sur, macOS uses 2 different kexts for handling CPU Power Management: 

- `ACPI_SMC_PlatformPlugin` (Legacy plugin used on Ivy Bridge and older)
- `X86PlatformPlugin` (used for Haswell and newer)

The **ACPI_SMC_PlatformPlugin** provides support for ACPI and the System Management Controller (SMC). It allows macOS to interact with the SMC and access information about the hardware components it controls.

The **X86PlatformPlugin** provides support for the x86 architecture on Apple computers. It allows the operating system to interact with the hardware components of the system such as the processor, memory, and nainboard.

In summary, the ACPI_SMC_PlatformPlugin kext is used to manage hardware components in the system through the SMC, while the X86PlatformPlugin kext is used to interact with x86-based hardware components in the system.

### About ACPI Power Management

For Ivy Bridge(-E) and older, you have to create an SSDT containing the power and turbo states of the CPU which are then injected into macOS via ACPI so that the `ACPI_SMC_PlatformPlugin` has the correct data to work with. That's why this method is also referred to as "ACPI CPU Power Management". 

You have to use **ssdtPRGen** to generate this table, which is now called `SSDT-PM`. In the early days of hackintoshing, when you had to use a patched DSDT to run macOS since hotpatching wasn't a thing yet, this table was simply referred to as "SSDT.aml" since it usually was the only SSDT injected into the system besides the DSDT.

Although **ssdtPRGen** supports Sandy Bridge to Kabylake CPUs, it's only used for 2nd and 3rd Gen Intel CPUs nowadays. It might still be useful on Haswell and newer when working with unlocked, overclockable "k" variants of Intel CPUs which support the `X86PlatformPlugin` to optimize performance.

### About XCPM (= XNU CPU Power Management)

Prior to the release of macOS 10.13, boot-arg `-xcpm` could be used to enable [**XCPM**](https://pikeralpha.wordpress.com/2013/10/05/xnu-cpu-power-management/) for unsupported CPUs. Since then, the boot-arg does no longer work. For Haswell and newer, you simple add [***SSDT-PLUG***](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/Enabling_XCPM_on_Ivy_Bridge_CPUs#readme) to select `plugin-type 1` (`X86PlatformPlugin.kext` and `X86PlatformShim.kext`), which then takes care of CPU Power Management using the `FrequencyVectors` provided by the selected SMBIOS (or more specifically, the board-id). The Frequency Vectors can be modified by using [**CPUFriendFriend**](https://github.com/corpnewt/CPUFriendFriend) to optimize the CPU Power Management for your specific CPU model which is recommended.  

Although the **Ivy Bridge(-E)** CPU family is totally capable of utilizing XCPM, it has been disabled in macOS for a long time (since OSX 10.11?). But you can [**force-enable**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/Enabling_XCPM_on_Ivy_Bridge_CPUs) it (which is mandatory if you want to have proper CPU Power Management in macOS Ventura).

On macOS Monterey and newer, the `ACPI_SMC_PlatformPlugin` has been dropped completely. Instead, the `X86PlatformPlugin` is now always loaded automatically, since Apple disabled the `plugin-type` check, so you don't even need `SSDT-PLUG` for Haswell and newer.

Since Apple dropped Intel CPU support after 10th Gen Comet Lake, newer Intel CPUs require a fake CPUID ("impersonating" a Comet Lake) in order to run macOS.

## Pick your SSDT
Clicking on an SSDT's name in the table below takes you to the corresponding guide or file to enable CPU power management for the listed CPU family.

CPU Family | Used Plugin | Required SSDT |Configuration Notes
----------------------|:-----------:|:-------------:|-----------
12th Gen (Alder Lake) | **`X86PlatformPlugin`** | [**SSDT-PLUG-ALT**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(SSDT-PLUG)#11th-gen-intel-and-newer)| Requires Comet Lake CPUID
11th Gen Ice/Rocket Lake| **`X86PlatformPlugin`**| [**SSDT-PLUG**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(SSDT-PLUG)#11th-gen-intel-and-newer)| - Not needed in macOS 12+</br> - Requires Comet Lake CPUID
4th to 10th Gen Intel | **`X86PlatformPlugin`**| [**SSDT-PLUG**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(SSDT-PLUG)#readme)| Not needed in macOS 12+
≤ 3rd Gen Ivy Bridge | **`ACPI_SMC_PlatformPlugin`** | [**SSDT-PM**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(Legacy)#readme)| - Plugin dropped from macOS 12+. <br>- Force-enable XCPM for macOS 12+ for proper CPU Power Management
AMD (17h)| **N/A**|[**SSDT-CPUR**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(SSDT-PLUG)#what-about-amd)| - :warning: Only needed for B550 and A520 mainboards!</br> - Enable `DummyPowerManagement` Quirk</br> - Add [SMCAMDProcesser.kext](https://github.com/trulyspinach/SMCAMDProcessor) (AMD Ryzen only)

## Further Resources
- **CPU Support list**: https://dortania.github.io/OpenCore-Install-Guide/macos-limits.html#cpu-support
