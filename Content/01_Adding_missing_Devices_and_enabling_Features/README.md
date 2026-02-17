# Enabling Devices and Features via SSDTs

## About

Listed below, you will find two categories of ACPI hotfixes: essential (or functional) and non-essential SSDTs. **Functional** SSDTs are a *necessity* for booting macOS on Wintel systems. Some SSDTs might be required based on the used macOS version (e.g. `SSDT-ALS0` or `SSDT-PNLF`), some are required based on the used CPU and/or chipset (e.g. `SSDT-HPET`, `SSDT-AWAC` or `SSDT-PMCR`). Non-essential (or **cosmetic**) SSDTs can only be regarded as a refinement. These are not a necessity for getting your Hackintosh to work. Read the descriptions or browser through the folders above to find out which you may need.

The hotfixes have to be placed in `EFI/OC/ACPI` and added to the `config.plist` (under `ACPI/Add`). OpenCore accepts files with `.aml` and `.bin` extension.

### More Details
&rarr; For a deeper understanding about SSDTs, fake devices, property injection, obtaining ACPI tables from your system, etc., check the [**Additional Info**](_Additional_Info/README.md) section!

## Automated SSDT generation

You can use Corpnewt's Python Script [**SSDTTime**](_SSDTTime/README.md) to generate required SSDT hotfixes and ACPI patches for your system automatically.
 
## Functional SSDTs
Listed below are SSDTs which add or enable devices and features in macOS. Use the listed search terms to find the device in your system's `DSDT`. If there's no search term listed, further analysis of the `DSDT` is required to apply the hotpatch. Read the description of a hotpatch first to find out if you really need it and how to apply it correctly.

|SSDT|Description|Search term(s) in DSDT 
|:----:|-------------|:-------------------:|
[**SSDT-ALS0/ALSD**](Ambient_Light_Sensor_(SSDT-ALS0))|Adds a fake Ambient Light Sensor (SSDT-ALS0) or enables an existing one in macOS (SSDT-ALSD). Also included in OpenCorePkg.|`ACPI0008`
[**SSDT-AWAC**](System_Clock_(SSDT-AWAC))|Disables AWAC system clock for macOS and force-enables RTC instead. For 300-series chipsets and newer. Also included in OpenCorePkg.|`Device (AWAC)` or `ACPI000E`
[**SSDT-BRG0**](/Content/11_Graphics/GPU/GPU_undetected/)|For enabling undetected AMD GPUs sitting behind an intermediate PCI bridge without an ACPI device name assigned to it. Also included in OpenCorePkg.| –
[**SSDT-Darwin**](SSDT-Darwin/README.md)|Enhances the `_OSI` method to allow for macOS version detection. Allows injecting different properties for devices for different versions of macOS.
[**SSDT-DTGP**](Method_DTGP)|Adds `DTPG` method. Only required when the method is addressed but not contained in the SSDT itself.|–
[**SSDT-EC/-USBX**](Embedded_Controller_(SSDT-EC))|Adds a fake Embedded Controller (SSDT-EC) and enables USB Power Management (SSDT-EC-USBX). Also included in OpenCorePkg.|`PNP0C09`
[**SSDT-GPIO**](OCI2C-GPIO_Patch)|Enables GPIO device.|–
[**SSDT-HPET**](IRQ_and_Timer_Fix_(SSDT-HPET)) | Fixes IRQ conflicts. Required for on-board sound to work.| –
[**SSDT-I225V**](Intel_I225-V_Fix_(SSDT-I225V))|Fixes Intel I225-V Ethernet Controller on Gigabyte Boards.|–
[**SSDT-HV-…**](Enabling_Hyper-V_(SSDT-HV-.../README.md))|Set of SSDTs to enable Hyper-V in macOS. Requires additional Kext and binary renames. Also included in OpenCorePkg.|–
[**SSDT-IMEI**](Intel_MEI_(SSDT-IMEI))|Adds Intel Management Engine Interface to ACPI. Required for Intel iGPU acceleration on older Platforms. Also included in OpenCorePkg.|`0x00160000`
[**SSDT-LAN**](Fake_Ethernet_Controller_(LAN))|Adds a fake Ethernet controller if the included controller isn't supported natively.|–
[**SSDT-NAVI**](/Content/11_Graphics/GPU/AMD_Navi/)|Enables AMD Navi GPUs in macOS|–
[**SSDT-PLUG**](CPU_Power_Management/CPU_Power_Management_(SSDT-PLUG))| Enables XNU CPU power management (XCPM) for Intel CPUs (only required up to macOS 11). Also included in OpenCorePkg.|–
[**SSDT-PM**](CPU_Power_Management_(Legacy))|CPU Power Management for legacy Intel CPUs (1st to 3rd Gen).| –
[**SSDT-PMCR**](PMCR_Support_(SSDT-PMCR))|Adds Apple exclusive `PCMR` Device to ACPI (required for 300-series only). Also included in OpenCorePkg.|`PMCR` or</br> `APP9876`
[**SSDT-PNLF**](Brightness_Controls_(SSDT-PNLF))|Adds Backlight Control for Laptop Screens. Also included in OpenCorePkg.|–
[**SSDT-PWRB/SLPB**](/Content/01_Adding_missing_Devices_and_enabling_Features/Power_and_Sleep_Button_(SSDT-PWRB_SSDT-SLPB)/README.md)|Adds Power and Sleep Button Devices if missing (for Laptops primarily).|`PNP0C0C`(Power), `PNP0C0E`(Sleep)
[**SSDT-RTC0**](/Content/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-RTC0)/README.md) </br>[**SSDT-RTC0-RANGE**](https://dortania.github.io/Getting-Started-With-ACPI/Universal/awac-methods/manual-hedt.html#seeing-if-you-need-ssdt-rtc0-range)|Adds a fake Real Time Clock. Required for (real) 300-series mainboards (RTCO) and X299 (RTC0-Range) only! Also included in OpenCorePkg.|`PNP0B00`
[**SSDT-SBUS-MCHC**](/Content/01_Adding_missing_Devices_and_enabling_Features/System_Management_Bus_and_Memory_Controller_(SSDT-SBUS-MCHC)README.md)|Fixes System Management Bus and Memory Controller in macOS. Also included in OpenCorePkg.|`0x001F0003` or</br> `0x001F0004`
[**SSDT-UNC**](https://dortania.github.io/Getting-Started-With-ACPI/Universal/unc0.html) |Disables unused uncore bridges to prevent kernel panics in macOS 11+. Affected chipsets: X99, X79, C602, C612. Also included in OpenCorePkg.|–
[**SSDT-XCPM**](/Content/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/Enabling_XCPM_on_Ivy_Bridge_CPUs/README.md)|SSDT and Kernel Patches and to force-enable XCPM Power Management on Ivy Bridge CPUs.| –
[**SSDT-XOSI**](/Content/01_Adding_missing_Devices_and_enabling_Features/OS_Compatibility_Patch_(XOSI)/README.md)|OS Compatibility Patch. Also included in OpenCorePkg.|–

## Cosmetic SSDTs (optional)
The SSDTs listed below are considered cosmetic and non-functional – they are not needed!. They add virtual versions of devices existing in real Macs. Adding any of the tables listed below, ***does not*** add or enable any features besides mimicking the ***look*** of the I/O registry of the corresponding Mac model (as defined in the SMBIOS). To quote one of the developers of OpenCore:

> It is unjustified why these devices are needed on our machines. Just the fact they are present in Apple ACPI does not make it a requirement for our ACPI. 
>
> – [**vit9696**](https://github.com/acidanthera/OpenCorePkg/pull/121#issuecomment-696825376)

|SSDT|Description|Search term(s) in DSDT
|:----:|-------------|:-------------------:|
[**SSDT-AC**](/Content/01_Adding_missing_Devices_and_enabling_Features/AC_Adapter_(SSDT-AC)/README.md)|Attaches AC Adapter Device to `AppleACPIACAdapter` Service in I/O Registry. No longer needed since `VirtualSMC` and `SMCBatteryManager` handle this nowadays.|`ACPI0003`
[**SSDT-ARTC**](/Content/01_Adding_missing_Devices_and_enabling_Features/Fake_Apple_RTC_(SSDT-ARTC)/README.md)|Adds fake `ARTC` Device (Apple Realtime Clock) to IOReg. For Intel Core 9th Gen and newer. Uses the same `_HID` as `AWAC`.| `ACPI000E` 
[**SSDT-DMAC**](/Content/01_Adding_missing_Devices_and_enabling_Features/DMA_Controller_(SSDT-DMAC)/README.md)|Adds fake DMA Controller to the device tree. Might be helpful when trying to [activate AppleVTD](/Content/20_AppleVTD) |`PNP0200` or</br> `DMAC`
[**SSDT-FWHD**](/Content/01_Adding_missing_Devices_and_enabling_Features/Fake_Firmware_Hub_(SSDT-FWHD)/README.md)|Adds fake Firmware Hub Device (`FWHD`) to IOReg. Used by almost every Intel-based Mac.|`INT0800`
[**SSDT-MEM2**](/Content/01_Adding_missing_Devices_and_enabling_Features/SSDT-MEM2/README.md)|Adds `MEM2` Device to the iGPU (for 4th to 7th Gen Intel Core CPUs)|`PNP0C01`
[**SSDT-PPMC**](/Content/01_Adding_missing_Devices_and_enabling_Features/Platform_Power_Management_(SSDT-PPMC)/README.md)| Adds fake Platform Power Management Controller to I/O Registry (100/200-series chipsets only).|`0x001F0002` or</br> `Device (PPMC)`
[**SSDT-XSPI**](/Content/01_Adding_missing_Devices_and_enabling_Features/Intel_PCH_SPI_Controller_(SSDT-XSPI)/README.md)|Adds fake Intel PCH SPI Controller to IOReg. Present on 10th gen Macs (and some 9th Gen Mobile CPUs). Probably cosmetic, although uncertain.|`0x001F0005` 

---

> [!CAUTION]
> 
> Avoid using pre-made OpenCore (and Clover) EFI folders from MalD0n/Olarila as they include a generic `SSDT-OLARILA.aml` which injects all sorts of devices which your system may not even need. It also injects an "Olarila" branding into the "About this Mac" section. To get rid of it, delete `Device (_SB.PCI0.OLAR)` and `Device (_SB.PCI0.MALD)` from this SSDT. Or even better: delete the whole file and add individual SSDTs for the devices/features your system actually needs instead.

## Further Resources
[**DarwinDumped**](https://github.com/khronokernel/DarwinDumped) – IORegistry collection of almost any Mac model by khronokernel
