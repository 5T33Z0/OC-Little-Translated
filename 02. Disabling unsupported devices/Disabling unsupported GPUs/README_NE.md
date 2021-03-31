## How to disable external GPU 
There are two methods for disabling incompazinöe external GPUs:

**Method 1**: Modifying `DeviceProperties` for external GPU in config.plist:

  - Find `DeviceProperties\Add\PciRoot(0x0)/Pci(0x2,0x0)` 
  - Add `disable-external-gpu`: 01000000
  - Add boot-arg `-wegnoegpu` 
    
**Method 2**: SSDT Hotpatch

## SSDT blocking solo process

- Disable solo display during initialization phase.
- Enable solo during machine sleep to prevent possible system crashes if solo goes to `S3` while disabled.
- Disable solo again after the machine wakes up.

## Patch Combinations

- Comprehensive patch-- ***SSDT-PTSWAK***
- Solo blocking patch-- ***SSDT-NDGP_OFF*** [or ***SSDT-NDGP_PS3***]

## Example

- ***SSDT-PTSWAK***

  Slightly, see "PTSWAK Comprehensive Extension Patch" for details.
  
- ***SSDT-NDGP_OFF***

  - Query the name and path of the solo display to confirm the existence of the `_ON` and `_OFF` methods
  - Refer to the example and change the name and path to match the query result
  
- ***SSDT-NDGP_PS3***

  - Query the name and path of the Solo display and confirm the existence of `_PS0`, `_PS3` and `_DSM` methods
  - Refer to the example and change the name and path to match the query result
  
- **Note**

  - When querying for the solo name and path and `_ON`, `_OFF`, `_PS0`, `_PS3` and `_DSM`, all `ACPI` files should be searched, which may exist in `DSDT` files or in other `SSDT` files of `ACPI`.
  - The name and path of the solo display in the example is: `_SB.PCI0.RP13.PXSX`.

## Caution

- Both ***SSDT-PTSWAK*** and ***SSDT-NDGP_OFF*** [or ***SSDT-NDGP_PS3***] must be used as per **patch combination** requirement
- If both ***SSDT-NDGP_OFF*** and ***SSDT-NDGP_PS3*** meet the requirements, ***SSDT-NDGP_OFF*** will be used first.

**Note** : The above main content is from [@RehabMan](https://github.com/rehabman)
