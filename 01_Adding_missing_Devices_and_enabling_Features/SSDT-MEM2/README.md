# Adding SSDT-MEM2

## Description
`MEM2` is related to Laptop iGPU's only. It makes the iGPU use `MEM2` instead of `TPMX`. [More details](https://www.tonymacx86.com/threads/guide-patching-laptop-dsdt-ssdts.152573/post-1277391).

**Applicable to**: 4th to 7th Gen Intel mobile CPUs and Graphics only!

## Instructions
In **DSDT**, search for:

- `MEM2` or `PNP0C01`. If missing, add ***SSDT-MEM2***.

**CAUTION:** When using the any of the patches, note that `LPC`/`LPCB` name should be consistent with the name used in the system's original `DSDT`.
