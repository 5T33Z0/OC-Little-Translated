# Add missing parts

Although adding any of the missing parts listed below may improve performance, they can only be regarded as a refinement. They are not a necessity for getting your Hackintosh to work, except for `PMCR` which may be a requirement for Z390 Chipsets.

## Instructions
Applicable to Haswell/Broadwell Grpahics only!

In **DSDT**, search for:

- `PNP0C01`, if missing, add ***SSDT-MEM2***. Seems to be related to Laptop iGPU's only. Not very much is known about this device, [though](https://www.tonymacx86.com/threads/guide-patching-laptop-dsdt-ssdts.152573/post-1277391)

**CAUTION:** When using the any of the patches, note that `LPC`/`LPCB` name should be consistent with the name used in the original ACPI.
