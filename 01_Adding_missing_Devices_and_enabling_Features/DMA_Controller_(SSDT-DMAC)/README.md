# Add missing parts
Although adding any of the missing parts listed below may improve performance, they can only be regarded as a refinement. They are not a necessity for getting your Hackintosh to work, except for `PMCR` which may be a requirement for Z390 Chipsets.

## About
Adds Direct Memory Access Controller [**(DMA) Controller**](https://binaryterms.com/direct-memory-access-dma.html) device. Applicable to every SMBIOS, although necessity is questionalbe.

## Instructions

In **DSDT**, search for:

- `PNP0200`
-  If missing, add ***SSDT-DMAC*** (export as `.aml`) 

**CAUTION:** When using this patch, make sure that the name `LPC`/`LPCB` is consistent with the name used in the original `DSDT`. Otherwise it won't work.

## Verifying that the patch is working
- Incorporate SSDT-DMAC.aml in your EFI's ACPI folder and config.plist.
- Restart your system 
- Open IORegistry Explorer and serch for `DMAC`
- If the Device is present, it should look like this. The arry "DeviceIOMemory" should contain further entries and data:

![](/Users/kl45u5/Desktop/DMAC_present.png)