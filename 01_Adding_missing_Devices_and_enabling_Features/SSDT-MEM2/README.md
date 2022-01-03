# Adding MEM2 Device (`SSDT-MEM2`) 

## Description
`MEM2` is relevant for Intel iGPUs in Laptops only. It makes the iGPU use `MEM2` instead of `TPMX`. Little is known about the device besides that without patching `TPMX` in DSDT, `PNP0C01` and `IOAccelMemoryInfoUserClient` will not be loaded correctly. [**Source**](https://www.tonymacx86.com/threads/guide-patching-laptop-dsdt-ssdts.152573/post-1277391)

**Applicable to**: 4th to 7th Gen Intel mobile CPUs and integrated graphics only!

## Instructions
In **DSDT**, search for `MEM2` or `PNP0C01`. If missing, add ***SSDT-MEM2***.
