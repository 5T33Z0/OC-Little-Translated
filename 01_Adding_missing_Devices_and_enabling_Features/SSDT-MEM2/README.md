# Adding MEM2 Device (`SSDT-MEM2`) 

## Description
`MEM2` is relevant for Intel iGPUs in Laptops only. It makes the iGPU use `MEM2` instead of `TPMX`. Little is known about the device besides that without patching `TPMX` in DSDT, `PNP0C01` and IOAccelMemoryInfoUserClient will not be loaded correctly. [**Source**](https://www.tonymacx86.com/threads/guide-patching-laptop-dsdt-ssdts.152573/post-1277391)

**Applicable to**: 4th to 7th Gen Intel mobile CPUs and integrated graphics only! 

## Instructions
- In **DSDT**, search for `MEM2` or `PNP0C01`. 
- If missing, you can add ***SSDT-MEM2***. 
- If `PNP0C01` is present but is called `MEM` instead, you don't need this patch either – IOReg will still pick it up.

>[!NOTE]
>
> Whether or not this patch is needed is uncertain. In my test on an Ivy Bridge Notebook with Intel HD4000 graphics, adding `SSDT-MEM2` did not result in `IOAccelMemoryInfoUserClient` being present. Also, my system already has a `MEM` device. So this SSDT has to be tested on a case-by-case basis. If you are uncertain, don't use it.
