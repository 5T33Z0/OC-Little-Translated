# How to disable incompatible discrete GPUs

There are two main methods for disabling incompatible external GPUs.

## Method 1: via Config
The easiest way to disable an incompatible discrete GPU is via your config.plist. You can use either DeviceProperties or a boot argument to do so (both require [**`WhateverGreen.kext`**](https://github.com/acidanthera/WhateverGreen)). :warning: This method only works on CPUs with integrated graphics since the device property/boot-arg instructs the iGPU to disable the dGPU. Otherwise, you need to disable it via ACPI (Method 2).
 
- **Option 1**: using `DeviceProperties`.
	- Open your config.plist
	- Go to `DeviceProperties/Add/PciRoot(0x0)/Pci(0x2,0x0)` 
  	- Add Key `disable-gpu`: Value: `01000000`, Class: `DATA`to your GPU's PCI Address to disable it:</br>![DisableGPU](https://user-images.githubusercontent.com/76865553/218488197-1428c8b2-47ed-400a-8114-f844ba543632.png)
	- Add `WhateverGreen.kext` (if not present already)
- **Option 2**: using boot-arg
	- In `NVRAM/Add/7C436110-AB2A-4BBB-A880-FE41995C9F82` 
	- Add`-wegnoegpu` to boot-args (disables *all* external GPUs!)
	- Add `WhateverGreen.kext` (if not present already)
- **Option 3**: Multiple GPUs
	- In case you are using more than one GPU but only one of them is compatible with macOS, disable the incompatible GPU via SSDT (&rarr; see Method 2), don't use the boot-arg!

## Method 2: with SSDT Hotpatches

### Patch principle
- Disables the dGPU during initialization phase.
- Enables dGPU during sleep to prevent the system from crashing when it enters `S3` powerstate.
- Disables dGPU again after the machine wakes up.

### Patch Requirements
- **SSDT-PTSWAK**
- GPU blocking patch: either ***SSDT-NDGP_OFF*** or ***SSDT-NDGP_PS3***

### Instructions

- Add ***SSDT-PTSWAK***. See [**Comprehensive Sleep and Wake Patch**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/PTSWAK_Sleep_and_Wake_Fix) for details
- Add eiher/or:
	- ***SSDT-NDGP_OFF***
		- In `DSDT`, find the name and path of `DGPU` and confirm the existence of the `_ON` and `_OFF` methods.
		- Refer to the example and change the name and path to match the device name and patch used in the `DSDT`.
  	- ***SSDT-NDGP_PS3***
		- Find the name and path of `DGPU` and confirm the existence of `_PS0`, `_PS3` and `_DSM` methods
		- Refer to the example and change the name and path to match the query result.

**Note**: if this doesn't work either, you can try your luck with Rehabman's `SSDT-DGPU` (See instructions inside the .dsl file)


## Disabling discrete Laptop GPUs
&rarr; Follow [this guide](https://github.com/dortania/Getting-Started-With-ACPI/blob/master/Laptops/laptop-disable.md) by Dortania.
 
## Notes and Resources

- For Method 2, ***SSDT-PTSWAK*** and ***SSDT-NDGP_OFF*** [or ***SSDT-NDGP_PS3***] must be combined to make the whole construct work.
- If both ***SSDT-NDGP_OFF*** and ***SSDT-NDGP_PS3*** meet the requirements, ***SSDT-NDGP_OFF*** is preferred.
- The name and path of the GPU in the example is: `_SB.PCI0.RP13.PXSX`. Correct the name and path according to the name used in your ACPI tables if necessary.
- The SSDT method was developed by [RehabMan](https://github.com/rehabman)
