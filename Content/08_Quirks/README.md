# OpenCore Quirks for Intel and AMD CPUs 
Quirks (ACPI, Booter, Kernel and UEFI) for Intel and AMD CPUs. Based on the information provided by Dortania's [**OpenCore Install Guide** ](https://dortania.github.io/OpenCore-Install-Guide/) and my own research (for 11 the Gen and newer). Presented in neatly structured tables. 

Also available in [**list form**](/Content/08_Quirks/Quirks_List.md) which is easier to read and maintain and contains newer data, such as Quirks for 11th and 12th Gen Intel Core CPUs.

:bulb: **TIP**: All of these Quirks combinations are included in [**OpenCore Auxiliary Tools**](https://github.com/ic005k/OCAuxiliaryTools) as presets in the corresponding Quirks sections!

**Legend**:

- **x** = Quirk enabled
- **( )** = Quirk disabled, but enabled for certain CPUs/Chipsets/Mainboards (read annotations for quirk in question)
- **(x)** = Quirk enabled, but disabled for certain CPUs/Chipsets/Mainboards (read annotations for quirk in question)
- **empty** = Quirk disabled. And by disabled, I mean *disabled* and not leaving it as is!

**Applicable Version**: OpenCore ≥ 0.7.5

## 8th to 10th Gen Intel CPUs (Desktop, High End, Mobile/NUC)

### SMBIOS Requirements
- 10th Gen Desktop: [**iMac20,1**](https://everymac.com/ultimate-mac-lookup/?search_keywords=iMac20,1) and [**iMac20,2**](https://everymac.com/ultimate-mac-lookup/?search_keywords=iMac20,2). (≥ macOS Catalina)
- 10th Gen Mobile/NUC: [**various**](https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/coffee-lake-plus.html#platforminfo)
- 8th/9th/10th Gen High End Desktop [**iMacPro1,1**](https://dortania.github.io/OpenCore-Install-Guide/config-HEDT/skylake-x.html#platforminfo) (≥ macOS High Sierra)
- 8/9th Gen Desktop: [**iMac19,1**](https://everymac.com/ultimate-mac-lookup/?search_keywords=iMac19,1) (macOS Mojave+), [**iMac18,3**](https://everymac.com/ultimate-mac-lookup/?search_keywords=iMac18,3) (≤ macOS High Sierra)
- 8/9th Gen Mobile/NUC: [**various**](https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/coffee-lake.html#platforminfo)

### ACPI Quirks
| CPU Family | [Comet Lake](https://ark.intel.com/content/www/us/en/ark/products/codename/90354/products-formerly-comet-lake.html) | 10th Gen |Cascade Lake-[X](https://ark.intel.com/content/www/us/en/ark/products/codename/124664/products-formerly-cascade-lake.html#@Desktop)/[W](https://ark.intel.com/content/www/us/en/ark/products/codename/124664/products-formerly-cascade-lake.html#@Workstation), Skylake-[X](https://ark.intel.com/content/www/us/en/ark/products/126699/intel-core-i97980xe-extreme-edition-processor-24-75m-cache-up-to-4-20-ghz.html)/[W](https://ark.intel.com/content/www/us/en/ark/products/126793/intel-xeon-w2195-processor-24-75m-cache-2-30-ghz.html)| [Coffee Lake](https://ark.intel.com/content/www/us/en/ark/products/codename/97787/products-formerly-coffee-lake.html) | 8th/9th Gen | Description |
|:-----------|:---------:|:--------:|:------------:|:----------:|:-----------:|:-----------------|
|**Platform**|[Desktop](https://dortania.github.io/OpenCore-Install-Guide/config.plist/comet-lake.html)|[Mobile/NUC](https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/coffee-lake-plus.html#laptop-coffee-lake-plus-and-comet-lake)|[High End](https://dortania.github.io/OpenCore-Install-Guide/config-HEDT/skylake-x.html)|[Desktop](https://dortania.github.io/OpenCore-Install-Guide/config.plist/coffee-lake.html)|Mobile/NUC [8th Gen](https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/coffee-lake.html) / [9thGen](https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/coffee-lake-plus.html)|Corresponding Config Guide
| **SMBIOS** |iMac20,x|MacBookPro16,x / Macmini8,1|iMacPro1,1|iMac19,1|MacBookPro15,x/16,x / Macmini8,1|PlatformInfo
|                 |           |          ||           |             |             |
|**FadtEnableReset**  ||||||For legacy systems and a few newer laptops. Can fix pwr-button shortcuts. Not recommended unless required.
|**NormalizeHeaders** ||||||Cleans up ACPI headers to avoid boot crashes in macOS 10.13. 
|**RebaseRegions**    ||||||Relocates ACPI memory regions. Not recommended!
|**ResetHwSig**       ||||||Resets FACS table Hardware Signature to 0. Fixes firmware-based issues with waking from hibernation.|
|**ResetLogoStatus**°|(x)|(x)|(x)|(x)|(x)|Sets `Displayed` to `0` (false) in `BRGT` table. Workaround for firmwares containing a `BGRT` table but fail to handle screen updates after displaying the logo. 
|**SyncTableIDs**     ||||||Fixes tables for compatibility with in older Windows versions

`°`Enabled by fefault in `sample.plist`. This Quirk didn't exist at the time the OpenCore Install Guide was written, so it's unknown if it's a requirement. Most likely it's not.

### Boooter Quirks
| CPU Family | Comet Lake | 10th Gen |Cascade Lake X| Coffee Lake | 8th/9th Gen | Description |
|:-----------|:---------:|:--------:|:------------:|:----------:|:-----------:|:-----------------|
|**Platform**|Desktop|Mobile/NUC|High End Desktop|Desktop|Mobile/NUC
| **SMBIOS** |iMac20,X|MacBookPro16,X / Macmini8,1|iMacPro1,1|iMac19,1|MacBookPro15,1 / Macmini8,1|System Management BIOS
|                 |           |          ||           |             |             ||**AllowRelocationBlock**||||||Allows booting macOS through a relocation block. Req. ProvideCustomSlide and AvoidRuntimeDefrag.
|**AvoidRuntimeDefrag**|x|x|x|x|x|Protects from boot.efi runtime memory defragmentation.
|**DevirtualiseMmio**|x|x|x|x||Removes runtime attribute from certain MMIO regions
|**DisableSingleUser**||||||Disables single user mode which improves Security.
|**DisableVariableWrite**||||||Restricts NVRAM access in macOS.
|**DiscardHibernateMap**||||||Reuses original hibernate memory map.
|**EnableSafeModeSlide**|x|x|x|x|x|Patches bootloader to have KASLR enabled in safe mode. Req. ProvideCustomSlide
|**EnableWriteUnprotector**||||||Permits write access to UEFI runtime services code.
|**ForceBooterSignature**||||||Sets macOS boot-signature to OpenCore launcher
|**ForceExitBootServices**||||||Fixed early boot crashes of the firmware. Do not use if you don't know what you're doing!
|**ProtectMemoryRegions**||||||Protects memory regions from incorrect access.
|**ProtectSecureBoot**||||||Protects UEFI Secure Boot variables from being written.
|**ProtectUefiServices**°|x|x||(x)°||Protect UEFI services from being overridden by the firmware.
|**ProvideCustomSlide**|x|x|x|x|x|Provides custom KASLR slide on low memory.
|**ProvideMaxSlide**||||||Provide maximum KASLR slide when higher ones are unavailable.
|**RebuildAppleMemoryMap**|x|x|x|x|x|Generates macOS compatible Memory Map
|**ResizeAppleGpuBars**||||||Reduce GPU PCI BAR sizes for compatibility with macOS.
|**SetupVirtualMap**|||x|x|x|Setup virtual memory at SetVirtualAddresses
|**SignalAppleOS**||||||Report macOS being loaded through OS Info for any OS
|**SyncRuntimePermissions**|x|x|x|x|x|Updates memory permissions for the runtime environment|

`°` Required for Z390 mainboards

### Kernel Quirks
| CPU Family | Comet Lake | 10th Gen |Cascade Lake X| Coffee Lake | 8th/9th Gen | Description |
|:-----------|:---------:|:--------:|:------------:|:----------:|:-----------:|:-----------------|
|**Platform**|Desktop|Mobile/NUC|High End Desktop|Desktop|Mobile/NUC
| **SMBIOS** |iMac20,X|MacBookPro16,X / Macmini8,1|iMacPro1,1|iMac19,1|MacBookPro15,1 / Macmini8,1|System Management BIOS
|                 |           |          ||           |             |             ||**AppleCpuPmCfgLock**||||||Disables MSR modification in AppleIntelCPUPowerManagement.kext
|**AppleXcpmCfgLock**°|(x)|(x)||(x)|(x)|Enables write access for XNU Kernel to enable XCPM power management.
|**AppleXcpmExtraMsrs**||||||Disables multiple MSR access critical for certain CPUs, which have no native XCPM support. This Quirk is disabled on macOS 12+ due to non-existence of the feature
|**AppleXcpmForceBoost**||||||Forces maximum performance in XCPM mode. Not recomm.
|**CustomSMBIOSGuid**°°|( )|( )||( )|( )|Usually relevant for Dell laptops and when having issues with Windows License.
|**DisableIoMapper**|x|x||x|x|Disables IOMapper support in XNU (VT-d).
|**DisableLinkeditJettison**|x|x||x|x|Improves Lilu.kext performance in macOS Big Sur without `keepsyms=1` boot-arg.
|**DisableRtcChecksum**||||||Disables primary checksum (0x58-0x59) writing in AppleRTC.
|**ExtendBTFeatureFlags**||||||Sets FeatureFlags to `0x0F` for full functionality of Bluetooth, including Continuity.
|**ExternalDiskIcons**||||||Forces internal disk icons for all AHCI disks. Avoid if possible!
|**ForceSecureBootScheme**||||||Forces x86 scheme for IMG4 verification. Req. for VMs if SecureBootModel ≠ default
|**IncreasePciBarSize**||||||Allows IOPCIFamily to boot with 2 GB PCI BARs. Avoid!
|**LapicKernelPanic**°°°|( )|( )||( )|( )|Disables kernel panic on LAPIC interrupts.
|**LegacyCommpage**||||||For legacy platforms without SSSE3 support.
|**PanicNoKextDump**|x|x||x|x|Prevents kernel from printing kext dump in panic log. macOS 10.13 and above.
|**PowerTimeoutKernelPanic**|x|x||x|x|Disables kernel panic on setPowerState timeout.
|**ProvideCurrentCpuInfo**||||||Addresses issues with Microsoft Hyper-V.
|**SetApfsTrimTimeout**|-1|-1||-1|-1|Sets trim timeout in ms for APFS filesystems on SSDs.
|**ThirdPartyDrives**||||||Enables TRIM and hibernation Support for SSDs in macOS 10.15 and newer.
|**XhciPortLimit**°°°°|(x)|(x)||(x)|(x)|Patches  various kexts to remove USB port limit of 15.|

`°` `AppleXcpmCfgLock`: Not needed if you can disable CFGLock in BIOS</br>
`°°` `CustomSMBIOSGuid`: Enable for Dell or Sony VAIO</br>
`°°°` `LapicKernelPanic`: Enable for HP Systems</br>
`°°°°` `XhciPortLimit`: Disable for macOS 11.3 and newer – create a USB Port Map instead!

### UEFI Quirks
| CPU Family | Comet Lake | 10th Gen |Cascade Lake X| Coffee Lake | 8th/9th Gen | Description |
|:-----------|:---------:|:--------:|:------------:|:----------:|:-----------:|:-----------------|
|**Platform**|Desktop|Mobile/NUC|High End Desktop|Desktop|Mobile/NUC
| **SMBIOS** |iMac20,X|MacBookPro16,X / Macmini8,1|iMacPro1,1|iMac19,1|MacBookPro15,1 / Macmini8,1|System Management BIOS
|                 |           |          ||           |             |             |
|**ActivateHpetSupport**||||||Force enables HPET, if there's no option for it in the BIOS.
|**DisableSecurityPolicy**||||||Disables platform security policy. Do NOT enable if you're using UEFI Secure Boot.
|**EnableVectorAcceleration**|x|x||||Enables AVX vector acceleration of SHA-512 and SHA-384 hashing algorithms.
|**ExitBootServicesDelay**||||||Adds delay in microseconds after `EXIT_BOOT_SERVICES` event.
|**ForceOcWriteFlash**||||||Enables writing to flash memory for all OpenCore system variables.
|**ForgeUefiSupport**||||||Implements partial UEFI 2.x support on EFI 1.x firmware.
|**IgnoreInvalidFlexRatio**||||||Fixes invalid values in the MSR_FLEX_RATIO (0x194) MSR register.
|**ReleaseUsbOwnership**||x|||x|Attempt to detach USB controller ownership from the firmware driver.
|**ReloadOptionRoms**||||||Query PCI devices and reload their Option ROMs if available
|**RequestBootVarRouting**|x|x||x|x|Required for Startup Disk PrefPane to work.
|**ResizeGpuBars**||||||Configure GPU PCI BAR size
|**TscSyncTimeout**||||||Experimental quirk for debugging TSC synchronization.
|**UnblockFsConnect**°|( )|( )||( )|( )|Useful if drive detection fails and results in an missing boot entries.

`°` `UnblockFsConnect`: Enable on HP Machines
<details>
<summary><strong>6th and 7th Gen Intel Quirks</strong> (Click to show content!)</summary>

## 6th and 7th Gen Intel CPUs (Desktop/Mobile)

### SMBIOS Requirements
- 7th Gen Desktop: 
	- [**iMac18,3**](https://everymac.com/ultimate-mac-lookup/?search_keywords=iMac18,3) (for systems with discrete GPU, using iGPU for computing task only)
	- [**iMac18,1**](https://everymac.com/ultimate-mac-lookup/?search_keywords=iMac18,1) (for systems with using iGPU for display output)
- 7th Gen Mobile/NUC: [**various**](https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/kaby-lake.html#platforminfo)
- 6th Gen Desktop: [**iMac17,1**](https://everymac.com/ultimate-mac-lookup/?search_keywords=iMac17,1) (macOS El Capitan)
- 6th Gen Mobile/NUC: [**various**](https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/skylake.html#platforminfo)

### ACPI Quirks   
| CPU Family      | Kaby Lake    | 7th Gen       | Skylake    | 6th Gen |
|:----------------|:-----------:|:-------------:|:----------:|:-------:|
| **ACPI Quirks** | Desktop     | Mobile        | Desktop    | Mobile  |    
|                 |             | 	        |            |         |
|FadtEnableReset  |
|NormalizeHeaders |
|RebaseRegions    |
|ResetHwSig       | 
|ResetLogoStatus* |(x)|(x)|(x)|(x)|
|SyncTableIDs     |

`*`Default in `sample.plist`

### Booter Quirks
| CPU Family        | Kaby Lake    | 7th Gen      | Skylake    | 6th Gen |
|:------------------|:-----------:|:-------------:|:---------:|:-------:|
| **Booter Quirks** | Desktop     | Mobile        | Desktop   | Mobile  |
|	            |             |               |           |         |
|AllowRelocationBlock||||
|AvoidRuntimeDefrag|x|x|x|x|
|DevirtualiseMmio||||
|DisableSingleUser||||
|DisableVariableWrite||||
|DiscardHibernateMap||||
|EnableSafeModeSlide|x|x|x|x|
|EnableWriteUnprotector|x|x|x|x|
|ForceBooterSignature||||
|ForceExitBootServices||||
|ProtectMemoryRegions||||
|ProtectSecureBoot||||
|ProtectUefiServices||||
|ProvideCustomSlide|x|x|x|x|
|ProvideMaxSlide||||
|RebuildAppleMemoryMap||||
|ResizeAppleGpuBars||||
|SetupVirtualMap|x|x|x|x|
|SignalAppleOS||||
|SyncRuntimePermissions||||

### Kernel Quirks
| CPU Family        | Kaby Lake    | 7th Gen       | Skylake    | 6th Gen |
|:------------------|:-----------:|:-------------:|:----------:|:-------:|
| **Kernel Quirks** | Desktop     | Mobile        | Desktop    | Mobile  |
|                   |             |               |            |         |
|AppleCpuPmCfgLock||||
|AppleXcpmCfgLock|x|x|x|x
|AppleXcpmExtraMsrs||||
|AppleXcpmForceBoost||||
|CustomSMBIOSGuid*|( )|( )|( )|( )|
|DisableIoMapper|x|x|x|x
|DisableLinkeditJettison|x|x|x|x|
|DisableRtcChecksum||||
|ExtendBTFeatureFlags||||
|ExternalDiskIcons||||
|ForceSecureBootScheme||||
|IncreasePciBarSize||||
|LapicKernelPanic**|( )|( )|( )|( )|
|LegacyCommpage||||
|PanicNoKextDump|x|x|x|x|
|PowerTimeoutKernelPanic|x|x|x|x|
|ProvideCurrentCpuInfo||||
|SetApfsTrimTimeout|-1|-1|-1|-1|
|ThirdPartyDrives||||
|XhciPortLimit***|x|x|x|x

`*` `CustomSMBIOSGuid`: Enable for Dell or Sony VAIO Systems</br>
`**` `LapicKernelPanic`: Enable for HP Systems</br>
`***` `XhciPortLimit`: Disable for macOS 11.3 and newer – create a USB Port Map instead!

### UEFI Quirks
| CPU Family      | Kaby Lake    | 7th Gen       | Skylake   | 6th Gen |
|:----------------|:-----------:|:-------------:|:---------:|:-------:|
| **UEFI Quirks** | Desktop     | Mobile        | Desktop   | Mobile  |
|                 |             |               |           |         |
|ActivateHpetSupport||||
|DisableSecurityPolicy||||
|EnableVectorAcceleration||||
|ExitBootServicesDelay||||
|ForceOcWriteFlash||||
|ForgeUefiSupport||||
|IgnoreInvalidFlexRatio||||
|ReleaseUsbOwnership||||
|ReloadOptionRoms||||
|RequestBootVarRouting|x|x|x|x
|ResizeGpuBars||||
|TscSyncTimeout||||
|UnblockFsConnect*|( )|( )|( )|( )|

`*` `UnblockFsConnect`: Enable on HP Machines
</details>
<details>
<summary><strong>4th and 5th Gen Intel Quirks</strong> (Click to show content)</summary>

## 4th and 5th Gen Intel CPUs (Desktop/Mobile)

### SMBIOS Requirements
- 5th Gen Desktop: N/A
- 5th Gen Mobile/NUC: [**various**](https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/broadwell.html#platforminfo)
- 4th Gen Desktop: [**iMac14,4**](https://everymac.com/ultimate-mac-lookup/?search_keywords=iMac14,1) (Haswell with iGPU only) or [**iMac15,1**](https://everymac.com/ultimate-mac-lookup/?search_keywords=iMac15,1) (Haswell with dGPU)
- 4th Gen Mobile/NUC: [**various**](https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/haswell.html#platforminfo)

### ACPI Quirks   
| CPU Family      | Broadwell     | 5th Gen | Haswell | 4th Gen |
|:----------------|:-------------:|:-------:|:-------:|:-------:|
| **ACPI Quirks** | Desktop (N/A) | Mobile  | Desktop | Mobile  |    
|                 |               |         |         |         |
|FadtEnableReset|
|NormalizeHeaders|
|RebaseRegions|
|ResetHwSig| 
|ResetLogoStatus*||x|x|x|
|SyncTableIDs|

`*` Default in `sample.plist`

### Booter Quirks
| CPU Family        | Broadwell     | 5th Gen | Haswell | 4th Gen |
|:------------------|:-------------:|:-------:|:-------:|:-------:|
| **Booter Quirks** | Desktop (N/A) | Mobile  | Desktop | Mobile  |
|		    |		    |  	      |         |         |
|AllowRelocationBlock||||
|AvoidRuntimeDefrag||x|x|x|
|DevirtualiseMmio||||
|DisableSingleUser||||
|DisableVariableWrite||||
|DiscardHibernateMap||||
|EnableSafeModeSlide||x|x|x|
|EnableWriteUnprotector||x|x|x|
|ForceBooterSignature||||
|ForceExitBootServices||||
|ProtectMemoryRegions||||
|ProtectSecureBoot||||
|ProtectUefiServices||||
|ProvideCustomSlide*||x|x|x|
|ProvideMaxSlide||||
|RebuildAppleMemoryMap||||
|ResizeAppleGpuBars||||
|SetupVirtualMap||x|x|x|
|SignalAppleOS||||
|SyncRuntimePermissions||||

`*` `ProvideCustomSlide`: Used for Slide variable calculation. However, the necessity of this quirk is determined by "OCABC: Only N/256 slide values are usable!" message in the debug log. If the message "OCABC: All slides are usable! You can disable `ProvideCustomSlide`!" is present in your log, you can disable ProvideCustomSlide.

### Kernel Quirks
| CPU Family        | Broadwell | 5th Gen | Haswell | 4th Gen |
|:------------------|:---------:|:-------:|:-------:|:-------:|
| **Kernel Quirks** | Desktop (N/A) | Mobile  | Desktop | Mobile |
|                   |           |         |         |         |
|AppleCpuPmCfgLock||||
|AppleXcpmCfgLock°||x|x|x|
|AppleXcpmExtraMsrs||||
|AppleXcpmForceBoost||||
|CustomSMBIOSGuid*||( )|( )|( )
|DisableIoMapper||x|x|x|
|DisableLinkeditJettison||x|x|x|
|DisableRtcChecksum||||
|ExtendBTFeatureFlags||||
|ExternalDiskIcons||||
|ForceSecureBootScheme||||
|IncreasePciBarSize||||
|LapicKernelPanic**||( )|( )|( )
|LegacyCommpage||||
|PanicNoKextDump||x|x|x|
|PowerTimeoutKernelPanic||x|x|x|
|ProvideCurrentCpuInfo||||
|SetApfsTrimTimeout||-1|-1|-1|
|ThirdPartyDrives||||
|XhciPortLimit***||(x)|(x)|(X)|

`°` `AppleXcpmCfgLock`: Not needed if you can disable CFGLock in BIOS</br>
`*` `CustomSMBIOSGuid`: Enable for Dell or Sony VAIO</br>
`**` `LapicKernelPanic`: Enable for HP Systems</br>
`***` `XhciPortLimit`: Disable for macOS 11.3 and newer – create a USB Port Map instead!

### UEFI Quirks
| CPU Family      | Broadwell | 5th Gen | Haswell | 4th Gen |
|:----------------|:---------:|:-------:|:-------:|:-------:|
| **UEFI Quirks** | Desktop (N/A) | Mobile  | Desktop | Mobile|
|                 |           |         |         |         |
|ActivateHpetSupport||||
|DisableSecurityPolicy||||
|EnableVectorAcceleration||||
|ExitBootServicesDelay||||
|ForceOcWriteFlash||||
|ForgeUefiSupport||||
|IgnoreInvalidFlexRatio||x|x|x
|ReleaseUsbOwnership||x||x|
|ReloadOptionRoms||||
|RequestBootVarRouting||x||x
|ResizeGpuBars||-1|-1|-1
|TscSyncTimeout||||
|UnblockFsConnect*||( )|( )|( )

`*` `UnblockFsConnect`: Enable on HP Machines
</details>
<details>
<summary><strong>2nd and 3rd Gen Intel Quirks</strong> (Click to show content)</summary>

## 2nd and 3rd Gen Intel CPUs (Desktop/Mobile)

### SMBIOS Requirements
- 3rd Gen Desktop: 
	- [**iMac13,1**](https://everymac.com/ultimate-mac-lookup/?search_keywords=iMac13,1).For system using the iGPU for driving a display.
	- [**iMac13,2**](https://everymac.com/ultimate-mac-lookup/?search_keywords=iMac13,1). For systems using a dGPU for displaying and the iGPU for computing tasks only.
	- For Big Sur: **iMac14,4** (iGPU), **iMac15,1** (dGPU + iGPU)
- 3rd Gen Mobile/NUC: [**various**](https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/ivy-bridge.html#platforminfo)
- 2nd Gen Desktop: [**iMac14,4**](https://everymac.com/ultimate-mac-lookup/?search_keywords=iMac14,1) (Haswell with iGPU only) or [**iMac15,1**](https://everymac.com/ultimate-mac-lookup/?search_keywords=iMac15,1) (Haswell with dGPU)
- 2nd Gen Mobile/NUC: [**various**](https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/haswell.html#platforminfo)

### ACPI Quirks   
| CPU Family       | Ivy Bridge | 3rd Gen | Sandy Bridge | 2nd Gen |
|:----------------|:----------:|:--------:|:------------:|:-------:|
| **ACPI Quirks** | Desktop    | Mobile   | Desktop      | Mobile  |
|                 |            |          |              |         |
|FadtEnableReset|
|NormalizeHeaders|
|RebaseRegions|
|ResetHwSig| 
|ResetLogoStatus*|(x)|(x)|(x)|(x)|
|SyncTableIDs|

`*` Default in `sample.plist`

### Booter Quirks
| CPU Family        | Ivy Bridge | 3rd Gen | Sandy Bridge | 2nd Gen |
|:------------------|:----------:|:--------:|:-----------:|:-------:|
| **Booter Quirks** | Desktop    | Mobile   | Desktop     | Mobile  |
|                   |            |          |             |         |
|AllowRelocationBlock||||
|AvoidRuntimeDefrag|x|x|x|x|
|DevirtualiseMmio||||
|DisableSingleUser||||
|DisableVariableWrite||||
|DiscardHibernateMap||||
|EnableSafeModeSlide|x|x|x|x|
|EnableWriteUnprotector|x|x|x|x
|ForceBooterSignature||||
|ForceExitBootServices||||
|ProtectMemoryRegions||||
|ProtectSecureBoot||||
|ProtectUefiServices||||
|ProvideCustomSlide*|x|x|x|x
|ProvideMaxSlide||||
|RebuildAppleMemoryMap||||
|ResizeAppleGpuBars||||
|SetupVirtualMap|x|x|x|x|
|SignalAppleOS||||
|SyncRuntimePermissions||||

`*` `ProvideCustomSlide`: Used for Slide variable calculation. However, the necessity of this quirk is determined by "OCABC: Only N/256 slide values are usable!" message in the debug log. If the message "OCABC: All slides are usable! You can disable `ProvideCustomSlide`!" is present in your log, you can disable ProvideCustomSlide.

### Kernel Quirks
| CPU Family        | Ivy Bridge | 3rd Gen | Sandy Bridge | 2nd Gen |
|:------------------|:----------:|:-------:|:------------:|:-------:|
| **Kernel Quirks** | Desktop    | Mobile  | Desktop      | Mobile  |
|                   |            |         |              |         |
|AppleCpuPmCfgLock|x|x|x|x
|AppleXcpmCfgLock||||
|AppleXcpmExtraMsrs||||
|AppleXcpmForceBoost||||
|CustomSMBIOSGuid*||||
|DisableIoMapper|x|x|x|x
|DisableLinkeditJettison|x|x|x|x
|DisableRtcChecksum||||
|ExtendBTFeatureFlags||||
|ExternalDiskIcons||||
|ForceSecureBootScheme||||
|IncreasePciBarSize||||
|LapicKernelPanic**||||
|LegacyCommpage||||
|PanicNoKextDump|x|x|x|x
|PowerTimeoutKernelPanic|x|x|x|x
|ProvideCurrentCpuInfo||||
|SetApfsTrimTimeout||||
|ThirdPartyDrives||||
|XhciPortLimit***|x|x|x|x|

`*` `CustomSMBIOSGuid`: Enable for Dell or Sony VAIO Systems</br>
`**` `LapicKernelPanic`: Enable for HP Systems</br>
`***` `XhciPortLimit`: Disable if your system doesn't have USB 3.0 ports And if you are running macOS 11.3 and newer – create a USB Port Map instead!

### UEFI Quirks
| CPU Family      | Ivy Bridge | 3rd Gen | Sandy Bridge | 2nd Gen |
|:----------------|:----------:|:-------:|:------------:|:-------:|
| **UEFI Quirks** | Desktop    | Mobile  | Desktop      | Mobile  |
|                 |            |         |              |         |
|ActivateHpetSupport||||
|DisableSecurityPolicy||||
|EnableVectorAcceleration||||
|ExitBootServicesDelay||||
|ForceOcWriteFlash||||
|ForgeUefiSupport||||
|IgnoreInvalidFlexRatio|x|x|x|x
|ReleaseUsbOwnership||x||x
|ReloadOptionRoms||||
|RequestBootVarRouting||||
|ResizeGpuBars||||
|TscSyncTimeout||||
|UnblockFsConnect*|( )|( )|( )|( )|

`*` `UnblockFsConnect`: Enable on HP Machines
</details>
<details>
<summary><strong>AMD Quirks</strong> (Click to show content!)</summary>

## AMD Ryzen and Threadripper (17h and 19h)

### SMBIOS Requirements
- **Dektop**: [**various**](https://dortania.github.io/OpenCore-Install-Guide/AMD/zen.html#platforminfo)

### ACPI Quirks    
| CPU Family      | Ryzen and Threadripper |
|:----------------|:--------------------:|
| **ACPI Quirks** | Desktop              |    
|                 |                      |
|FadtEnableReset  |
|NormalizeHeaders |
|RebaseRegions    |
|ResetHwSig       | 
|ResetLogoStatus* |(x)|
|SyncTableIDs     |

`*`Default in `sample.plist`

### Boooter Quirks
| CPU Family         | Ryzen and Threadripper |
|:------------------ |:--------------------:|
| **Booter Quirks**  | Desktop              |    
|                    |                      |
|AllowRelocationBlock|
|AvoidRuntimeDefrag|x
|DevirtualiseMmio°|( )°|
|DisableSingleUser|
|DisableVariableWrite|
|DiscardHibernateMap|
|EnableSafeModeSlide|x
|EnableWriteUnprotector|
|ForceBooterSignature
|ForceExitBootServices
|ProtectMemoryRegions|
|ProtectSecureBoot
|ProtectUefiServices|
|ProvideCustomSlide|
|ProvideMaxSlide
|RebuildAppleMemoryMap|x|
|ResizeAppleGpuBars
|SetupVirtualMap|x|x
|SignalAppleOS
|SyncRuntimePermissions|x|

`°` `DevirtualiseMmio`: Enable for TRx 40</br>

### Kernel Quirks
- For AMD, enable `Kernel` > `Emulate`: `DummyPowerManagement`
- AMD also requires a lot of [**Kernel patches**](https://github.com/AMD-OSX/AMD_Vanilla/tree/master) to make macOS work.

| CPU Family         | Ryzen and Threadripper |
|:------------------ |:--------------------:|
| **kernel Quirks**  | Desktop              |    
|                    |                      |
|AppleCpuPmCfgLock||
|AppleXcpmCfgLock||
|AppleXcpmExtraMsrs||
|AppleXcpmForceBoost||
|CustomSMBIOSGuid||
|DisableIoMapper||
|DisableLinkeditJettison||
|DisableRtcChecksum||
|ExtendBTFeatureFlags||
|ExternalDiskIcons||
|ForceSecureBootScheme||
|IncreasePciBarSize||
|LapicKernelPanic||
|LegacyCommpage||
|PanicNoKextDump|x|
|PowerTimeoutKernelPanic|x|
|ProvideCurrentCpuInfo|x|
|SetApfsTrimTimeout||
|ThirdPartyDrives||
|XhciPortLimit°||

`°` `XhciPortLimit`: Not required on AMD systems, since these boards usually have 2 or more USB controllers with 10 Ports max.

### UEFI Quirks
| CPU Family       | Ryzen and Threadripper |
|:---------------- |:--------------------:|
| **UEFI Quirks**  | Desktop              |    
|                  |                      |
|ActivateHpetSupport||
|DisableSecurityPolicy||
|EnableVectorAcceleration|x|
|ExitBootServicesDelay||
|ForceOcWriteFlash||
|ForgeUefiSupport||
|IgnoreInvalidFlexRatio||
|ReleaseUsbOwnership||
|ReloadOptionRoms||
|RequestBootVarRouting|x|
|ResizeGpuBars||
|TscSyncTimeout||
|UnblockFsConnect°|( )|

`°` `UnblockFsConnect`: Enable on HP Machines

## AMD Bulldozer (15h) and Jaguar (16h)

### SMBIOS Requirements
- **Dektop**: [**various**](https://dortania.github.io/OpenCore-Install-Guide/AMD/fx.html#platforminfo)

### ACPI Quirks    
| CPU Family      | Bulldozer and Jaguar |
|:----------------|:------------------:|
| **ACPI Quirks** | Desktop            |    
|                 |                    |
|FadtEnableReset  |
|NormalizeHeaders |
|RebaseRegions    |
|ResetHwSig       | 
|ResetLogoStatus° |(x)|
|SyncTableIDs     |

`°`Default in `sample.plist`

### Boooter Quirks
| CPU Family         | Bulldozer and Jaguar |
|:------------------ |:------------------:|
| **Booter Quirks**  | Desktop            |    
|                    |                    |
|AllowRelocationBlock|
|AvoidRuntimeDefrag|x
|DevirtualiseMmio||
|DisableSingleUser|
|DisableVariableWrite|
|DiscardHibernateMap|
|EnableSafeModeSlide|x
|EnableWriteUnprotector|X
|ForceBooterSignature
|ForceExitBootServices
|ProtectMemoryRegions|
|ProtectSecureBoot
|ProtectUefiServices|
|ProvideCustomSlide°|X
|ProvideMaxSlide
|RebuildAppleMemoryMap|x|
|ResizeAppleGpuBars
|SetupVirtualMap|x|
|SignalAppleOS
|SyncRuntimePermissions||

`°` `ProvideCustomSlide`: If the message "OCABC: All slides are usable!" appears in the log, you can disable ProvideCustomSlide.

### Kernel Quirks
- For AMD, enable `Kernel` > `Emulate`: `DummyPowerManagement`
- AMD also requires a lot of [**Kernel patches**](https://github.com/AMD-OSX/AMD_Vanilla/tree/master) to make macOS work.

| CPU Family         | Bulldozer and Jaguar |
|:------------------ |:------------------:|
| **kernel Quirks**  | Desktop            |    
|                    |                    |
|AppleCpuPmCfgLock||
|AppleXcpmCfgLock||
|AppleXcpmExtraMsrs||
|AppleXcpmForceBoost||
|CustomSMBIOSGuid||
|DisableIoMapper||
|DisableLinkeditJettison||
|DisableRtcChecksum||
|ExtendBTFeatureFlags||
|ExternalDiskIcons||
|ForceSecureBootScheme||
|IncreasePciBarSize||
|LapicKernelPanic||
|LegacyCommpage||
|PanicNoKextDump|x|
|PowerTimeoutKernelPanic|x|
|ProvideCurrentCpuInfo|x|
|SetApfsTrimTimeout||
|ThirdPartyDrives||
|XhciPortLimit°||

`°` `XhciPortLimit`: Not required on AMD systems, since these boards usually have 2 or more USB controllers with 10 Ports max.

### UEFI Quirks
| CPU Family       | Bulldozer and Jaguar |
|:---------------- |:------------------:|
| **UEFI Quirks**  | Desktop            |    
|                  |                    |
|ActivateHpetSupport||
|DisableSecurityPolicy||
|EnableVectorAcceleration|x|
|ExitBootServicesDelay||
|ForceOcWriteFlash||
|ForgeUefiSupport||
|IgnoreInvalidFlexRatio||
|ReleaseUsbOwnership||
|ReloadOptionRoms||
|RequestBootVarRouting|x|
|ResizeGpuBars||
|TscSyncTimeout||
|UnblockFsConnect°|( )|

`°` `UnblockFsConnect`: Enable on HP Machines
</details>
