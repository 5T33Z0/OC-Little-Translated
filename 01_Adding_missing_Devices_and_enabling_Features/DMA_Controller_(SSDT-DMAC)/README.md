# Add missing parts
Although adding any of the missing parts listed in this chapter may improve performance, they can only be regarded as a refinement. They are not a necessity for getting your Hackintosh to work, except for `PMCR` which is mandatory for Z390 Chipsets.

## About `SSTD-DMAC`
Adds Direct Memory Access Controller [**(DMA) Controller**](https://binaryterms.com/direct-memory-access-dma.html) device. Applicable to every SMBIOS, although necessity is questionable.

## Instructions

In **DSDT**, search for:

- `PNP0200` or `DMAC`
-  If missing, add ***SSDT-DMAC*** (export as `.aml`)
-  Supported CPU Family: any

**CAUTION:** When using this patch, make sure that the name of the Low Pin Configuration Bus (`LPC` or `LPCB`) is consistent with the name used in the original `DSDT`.

## Verifying that the patch is working
- Incorporate SSDT-DMAC.aml in your EFI's ACPI folder and config.plist.
- Restart your system 
- Open IORegistryExplorer and search for `DMAC`
- If the Device is present, it should look like this. The array "IODeviceMemory" should contain further entries and data:
  ![DMAC](https://user-images.githubusercontent.com/76865553/141217597-78d7dcbb-2a7a-4910-a607-b1ec7e780d35.png)
