# Add missing parts
Although adding missing devices/features may improve performance, they can only be regarded as a refinement. They are not a necessity for getting your Hackintosh to work, except for `PMCR` which is a requirement for Z390 Chipsets.

## Instructions
In ACPI, you won't find `PMCR` or `APP9876`, because it is an EXCLUSIVE Apple device. So add ***SSDT-PMCR.aml*** for 6th Gen Intel and later. For Z390 Boards this patch is mandatory.

**CAUTION:** When using this patch, makes sur that the name of the Low Pin Configration Bus (`LPC`/`LPCB`) is consistent with the name used in the original ACPI.

### Checking if the patch is working
Open IORegistryExplorer and search for `PCMR`. If the SSDT works, you should find it:</br>

![Bildschirmfoto 2021-11-01 um 16 37 33](https://user-images.githubusercontent.com/76865553/139699060-75fdc4b4-ff16-448e-9e19-96af3c392064.png)

## Background
This patch was found by @Pleasecallmeofficial to provide the method, which has now become the official OpenCore SSDT example.
  > 300/400/500 chipsets PMC (D31:F2) can only be booted via MMIO. Since there is no PMC device in the ACPI specification, Apple has introduced its own named `APP9876` to access this device from the AppleIntelPCHPMC driver. In other operating systems, this device is generally accessed using `HID: PNP0C02`, `UID: PCHRESV`.  
  > Platforms, including APTIO V, cannot read or write NVRAM until the PMC device is initialized (it is frozen in SMM mode).  
  > It is not known why this is the case, but it is worth noting that PMC and SPI are located in different memory regions, and PCHRESV maps both, but Apple's AppleIntelPCHPMC will only map the region where PMC is located.  
  > There is no relationship between the PMC device and the LPC bus, and this SSDT is purely to add the device under the LPC bus to speed up the initialization of the PMC. If it is added to the PCI0 bus, the PMC will only start after the PCI configuration is finished and it will be too late for operations that need to read NVRAM.
