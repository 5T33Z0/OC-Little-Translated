# Add missing parts
Although adding any of the missing parts listed below may improve performance, they can only be regarded as a refinement. They are not a necessity for getting your Hackintosh to work, except for `PMCR` which may be a requirement for Z390 Chipsets.

## Instructions

In **DSDT**, search for:

- `PMCR` or `APP9876`, if missing, add ***SSDT-PMCR***. For 6th gen or later. Z390 Chipsets also require this.

  **Note**: found by @Pleasecallmeofficial to provide the method, which has now become the official OpenCore SSDT example.
  > Z390 chipset PMC (D31:F2) can only be booted via MMIO. Since there is no PMC device in the ACPI specification, Apple has introduced its own named `APP9876` to access this device from the AppleIntelPCHPMC driver. In other operating systems, this device is generally accessed using `HID: PNP0C02`, `UID: PCHRESV`.  
  > Platforms, including APTIO V, cannot read or write NVRAM until the PMC device is initialized (it is frozen in SMM mode).  
  > It is not known why this is the case, but it is worth noting that PMC and SPI are located in different memory regions, and PCHRESV maps both, but Apple's AppleIntelPCHPMC will only map the region where PMC is located.  
  > There is no relationship between the PMC device and the LPC bus, and this SSDT is purely to add the device under the LPC bus to speed up the initialization of the PMC. If it is added to the PCI0 bus, the PMC will only start after the PCI configuration is finished and it will be too late for operations that need to read NVRAM.

**CAUTION:** When using the any of the patches, note that `LPC`/`LPCB` name should be consistent with the name used in the original ACPI.
