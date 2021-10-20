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
| CPU Family      | Rocktelake  11th Gen | 
|:----------------|:---------:|:---------:
| **ACPI Quirks** | Desktop   | Mobile   |      
|			        |           | 		    |  
|FadtEnableReset  |
|NormalizeHeaders |
|RebaseRegions    |
|ResetHwSig       | 
|ResetLogoStatus* |(x)|()|()|()|
|SyncTableIDs     |

`*`Default in `sample.plist`

### Boooter Quirks
| CPU Family        | Rocktelake  11th Gen | 
|:------------------|:---------:|:---------:|
| **Booter Quirks** | Desktop   | Mobile   |
|			          |			  | 		   |
|AllowRelocationBlock|
|AvoidRuntimeDefrag|x|x|x|x
|DevirtualiseMmio|x|x|x
|DisableSingleUser|
|DisableVariableWrite|
|DiscardHibernateMap|
|EnableSafeModeSlide|x|x|x|x
|EnableWriteUnprotector|x|
|ForceBooterSignature
|ForceExitBootServices
|ProtectMemoryRegions|
|ProtectSecureBoot
|ProtectUefiServices*|x|x|(x)*|
|ProvideCustomSlide|x|x|x|x
|ProvideMaxSlide
|RebuildAppleMemoryMap||
|ResizeAppleGpuBars
|SetupVirtualMap|||x|x
|SignalAppleOS
|SyncRuntimePermissions|x|x|x|x

`*` Required for Z390 mainboards

### Kernel Quirks
| CPU Family      | Rocktelake  11th Gen   | 
|:----------------|:---------:|:----------:|
| **Kernel Quirks** | Desktop     | Mobile |      
|                   |             |        |
|AppleCpuPmCfgLock||||
|AppleXcpmCfgLock°|(x)|(x)|(x)|(x)
|AppleXcpmExtraMsrs||||
|AppleXcpmForceBoost||||
|CustomSMBIOSGuid*|( )|( )|( )|( )
|DisableIoMapper|x|||
|DisableLinkeditJettison|x|||
|DisableRtcChecksum|x|||
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
|XhciPortLimit***|( )|())|()|()

`°` `AppleXcpmCfgLock`: Not needed if you can disable CFGLock in BIOS</br>
`*` `CustomSMBIOSGuid`: Enable for Dell or Sony VAIO</br>
`**` `LapicKernelPanic`: Enable for HP Systems</br>
`***` `XhciPortLimit`: Disable for macOS 11.3 and newer – create a USB Port Map instead!

### UEFI Quirks
| CPU Family      | Rocktelake 11th Gen | 
|:----------------|:---------:|:---------:|
| **UEFI Quirks** | Desktop      | Mobile         | Desktop    | Mobile      |
|			        |	             |                |            |             |
|ActivateHpetSupport||||
|DisableSecurityPolicy||||
|EnableVectorAcceleration|x|||
|ExitBootServicesDelay||||
|ForceOcWriteFlash||||
|ForgeUefiSupport||||
|IgnoreInvalidFlexRatio||||
|ReleaseUsbOwnership|x|||
|ReloadOptionRoms||||
|RequestBootVarRouting|x|x|x|x
|ResizeGpuBars||||
|TscSyncTimeout||||
|UnblockFsConnect*|( )|( )|( )|( )|

`*` `UnblockFsConnect`: Enable on HP Machines
</details>
