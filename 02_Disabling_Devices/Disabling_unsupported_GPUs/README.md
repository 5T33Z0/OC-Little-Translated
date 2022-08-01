# How to disable incompatible discrete GPUs

There are two main methods for disabling incompatible external GPUs.

## Method 1: via Config
The easiest way to disable discrete GPUs is to do it via your config.plist. You can use either DeviceProperties or a boot argument to do so. If this doesn't work, you need to do it via ACPI (Method 2)

- **Option 1**: using `DeviceProperties`. This only works for CPUs with integrated graphics since this property instructs the iGPU to disable the dGPU.
	- In `DeviceProperties\Add\PciRoot(0x0)/Pci(0x2,0x0)`
  	- Add Key `disable-external-gpu`: Value: `01000000`, Class: `DATA`</br>![Disable-GPU](https://user-images.githubusercontent.com/76865553/182168535-a51aca54-b23d-477f-8367-d07d2570bfb8.png)
- **Option 2:** using boot-arg
	- In  `NVRAM/Add/7C436110-AB2A-4BBB-A880-FE41995C9F82` 
	- Add`-wegnoegpu` to boot-args (requires `Whatevergreen.kext`)

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
 
## NOTES

- For Method 2, ***SSDT-PTSWAK*** and ***SSDT-NDGP_OFF*** [or ***SSDT-NDGP_PS3***] must be combined to make the whole construct work.
- If both ***SSDT-NDGP_OFF*** and ***SSDT-NDGP_PS3*** meet the requirements, ***SSDT-NDGP_OFF*** is preferred.
- The name and path of the GPU in the example is: `_SB.PCI0.RP13.PXSX`. Correct the name and path according to the name used in your ACPI tables if necessary.
- The SSDT method was developed by [RehabMan](https://github.com/rehabman)
