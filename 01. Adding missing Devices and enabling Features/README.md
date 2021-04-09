# About Fake Devices

Among the many `SSDT` patches, a significant number of them can be categorized as patches for spoofing components. These include:

- Devices which either do not exist in ACPI, or have a different name as required by macOS to function correctly. Patches that correctly rename these devices can load device drivers. For example, "05-2-PNLF Injection Method", "Adding Missing Parts", "Spoofing Ethernet", etc.
- Fake EC for fixing Embedded Controller issues
- For some special devices, using a method that prohibits the original device from impersonating it again will make it easier for us to adjust the patch. Such as "OCI2C-TPXX Patching Method".
- A device is disabled for some reason, but macOS system needs it to work. See `this chapter` for an example.
- In most cases, devices can also be enabled using the Binary Renaming and Preset Variables.

## Properties of Fake ACPI Devices

- Features:
  
  - The fake device already exists in ACPI, and is relatively short, small and self-contained in code.  
  - The original device has a canonical `_HID` or `_CID` parameter.
  - Even if the original device is not disabled, patching with a counterfeit device will not harm ACPI.
  
- Requirements:

  - The counterfeit device name is **different** from the original device name of ACPI.
  - Patch content and original device main content **identical**.
  - The `_STA` section of the counterfeit patch should include the following to ensure that windows systems use the original ACPI.

    ```Swift
        Method (_STA, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                ...
                Return (0x0F)
            }
            Else
            {
                Return (Zero)
            }
        }
    ```
  
- Example: Realtime Clock Fix (RTC0)
  
  - ***SSDT-RTC0*** - Counterfeit RTC
  - Original device name: RTC
  - _HID: PNP0B00
  
**Note**: The `LPC/LPCB` name used in the SSDT should be identical with the one used in ACPI.

# Add missing parts

Although adding any of the missing parts listed below may improve performance, they can only be regarded as a refinement. They are not a necessity for getting your Hackintosh to work, except for `PMCR` which may be a requirement for Z390 Chipsets.

**NOTE:** In order to add any of the components listed below, click on the entry for the device in the main menu to find the corresponding SSDT.

## Instructions

In **DSDT**, search for:

- `PNP0200`, if missing, add ***SSDT-DMAC***. Adds Direct Memory Access [(DMA) Controller](https://binaryterms.com/direct-memory-access-dma.html).
- `PNP0C01`, if missing, add ***SSDT-MEM2***.
- `0x00160000`, if missing, add ***SSDT-IMEI***. Adds Intel MEI. Required for Intel GPU acceleration (Req for 6th-series mainboards only)
- `0x001F0002`, if missing, add ***SSDT-PPMC***. For 6th Gen machines or later. Adds Platform Power Management Controller 
- `MCHC`, if missing, add ***SSDT-MCHC***  
	**NOTE**: Adding `MCHC` is no longer necessary. Use ***SSDT-SBUS-MCHC*** instead, which comes with the OpenCore package. Follow Instructions in "Chapter 05: Injecting Devices" to configure it correctly!
- `PMCR` or `APP9876`, if missing, add ***SSDT-PMCR***. For 6th gen or later. Z390 Chipsets also require this.

  **Note**: found by @Pleasecallmeofficial to provide the method, which has now become the official OpenCore SSDT example.
  > Z390 chipset PMC (D31:F2) can only be booted via MMIO. Since there is no PMC device in the ACPI specification, Apple has introduced its own named `APP9876` to access this device from the AppleIntelPCHPMC driver. In other operating systems, this device is generally accessed using `HID: PNP0C02`, `UID: PCHRESV`.  
  > Platforms, including APTIO V, cannot read or write NVRAM until the PMC device is initialized (it is frozen in SMM mode).  
  > It is not known why this is the case, but it is worth noting that PMC and SPI are located in different memory regions, and PCHRESV maps both, but Apple's AppleIntelPCHPMC will only map the region where PMC is located.  
  > There is no relationship between the PMC device and the LPC bus, and this SSDT is purely to add the device under the LPC bus to speed up the initialization of the PMC. If it is added to the PCI0 bus, the PMC will only start after the PCI configuration is finished and it will be too late for operations that need to read NVRAM.

- Search for `PNP0C0C` and add ***SSDT-PWRB*** if it is missing. Adds Power Button Device
- Search for `PNP0C0E` and add ***SSDT-SLPB*** if missing, this part is needed for the `PNP0C0E Sleep Correction Method`.

**CAUTION:** When using the any of the patches, note that `LPC`/`LPCB` name should be consistent with the name used in the original ACPI.
