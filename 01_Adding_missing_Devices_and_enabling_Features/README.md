# Enabling Devices and Features for macOS

## About

Among the many `SSDT` patches available in this repo, a significant number of them are for enabling devices, services or features in macOS. They can be divided into four main categories:

- **Virtual Devices**, such as Fake Embedded Controllers or Ambient Light Sensors, etc. These just need to be present, so macOS is happy and works as expected.
- **Devices which exist in the `DSDT` but are disabled by the vendor.** These are usually devices considered "legacy" under Windows but are required by macOS to boot. They are still present in the system's `DSDT` and provide the same functionality but are disabled in favor of a newer device. A prime example for this is the Realtime Clock (`RTC`) which is disabled in favor of the `AWAC` clock on modern Wintel machines, like 300-series mainboards and newer. SSDT Hotfixes from this category disable the newer device and enable its "legacy" pendent for macOS only by inverting their statuses (`_STA`). 
- **Devices which either do not exist in ACPI or use different names than expected by macOS in order to work**. SSDT hotpatches rename these devices/methods for macOS only, so they can attach to drivers and services in macOS but work as intended in other OSes as well, such as: USB and CPU Power Management, Backlight Control for Laptop Displays, ect. 
- **Patch combinations which work in stages to redefine a device or method so it works with macOS**. First, the original device/method is renamed so macOS doesn't detect it, like `_DSM` to `XDSM` for example. Then a replacement SSDT is written which redefines the device or method for macOS only. The redefined device/method is then injected back into the system, so it's working as expected in macOS. Examples: fixing Sleep and Wake issues or enabling Touchpads.

:bulb: OpenCore users should avoid using binary renames for enabling devices and methods since these renames will be applied system-wide which can break other OSes. Instead, ACPI-compliant SSDTs making use of the `_OSI` method to rename these devices/methods for macOS only should be applied. Clover users don't have to worry about this since binary rename and SSDT hotpatches are not injected into other OSes (unless you tell it to do so).

### :warning: Don't inject already known Devices
Sometimes I come across configs which contain a lot of unnecessary `DeviceProperties` which Hackintool extracted for them. In other words: they inject the same already known devices and properties back into the system where they came from. In most cases, this is completely unnecessary – there are no benefits in doing so – and it slows down the boot process as well.

The only reason for doing this is to have installed PCIe cards listed in the "PCI" section of System Profiler. Apart from that, all detected devices will be listed in the corresponding category they belong to automatically. So there's really no need to do this.

:bulb: You only need to inject DeviceProperties in case you need to modify parameters/properties of devices, features etc. So please: don't inject the same, unmodified properties into the system you got them from in the first place.

## Properties of Virtual ACPI Devices

- **Features**:
  - The device already exists in ACPI, is relatively short, small and self-contained in code.  
  - The original device has a canonical `_HID` or `_CID` parameter.
  - Even if the original device is not disabled, patching with a fake device will not harm ACPI.
- **Requirements**:
  - The fake name **differs** from the original device name used in ACPI.
  - Patch content and original device main content are **identical**.
  - The `_STA` section of the hotpatch should contain the [`_OSI`](https://uefi.org/specs/ACPI/6.4/05_ACPI_Software_Programming_Model/ACPI_Software_Programming_Model.html#osi-operating-system-interfaces) method to ensure that the code changes only apply to macOS (Darwin Kernel) only:
	```asl
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

#### Obtaining ACPI Tables
**Requirements**: FAT32 formatted USB flash drive (for Clover/OpenCore) and one of the following methods to dump your system's ACPI tables:

- Using **Clover** (easiest and fastest way): Clover can dump ACPI tables without a working config within seconds.
	- Download the latest [**Release**](https://github.com/CloverHackyColor/CloverBootloader/releases) (CloverV2-51xx.zip) and extract it 
	- Put the `EFI` folder on the USB flash drive. 
	- Start the system from the flash drive. 
	- Hit `F4` in the Boot Menu. The screen should blink once.
	- Pull the USB flash drive, reset the system and boot into macOS
	- Put the USB flash drive back in. The dumped ACPI tables will be stored on the flash drive under: `EFI\CLOVER\ACPI\origin`.
- Using **OpenCore**: Normally, you would need a working config to do this. But the guys from Utopia-Team have created a generic, pre-build Debug EFI which can do it *without* it.
	- Download the [**OC Debug EFI**](https://github.com/utopia-team/opencore-debug/releases) and extract it
	- Put the `EFI` folder on the USB flash drive. 
	- Start the system from the flash drive.
	- Let the text run through until you reach the text-based boot menu. This takes about a minute
	- Pull out the USB stick and reboot into a working OS.
	- Put the USB flash drive back in. The dumped ACPI tables will be located in the "SysReport".
- Using [**SSDTTime**](https://github.com/corpnewt/SSDTTime) (Windows only): if you use SSDTTime under Windows, you can also dump the DSDT, which is not possible under macOS.

### Included Hotpatches
Listed below are all SSDTs contained in this chapter. Use the listed search terms to check your system's `DSDT`. If you can't find the term/device/hardware-ID, you can add it with the corresponding SSDT. In any case, read the instructions first, to find out if you really need it and how to apply it. If there's no search term listed further analysis of the `DSDT` is required to apply the hotpatch.

#### Functional SSDTs
Listed below are SSDTs which add or enable devices and features in macOS.

|SSDT|Description|Search term(s) in DSDT 
|:----:|-------------|:-------------------:|
[**SSDT-AC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/AC_Adapter_(SSDT-AC))|Attaches AC Adapter Device to AppleACPIACAdapter Service in I/O Registry.|`ACPI0003`
[**SSDT-ALS0/ALSD**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Ambient_Light_Sensor_(SSDT-ALS0))|Adds a fake Ambient Light Sensor (SSDT-ALS0) or enables an existing one in macOS (SSDT-ALSD).|`ACPI0008`
[**SSDT-AWAC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-AWAC))|Disables AWAC system clock for macOS and force-enables RTC instead. For 300-series chipsets and newer.|`Device (AWAC)` or `ACPI000E`
[**SSDT-DTGP**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Method_DTGP)|Adds DTPG method. Required for some other SSDTs to work which address this method.
[**SSDT-EC/-USBX**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Embedded_Controller_(SSDT-EC))|Adds a fake Embedded Controller (SSDT-EC) and enables USB Power Management (SSDT-EC-USBX).|`PNP0C09`
[**SSDT-GPIO**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/OCI2C-GPIO_Patch)|Enables GPIO device|–
[**SSDT-HPET**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/IRQ_and_Timer_Fix_(SSDT-HPET))|Fixes IRQ conflicts. Required for on-board sound to work|–
[**SSDT-I225V**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Intel_I225-V_Fix_(SSDT-I225V))|Fixes Inte I225-V Ethernet Controller on Gigabyte Boards|–
[**SSDT-HV-…**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Enabling_Hyper-V_(SSDT-HV-...))|Set of SSDTs to enable Hyper-V in macOS. Requires addtional Kext and binary renames.|
[**SSDT-IMEI**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Intel_MEI_(SSDT-IMEI))|Adds Intel Management Engine Interface to ACPI. Required for Intel iGPU acceleration on older Platforms.|`0x00160000`
[**SSDT-LAN**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Fake_Ethernet_Controller_(LAN))|Adds a fake Ethernet controller if the included controller isn't supported natively.|–
[**SSDT-NAVI**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/11_Graphics/GPU/AMD_Navi)|Enables AMD Navi GPUs in macOS
[**SSDT-PLUG**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management_(SSDT-PLUG))| Enables XNU CPU power management (XCPM) for Intel CPUs (only req'd for macOS ≤ 11)|–
[**SSDT-PMC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/PMC_Support_(SSDT-PMC))|Adds Apple exclusice `PCMR` Device to ACPI (required for 300-series, optional on 400-series chipsets and newer)|`PMCR` or</br> `APP9876`
[**SSDT-PNLF**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Brightness_Controls_(SSDT-PNLF))|Adds Backlight Control for Laptop Screens.|–
[**SSDT-PWRB/SLPB**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Power_and_Sleep_Button_(SSDT-PWRB:SSDT-SLPB))|Adds Power and Sleep Button Devices if missing (for Laptops primarily).|`PNP0C0C`(Power), `PNP0C0E`(Sleep)
[**SSDT-RTC0**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-RTC0))|Adds a fake RTC. Required for 300-series chipsets only.|`PNP0B00`
[**SSDT-SBUS-MCHC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/System_Management_Bus_and_Memory_Controller_(SSDT-SBUS-MCHC))|Fixes System Management Bus and Memory Controller in macOS|`0x001F0003` or</br> `0x001F0004`
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
[**SSDT-DMAC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/DMA_Controller_(SSDT-DMAC))|Adds fake DMA Controller to the device tree.|`PNP0200` or</br> `DMAC`
[**SSDT-FWHD**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Fake_Firmware_Hub_(SSDT-FWHD))|Adds fake Firmware Hub Device (FWHD) to IOReg. Used by almost every intel-based Mac.|`INT0800`
[**SSDT-MEM2**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/SSDT-MEM2)|Adds MEM2 Device to iGPU (for 4th to 7th Gen Intel Core CPUs)|`PNP0C01`
[**SSDT-PPMC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Platform_Power_Management_(SSDT-PPMC))| Adds fake Platform Power Management Controller to I/O Registry (100/200-series chipsets only).|`0x001F0002` or</br> `Device (PPMC)`
[**SSDT-XSPI**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Intel_PCH_SPI_Controller_(SSDT-XSPI))|Adds fake Intel PCH SPI Controller to IOReg. Present on 10th gen Macs (and some 9th Gen Mobile CPUs). Probably cosmetic, although uncertain.|`0x001F0005` 

## Resources
[**DarwinDumped**](https://github.com/khronokernel/DarwinDumped) – IO Reg Collection by khronokernel
