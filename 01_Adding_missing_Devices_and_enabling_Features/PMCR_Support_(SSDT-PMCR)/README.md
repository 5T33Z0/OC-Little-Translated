# Add PMCR Device (`SSDT-PMCR`)

## About
`PMCR` or `APP9876` is an Apple exclusive device which won't be present in your DSDT. It's required for mainboards with Z390 chipsets to enable NVRAM support so the system boots (see "Technical Background" for details).

### Affected Chipsets/Mainboards

- :warning: Mandatory for 390-series mainboards
- Optional for 400/500/600-series (for cosmetics)
- Users with 100 and 200-series mainboards can use [**SSDT-PPMC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Platform_Power_Management_(SSDT-PPMC)) instead!

### Instructions

- Add ***SSDT-PMCR.aml*** to `EFI/OC/ACPI` and config.plist

**CAUTION**: When using this patch, ensure that the ACPI path of the LPC Bus (`LPC` or `LPCB`) used in the SSDT is consistent with the one used in your system's `DSDT`. 

### Verifying that the patch is working
Open IORegistryExplorer and search for `PCMR`. If the SSDT works, you should find it:</br>

![Bildschirmfoto 2021-11-01 um 16 37 33](https://user-images.githubusercontent.com/76865553/139699060-75fdc4b4-ff16-448e-9e19-96af3c392064.png)

## Technical Background
> Starting from Z390 chipsets, PMCR (D31:F2) is only available through MMIO. Since there is no standard device for PMCR in ACPI, Apple introduced its own naming "APP9876" to access this device from AppleIntelPCHPMCR driver. To avoid confusion we disable this device for all other operating systems, as they normally use another non-standard device with "PNP0C02" HID and "PCHRESV" UID. […]
> 
> PMCR device has nothing to do to LPC bus, but is added to its scope for faster initialization. If we add it to PCI0, where it normally exists, it will start in the end of PCI configuration, which is too late for NVRAM support.

## Credits

- Pleasecallmeofficial who discovered this patch
- Acidathera for improving the SSDT.
