# Add PMCR Device (`SSDT-PMC`)
## About
:warning: Mandatory for 390 mainboards and recommended for 400/500/600-series chipsets! In ACPI, you won't find `PMCR` or `APP9876`, since it's a device exclusively used by Apple in their DSDTs.

**Instructions**:

- Add ***SSDT-PMC.aml***
- **For**: 300/400/500/600-series mainboards (100 and 200-series Boards use **SSDT-PPMC** instead!)

**CAUTION:** When using this patch, makes sur that the name of the Low Pin Configration Bus (`LPC`/`LPCB`) is consistent with the name used in the original DSDT.

### Checking if the patch is working
Open IORegistryExplorer and search for `PCMR`. If the SSDT works, you should find it:</br>

![Bildschirmfoto 2021-11-01 um 16 37 33](https://user-images.githubusercontent.com/76865553/139699060-75fdc4b4-ff16-448e-9e19-96af3c392064.png)

## Technical Background
> Starting from Z390 chipsets, PMC (D31:F2) is only available through MMIO. Since there is no standard device for PMC in ACPI, Apple introduced its own naming "APP9876" to access this device from AppleIntelPCHPMC driver. To avoid confusion we disable this device for all other operating systems, as they normally use another non-standard device with "PNP0C02" HID and "PCHRESV" UID.
> 
> On certain implementations, including APTIO V, PMC initialisation is required for NVRAM access. Otherwise it will freeze in SMM mode. The reason for this is rather unclear. Note, that PMC and SPI are located in separate memory regions and PCHRESV maps both, yet only PMC region is used by AppleIntelPCHPMC:
> 
> 0xFE000000~0xFE00FFFF - PMC MBAR</br>
> 0xFE010000~0xFE010FFF - SPI BAR0</br>
> 0xFE020000~0xFE035FFF - SerialIo BAR in ACPI mode</br>
> 
> PMC device has nothing to do to LPC bus, but is added to its scope for faster initialization. If we add it to PCI0, where it normally exists, it will start in the end of PCI configuration, which is too late for NVRAM support.

**CREDITS**:

- Pleasecallmeofficial: who first found this patch
- Acidathera for improving the SSDT sample.
