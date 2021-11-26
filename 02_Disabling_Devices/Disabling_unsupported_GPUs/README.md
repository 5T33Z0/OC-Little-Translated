# How to disable incompatible discrete GPUs

There are two main methods for disabling incompatible external GPUs:

## Method 1: via Config

  - In `DeviceProperties`, add `PciRoot(0x0)/Pci(0x2,0x0)` 
  - Add Key `disable-external-gpu`: `01000000`, Class: `DATA` 
  - Add boot-arg `-wegnoegpu` to `NVRAM\Add\7C436110-AB2A-4BBB-A880-FE41995C9F82`
    
## Method 2: with SSDT Hotpatches

### Patch principle
- Disables the dGPU during initialization phase.
- Enables dGPU during sleep to prevent the system from crashing when it enters `S3` state.
- Disables dGPU again after the machine wakes up.

### Patch Combinations

- GPU blocking patch: ***SSDT-NDGP_OFF*** or ***SSDT-NDGP_PS3***
- Modiefied Sleep/Wake mehods (***SSDT-PTSWAK***)

#### Example

- Add ***SSDT-PTSWAK***. See [**Comprehensive Sleep and Wake Patch**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/PTSWAK_Sleep_and_Wake_Fix)
- Add eiher/or:
	- ***SSDT-NDGP_OFF***
		- In DSDT, query the name and path of `DGPU` and confirm the existence of the `_ON` and `_OFF` methods
		- Refer to the example and change the name and path to match the device name and patch useed in the `DSDT`
  	- ***SSDT-NDGP_PS3***
		- Query the name and path of `DGPU` and confirm the existence of `_PS0`, `_PS3` and `_DSM` methods
		- Refer to the example and change the name and path to match the query result
  
## Notes

- For Method 2, ***SSDT-PTSWAK*** and ***SSDT-NDGP_OFF*** [or ***SSDT-NDGP_PS3***] must be combined to make the whole construct work.
- If both ***SSDT-NDGP_OFF*** and ***SSDT-NDGP_PS3*** meet the requirements, ***SSDT-NDGP_OFF*** is preferred.
- The unique name and path in the example is: `_SB.PCI0.RP13.PXSX`. Correct the name and path according to your ACPI tables if necessary.
- The above method was developed by [@RehabMan](https://github.com/rehabman)
