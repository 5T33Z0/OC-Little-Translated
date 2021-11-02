# Add missing parts

Although adding any of the missing parts listed below may improve performance, they can only be regarded as a refinement. They are not a necessity for getting your Hackintosh to work, except for `PMCR` which may be a requirement for Z390 Chipsets.

## Description
`MEM2` is related to Laptop iGPU's only. It makes the iGPU use `MEM2` instead of `TPMX`. [More details](https://www.tonymacx86.com/threads/guide-patching-laptop-dsdt-ssdts.152573/post-1277391). 

**Applicable to**: 4th to 7th Gen Intel mobile CPUs and Graphics only! In real Macs, the device is sometimes also called `^^MEM2`. 

## Instructions
In **DSDT**, search for:

- `MEM2` and/or `PNP0C01`, if missing, add ***SSDT-MEM2***. 
 


**CAUTION:** When using the any of the patches, note that `LPC`/`LPCB` name should be consistent with the name used in the original ACPI.
