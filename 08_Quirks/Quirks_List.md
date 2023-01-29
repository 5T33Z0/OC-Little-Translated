# Quirks
Collection of Booter, Kernel and UEFI Quirks for AMD and Intel CPUs.

**TABLE of CONTENTS**

- [Booter Quirks](#booter-quirks)
	- [High End Desktop](#high-end-desktop)
		- [Intel Skylake X/W and Cascade Lake X/W (High End Desktop)](#intel-skylake-xw-and-cascade-lake-xw-high-end-desktop)
		- [Intel Skylake X/W and Cascade Lake X/W (ASUS HEDT)](#intel-skylake-xw-and-cascade-lake-xw-asus-hedt)
		- [Intel Haswell-E, Broadwell-E, Sandy Bridge-E and Ivy Bridge-E (HEDT)](#intel-haswell-e-broadwell-e-sandy-bridge-e-and-ivy-bridge-e-hedt)
	- [Intel Core i5/i7/i9](#intel-core-i5i7i9)
		- [Intel 13th Gen Raptor Lake (Desktop)](#intel-13th-gen-raptor-lake-desktop)
		- [Intel 12th Gen Alder Lake (Desktop)](#intel-12th-gen-alder-lake-desktop)
		- [Intel 10th Gen Comet Lake and 11th Gen Rocket Lake (Dektop/Mobile/Nuc)](#intel-10th-gen-comet-lake-and-11th-gen-rocket-lake-dektopmobilenuc)
		- [Intel 8th and 9th Gen Coffee Lake (Desktop)](#intel-8th-and-9th-gen-coffee-lake-desktop)
		- [Intel 9th Gen Coffee Lake (Z390 Chipset)](#intel-9th-gen-coffee-lake-z390-chipset)
		- [Intel 8th and 9th Gen Coffee Lake (Mobile/Nuc)](#intel-8th-and-9th-gen-coffee-lake-mobilenuc)
		- [Intel 6th Gen Skylake and 7th Gen Kaby Lake (Desktop/Mobile/NUC)](#intel-6th-gen-skylake-and-7th-gen-kaby-lake-desktopmobilenuc)
		- [Intel 4th Gen Haswell and 5th Gen Broadwell (Desktop/Mobile/NUC)](#intel-4th-gen-haswell-and-5th-gen-broadwell-desktopmobilenuc)
		- [Intel 2nd Gen Sandy Bridge and 3rd Gen Ivy Bridge (Desktop/Mobile/NUC)](#intel-2nd-gen-sandy-bridge-and-3rd-gen-ivy-bridge-desktopmobilenuc)
	- [AMD](#amd)
		- [AMD Ryzen (17h)](#amd-ryzen-17h)
		- [AMD Threadripper TRx 40 (19h)](#amd-threadripper-trx-40-19h)
		- [AMD Bulldozer (15h) and Jaguar (16h)](#amd-bulldozer-15h-and-jaguar-16h)
- [Kernel Quirks](#kernel-quirks)
	- [High End Desktop](#high-end-desktop-1)
		- [Intel Skylake X/W and Cascade Lake X/W (High End Desktop)](#intel-skylake-xw-and-cascade-lake-xw-high-end-desktop-1)
		- [Intel Skylake X/W and Cascade Lake X/W (HP HEDT)](#intel-skylake-xw-and-cascade-lake-xw-hp-hedt)
		- [Intel Broadwell-E and Haswell-E (HEDT)](#intel-broadwell-e-and-haswell-e-hedt)
		- [Intel Broadwell-E and Haswell-E (HP HEDT)](#intel-broadwell-e-and-haswell-e-hp-hedt)
		- [Intel Sandy Bridge-E and Ivy Bridge-E (HEDT)](#intel-sandy-bridge-e-and-ivy-bridge-e-hedt)
		- [Intel Sandy Bridge-E and Ivy Bridge-E (HP HEDT)](#intel-sandy-bridge-e-and-ivy-bridge-e-hp-hedt)
	- [Intel Core i5/i7/i9](#intel-core-i5i7i9-1)
		- [Intel 13th Gen Raptor Lake (Desktop)](#intel-13th-gen-raptor-lake-desktop-1)
		- [Intel 12th Gen Alder Lake (Desktop)](#intel-12th-gen-alder-lake-desktop-1)
		- [Intel 11th Gen Rocket Lake (Dektop/Mobile/Nuc)](#intel-11th-gen-rocket-lake-dektopmobilenuc)
		- [Intel 10th Gen Comet Lake (Dektop/Mobile/Nuc)](#intel-10th-gen-comet-lake-dektopmobilenuc)
		- [Intel 10th Gen Comet Lake (Dell/Sony VAIO)](#intel-10th-gen-comet-lake-dellsony-vaio)
		- [Intel 10th Gen Comet Lake (HP)](#intel-10th-gen-comet-lake-hp)
		- [Intel 8th and 9th Gen Coffee Lake (Desktop/Mobile/NUC)](#intel-8th-and-9th-gen-coffee-lake-desktopmobilenuc)
		- [Intel 8th and 9th Gen Coffee Lake (Dell/Sony VAIO)](#intel-8th-and-9th-gen-coffee-lake-dellsony-vaio)
		- [Intel 8th and 9th Gen Coffee Lake (HP)](#intel-8th-and-9th-gen-coffee-lake-hp)
		- [Intel 6th Gen Skylake and 7th Gen Kaby Lake (Desktop/Mobile/NUC)](#intel-6th-gen-skylake-and-7th-gen-kaby-lake-desktopmobilenuc-1)
		- [Intel 6th Gen Skylake and 7th Gen Kaby Lake (Dell/SonyVaio)](#intel-6th-gen-skylake-and-7th-gen-kaby-lake-dellsonyvaio)
		- [Intel 6th Gen Skylake and 7th Gen Kaby Lake (HP)](#intel-6th-gen-skylake-and-7th-gen-kaby-lake-hp)
		- [Intel 4th Gen Haswell and 5th Gen Broadwell (Desktop/Mobile/NUC)](#intel-4th-gen-haswell-and-5th-gen-broadwell-desktopmobilenuc-1)
		- [Intel 4th Gen Haswell and 5th Gen Broadwell (Dell/Sony VAIO)](#intel-4th-gen-haswell-and-5th-gen-broadwell-dellsony-vaio)
		- [Intel 4th Gen Haswell and 5th Gen Broadwell (HP)](#intel-4th-gen-haswell-and-5th-gen-broadwell-hp)
		- [Intel 2nd Gen Sandy Bridge and 3rd Gen Ivy Bridge (Desktop/Mobile/NUC)](#intel-2nd-gen-sandy-bridge-and-3rd-gen-ivy-bridge-desktopmobilenuc-1)
		- [Intel 2nd Gen Sandy Bridge and 3rd Gen Ivy Bridge (Dell/Sony VAIO)](#intel-2nd-gen-sandy-bridge-and-3rd-gen-ivy-bridge-dellsony-vaio)
		- [Intel 2nd Gen Sandy Bridge and 3rd Gen Ivy Bridge (HP)](#intel-2nd-gen-sandy-bridge-and-3rd-gen-ivy-bridge-hp)
	- [AMD](#amd-1)
		- [AMD Ryzen (17h), Threadripper (19h), Bulldozer (15h), Jaguar (16h)](#amd-ryzen-17h-threadripper-19h-bulldozer-15h-jaguar-16h)
- [UEFI Quirks](#uefi-quirks)
	- [High End Desktop](#high-end-desktop-2)
		- [Intel Skylake X/W, Cascade Lake X/W, Broadwell-E, Haswell-E, Ivy Bridge-E and Sandy Bridge-E  (High End Desktop)](#intel-skylake-xw-cascade-lake-xw-broadwell-e-haswell-e-ivy-bridge-e-and-sandy-bridge-e--high-end-desktop)
		- [Intel Skylake X/W, Cascade Lake X/W, Broadwell-E, Haswell-E, Ivy Bridge-E and Sandy Bridge-E  (HP High End Desktop)](#intel-skylake-xw-cascade-lake-xw-broadwell-e-haswell-e-ivy-bridge-e-and-sandy-bridge-e--hp-high-end-desktop)
	- [Intel Core i5/i7/i9](#intel-core-i5i7i9-2)
		- [Intel 13th Gen Raptor Lake (Desktop)](#intel-13th-gen-raptor-lake-desktop-2)
		- [Intel 12th Gen Alder Lake (Desktop)](#intel-12th-gen-alder-lake-desktop-2)
		- [Intel 10th Gen Comet Lake and 11th Gen Rocket Lake (Dektop)](#intel-10th-gen-comet-lake-and-11th-gen-rocket-lake-dektop)
		- [Intel 10th Gen Comet Lake and 11th Gen Rocket Lake (Mobile/NUC)](#intel-10th-gen-comet-lake-and-11th-gen-rocket-lake-mobilenuc)
		- [Intel 10th Gen Comet Lake and 11th Gen Rocket Lake (HP Desktop)](#intel-10th-gen-comet-lake-and-11th-gen-rocket-lake-hp-desktop)
		- [Intel 10th Gen Comet Lake and 11th Gen Rocket Lake (HP Mobile/NUC)](#intel-10th-gen-comet-lake-and-11th-gen-rocket-lake-hp-mobilenuc)
		- [Intel 8th and 9th Gen Coffee Lake (Desktop)](#intel-8th-and-9th-gen-coffee-lake-desktop-1)
		- [Intel 8th and 9th Gen Coffee Lake (HP Desktop)](#intel-8th-and-9th-gen-coffee-lake-hp-desktop)
		- [Intel 8th and 9th Gen Coffee Lake (Mobile/NUC)](#intel-8th-and-9th-gen-coffee-lake-mobilenuc-1)
		- [Intel 8th and 9th Gen Coffee Lake (HP Mobile/NUC)](#intel-8th-and-9th-gen-coffee-lake-hp-mobilenuc)
		- [Intel 6th Gen Skylake and 7th Gen Kaby Lake (Desktop/Mobile/NUC)](#intel-6th-gen-skylake-and-7th-gen-kaby-lake-desktopmobilenuc-2)
		- [Intel 6th Gen Skylake and 7th Gen Kaby Lake (HP Desktop/Mobile/NUC)](#intel-6th-gen-skylake-and-7th-gen-kaby-lake-hp-desktopmobilenuc)
		- [Intel 5th Gen Broadwell (Mobile/NUC)](#intel-5th-gen-broadwell-mobilenuc)
		- [Intel 5th Gen Broadwell (HP Mobile/NUC)](#intel-5th-gen-broadwell-hp-mobilenuc)
		- [Intel 4th Gen Haswell (Desktop)](#intel-4th-gen-haswell-desktop)
		- [Intel 4th Gen Haswell (HP Desktop)](#intel-4th-gen-haswell-hp-desktop)
		- [Intel 2nd Gen Sandy Bridge and 3rd Gen Ivy Bridge (Desktop)](#intel-2nd-gen-sandy-bridge-and-3rd-gen-ivy-bridge-desktop)
		- [Intel 2nd Gen Sandy Bridge and 3rd Gen Ivy Bridge (Mobile/NUC)](#intel-2nd-gen-sandy-bridge-and-3rd-gen-ivy-bridge-mobilenuc)
		- [Intel 2nd Gen Sandy Bridge and 3rd Gen Ivy Bridge (HP Desktop)](#intel-2nd-gen-sandy-bridge-and-3rd-gen-ivy-bridge-hp-desktop)
		- [Intel 2nd Gen Sandy Bridge and 3rd Gen Ivy Bridge (HP Mobile/NUC)](#intel-2nd-gen-sandy-bridge-and-3rd-gen-ivy-bridge-hp-mobilenuc)
	- [AMD](#amd-2)
		- [AMD Ryzen (17h), Threadripper (19h), Bulldozer (15h), Jaguar (16h)](#amd-ryzen-17h-threadripper-19h-bulldozer-15h-jaguar-16h-1)
		- [AMD Ryzen (17h), Threadripper (19h), Bulldozer (15h), Jaguar (16h) \[HP\]](#amd-ryzen-17h-threadripper-19h-bulldozer-15h-jaguar-16h-hp)

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

#### Intel 13th Gen Raptor Lake (Desktop)
- AvoidRuntimeDefrag
- DevirtualiseMmio
- EnableSafeModeSlide
- ProvideCustomSlide 
- SetupVirtualMap
- RebuildAppleMemoryMap
- SyncRuntimePermissions
- ProvideMaxSlide: 0

#### Intel 12th Gen Alder Lake (Desktop)
- AvoidRuntimeDefrag
- DevirtualiseMmio
- EnableSafeModeSlide
- ProtectUefiServices
- ProvideCustomSlide 
- SetupVirtualMap
- RebuildAppleMemoryMap
- SyncRuntimePermissions
- ProvideMaxSlide: 0

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

### Intel Core i5/i7/i9

#### Intel 13th Gen Raptor Lake (Desktop)
Usupported CPU. Requires Comet Lake CPU-ID

- Kernel > Emulate
	- **Cpuid1Data**: 55060A00000000000000000000000000
	- **Cpuid1Mask**: FFFFFFFF000000000000000000000000
	- **MinKernel**: 20.0.0
- AppleXcpmCfgLock
- DisableLinkeditJettison
- PanicNoKextDump
- PowerTimeoutKernelPanic
- SetApfsTrimTimeout: -1
- ProvideCurrentCpuInfo
- XhciPortLimit (up to macOS Catalina only)

#### Intel 12th Gen Alder Lake (Desktop)
Usupported CPU. Requires Fake CPU-ID

- Kernel > Emulate
	- **Cpuid1Data**: 55060A00000000000000000000000000
	- **Cpuid1Mask**: FFFFFFFF000000000000000000000000
	- **MinKernel**: 20.0.0
- AppleXcpmCfgLock (only required if CFG Lock can't be disabled in BIOS)
- CustomSMBIOSGuid
- DisableLinkedJettison
- ExtentBTFeatureFlags (optional)
- ForceAqquantiaEthernet (optional, only req. for 10 Gbit Ethernet)
- PanicNoKextDump
- PowerTimeoutKernelPanic
- ProvideCurrentCpuInfo

#### Intel 11th Gen Rocket Lake (Dektop/Mobile/Nuc)
Usupported CPU. Requires Fake CPU-ID

- Kernel > Emulate
	- **Cpuid1Data**: 55060A00000000000000000000000000
	- **Cpuid1Mask**: FFFFFFFF000000000000000000000000
 	- **MinKernel**: 20.0.0
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
- XhciPortLimit (up to macOS Catalina only)

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

#### Intel 13th Gen Raptor Lake (Desktop)
- EnableVectorAcceleration
- RequestBootVarRouting

#### Intel 12th Gen Alder Lake (Desktop)
- EnableVectorAcceleration
- RequestBootVarRouting

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
