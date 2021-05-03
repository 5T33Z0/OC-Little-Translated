# Add missing parts
Although adding any of the missing parts listed below may improve performance, they can only be regarded as a refinement. They are not a necessity for getting your Hackintosh to work, except for `PMCR` which may be a requirement for Z390 Chipsets.

## Instructions

In **DSDT**, search for:

- `PNP0200`, if missing, add ***SSDT-DMAC***. Adds Direct Memory Access [(DMA) Controller](https://binaryterms.com/direct-memory-access-dma.html).
- `PNP0C01`, if missing, add ***SSDT-MEM2***.
- `0x00160000`, if missing, add ***SSDT-IMEI***. Adds Intel MEI. Required for Intel GPU acceleration (Req for 6th-series mainboards only)
- `0x001F0002`, if missing, add ***SSDT-PPMC***. For 6th Gen machines or later. Adds Platform Power Management Controller 
- `MCHC`, if missing, add ***SSDT-MCHC***</br>
	
	**NOTE**: `SSDT-MCHC`and `SSTD-SBUS/SMBU`have since been combined into one Patch. Use ***SSDT-SBUS-MCHC*** instead, which is included in the OpenCore package download from Acidanthera.
- `PMCR` or `APP9876`, if missing, add ***SSDT-PMCR***. For 6th gen or later. Z390 Chipsets also require this.

  **Note**: found by @Pleasecallmeofficial to provide the method, which has now become the official OpenCore SSDT example.
  > Z390 chipset PMC (D31:F2) can only be booted via MMIO. Since there is no PMC device in the ACPI specification, Apple has introduced its own named `APP9876` to access this device from the AppleIntelPCHPMC driver. In other operating systems, this device is generally accessed using `HID: PNP0C02`, `UID: PCHRESV`.  
  > Platforms, including APTIO V, cannot read or write NVRAM until the PMC device is initialized (it is frozen in SMM mode).  
  > It is not known why this is the case, but it is worth noting that PMC and SPI are located in different memory regions, and PCHRESV maps both, but Apple's AppleIntelPCHPMC will only map the region where PMC is located.  
  > There is no relationship between the PMC device and the LPC bus, and this SSDT is purely to add the device under the LPC bus to speed up the initialization of the PMC. If it is added to the PCI0 bus, the PMC will only start after the PCI configuration is finished and it will be too late for operations that need to read NVRAM.

- Search for `PNP0C0C` and add ***SSDT-PWRB*** if it is missing. Adds Power Button Device
- Search for `PNP0C0E` and add ***SSDT-SLPB*** if missing, this part is needed for the `PNP0C0E Sleep Correction Method`.

**CAUTION:** When using the any of the patches, note that `LPC`/`LPCB` name should be consistent with the name used in the original ACPI.
