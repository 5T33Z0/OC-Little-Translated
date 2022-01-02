# Enabling Devices and Features for macOS
## About

Among the many `SSDT` patches included in this repo, a significant number of them can be categorized as patches for enabling devices, services or features in macOS. These include:

- Devices which can simply be enabled by renaming them, so macOS can detect and use them. OpenCore users should avoid this method since OpenCore applies binary renames system-wide which can break other OSes, whereas Clover restricts renames and SSDT hotpatches to macOS only.
- Devices which either do not exist in ACPI or have different names than expected by macOS to function properly. SSDT hotpatches rename these devices/methods for macOS only, so they can attach to drivers and services in macOS but work as defined in other OSes. Like USB and CPU Power Management, Backlight Control for Laptop Displays, ect.
- Fake Devices like Embedded Controllers or Ambient Light Sensors, so macOS is happy.
- Patches which rename the original device or controlling method to something else so a replacement SSDT can be written which takes its place and redefines the device or method, to address Sleep and Wake issues or Touchpads working incorrectly.
- Devices which are disabled for some reason, but macOS needs them to be present in order to boot, like legacy Realtime Clocks (RTC) in newer ACPI variants (300-series chipsets and newer)

## Properties of Fake ACPI Devices

- **Features**:
  - The device already exists in ACPI, is relatively short, small and self-contained in code.  
  - The original device has a canonical `_HID` or `_CID` parameter.
  - Even if the original device is not disabled, patching with a fake device will not harm ACPI.
- **Requirements**:
  - The fake name **differs** from the original device name used in ACPI.
  - Patch content and original device main content are **identical**.
  - The `_STA` section of the hotpatch should contain the [`_OSI`](https://uefi.org/specs/ACPI/6.4/05_ACPI_Software_Programming_Model/ACPI_Software_Programming_Model.html#osi-operating-system-interfaces) method to ensure that the code changes only apply to macOS (Darwin Kernel) only:
	```swift
	Method (_STA, 0, NotSerialized)
       {
            If (_OSI ("Darwin"))
            {
                Return (0x0F)
            }
            Else
            {
                Return (Zero)
            }
        }
	```
- **Example**: [**Adding a fake Realtime Clock (RTC0)**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-RTC0))
  
  - ***SSDT-RTC0*** - Fake RTC
  - Original device name: RTC
  - _HID: `PNP0B00`

**Important**: The path and name of the Low Pin Configuration Bus used in a SSDT – either `LPC` or `LPCB` – must match the one used in the original ACPI tabled in order for a patch to work!

## Adding missing Devices and Features

Although adding any of the missing parts listed below may improve performance, they can only be regarded as a refinement. They are not a necessity for getting your Hackintosh to work, except for `PMCR` which may be a requirement for Z390 Chipsets. Browse through the folders above to find out which you may need.

### Preparations
In order to add/apply any of the Devices/Patches, it is necessary to research your machine's ACPI - more specifically, the `DSDT`. To obtain a copy of the DSDT, it is necessary to dump it from your system's ACPI Table. There are a few options to do this.

#### Dumping the DSDT

- Using **Clover** (easiest way): hit `F4` in the Boot Menu. You don't even need a working configuration to do this. Just download the latest [**Release**](https://github.com/CloverHackyColor/CloverBootloader/releases) as a .zip file, extract it to a USB stick. The Dump will be located at: `EFI\CLOVER\ACPI\origin`
- Using **SSDTTime** (in Windows): if you use SSDTTime under Windows, you can dump the DSDT, which is not possible if you use it under macOS.
- Using **OpenCore** (requires Debug version and working config): enable Misc > Debug > `SysReport` Quirk. The DSDT will be dumped during next boot.

### Included Hotpatches
Listed below are all SSDTs contained in this chapter. Search for the listed terms in your system's `DSDT`. If you can't find the term/device/hardware-ID, you can add it with the corresponding SSDT. In any case, read the instructions first, to find out if you really need it and how to apply it. If there's no search term listed further analysis of the `DSDT` is required to apply the hotpatch.

#### Functional SSDTs (which add or enable features)
|SSDT|Description|Search term(s) in DSDT 
|:----:|-------------|:-------------------:|
[**SSDT-AWAC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-AWAC))|Disables AWAC system clock for macOS and force-enables RTC instead. For 300-series chipsets and newer.|`Device (AWAC)` or `ACPI000E` 
[**SSDT-ALS0/ALSD**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Ambient_Light_Sensor_(SSDT-ALS0))|Adds a fake Ambient Light Sensor (SSDT-ALS0) or enables an existing one in macOS (SSDT-ALSD).|`ACPI0008`
[**SSDT-NAVI**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/AMD_Radeon_Tweaks)|For AMD Navi Cards running in macOS|–
[**SSDT-PNLF**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Brightness_Controls_(SSDT-PNLF))|Adds Backlight Control for Laptop Screens.|–
[**SSDT-PLUG**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management_(SSDT-PLUG))| Enables XCPM CPU Power Management for Intel CPUS|–
[**SSDT-EC/-USBX**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Embedded_Controller_(SSDT-EC))|Adds a fake Embedded Controller (SSDT-EC) and enables USB Power Management (SSDT-EC-USBX).|`PNP0C09`
[**SSDT-LAN**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Fake_Ethernet_Controller_(LAN))|Adds a fake Ethernet controller if the included controller isn't supported natively.|–
[**SSDT-HPET**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/IRQ_and_Timer_Fix_(SSDT-HPET))|Fixes IRQ conflicts. Required for on-board sound to work|–
[**SSDT-IMEI**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Intel_MEI_(SSDT-IMEI))|Adds Intel Management Engine Interface to ACPI. Required for Intel iGPU acceleration on older Platforms.|`0x00160000`
[**SSDT-GPIO**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/OCI2C-GPIO_Patch)|Enables GPIO device|–
[**SSDT-XOSI**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/OS_Compatibility_Patch_(XOSI))|OS Compatibility Patch. Read for details.|–
[**SSDT-PMC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/PMC_Support_(SSDT-PMC))|Adds Apple exclusice `PCMR` Device to ACPI (required for 300-series, optional on 400-series chipsets and newer)|`PMCR` or `APP9876`
[**SSDT-RX…**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/AMD_Radeon_Tweaks)|Performance Tweaks for some AMD Radeon RX Cards|
[**SSDT-PWRB/SSDT-SLPB**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Power_and_Sleep_Button_(SSDT-PWRB:SSDT-SLPB))|Adds Power and Sleep Button Devices if missing (for Laptops primarily).|`PNP0C0C`(Power), `PNP0C0E`(Sleep)
[**SSDT-RTC0**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-RTC0))|Adds a fake RTC. Required for 300-series chipsets only.|`PNP0B00` 
[**SSDT-SBUS-MCHC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/System_Management_Bus_and_Memory_Controller_(SSDT-SBUS-MCHC))|Fixes System Management Bus and Memory Controller in macOS|`0x001F0003` or `0x001F0004`
[**SSDT-XCPM**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Xtra_Enabling_XCPM_on_Ivy_Bridge_CPUs)|SSDT and Kernel Patches and to force-enable XCPM Power Management on Ivy Bridge CPUs|–

#### Cosmetic SSDTs 
The SSDTs listed below will most likely not add or enable any features besides being present in the IO Registry as a device or service, so it _looks_ more like a genuine Mac model as defined by the SMBIOS.

|SSDT|Description|Search term(s) in DSDT
|:----:|-------------|:-------------------:|
[**SSDT-AC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/AC_Adapter_(SSDT-AC))|Attaches AC Adapter Device to AppleACPIACAdapter Service in IOReg|`ACPI0003`
[**SSDT-DMAC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/DMA_Controller_(SSDT-DMAC))|Adds DMA Controller to IOReg|`PNP0200` or `DMAC`
[**SSDT-PPMC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Platform_Power_Management_(SSDT-PPMC))| Adds Platform Power Management Controller to IOReg (for 100- and 200-series chipsets only). Possibly cosmetic only.|`0x001F0002` or `Device (PPMC)`
[**SSDT-MEM2**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/SSDT-MEM2)|Adds Mem Device to iGPU (for 4th to 7th Gen Intel Core CPUs)|`PNP0C01`
[**SSDT-XSPI**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Intel_PCH_SPI_Controller_(SSDT-XSPI))|Adds Intel PCH SPI Controller to IOReg. Present on 10th gen Macs (and some 9th Gen Mobile CPUs). Probably cosmetic, although uncertain.|`0x001F0005` 
[**SSDT-ARTC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Fake_Apple_RTC_(SSDT-ARTC))|Adds ARTC Device (Apple Realtime Clock) to IOReg. For Intel Core 9th Gen and newer. Uses same HID as AWAC.| `ACPI000E` 
[**SSDT-FWHD**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Fake_Firmware_Hub_(SSDT-FWHD))|Adds FWHD (Firmware Hub Device) to IOReg. Used by a lot of Macs.|`INT0800`

## Resources
[**DarwinDumped**](https://github.com/khronokernel/DarwinDumped) by khronokernel
