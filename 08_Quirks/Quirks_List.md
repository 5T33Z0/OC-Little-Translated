# Quirks
Collection of Booter, Kernel and UEFI Quirks for AMD and Intel CPUs.

## Booter Quirks

### High End Desktop

#### Intel Skylake X/W and Cascade Lake X/W (High End Desktop)
- AvoidRuntimeDefrag
- DevirtualiseMmio
- EnableSafeModeSlide
- ProvideCustomSlide
- RebuildAppleMemoryMap
- SetupVirtualMap
- SyncRuntimePermissions
- ProvideMaxSlide: 0

#### Intel Skylake X/W and Cascade Lake X/W (ASUS HEDT)
- AvoidRuntimeDefrag
- DevirtualiseMmio
- EnableSafeModeSlide
- ProvideCustomSlide
- RebuildAppleMemoryMap
- SyncRuntimePermissions
- ProvideMaxSlide: 0

#### Intel Haswell-E, Broadwell-E, Sandy Bridge-E and Ivy Bridge-E (HEDT)
- AvoidRuntimeDefrag
- EnableSafeModeSlide
- EnableWriteUnprotector
- ProvideCustomSlide
- SetupVirtualMap
- ProvideMaxSlide: 0

### Intel Core i5/i7/i9

#### Intel 10th Gen Comet Lake and 11th Gen Rocket Lake (Dektop/Mobile/Nuc)
- AvoidRuntimeDefrag
- DevirtualiseMmio
- EnableSafeModeSlide
- ProtectUefiServices
- ProvideCustomSlide
- RebuildAppleMemoryMap
- SyncRuntimePermissions
- ProvideMaxSlide: 0

#### Intel 8th and 9th Gen Coffee Lake (Desktop)
- AvoidRuntimeDefrag
- DevirtualiseMmio
- EnableSafeModeSlide
- ProvideCustomSlide
- RebuildAppleMemoryMap
- SetupVirtualMap
- SyncRuntimePermissions
- ProvideMaxSlide: 0

#### Intel 9th Gen Coffee Lake (Z390 Chipset)
- AvoidRuntimeDefrag
- DevirtualiseMmio
- EnableSafeModeSlide
- ProtectUefiServices
- ProvideCustomSlide
- RebuildAppleMemoryMap
- SetupVirtualMap
- SyncRuntimePermissions
- ProvideMaxSlide: 0

#### Intel 8th and 9th Gen Coffee Lake (Mobile/Nuc)
- AvoidRuntimeDefrag
- EnableSafeModeSlide
- ProvideCustomSlide
- RebuildAppleMemoryMap
- SetupVirtualMap
- SyncRuntimePermissions
- ProvideMaxSlide: 0

#### Intel 6th Gen Skylake and 7th Gen Kaby Lake (Desktop/Mobile/NUC)
- AvoidRuntimeDefrag
- EnableSafeModeSlide
- EnableWriteUnprotector
- ProvideCustomSlide
- SetupVirtualMap
- ProvideMaxSlide: 0

#### Intel 4th Gen Haswell and 5th Gen Broadwell (Desktop/Mobile/NUC)
- AvoidRuntimeDefrag
- EnableSafeModeSlide
- EnableWriteUnprotector
- ProvideCustomSlide
- SetupVirtualMap
- ProvideMaxSlide: 0

#### Intel 2nd Gen Sandy Bridge and 3rd Gen Ivy Bridge (Desktop/Mobile/NUC)
- AvoidRuntimeDefrag
- EnableSafeModeSlide
- EnableWriteUnprotector
- ProvideCustomSlide
- SetupVirtualMap
- ProvideMaxSlide: 0

### AMD 

#### AMD Ryzen (17h)
- AvoidRuntimeDefrag
- EnableSafeModeSlide
- RebuildAppleMemoryMap
- SetupVirtualMap
- SyncRuntimePermissions

#### AMD Threadripper TRx 40 (19h)
- AvoidRuntimeDefrag
- DevirtualiseMmio
- EnableSafeModeSlide
- RebuildAppleMemoryMap
- SetupVirtualMap
- SyncRuntimePermissions

#### AMD Bulldozer (15h) and Jaguar (16h)
- AvoidRuntimeDefrag
- EnableSafeModeSlide
- EnableWriteUnprotector
- ProvideCustomSlide
- RebuildAppleMemoryMap
- SetupVirtualMap
- MaxSlide: 0

## Kernel Quirks

### High End Desktop

#### Intel Skylake X/W and Cascade Lake X/W (High End Desktop)
- AppleXcpmCfgLock
- DisableIoMapper
- DisableLinkeditJettison
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

#### Intel Skylake X/W and Cascade Lake X/W (HP HEDT)
- AppleXcpmCfgLock
- DisableIoMapper
- DisableLinkeditJettison
- LapicKernelPanic
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

#### Intel Broadwell-E and Haswell-E (HEDT)
- AppleXcpmCfgLock
- AppleXcpmExtraMsrs
- DisableIoMapper
- DisableLinkeditJettison
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

#### Intel Broadwell-E and Haswell-E (HP HEDT)
- AppleXcpmCfgLock
- AppleXcpmExtraMsrs
- DisableIoMapper
- DisableLinkeditJettison
- LapicKernelPanic
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

#### Intel Sandy Bridge-E and Ivy Bridge-E (HEDT)
- AppleCpuPmCfgLock
- AppleXcpmExtraMsrs
- DisableIoMapper
- DisableLinkeditJettison
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

#### Intel Sandy Bridge-E and Ivy Bridge-E (HP HEDT)
- AppleCpuPmCfgLock
- AppleXcpmExtraMsrs
- DisableIoMapper
- DisableLinkeditJettison
- LapicKernelPanic
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

### Intel Core i5/i7i9

#### Intel 11th Gen Rocket Lake (Dektop/Mobile/Nuc)
Usupported CPU. Requires Fake CPU-ID

- Kernel > Emulate
	- **Cpuid1Data**: EB060900000000000000000000000000
	- **Cpuid1Mask**: FFFFFFFF000000000000000000000000
- AppleXcpmCfgLock
- DisableIoMapper
- DisableLinkeditJettison
- DisableRtcChecksum
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

#### Intel 10th Gen Comet Lake (Dektop/Mobile/Nuc)
- AppleXcpmCfgLock
- DisableIoMapper
- DisableLinkeditJettison
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

#### Intel 10th Gen Comet Lake (Dell/Sony VAIO)
- AppleXcpmCfgLock
- CustomSMBIOSGuid
- DisableIoMapper
- DisableLinkeditJettison
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

#### Intel 10th Gen Comet Lake (HP)
- AppleXcpmCfgLock
- DisableIoMapper
- DisableLinkeditJettison
- LapicKernelPanic
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

#### Intel 8th and 9th Gen Coffee Lake (Desktop/Mobile/NUC)
- AppleXcpmCfgLock
- DisableIoMapper
- DisableLinkeditJettison
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

#### Intel 8th and 9th Gen Coffee Lake (Dell/Sony VAIO)
- AppleXcpmCfgLock
- CustomSMBIOSGuid
- DisableIoMapper
- DisableLinkeditJettison
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

#### Intel 8th and 9th Gen Coffee Lake (HP)

- AppleXcpmCfgLock
- DisableIoMapper
- DisableLinkeditJettison
- LapicKernelPanic
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

#### Intel 6th Gen Skylake and 7th Gen Kaby Lake (Desktop/Mobile/NUC)
- AppleXcpmCfgLock
- DisableIoMapper
- DisableLinkeditJettison
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

#### Intel 6th Gen Skylake and 7th Gen Kaby Lake (Dell/SonyVaio)
- AppleXcpmCfgLock
- CustomSMBIOSGuid
- DisableIoMapper
- DisableLinkeditJettison
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

#### Intel 6th Gen Skylake and 7th Gen Kaby Lake (HP)
- AppleXcpmCfgLock
- DisableIoMapper
- DisableLinkeditJettison
- LapicKernelPanic
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

#### Intel 4th Gen Haswell and 5th Gen Broadwell (Desktop/Mobile/NUC)
- AppleXcpmCfgLock
- DisableIoMapper
- DisableLinkeditJettison
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

#### Intel 4th Gen Haswell and 5th Gen Broadwell (Dell/Sony VAIO)
- AppleXcpmCfgLock
- CustomSMBIOSGuid
- DisableIoMapper
- DisableLinkeditJettison
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

#### Intel 4th Gen Haswell and 5th Gen Broadwell (HP)
- AppleXcpmCfgLock
- DisableIoMapper
- DisableLinkeditJettison
- LapicKernelPanic
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

#### Intel 2nd Gen Sandy Bridge and 3rd Gen Ivy Bridge (Desktop/Mobile/NUC)
- AppleCpuPmCfgLock
- DisableIoMapper
- DisableLinkeditJettison
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

#### Intel 2nd Gen Sandy Bridge and 3rd Gen Ivy Bridge (Dell/Sony VAIO)
- AppleCpuPmCfgLock
- CustomSMBIOSGuid
- DisableIoMapper
- DisableLinkeditJettison
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

#### Intel 2nd Gen Sandy Bridge and 3rd Gen Ivy Bridge (HP)
- AppleCpuPmCfgLock
- DisableIoMapper
- DisableLinkeditJettison
- LapicKernelPanic
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- XhciPortLimit

### AMD

#### AMD Ryzen (17h), Threadripper (19h), Bulldozer (15h), Jaguar (16h)
- PanicNoKextDump
- PowerTimeoutKernelPanic
- ProvideCurrentCpuInfo

**NOTES**

- `AppleXcpmCfgLock`: Not needed if you can disable CFGLock in BIOS 
- `XhciPortLimit`: Disable for macOS 11.3 and newer – create a custom USB Port Map instead!
- AMD CPUs require `Kernel` > `Emulate`: `DummyPowerManagement`
- AMD CPUs also require additional [**Kernel patches**](https://github.com/AMD-OSX/AMD_Vanilla/tree/master) to run macOS.

## UEFI Quirks

### High End Desktop

#### Intel Skylake X/W, Cascade Lake X/W, Broadwell-E, Haswell-E, Ivy Bridge-E and Sandy Bridge-E  (High End Desktop)
- EnableVectorAcceleration
- RequestBootVarRouting

#### Intel Skylake X/W, Cascade Lake X/W, Broadwell-E, Haswell-E, Ivy Bridge-E and Sandy Bridge-E  (HP High End Desktop)
- EnableVectorAcceleration
- RequestBootVarRouting
- UnblockFsConnect

### Intel Core i5/i7/i9

#### Intel 10th Gen Comet Lake and 11th Gen Rocket Lake (Dektop)
- EnableVectorAcceleration
- RequestBootVarRouting

#### Intel 10th Gen Comet Lake and 11th Gen Rocket Lake (Mobile/NUC)
- EnableVectorAcceleration
- ReleaseUsbOwnership
- RequestBootVarRouting

#### Intel 10th Gen Comet Lake and 11th Gen Rocket Lake (HP Desktop)
- EnableVectorAcceleration
- RequestBootVarRouting
- UnblockFsConnect

### Intel 10th Gen Comet Lake and 11th Gen Rocket Lake (HP Mobile/NUC)
- EnableVectorAcceleration
- ReleaseUsbOwnership
- RequestBootVarRouting
- UnblockFsConnect

#### Intel 8th and 9th Gen Coffee Lake (Desktop)
- RequestBootVarRouting

#### Intel 8th and 9th Gen Coffee Lake (HP Desktop)
- RequestBootVarRouting
- UnblockFsConnect

#### Intel 8th and 9th Gen Coffee Lake (Mobile/NUC)
- ReleaseUsbOwnership
- RequestBootVarRouting

#### Intel 8th and 9th Gen Coffee Lake (HP Mobile/NUC)
- ReleaseUsbOwnership
- RequestBootVarRouting
- UnblockFsConnect

#### Intel 6th Gen Skylake and 7th Gen Kaby Lake (Desktop/Mobile/NUC)
- RequestBootVarRouting

#### Intel 6th Gen Skylake and 7th Gen Kaby Lake (HP Desktop/Mobile/NUC)
- RequestBootVarRouting
- UnblockFsConnect

#### Intel 5th Gen Broadwell (Mobile/NUC)
- IgnoreInvalidFlexRatio
- ReleaseUsbOwnership
- RequestBootVarRouting
- ResizeGpuBars: -1

#### Intel 5th Gen Broadwell (HP Mobile/NUC)
- IgnoreInvalidFlexRatio
- ReleaseUsbOwnership
- RequestBootVarRouting
- ResizeGpuBars: -1
- UnblockFsConnect

#### Intel 4th Gen Haswell (Desktop)
- IgnoreInvalidFlexRatio
- ResizeGpuBars: -1

#### Intel 4th Gen Haswell (HP Desktop)
- IgnoreInvalidFlexRatio
- ResizeGpuBars: -1
- UnblockFsConnect

#### Intel 2nd Gen Sandy Bridge and 3rd Gen Ivy Bridge (Desktop)
- IgnoreInvalidFlexRatio
- RequestBootVarRouting

#### Intel 2nd Gen Sandy Bridge and 3rd Gen Ivy Bridge (Mobile/NUC)
- IgnoreInvalidFlexRatio
- RequestBootVarRouting
- ReleaseUsbOwnership

#### Intel 2nd Gen Sandy Bridge and 3rd Gen Ivy Bridge (HP Desktop)
- IgnoreInvalidFlexRatio
- RequestBootVarRouting
- UnblockFsConnect

#### Intel 2nd Gen Sandy Bridge and 3rd Gen Ivy Bridge (HP Mobile/NUC)
- IgnoreInvalidFlexRatio
- ReleaseUsbOwnership
- RequestBootVarRouting
- UnblockFsConnect

### AMD
#### AMD Ryzen (17h), Threadripper (19h), Bulldozer (15h), Jaguar (16h)
- EnableVectorAcceleration
- RequestBootVarRouting

#### AMD Ryzen (17h), Threadripper (19h), Bulldozer (15h), Jaguar (16h) [HP]
- EnableVectorAcceleration
- RequestBootVarRouting
- UnblockFsConnect
