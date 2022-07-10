# Enabling Devices and Features for macOS

## About

Among the many `SSDT` patches included in this repo, a significant number of them can be categorized as patches for enabling devices, services or features in macOS. These include:

- Devices which can simply be enabled by renaming them, so macOS can detect and use them. OpenCore users should avoid this method since OpenCore applies binary renames system-wide which can break other OSes, whereas Clover restricts renames and SSDT hotpatches to macOS only.
- Devices which either do not exist in ACPI or have different names than expected by macOS to function properly. SSDT hotpatches rename these devices/methods for macOS only, so they can attach to drivers and services in macOS but work as defined in other OSes. Like USB and CPU Power Management, Backlight Control for Laptop Displays, ect.
- Fake Devices like Embedded Controllers or Ambient Light Sensors, so macOS is happy.
- Patches which rename the original device or method to something else so a replacement SSDT can be written which redefines the device or method to address issues such and Sleep and Wake or Touchpads not working properly, for example.
- Devices which are present in the `DSDT` but are disabled because they are considered legacy but macOS needs them to be enabled in order to work. A prime example for this is the Realtime Clock (RTC) which is disabled in favor of `AWAC` on Wintel machines following newer ACPI specs – usually found on mainboards with 300-series chipsets and newer.

### :warning: Don't inject already known Devices
A lot of times I come across user configs which contain ACPI Tables and DeviceProperties Hackintool extracted for them. In other words: they inject the same already known, unchanged, identical tables and properties back into macOS. This is completely unnecessary and slows down boot times as well. 

:bulb: You only need to inject SSDTs and DeviceProperties for *unknown* devices or features or in case you need to adjust parameters of devices, features etc. So please: don't inject unchanged tables and unmodified properties into the system that you got from the same system in the first place – there are no benefits to it!

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
Listed below are all SSDTs contained in this chapter. Use the listed search terms to check your system's `DSDT`. If you can't find the term/device/hardware-ID, you can add it with the corresponding SSDT. In any case, read the instructions first, to find out if you really need it and how to apply it. If there's no search term listed further analysis of the `DSDT` is required to apply the hotpatch.

#### Functional SSDTs
Listed below are SSDTs which add or enable devices and features in macOS.

|SSDT|Description|Search term(s) in DSDT 
|:----:|-------------|:-------------------:|
[**SSDT-AC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/AC_Adapter_(SSDT-AC))|Attaches AC Adapter Device to AppleACPIACAdapter Service in I/O Registry.|`ACPI0003`
[**SSDT-ALS0/ALSD**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Ambient_Light_Sensor_(SSDT-ALS0))|Adds a fake Ambient Light Sensor (SSDT-ALS0) or enables an existing one in macOS (SSDT-ALSD).|`ACPI0008`
[**SSDT-AWAC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-AWAC))|Disables AWAC system clock for macOS and force-enables RTC instead. For 300-series chipsets and newer.|`Device (AWAC)` or `ACPI000E`
[**SSDT-EC/-USBX**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Embedded_Controller_(SSDT-EC))|Adds a fake Embedded Controller (SSDT-EC) and enables USB Power Management (SSDT-EC-USBX).|`PNP0C09`
[**SSDT-GPIO**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/OCI2C-GPIO_Patch)|Enables GPIO device|–
[**SSDT-HPET**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/IRQ_and_Timer_Fix_(SSDT-HPET))|Fixes IRQ conflicts. Required for on-board sound to work|–
[**SSDT-I225V**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Intel_I225-V_Fix_(SSDT-I225V))|Fixes Inte I225-V Ethernet Controller on Gigabyte Boards|–
[**SSDT-IMEI**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Intel_MEI_(SSDT-IMEI))|Adds Intel Management Engine Interface to ACPI. Required for Intel iGPU acceleration on older Platforms.|`0x00160000`
[**SSDT-LAN**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Fake_Ethernet_Controller_(LAN))|Adds a fake Ethernet controller if the included controller isn't supported natively.|–
[**SSDT-PLUG**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management_(SSDT-PLUG))| Enables XCPM CPU Power Management for Intel CPUS|–
[**SSDT-PMC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/PMC_Support_(SSDT-PMC))|Adds Apple exclusice `PCMR` Device to ACPI (required for 300-series, optional on 400-series chipsets and newer)|`PMCR` or `APP9876`
[**SSDT-PNLF**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Brightness_Controls_(SSDT-PNLF))|Adds Backlight Control for Laptop Screens.|–
[**SSDT-PWRB/SLPB**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Power_and_Sleep_Button_(SSDT-PWRB:SSDT-SLPB))|Adds Power and Sleep Button Devices if missing (for Laptops primarily).|`PNP0C0C`(Power), `PNP0C0E`(Sleep)
[**SSDT-RTC0**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-RTC0))|Adds a fake RTC. Required for 300-series chipsets only.|`PNP0B00`
[**SSDT-SBUS-MCHC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/System_Management_Bus_and_Memory_Controller_(SSDT-SBUS-MCHC))|Fixes System Management Bus and Memory Controller in macOS|`0x001F0003` or `0x001F0004`
[**SSDT-XCPM**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Xtra_Enabling_XCPM_on_Ivy_Bridge_CPUs)|SSDT and Kernel Patches and to force-enable XCPM Power Management on Ivy Bridge CPUs|–
[**SSDT-XOSI**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/OS_Compatibility_Patch_(XOSI))|OS Compatibility Patch. Read for details.|–

#### Cosmetic SSDTs (optional)
The SSDTs listed below are considered cosmetic and non-essential. They add devices which are present in real Macs. Adding any of these tables does not add or enable features besides _mimicking the look_ of the I/O registy of the Mac model selected in the SMBIOS/PlatformInfo section:

> It is unjustified why these devices are needed on our machines. Just the fact they are present in Apple ACPI does not make it a requirement for our ACPI. 
> 
> [**– vit9696**](https://github.com/acidanthera/OpenCorePkg/pull/121#issuecomment-696825376)

Basically, any SSDTs which define devices that are not already present in the system's DSDT have to be considered _fake_ or _virtual_. You can easily verfiy this by checking the added device(s) in I/O Registry: if the device in questions contains collapsed sections, they will snap close again as soon as you click on them because no data can be gathered for it.

Nonetheless, I included them here for two reasons:

1. It's your choice to use them or not
2. For documentary purposes. Sometimes it can be strenuous to find out what a device listed in an `.ioreg` file actually is and does. 

|SSDT|Description|Search term(s) in DSDT
|:----:|-------------|:-------------------:|
[**SSDT-ARTC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Fake_Apple_RTC_(SSDT-ARTC))|Adds fake ARTC Device (Apple Realtime Clock) to IOReg. For Intel Core 9th Gen and newer. Uses same HID as AWAC.| `ACPI000E` 
[**SSDT-DMAC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/DMA_Controller_(SSDT-DMAC))|Adds fake DMA Controller to the device tree.|`PNP0200` or `DMAC`
[**SSDT-FWHD**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Fake_Firmware_Hub_(SSDT-FWHD))|Adds fake Firmware Hub Device (FWHD) to IOReg. Used by almost every intel-based Mac.|`INT0800`
[**SSDT-MEM2**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/SSDT-MEM2)|Adds MEM2 Device to iGPU (for 4th to 7th Gen Intel Core CPUs)|`PNP0C01`
[**SSDT-PPMC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Platform_Power_Management_(SSDT-PPMC))| Adds fake Platform Power Management Controller to I/O Registry (100/200-series chipsets only).|`0x001F0002` or `Device (PPMC)`
[**SSDT-XSPI**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Intel_PCH_SPI_Controller_(SSDT-XSPI))|Adds fake Intel PCH SPI Controller to IOReg. Present on 10th gen Macs (and some 9th Gen Mobile CPUs). Probably cosmetic, although uncertain.|`0x001F0005` 

## Resources
[**DarwinDumped**](https://github.com/khronokernel/DarwinDumped) – IO Reg Collection by khronokernel
