# OpenCore Quirks for Intel CPUs
Required OpenCore Quirks (ACPI, Booter, Kernel and UEFI) for Intel CPUs. Based on the information provide by the [**OpenCore Install Guide** ](https://dortania.github.io/OpenCore-Install-Guide/)by Dortania. Presented in neatly sturctured tables.

**Applicable Version**: OpenCore ≥ 0.7.5

## 8th to 10th Gen Intel CPUs (Desktop/Mobile)

### SMBIOS Requirements
- 10th Gen Dektop: [**iMac20,1**](https://everymac.com/ultimate-mac-lookup/?search_keywords=iMac20,1) and [**iMac20,2**](https://everymac.com/ultimate-mac-lookup/?search_keywords=iMac20,2). (≥ macOS Catalina)
- 10th Gen Mobile/NUC: [**various**](https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/coffee-lake-plus.html#platforminfo)
- 8/9th Gen Desktop: [**iMac19,1**](https://everymac.com/ultimate-mac-lookup/?search_keywords=iMac19,1) (macOS Mojave+), [**iMac18,3**](https://everymac.com/ultimate-mac-lookup/?search_keywords=iMac18,3) (≤ macOS High Sierra)
- 8/9th Gen Mobile/NUC: [**various**](https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/coffee-lake.html#platforminfo)

### ACPI Quirks    
| CPU Family      | Cometlake | 10th Gen | Coffeelake | 8th/9th Gen |
|:----------------|:---------:|:--------:|:----------:|:-----------:|
| **ACPI Quirks** | Desktop   | Mobile   | Desktop    | Mobile      |      
|		  |           |		 |            |             |
|FadtEnableReset  |
|NormalizeHeaders |
|RebaseRegions    |
|ResetHwSig       | 
|ResetLogoStatus* |(x)|(x)|(x)|(x)|
|SyncTableIDs     |

`*`Default in `sample.plist`

### Boooter Quirks
| CPU Family        | Cometlake | 10th Gen | Coffeelake | 8th/9th Gen |
|:------------------|:---------:|:--------:|:----------:|:-----------:|
| **Booter Quirks** | Desktop   | Mobile   | Desktop    | Mobile      |
|	            |		| 	   |            |             |
|AllowRelocationBlock|
|AvoidRuntimeDefrag|x|x|x|x
|DevirtualiseMmio|x|x|x
|DisableSingleUser|
|DisableVariableWrite|
|DiscardHibernateMap|
|EnableSafeModeSlide|x|x|x|x
|EnableWriteUnprotector
|ForceBooterSignature
|ForceExitBootServices
|ProtectMemoryRegions|
|ProtectSecureBoot
|ProtectUefiServices*|x|x|(x)*|
|ProvideCustomSlide|x|x|x|x
|ProvideMaxSlide
|RebuildAppleMemoryMap|x|x|x|x
|ResizeAppleGpuBars
|SetupVirtualMap|||x|x
|SignalAppleOS
|SyncRuntimePermissions|x|x|x|x

`*` Required for Z390 mainboards

### Kernel Quirks
| CPU Family        | Cometlake   | 10th Gen      | Coffeelake | 8th/9th Gen |
|:------------------|:-----------:|:-------------:|:----------:|:-----------:|
| **Kernel Quirks** | Desktop     | Mobile        | Desktop    | Mobile      |
|                   |             |               |            |             |
|AppleCpuPmCfgLock||||
|AppleXcpmCfgLock°|(x)|(x)|(x)|(x)
|AppleXcpmExtraMsrs||||
|AppleXcpmForceBoost||||
|CustomSMBIOSGuid*|( )|( )|( )|( )
|DisableIoMapper|x|x|x|x
|DisableLinkeditJettison|x|x|x|x
|DisableRtcChecksum||||
|ExtendBTFeatureFlags||||
|ExternalDiskIcons||||
|ForceSecureBootScheme||||
|IncreasePciBarSize||||
|LapicKernelPanic**|( )|( )|( )|( )
|LegacyCommpage||||
|PanicNoKextDump|x|x|x|x
|PowerTimeoutKernelPanic|x|x|x|x
|ProvideCurrentCpuInfo||||
|SetApfsTrimTimeout|-1|-1|-1|-1
|ThirdPartyDrives||||
|XhciPortLimit***|(x)|(x)|(x)|(x)

`°` `AppleXcpmCfgLock`: Not needed if you can disable CFGLock in BIOS</br>
`*` `CustomSMBIOSGuid`: Enable for Dell or Sony VAIO</br>
`**` `LapicKernelPanic`: Enable for HP Systems</br>
`***` `XhciPortLimit`: Disable for macOS 11.3 and newer – create a USB Port Map instead!

### UEFI Quirks
|CPU Family       | Cometlake    | 10th Gen       | Coffeelake | 8th/9th Gen |
|:----------------|:------------:|:--------------:|:----------:|:-----------:|
| **UEFI Quirks** | Desktop      | Mobile         | Desktop    | Mobile      |
|			        |	             |                |            |             |
|ActivateHpetSupport||||
|DisableSecurityPolicy||||
|EnableVectorAcceleration|x|x||
|ExitBootServicesDelay||||
|ForceOcWriteFlash||||
|ForgeUefiSupport||||
|IgnoreInvalidFlexRatio||||
|ReleaseUsbOwnership||x||x
|ReloadOptionRoms||||
|RequestBootVarRouting|x|x|x|x
|ResizeGpuBars||||
|TscSyncTimeout||||
|UnblockFsConnect*|( )|( )|( )|( )|

`*` `UnblockFsConnect`: Enable on HP Machines
<details>
<summary><strong>6th and 7th Gen Intel Quirks</strong> (Click to show content!)</summary>

## 6th and 7th Gen Intel CPUs (Desktop/Mobile)

### SMBIOS Requirements
- 7th Gen Desktop: 
	- [**iMac18,3**](https://everymac.com/ultimate-mac-lookup/?search_keywords=iMac18,3) (for systems with discrete GPU, using iGPU for computing taks only)
	- [**iMac18,1**](https://everymac.com/ultimate-mac-lookup/?search_keywords=iMac18,1) (for systems with using iGPU for display output)
- 7th Gen Mobile/NUC: [**various**](https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/kaby-lake.html#platforminfo)
- 6th Gen Desktop: [**iMac17,1**](https://everymac.com/ultimate-mac-lookup/?search_keywords=iMac17,1) (macOS El Capitan)
- 6th Gen Mobile/NUC: [**various**](https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/skylake.html#platforminfo)

### ACPI Quirks   
|CPU Family       |Kabylake     |7th Gen        |Skylake     |6th Gen |
|:----------------|:-----------:|:-------------:|:----------:|:------:|
| **ACPI Quirks** | Desktop     | Mobile        | Desktop    | Mobile |    
|                 |             | 		        |            |        |
|FadtEnableReset  |
|NormalizeHeaders |
|RebaseRegions    |
|ResetHwSig       | 
|ResetLogoStatus* |(x)|(x)|(x)|(x)|
|SyncTableIDs     |

`*`Default in `sample.plist`

### Booter Quirks
|CPU Family         | Kabylake    | 7th Gen      | Skylake    | 6th Gen |
|:------------------|:-----------:|:-------------:|:---------:|:-------:|
| **Booter Quirks** | Desktop     | Mobile        | Desktop   | Mobile  |
|						|			    |               |           |         |
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
| CPU Family        | Kabylake    | 7th Gen       | Skylake    | 6th Gen |
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
|CPU Family       | Kabylake    | 7th Gen       | Skylake   | 6th Gen |
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
|CPU Family       | Broadwell | 5th Gen | Haswell | 4th Gen |
|:----------------|:---------:|:-------:|:-------:|:-------:|
| **ACPI Quirks** | Desktop (N/A) | Mobile  | Desktop | Mobile |    
|			        |           |         |         |         |
|FadtEnableReset|
|NormalizeHeaders|
|RebaseRegions|
|ResetHwSig| 
|ResetLogoStatus*||x|x|x|
|SyncTableIDs|

`*` Default in `sample.plist`

### Booter Quirks
|CPU Family         | Broadwell | 5th Gen | Haswell | 4th Gen |
|:------------------|:---------:|:-------:|:-------:|:-------:|
| **Booter Quirks** | Desktop (N/A) | Mobile  | Desktop | Mobile |
|			          |		     |  	     |         |         |
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
|CPU Family         | Broadwell | 5th Gen | Haswell | 4th Gen |
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
|CPU Family       | Broadwell | 5th Gen | Haswell | 4th Gen |
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
