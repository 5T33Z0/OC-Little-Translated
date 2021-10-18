# OpenCore Quirks for Intel CPUs (Work in Progress)
Required OpenCore Quirks (ACPI, Booter, Kernel and UEFI) for Intel CPUs. Based on the information provide by the [**OpenCore Install Guide** ](https://dortania.github.io/OpenCore-Install-Guide/)by Dortania. Presented in neatly sturctured tables.

**Applicable Version**: OpenCore ≥ 0.7.5

## 8th to 10th Gen Intel CPUs (Desktop/Mobile)

### ACPI Quirks    
| CPU Family      | Cometlake | 10th Gen | Coffeelake | 8th/9th Gen|
|:----------------|:---------:|:--------:|:----------:|:----------:|
| **ACPI Quirks** | Desktop    | Mobile   | Desktop    | Mobile     |      
|				          |				    | 			   |            |            |
|FadtEnableReset  |
|NormalizeHeaders |
|RebaseRegions    |
|ResetHwSig       | 
|ResetLogoStatus* |(x)|(x)|(x)|(x)|
|SyncTableIDs     |

`*`Default in `sample.plist`

### Boooter Quirks
|CPU Family         |Cometlake    |10th Gen     |Coffeelake  | 8th/9th Gen |
|:------------------|:-----------:|:-----------:|:----------:|:-----------:|
| **Booter Quirks** | Desktop      | Mobile      | Desktop     | Mobile     |
|				          |				    | 			   |            |            |
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
|CPU Family         |Cometlake    |10th Gen       |Coffeelake  | 8th/9th Gen |
|:------------------|:-----------:|:-------------:|:----------:|:-----------:|
| **Kernel Quirks** | Desktop      | Mobile        | Desktop    | Mobile      |
|				          |				    | 			   |            |            |
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

`°` `AppleXcpmCfgLock`: Not needed if you can disable CFGLock in BIOS
`*` `CustomSMBIOSGuid`: Enable for Dell or Sony VAIO</br>
`**` `LapicKernelPanic`: Enable for HP Systems</br>
`***` `XhciPortLimit`: Disable for macOS 11.3 and newer – create a USB Port Map instead!

### UEFI Quirks
|CPU Family       |Cometlake    |10th Gen       |Coffeelake  | 8th/9th Gen |
|:----------------|:-----------:|:-------------:|:----------:|:-----------:|
|			     |				    | 			   |            |            |
| **UEFI Quirks** | Desktop      |Mobile         |Desktop     |Mobile       |
|ActivateHpetSupport||||
|DisableSecurityPolicy||||
|EnableVectorAcceleration||||
|ExitBootServicesDelay||||
|ForceOcWriteFlash||||
|ForgeUefiSupport||||
|IgnoreInvalidFlexRatio||||
|ReleaseUsbOwnership||x||x
|ReloadOptionRoms||||
|RequestBootVarRouting|x|x|x|x
|ResizeGpuBars||||
|TscSyncTimeout||||
|UnblockFsConnect||||
<details>
<summary><strong>6th and 7th Gen Intel Quirks</strong> (Click to show content!)</summary>

## 6th and 7th Gen Intel CPUs (Desktop/Mobile)

### ACPI Quirks   
|CPU Family       |Kabylake     |7th Gen        |Skylake     |6th Gen |
|:----------------|:-----------:|:-------------:|:----------:|:------:|
| **ACPI Quirks** | Desktop     | Mobile        | Desktop    | Mobile |    
|                 |	 		     | 		        |            |        |
|FadtEnableReset|
|NormalizeHeaders|
|RebaseRegions|
|ResetHwSig| 
|ResetLogoStatus* |(x)|(x)|(x)|(x)|
|SyncTableIDs|

`*`Default in `sample.plist`

### Booter Quirks
|CPU Family          |Kabylake     |7th Gen        |Skylake     |6th Gen |
|:-------------------|:-----------:|:-------------:|:----------:|:------:|
| **Booter Quirkss** | Desktop     | Mobile        | Desktop    | Mobile |
|						 |			     |               |            |        |
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
|UnblockFsConnect||||
</details>
<details>
<summary><strong>4th and 5th Gen Intel Quirks</strong> (Work in Progress)</summary>

## 4th and 5th Gen Intel CPUs (Desktop/Mobile)
### ACPI Quirks   
|CPU Family       | Broadwell | 5th Gen | Haswell | 4th Gen |
|:----------------|:---------:|:-------:|:-------:|:-------:|
| **ACPI Quirks** | Desktop    | Mobile  | Desktop | Mobile  |    
|				          |				    | 			   |            |            |
|FadtEnableReset|
|NormalizeHeaders|
|RebaseRegions|
|ResetHwSig| 
|ResetLogoStatus*|x| x|x|x|
|SyncTableIDs|
`*`Default in sample.plist

### Booter Quirks
|CPU Family          | Broadwell | 5th Gen | Haswell | 4th Gen |
|:-------------------|:---------:|:-------:|:-------:|:-------:|
| **Booter Quirkss** | Desktop    | Mobile  | Desktop | Mobile  |
|				          |				    | 			   |            |            |
|AllowRelocationBlock||||
|AvoidRuntimeDefrag||||
|DevirtualiseMmio||||
|DisableSingleUser||||
|DisableVariableWrite||||
|DiscardHibernateMap||||
|EnableSafeModeSlide|||||
|EnableWriteUnprotector||||
|ForceBooterSignature||||
|ForceExitBootServices||||
|ProtectMemoryRegions||||
|ProtectSecureBoot||||
|ProtectUefiServices||||
|ProvideCustomSlide||||
|ProvideMaxSlide||||
|RebuildAppleMemoryMap||||
|ResizeAppleGpuBars||||
|SetupVirtualMap||||
|SignalAppleOS||||
|SyncRuntimePermissions||||

### Kernel Quirks
|CPU Family       |Broadwell |5th Gen |Haswell |4th Gen |
|:----------------|:--------:|:------:|:------:|:------:|
| **Kernel Quirks** | Desktop |Mobile  |Desktop |Mobile  |
|				          |				    | 			   |            |            |
|AppleCpuPmCfgLock||||
|AppleXcpmCfgLock||||
|AppleXcpmExtraMsrs||||
|AppleXcpmForceBoost||||
|CustomSMBIOSGuid||||
|DisableIoMapper||||
|DisableLinkeditJettison||||
|DisableRtcChecksum||||
|ExtendBTFeatureFlags||||
|ExternalDiskIcons||||
|ForceSecureBootScheme||||
|IncreasePciBarSize||||
|LapicKernelPanic||||
|LegacyCommpage||||
|PanicNoKextDump||||
|PowerTimeoutKernelPanic||||
|ProvideCurrentCpuInfo||||
|SetApfsTrimTimeout||||
|ThirdPartyDrives||||
|XhciPortLimit||||

### UEFI Quirks
|CPU Family       |Broadwell |5th Gen |Haswell |4th Gen |
|:----------------|:--------:|:------:|:------:|:------:|
| **UEFI Quirks** |Desktop    |Mobile  |Desktop |Mobile  |
|				          |				    | 			   |            |            |
|ActivateHpetSupport||||
|DisableSecurityPolicy||||
|EnableVectorAcceleration||||
|ExitBootServicesDelay||||
|ForceOcWriteFlash||||
|ForgeUefiSupport||||
|IgnoreInvalidFlexRatio||||
|ReleaseUsbOwnership||||
|ReloadOptionRoms||||
|RequestBootVarRouting||||
|ResizeGpuBars||||
|TscSyncTimeout||||
|UnblockFsConnect||||
</details>
<details>
<summary><strong>2nd and 3rd Gen Intel Quirks</strong> (Work in Progress)</summary>

## 2nd and 3rd Gen Intel CPUs (Desktop/Mobile)

### ACPI Quirks   
|CPU Family       |Ivy Bridge |3rd Gen |Sandy Bridge |2nd Gen |
|:----------------|:--------:|:------:|:------:|:------:|
|				          |				    | 			   |            |            |
| **ACPI Quirks** | Desktop   | Mobile |Desktop |Mobile  |    
|FadtEnableReset|
|NormalizeHeaders|
|RebaseRegions|
|ResetHwSig| 
|ResetLogoStatus*|x| x|x|x|
|SyncTableIDs|
`*`Default in sample.plist

### Booter Quirks
|CPU Family       |Ivy Bridge |3rd Gen |Sandy Bridge |2nd Gen |
|:----------------|:--------:|:------:|:------:|:------:|
|				          |				    | 			   |            |            |
| **Booter Quirkss** | Desktop      | Mobile        |Desktop     |Mobile  |
|AllowRelocationBlock||||
|AvoidRuntimeDefrag||||
|DevirtualiseMmio||||
|DisableSingleUser||||
|DisableVariableWrite||||
|DiscardHibernateMap||||
|EnableSafeModeSlide|||||
|EnableWriteUnprotector||||
|ForceBooterSignature||||
|ForceExitBootServices||||
|ProtectMemoryRegions||||
|ProtectSecureBoot||||
|ProtectUefiServices||||
|ProvideCustomSlide||||
|ProvideMaxSlide||||
|RebuildAppleMemoryMap||||
|ResizeAppleGpuBars||||
|SetupVirtualMap||||
|SignalAppleOS||||
|SyncRuntimePermissions||||

### Kernel Quirks
|CPU Family       |Ivy Bridge |3rd Gen |Sandy Bridge |2nd Gen |
|:----------------|:--------:|:------:|:------:|:------:|
| **Kernel Quirks** | Desktop      |Mobile         |Desktop     |Mobile  |
|				          |				    | 			   |            |            |
|AppleCpuPmCfgLock||||
|AppleXcpmCfgLock||||
|AppleXcpmExtraMsrs||||
|AppleXcpmForceBoost||||
|CustomSMBIOSGuid||||
|DisableIoMapper||||
|DisableLinkeditJettison||||
|DisableRtcChecksum||||
|ExtendBTFeatureFlags||||
|ExternalDiskIcons||||
|ForceSecureBootScheme||||
|IncreasePciBarSize||||
|LapicKernelPanic||||
|LegacyCommpage||||
|PanicNoKextDump||||
|PowerTimeoutKernelPanic||||
|ProvideCurrentCpuInfo||||
|SetApfsTrimTimeout||||
|ThirdPartyDrives||||
|XhciPortLimit||||

### UEFI Quirks
|CPU Family       |Ivy Bridge |3rd Gen |Sandy Bridge |2nd Gen |
|:----------------|:--------:|:------:|:------:|:------:|
|				          |				    | 			   |            |            |
| **UEFI Quirks** | Desktop      |Mobile         |Desktop     |Mobile  |
|ActivateHpetSupport||||
|DisableSecurityPolicy||||
|EnableVectorAcceleration||||
|ExitBootServicesDelay||||
|ForceOcWriteFlash||||
|ForgeUefiSupport||||
|IgnoreInvalidFlexRatio||||
|ReleaseUsbOwnership||||
|ReloadOptionRoms||||
|RequestBootVarRouting||||
|ResizeGpuBars||||
|TscSyncTimeout||||
|UnblockFsConnect||||
</details>
<details>
<summary><strong>1st Gen Intel Quirks</strong> (Work in Progress)</summary>

## 1st Gen Intel CPUs (Desktop/Mobile)

### ACPI Quirks   
|CPU Family       |Bloomfield |1st Gen |
|:----------------|:--------:|:------:|
|				          |				    | 			   |            |            |
| **ACPI Quirks** | Desktop   | Mobile | 
|FadtEnableReset|
|NormalizeHeaders|
|RebaseRegions|
|ResetHwSig| 
|ResetLogoStatus*|x| x|x|x|
|SyncTableIDs|
`*`Default in sample.plist

### Booter Quirks
|CPU Family       |Ivy Bridge |3rd Gen |Sandy Bridge |2nd Gen |
|:----------------|:--------:|:------:|:------:|:------:|
| **Booter Quirkss** | Desktop      | Mobile        |Desktop     |Mobile  |
|				          |				    | 			   |            |            |
|AllowRelocationBlock||||
|AvoidRuntimeDefrag||||
|DevirtualiseMmio||||
|DisableSingleUser||||
|DisableVariableWrite||||
|DiscardHibernateMap||||
|EnableSafeModeSlide|||||
|EnableWriteUnprotector||||
|ForceBooterSignature||||
|ForceExitBootServices||||
|ProtectMemoryRegions||||
|ProtectSecureBoot||||
|ProtectUefiServices||||
|ProvideCustomSlide||||
|ProvideMaxSlide||||
|RebuildAppleMemoryMap||||
|ResizeAppleGpuBars||||
|SetupVirtualMap||||
|SignalAppleOS||||
|SyncRuntimePermissions||||

### Kernel Quirks
|CPU Family       |Ivy Bridge |3rd Gen |Sandy Bridge |2nd Gen |
|:----------------|:--------:|:------:|:------:|:------:|
| **Kernel Quirks** | Desktop      |Mobile         |Desktop     |Mobile  |
|				          |				    | 			   |            |            |
|AppleCpuPmCfgLock||||
|AppleXcpmCfgLock||||
|AppleXcpmExtraMsrs||||
|AppleXcpmForceBoost||||
|CustomSMBIOSGuid||||
|DisableIoMapper||||
|DisableLinkeditJettison||||
|DisableRtcChecksum||||
|ExtendBTFeatureFlags||||
|ExternalDiskIcons||||
|ForceSecureBootScheme||||
|IncreasePciBarSize||||
|LapicKernelPanic||||
|LegacyCommpage||||
|PanicNoKextDump||||
|PowerTimeoutKernelPanic||||
|ProvideCurrentCpuInfo||||
|SetApfsTrimTimeout||||
|ThirdPartyDrives||||
|XhciPortLimit||||

### UEFI Quirks
|CPU Family       |Ivy Bridge |3rd Gen |Sandy Bridge |2nd Gen |
|:----------------|:--------:|:------:|:------:|:------:|
| **UEFI Quirks** | Desktop      |Mobile         |Desktop     |Mobile  |
|				          |				    | 			   |            |            |
|ActivateHpetSupport||||
|DisableSecurityPolicy||||
|EnableVectorAcceleration||||
|ExitBootServicesDelay||||
|ForceOcWriteFlash||||
|ForgeUefiSupport||||
|IgnoreInvalidFlexRatio||||
|ReleaseUsbOwnership||||
|ReloadOptionRoms||||
|RequestBootVarRouting||||
|ResizeGpuBars||||
|TscSyncTimeout||||
|UnblockFsConnect||||
</details>


