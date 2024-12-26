# DMA Controller (`SSDT-DMAC`)

- [About](#about)
- [Use case: enabling `AppleVTD`](#use-case-enabling-applevtd)
- [Instructions](#instructions)
- [Verifying that the patch is working](#verifying-that-the-patch-is-working)


## About 
`SSDT-DMAC` adds a **Direct Memory Access Controller** [**(DMAC)**](https://binaryterms.com/direct-memory-access-dma.html) device to IO Registry. Although present in any SMBIOS of intel-based Macs, the necessity for the SSDT on Hackintoshes is uncertain. 

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
Some Ethernet Controllers and/or Wifi Cards require `AppleVTD` to be present in IO Registry in order to work properly. Especially on Gigabyte Boards with Intel I225-V NICs and additional 3rd party cards from Fenvi or Aquantia.

For `AppleVTD` to be present, additional conditions must be met:
 
1. `Vt-D` must be enabled in BIOS
2. `DisableIOMapper` Quirk must be unselected
3. Original `DMAR` Table must be [dropped](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00_ACPI/ACPI_Dropping_Tables#example-1-dropping-the-dmar-table)
4. A [modified `DMAR` Table](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00_ACPI/ACPI_Dropping_Tables#example-2-replacing-the-dmar-table-by-a-modified-one) without memory regions must be injected instead.

Once Vt-D is enabled, it should be present in the IO Registry as `AppleVTD`:

![AppleVTD](https://user-images.githubusercontent.com/76865553/173662447-02328900-46a3-445f-aa39-205a8eecdff8.png)

If `AppleVTD` is still not present after this, adding a `DMAC` device via `SSDT-DMAC` *might* resolve this issus. It's supposed to be present so that macOS can access all memory regions in order for `AppleVTD` to work. However, AppleVTD works fine without injecting `DMAC` xin most cases, so that's why it's categorized as "cosmetic".

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
- If the Device is present, it should look like this. The array "IODeviceMemory" should contain further entries and data:</br></br>
  ![DMAC](https://user-images.githubusercontent.com/76865553/141217597-78d7dcbb-2a7a-4910-a607-b1ec7e780d35.png)
