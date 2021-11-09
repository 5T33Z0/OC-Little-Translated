# Add missing parts
Although adding any of the missing parts listed below may improve performance, they can only be regarded as a refinement. They are not a necessity for getting your Hackintosh to work, except for `PMCR` which is mandatory for Z390 Chipsets.

## About
Adds Direct Memory Access Controller [**(DMA) Controller**](https://binaryterms.com/direct-memory-access-dma.html) device. Applicable to every SMBIOS, although necessity is questionable.

## Instructions

In **DSDT**, search for:

- `PNP0200`
-  If missing, add ***SSDT-DMAC*** (export as `.aml`) 

**CAUTION:** When using this patch, make sure that the name `LPC`/`LPCB` is consistent with the name used in the original `DSDT`. Otherwise it won't work.

## Verifying that the patch is working
- Incorporate SSDT-DMAC.aml in your EFI's ACPI folder and config.plist.
- Restart your system 
- Open IORegistry Explorer and search for `DMAC`
- If the Device is present, it should look like this. The array "IODeviceMemory" should contain further entries and data:

![DMAC_present](https://user-images.githubusercontent.com/76865553/139804828-7a797e03-06c8-4abe-9216-c0627efbaafe.png)
