# DMA Controller (`SSTD-DMAC`)
Adds Direct Memory Access Controller [**(DMAC)**](https://binaryterms.com/direct-memory-access-dma.html) device to IO Registry. Altthough present in any SMBIOS of intel-based Macs, the necessity for this SSDT on Hackintoshes is unknown. That's why it's categorized as "cosmetic".

Present in:

- **iMac**: 5,1 to 20,x
- **iMacPro1,1**
- **MacBook**: 1,1 to 9,1
- **MacBookAir**: 1,1 to 9,1
- **MacBookPro**: 1,1 to 16,1
- **MacMini**: 1,1 to 8,1
- **MacPro**: 1,1 to 7,1
- **Xserve**: 1,3 to 3,1

## Instructions

In **DSDT**, search for:

- `PNP0200` or `DMAC`
-  If missing, add ***SSDT-DMAC*** (export as `.aml`)

**CAUTION**: When using this patch, make sure that the name and path of the Low Pin Configuration Bus (`LPC` or `LPCB`) is consistent with the name used in the your system's `DSDT`. 

## Verifying that the patch is working
- Incorporate SSDT-DMAC.aml in your EFI's ACPI folder and config.plist.
- Restart your system 
- Open IORegistryExplorer and search for `DMAC`
- If the Device is present, it should look like this. The array "IODeviceMemory" should contain further entries and data:</br></br>
  ![DMAC](https://user-images.githubusercontent.com/76865553/141217597-78d7dcbb-2a7a-4910-a607-b1ec7e780d35.png)
