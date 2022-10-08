# DMA Controller (`SSTD-DMAC`)
Adds **Direct Memory Access Controller** [**(DMAC)**](https://binaryterms.com/direct-memory-access-dma.html) device to IO Registry. Although present in any SMBIOS of intel-based Macs, the necessity for the SSDT on Hackintoshes is uncertain. 

**DMAC** is present in the following SMBIOS variants:

- **iMac**: 5,1 to 20,x
- **iMacPro1,1**
- **MacBook**: 1,1 to 9,1
- **MacBookAir**: 1,1 to 9,1
- **MacBookPro**: 1,1 to 16,1
- **MacMini**: 1,1 to 8,1
- **MacPro**: 1,1 to 7,1
- **Xserve**: 1,3 to 3,1

## Use case
Some Ethernet Controllers and/or Wifi Cards require `Vt-D` to be enabled in BIOS to address the Reserved Memory Regions defined in the `DMAR` table in order to work properly. Especially on Gigabyte Boards with Intel I225-V NICs and additional 3rd party cards from Fenvi or Aquantia.

Once Vt-D is enabled, it should be present in the IO Registry as `AppleVTD`:

![AppleVTD](https://user-images.githubusercontent.com/76865553/173662447-02328900-46a3-445f-aa39-205a8eecdff8.png)

If `AppleVTD` is not present after enabling it, adding a DMAC device via `SSDT-DMAC` *might* resolve this issus. It's supposed to be present so that macOS can access all memory regions in order for AppleVTD to work in combination with a modified DMAR table. However, AppleVTD works fine without DMAC in most cases, so that's why it's categorized as "cosmetic".

In general, the `DisableIOMapper` Quirk must not be enabled in this case, since it disables Vt-D in macOS and also blocks loading of the `DMAR` table which defeats the whole pupose of trying to get these Ethernet Controllers to work.

## Instructions

In **DSDT**, search for:

- `PNP0200` or `DMAC`
-  If missing, add ***SSDT-DMAC*** (export as `.aml`)

**CAUTION**: When using this patch, ensure that the ACPI path of the LPC Bus (`LPC` or `LPCB`) used in the SSDT is consistent with the one used in your system's `DSDT`. 

## Verifying that the patch is working
- Incorporate SSDT-DMAC.aml in your EFI's ACPI folder and config.plist.
- Restart your system 
- Open IORegistryExplorer and search for `DMAC`
- If the Device is present, it should look like this. The array "IODeviceMemory" should contain further entries and data:</br></br>
  ![DMAC](https://user-images.githubusercontent.com/76865553/141217597-78d7dcbb-2a7a-4910-a607-b1ec7e780d35.png)
