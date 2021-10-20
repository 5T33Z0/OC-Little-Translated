# How to disable incompatible external GPUs

There are two methods for disabling incompatible external GPUs:

**Method 1**: Adding `DeviceProperties` for external GPU in config.plist:

  - In `DeviceProperties`, find `PciRoot(0x0)/Pci(0x2,0x0)` 
  - Add Key `disable-external-gpu`: 01000000
  - Add boot-arg `-wegnoegpu` 
    
**Method 2**: SSDT Hotpatch

## Disabling dicrete GPU via SSDT Hotpatch

- Disables the dGPU during initialization phase.
- Enables dGPU during machine sleep to prevent the system from crashing when it enters `S3` sleep.
- Disables dGPU again after the machine wakes up.

## Patch Combinations

- See [**Comprehensive Sleep and Wak Patch**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/PTSWAK_Sleep_and_Wake_Fix)
- GPU blocking patch ***SSDT-NDGP_OFF*** or ***SSDT-NDGP_PS3***

## Example

- ***SSDT-PTSWAK***

  Slightly, see "PTSWAK Comprehensive Extension Patch" for details.
  
- ***SSDT-NDGP_OFF***

  - Query the name and path of the solo display to confirm the existence of the `_ON` and `_OFF` methods
  - Refer to the example and change the name and path to match the query result
  
- ***SSDT-NDGP_PS3***

  - Query the name and path of the Solo display and confirm the existence of `_PS0`, `_PS3` and `_DSM` methods
  - Refer to the example and change the name and path to match the query result
  
- **NOTES**
	- When querying the unique name and path, as well as `_ON`, `_OFF`, `_PS0`, `_PS3` and `_DSM`, all ACPI files should be searched. It may exist in the `DSDT` file or in other `SSDT` files.
	- The unique name and path in the example are: _SB.PCI0.RP13.PXSX.

## Caution

- Both ***SSDT-PTSWAK*** and ***SSDT-NDGP_OFF*** [or ***SSDT-NDGP_PS3***] must be used as per **patch combination** requirement
- If both ***SSDT-NDGP_OFF*** and ***SSDT-NDGP_PS3*** meet the requirements, ***SSDT-NDGP_OFF*** will be used first.

**Note** : The above method was developed by [@RehabMan](https://github.com/rehabman)
