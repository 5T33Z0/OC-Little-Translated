## 11th Gen Intel Quirks

Unofficial, unconfirmed and untested on my end. Since Apple stoped using Intel CPUs after 10th, Rocketlake CPUs are not supported and no SMBIOS exists.

Therefore a **MacPro7,1** is emulated. 

### SMBIOS Requirements

- SMBIOS (Desktop): **MacPro7,1**
- Fake CPUID: In Kernel > Emulate, enter the following:

	```text
	Cpuid1Data: EB060900000000000000000000000000
	Cpuid1Mask: FFFFFFFF000000000000000000000000
	```

### ACPI Quirks    
| CPU Family      | Rocktelake | 
|:----------------|:---------:|
| **ACPI Quirks** | Desktop   |      
|			        |           |  
|FadtEnableReset  |
|NormalizeHeaders |
|RebaseRegions    |
|ResetHwSig       | 
|ResetLogoStatus* |(x)|
|SyncTableIDs     |

`*`Default in `sample.plist`

### Boooter Quirks
| CPU Family        | Rocktelake | 
|:------------------|:----------:|
| **Booter Quirks** | Desktop    |
|			          |			   |
|AllowRelocationBlock|
|AvoidRuntimeDefrag|x|
|DevirtualiseMmio|x|
|DisableSingleUser|
|DisableVariableWrite|
|DiscardHibernateMap|
|EnableSafeModeSlide|x
|EnableWriteUnprotector|x|
|ForceBooterSignature
|ForceExitBootServices
|ProtectMemoryRegions|
|ProtectSecureBoot
|ProtectUefiServices*|x|
|ProvideCustomSlide|x|
|ProvideMaxSlide|
|RebuildAppleMemoryMap||
|ResizeAppleGpuBars
|SetupVirtualMap||
|SignalAppleOS
|SyncRuntimePermissions|x|

`*` Required for Z390 mainboards

### Kernel Quirks
| CPU Family      | Rocktelake |
|:----------------|:----------:|
| **Kernel Quirks** | Desktop  |      
|                   |          |
|AppleCpuPmCfgLock||||
|AppleXcpmCfgLock°|(x)|
|AppleXcpmExtraMsrs||
|AppleXcpmForceBoost||
|CustomSMBIOSGuid*|( )|
|DisableIoMapper|x|
|DisableLinkeditJettison|x|
|DisableRtcChecksum|x|
|ExtendBTFeatureFlags||
|ExternalDiskIcons||
|ForceSecureBootScheme||
|IncreasePciBarSize||||
|LapicKernelPanic**|( )|
|LegacyCommpage||
|PanicNoKextDump|x|
|PowerTimeoutKernelPanic|x|
|ProvideCurrentCpuInfo||
|SetApfsTrimTimeout|-1|
|ThirdPartyDrives||
|XhciPortLimit***|( )|

`°` `AppleXcpmCfgLock`: Not needed if you can disable CFGLock in BIOS</br>
`*` `CustomSMBIOSGuid`: Enable for Dell or Sony VAIO</br>
`**` `LapicKernelPanic`: Enable for HP Systems</br>
`***` `XhciPortLimit`: Disable for macOS 11.3 and newer – create a USB Port Map instead!

### UEFI Quirks
| CPU Family      | Rocktelake |
|:----------------|:----------:|
| **UEFI Quirks** | Desktop    |
|			        |	           |
|ActivateHpetSupport||
|DisableSecurityPolicy||
|EnableVectorAcceleration|x|
|ExitBootServicesDelay||
|ForceOcWriteFlash||
|ForgeUefiSupport||
|IgnoreInvalidFlexRatio||
|ReleaseUsbOwnership|x|
|ReloadOptionRoms||
|RequestBootVarRouting|x|
|ResizeGpuBars||
|TscSyncTimeout||
|UnblockFsConnect*|( )|

`*` `UnblockFsConnect`: Enable on HP Machines
</details>
