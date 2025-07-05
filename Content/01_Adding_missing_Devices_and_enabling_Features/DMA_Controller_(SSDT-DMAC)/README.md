# DMA Controller (`SSDT-DMAC`)

**INDEX**

- [About](#about)
- [Use case: enabling `AppleVTD`](#use-case-enabling-applevtd)
- [Instructions](#instructions)
- [Verifying that the patch is working](#verifying-that-the-patch-is-working)

--- 

## About 
`SSDT-DMAC` adds a fake **Direct Memory Access Controller** [**(DMAC)**](https://binaryterms.com/direct-memory-access-dma.html) device to IO Registry. Although present in any SMBIOS of intel-based Macs, the necessity for the SSDT on Hackintoshes is uncertain but it can help when trying to enable AppleVTD. 

**DMAC** is present in the following SMBIOS variants:

- **iMac**: 5,1 to 20,x
- **iMacPro1,1**
- **MacBook**: 1,1 to 9,1
- **MacBookAir**: 1,1 to 9,1
- **MacBookPro**: 1,1 to 16,1
- **MacMini**: 1,1 to 8,1
- **MacPro**: 1,1 to 7,1
- **Xserve**: 1,3 to 3,1

## Use case: enabling `AppleVTD`

&rarr; See [**Enabling AppleVTD**](/01_Adding_missing_Devices_and_enabling_Features/AppleVTD)

## Instructions

In **DSDT**, search for:

- `PNP0200` or `DMAC`
-  If missing, add ***SSDT-DMAC*** (export as `.aml`)

> [!CAUTION]
> 
> Ensure that the ACPI path of the LPC Bus (`LPC` or `LPCB`) used in the SSDT is identical with the one used in your system's `DSDT`! 

## Verifying that the patch is working
- Incorporate SSDT-DMAC.aml in your EFI's ACPI folder and config.plist.
- Restart your system 
- Open IORegistryExplorer and search for `DMAC`
- If the Device is present, it should look like this. The array "IODeviceMemory" should contain further entries and data:</br>![DMAC](https://user-images.githubusercontent.com/76865553/141217597-78d7dcbb-2a7a-4910-a607-b1ec7e780d35.png)
