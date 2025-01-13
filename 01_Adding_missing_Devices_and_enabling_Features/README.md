# Enabling Devices and Features for macOS

**TABLE of CONTENTS**

- [About](#about)
- [Properties of Virtual Devices](#properties-of-virtual-devices)
- [Obtaining ACPI Tables](#obtaining-acpi-tables)
  - [Dumping ACPI tables with Clover (easiest and fastest method)](#dumping-acpi-tables-with-clover-easiest-and-fastest-method)
  - [Dumping ACPI tables with OpenCore (requires Debug version)](#dumping-acpi-tables-with-opencore-requires-debug-version)
  - [Dumping ACPI tables with `SSDTTime` (Windows version only)](#dumping-acpi-tables-with-ssdttime-windows-version-only)
- [Adding missing Devices and Features](#adding-missing-devices-and-features)
  - [Functional SSDTs](#functional-ssdts)
  - [Cosmetic SSDTs (optional)](#cosmetic-ssdts-optional)
- [Converting `.dsl` files to `.aml`](#converting-dsl-files-to-aml)
- [Applying different ACPI patches for different versions of macOS](#applying-different-acpi-patches-for-different-versions-of-macos)
- [SSDTs vs. `config.plist`: Understanding Property Injection Precedence](#ssdts-vs-configplist-understanding-property-injection-precedence)
- [Avoid patches by Olarila/MalD0n](#avoid-patches-by-olarilamald0n)
- [Resources](#resources)

---

## About
Among the many `SSDT` (Secondary System Description Table) patches available in this repo, a significant number of them are for enabling devices, services or features in macOS. They can be divided into four main categories:

- **Virtual Devices**, such as Fake Embedded Controllers or Ambient Light Sensors, etc. These just need to be present, so macOS is happy and works as expected.
- **Devices which exist in the `DSDT` but are disabled by the vendor.** These are usually devices considered "legacy" under Windows but are required by macOS to boot. They are still present in the system's `DSDT` and provide the same functionality but are disabled in favor of a newer device. A prime example for this is the Realtime Clock (`RTC`) which is disabled in favor of the `AWAC` clock on modern Wintel machines, like 300-series mainboards and newer. SSDT Hotfixes from this category disable the newer device and enable its "legacy" pendent for macOS only by inverting their statuses (`_STA`). 
- **Devices which either do not exist in ACPI or use different names than expected by macOS in order to work**. SSDT hotpatches rename these devices/methods for macOS only, so they can attach to drivers and services in macOS but work as intended in other OSes as well, such as: USB and CPU Power Management, Backlight Control for Laptop Displays, ect. 
- **Patch combinations which work in stages to redefine a device or method so it works with macOS**. First, the original device/method is renamed so macOS doesn't detect it, like `_DSM` to `XDSM` for example. Then a replacement SSDT is written which redefines the device or method for macOS only. The redefined device/method is then injected back into the system, so it's working as expected in macOS. Examples: fixing Sleep and Wake issues or enabling Trackpads.

:bulb: OpenCore users should avoid using binary renames for enabling devices and methods since these renames will be applied system-wide which can break other OSes. Instead, ACPI-compliant SSDTs making use of the `_OSI` method to rename these devices/methods for macOS only should be applied. 

Clover users don't have to worry about this since binary renames and SSDT hotpatches are not injected into other OSes (unless you tell it to do so). But if you are a Clover user switching over to OpenCore, you have to adjust your SSDTs since they most likely don't contain the `_OSI` method!

> [!WARNING] 
> 
> Don't inject already known Devices! Sometimes I come across configs which contain a lot of unnecessary `DeviceProperties` which Hackintool extracted for them. In other words: they inject the same, already known devices and properties back into the system where they came from. In most cases, this is completely unnecessary – there are no benefits in doing so – and it slows down the boot process as well.
>
> The only reason for doing this is to have installed PCIe cards listed in the "PCI" section of System Profiler. Apart from that, all detected devices will be listed in the corresponding category they belong in automatically. So there's really no need to do this.
>
>:bulb: You only need to inject DeviceProperties in case you need to modify parameters/properties of devices, features, etc. So don't inject the same, unmodified properties into the system you got them from in the first place!

## Properties of Virtual Devices
- **Features**:
  - The device already exists in the ACPI system, is relatively small and self-contained in code.  
  - The original device has a canonical **`_HID`** or **`_CID`** parameter.
  - Even if the original device is not disabled, adding a virtual device while macOS is running will not cause conflicts.
- **Requirements**:
  - The name of the fake/virtual device ***differs*** from the original device name used in the ACPI table.
  - Patch content and original device main content are **identical**.
  - The **`_STA`** method of the hotpatch must contain the [**`If (_OSI ("Darwin"))`**](https://uefi.org/specs/ACPI/6.4/05_ACPI_Software_Programming_Model/ACPI_Software_Programming_Model.html#osi-operating-system-interfaces) method to ensure that the patch is only applied to macOS (Darwin Kernel):
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
- **Example**: [**Fixing IRQ Conflicts**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/IRQ_and_Timer_Fix_(SSDT-HPET))

> [!IMPORTANT]
>
> The name and path of the [**Low Pin Count Bus**](https://www.intel.com/content/dam/www/program/design/us/en/documents/low-pin-count-interface-specification.pdf) used in an `SSDT` – usually `LPC` or `LPCB` – must match the one used in the original ACPI tabled in order for a patch to work!

## Obtaining ACPI Tables
In order to to figure out which SSDTs are required for your system, it is necessary to research your machine's ACPI tables - more specifically, your system's `DSDT` (Differentiated System Description Table) stored in your system's BIOS/UEFI. There are a couple of options to obtain a copy of it listed below.

**Requirements**: FAT32 formatted USB flash drive (for Clover/OpenCore) and one of the following methods to dump your system's ACPI tables.

### Dumping ACPI tables with Clover (easiest and fastest method)
Clover can dump ACPI tables *without* a working config within seconds.

- Download the latest [**Release**](https://github.com/CloverHackyColor/CloverBootloader/releases) (CloverV2-51xx.zip) and extract it 
- Put the `EFI` folder on the USB flash drive. 
- Start the system from the flash drive. 
- Hit `F4` in the Boot Menu. The screen should blink once.
- Pull the USB flash drive, reset the system and reboot into your OS
- Put the USB flash drive back in. The dumped ACPI tables will be stored on the flash drive under: `EFI\CLOVER\ACPI\origin`.

### Dumping ACPI tables with OpenCore (requires Debug version)
Normally, you would need an already working `config.plist` in order to obtain the ACPI tables from your system with OpenCore. But since you need the ACPI tables *first* in order to figure out which SSDT hotfixes you *actually* need to boot macOS this is a real dilemma. Luckily, the guys from Utopia-Team have created a generic, pre-configured Debug OpenCore EFI which can dump your system's ACPI tables *without* a bootable config.

- Download the [**OC Debug EFI**](https://github.com/utopia-team/opencore-debug/releases) and extract it
- Put the `EFI` folder on the USB flash drive. 
- Start the system from the flash drive.
- Let the text run through until you reach the text-based boot menu. This takes about a minute
- Pull out the USB stick and reboot into a working OS.
- Put the USB flash drive back in. The dumped ACPI tables will be located in the "SysReport".

### Dumping ACPI tables with `SSDTTime` (Windows version only)
If you are using [**SSDTTime**](https://github.com/corpnewt/SSDTTime) in Microsoft Windows, you can also dump the DSDT, which is not possible when running it in macOS. 

- Download **SSDTTime**
- Double-click on `SSDTTime.bat`
- You should see a menu with a lot of options. 
- Press "p" to dump the `DSDT`
- It will be located in a sub-folder called "Results".

> [!NOTE]
> 
> If you get an error message because automatic downloading of the required tools (`iasl.exe` and `acpidump.exe`) fails, download them manually [here](https://www.intel.com/content/www/us/en/download/774881/acpi-component-architecture-downloads-windows-binary-tools.html), extract the .zip, place both executables in the "Scripts" folder and run the `SSDTTime.bat` file again.

## Adding missing Devices and Features
Listed below, you will find two categories of ACPI hotfixes: essential (or functional) and non-essential SSDTs. **Functional** SSDTs are a *necessity* for booting macOS on Wintel systems. Some SSDTs might be required based on the used macOS version (e.g. `SSDT-ALS0` or `SSDT-PNLF`), some are required based on the used CPU and/or chipset (e.g. `SSDT-HPET`, `SSDT-AWAC` or `SSDT-PMCR`). Non-essential (or **cosmetic**) SSDTs can only be regarded as a refinement. These are not a necessity for getting your Hackintosh to work. Read the descriptions or browser through the folders above to find out which you may need.

The hotfixes have to be placed in `EFI/OC/ACPI` and added to the `config.plist` (under `ACPI/Add`). OpenCore accepts files with `.aml` and `.bin` extension.

> [!NOTE]
> 
> You can use the Python Script [**SSDTTime**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/_SSDTTime) to generate a lot of relevant SSDT hotfixes automatically. 

### Functional SSDTs
Listed below are SSDTs which add or enable devices and features in macOS. Use the listed search terms to find the device in your system's `DSDT`. If there's no search term listed, further analysis of the `DSDT` is required to apply the hotpatch. Read the description of a hotpatch first to find out if you really need it and how to apply it correctly.

|SSDT|Description|Search term(s) in DSDT 
|:----:|-------------|:-------------------:|
[**SSDT-ALS0/ALSD**](/01_Adding_missing_Devices_and_enabling_Features/Ambient_Light_Sensor_(SSDT-ALS0)/README.md)|Adds a fake Ambient Light Sensor (SSDT-ALS0) or enables an existing one in macOS (SSDT-ALSD). Also included in OpenCorePkg.|`ACPI0008`
[**SSDT-AWAC**](/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-AWAC)/README.md)|Disables AWAC system clock for macOS and force-enables RTC instead. For 300-series chipsets and newer. Also included in OpenCorePkg.|`Device (AWAC)` or `ACPI000E`
[**SSDT-BRG0**](/11_Graphics/GPU/GPU_undetected/README.md)|For enabling undetected AMD GPUs sitting behind an intermediate PCI bridge without an ACPI device name assigned to it. Also included in OpenCorePkg.| –
[**SSDT-Darwin**](/01_Adding_missing_Devices_and_enabling_Features/SSDT-Darwin/README.md)|Enhances the `_OSI` method to allow for macOS version detection. Allows injecting different properties for devices for different versions of macOS.
[**SSDT-DTGP**](/01_Adding_missing_Devices_and_enabling_Features/Method_DTGP/README.md)|Adds `DTPG` method. Only required when the method is addressed but not contained in the SSDT itself.|–
[**SSDT-EC/-USBX**](/01_Adding_missing_Devices_and_enabling_Features/Embedded_Controller_(SSDT-EC)/README.md)|Adds a fake Embedded Controller (SSDT-EC) and enables USB Power Management (SSDT-EC-USBX). Also included in OpenCorePkg.|`PNP0C09`
[**SSDT-GPIO**](/01_Adding_missing_Devices_and_enabling_Features/OCI2C-GPIO_Patch/README.md)|Enables GPIO device.|–
[**SSDT-HPET**](/01_Adding_missing_Devices_and_enabling_Features/IRQ_and_Timer_Fix_(SSDT-HPET)/README.md)| Fixes IRQ conflicts. Required for on-board sound to work.|–
[**SSDT-I225V**](/01_Adding_missing_Devices_and_enabling_Features/Intel_I225-V_Fix_(SSDT-I225V))|Fixes Intel I225-V Ethernet Controller on Gigabyte Boards.|–
[**SSDT-HV-…**](/01_Adding_missing_Devices_and_enabling_Features/Enabling_Hyper-V_(SSDT-HV-...)/README.md)|Set of SSDTs to enable Hyper-V in macOS. Requires additional Kext and binary renames. Also included in OpenCorePkg.|–
[**SSDT-IMEI**](/01_Adding_missing_Devices_and_enabling_Features/Intel_MEI_(SSDT-IMEI)/README.md)|Adds Intel Management Engine Interface to ACPI. Required for Intel iGPU acceleration on older Platforms. Also included in OpenCorePkg.|`0x00160000`
[**SSDT-LAN**](/01_Adding_missing_Devices_and_enabling_Features/Fake_Ethernet_Controller_(LAN)/README.md)|Adds a fake Ethernet controller if the included controller isn't supported natively.|–
[**SSDT-NAVI**](/11_Graphics/GPU/AMD_Navi/README.md)|Enables AMD Navi GPUs in macOS|–
[**SSDT-PLUG**](/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(SSDT-PLUG)/README.md)| Enables XNU CPU power management (XCPM) for Intel CPUs (only required up to macOS 11). Also included in OpenCorePkg.|–
[**SSDT-PM**](/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(Legacy)/README.md)|CPU Power Management for legacy Intel CPUs (1st to 3rd Gen).| –
[**SSDT-PMCR**](/01_Adding_missing_Devices_and_enabling_Features/PMCR_Support_(SSDT-PMCR)/README.md)|Adds Apple exclusive `PCMR` Device to ACPI (required for 300-series only). Also included in OpenCorePkg.|`PMCR` or</br> `APP9876`
[**SSDT-PNLF**](/01_Adding_missing_Devices_and_enabling_Features/Brightness_Controls_(SSDT-PNLF)/README.md)|Adds Backlight Control for Laptop Screens. Also included in OpenCorePkg.|–
[**SSDT-PWRB/SLPB**](/01_Adding_missing_Devices_and_enabling_Features/Power_and_Sleep_Button_(SSDT-PWRB_SSDT-SLPB)/README.md)|Adds Power and Sleep Button Devices if missing (for Laptops primarily).|`PNP0C0C`(Power), `PNP0C0E`(Sleep)
[**SSDT-RTC0**](/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-RTC0)/README.md) </br>[**SSDT-RTC0-RANGE**](https://dortania.github.io/Getting-Started-With-ACPI/Universal/awac-methods/manual-hedt.html#seeing-if-you-need-ssdt-rtc0-range)|Adds a fake Real Time Clock. Required for (real) 300-series mainboards (RTCO) and X299 (RTC0-Range) only! Also included in OpenCorePkg.|`PNP0B00`
[**SSDT-SBUS-MCHC**](/01_Adding_missing_Devices_and_enabling_Features/System_Management_Bus_and_Memory_Controller_(SSDT-SBUS-MCHC)README.md)|Fixes System Management Bus and Memory Controller in macOS. Also included in OpenCorePkg.|`0x001F0003` or</br> `0x001F0004`
[**SSDT-UNC**](https://dortania.github.io/Getting-Started-With-ACPI/Universal/unc0.html) |Disables unused uncore bridges to prevent kernel panics in macOS 11+. Affected chipsets: X99, X79, C602, C612. Also included in OpenCorePkg.|–
[**SSDT-XCPM**](/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/Enabling_XCPM_on_Ivy_Bridge_CPUs/README.md)|SSDT and Kernel Patches and to force-enable XCPM Power Management on Ivy Bridge CPUs.| –
[**SSDT-XOSI**](/01_Adding_missing_Devices_and_enabling_Features/OS_Compatibility_Patch_(XOSI)/README.md)|OS Compatibility Patch. Also included in OpenCorePkg.|–

### Cosmetic SSDTs (optional)
The SSDTs listed below are considered cosmetic and non-functional – they are not needed!. They add virtual versions of devices existing in real Macs. Adding any of the tables listed below, ***does not*** add or enable any features besides mimicking the ***look*** of the I/O registry of the corresponding Mac model (as defined in the SMBIOS). To quote one of the developers of OpenCore:

> It is unjustified why these devices are needed on our machines. Just the fact they are present in Apple ACPI does not make it a requirement for our ACPI. 
>
> – [**vit9696**](https://github.com/acidanthera/OpenCorePkg/pull/121#issuecomment-696825376)

|SSDT|Description|Search term(s) in DSDT
|:----:|-------------|:-------------------:|
[**SSDT-AC**](/01_Adding_missing_Devices_and_enabling_Features/AC_Adapter_(SSDT-AC)/README.md)|Attaches AC Adapter Device to `AppleACPIACAdapter` Service in I/O Registry. No longer needed since `VirtualSMC` and `SMCBatteryManager` handle this nowadays.|`ACPI0003`
[**SSDT-ARTC**](/01_Adding_missing_Devices_and_enabling_Features/Fake_Apple_RTC_(SSDT-ARTC)/README.md)|Adds fake `ARTC` Device (Apple Realtime Clock) to IOReg. For Intel Core 9th Gen and newer. Uses the same `_HID` as `AWAC`.| `ACPI000E` 
[**SSDT-DMAC**](/01_Adding_missing_Devices_and_enabling_Features/DMA_Controller_(SSDT-DMAC)/README.md)|Adds fake DMA Controller to the device tree.|`PNP0200` or</br> `DMAC`
[**SSDT-FWHD**](/01_Adding_missing_Devices_and_enabling_Features/Fake_Firmware_Hub_(SSDT-FWHD)/README.md)|Adds fake Firmware Hub Device (`FWHD`) to IOReg. Used by almost every Intel-based Mac.|`INT0800`
[**SSDT-MEM2**](/01_Adding_missing_Devices_and_enabling_Features/SSDT-MEM2/README.md)|Adds `MEM2` Device to the iGPU (for 4th to 7th Gen Intel Core CPUs)|`PNP0C01`
[**SSDT-PPMC**](/01_Adding_missing_Devices_and_enabling_Features/Platform_Power_Management_(SSDT-PPMC)/README.md)| Adds fake Platform Power Management Controller to I/O Registry (100/200-series chipsets only).|`0x001F0002` or</br> `Device (PPMC)`
[**SSDT-XSPI**](/01_Adding_missing_Devices_and_enabling_Features/Intel_PCH_SPI_Controller_(SSDT-XSPI)/README.md)|Adds fake Intel PCH SPI Controller to IOReg. Present on 10th gen Macs (and some 9th Gen Mobile CPUs). Probably cosmetic, although uncertain.|`0x001F0005` 

---

## Converting `.dsl` files to `.aml`
The Hotfixes in this section are provided as disassembled ASL Files (`.dsl`) so that they can be viewed in webbrowser. In order to use them in Bootloaders, they need to be converted to ASL Machine Language (`.aml`) first. Here's how to do this:

1. Click on the link to a `.dsl` file of your choice. This will display the code contained in the file
2. Download the file (there's a download button on the top right; "Download raw file").
3. Open it in [**maciASL**](https://github.com/acidanthera/MaciASL).
4. Edit the file (if necessary).
5. Click on "File" > "Save As…".
6. From the "File Format" dropdown menu, select "ACPI Machine Language Binary"
7. Save it as "SSDT–…" (whatever the original file name was).
8. Add the `.aml` file to `EFI/OC/ACPI` and your `config.plist` (under `ACPI/Add`).
9. Save and reboot to test it.

## Applying different ACPI patches for different versions of macOS

As you may know, the ACPI specs allow to apply different settings based on the detected Operating System by making use of the method (`_OSI`) (Operating System Interface). Hackintoshers make heavy use of the method `If (_OSI ("Darwin"))` in SSDTs to apply patches only if macOS is running.

What if you need to apply different patches for the same device depending on the macOS version—for instance, switching to a different `AAPL,ig-platform-id` and framebuffer patch to make your unsupported iGPU work in a newer macOS version? By default, this isn’t possible because the ACPI specifications don’t support such functionality. It’s essentially an all-or-nothing situation: the Darwin kernel is either running, or it isn’t.

Luckily, a relatively new kext called [**OSIEnhancer**](https://github.com/b00t0x/OSIEnhancer) addresses this issue. It enables modifications to the OSI ("Darwin") method, giving you greater control over when a patch is applied. With OSIEnhancer, you can specify the Darwin kernel and/or macOS version, effectively introducing functionality similar to the `MinKernel` and `MaxKernel` settings for kexts, but applied to ACPI tables.

Since OSIEnhancer is a relatively new kext, there aren’t many SSDT examples available for reference – some can be find on the repo, though. Its use cases tend to be highly specific and tailored to individual machines, as the patches often depend on unique hardware configurations and the macOS versions in question. This makes it more of a "per-machine" solution, requiring users to create custom SSDTs that address their particular needs. As a result, implementing OSIEnhancer may involve some trial and error, along with a solid understanding of ACPI and system-specific requirements.

## SSDTs vs. `config.plist`: Understanding Property Injection Precedence

In OpenCore, **properties injected via SSDTs (Secondary System Description Tables) typically take precedence over those defined in the `config.plist`**, provided the SSDTs are correctly implemented and loaded. This precedence is due to the hierarchical nature of how macOS processes ACPI tables and device properties during the boot sequence.

**Understanding the Hierarchy:**

1. **ACPI Level (SSDTs):**
   - **Function:** SSDTs are used to define or override ACPI tables, allowing for low-level hardware configuration and property injection.
   - **Precedence:** Since SSDTs are loaded early in the boot process, they can establish or modify device properties at a fundamental level.

2. **Bootloader Level (`config.plist`):**
   - **Function:** The `config.plist` file in OpenCore is used to configure various bootloader settings, including device property injections.
   - **Precedence:** Properties defined here are applied after the ACPI tables have been processed. If a property has already been set by an SSDT, the `config.plist` may not override it unless explicitly configured to do so.

**Practical Implications:**

- **USB Power Properties:** Injecting USB power properties via an SSDT (e.g., creating a `USBX` device) is a common practice to ensure proper USB functionality. This method is often preferred over injecting the same properties via `config.plist` because it integrates the properties at a lower level, leading to more reliable behavior. 

- **Device Renaming:** Certain device renaming tasks, such as changing `GFX0` to `IGPU`, are better handled within SSDTs or by using kexts like WhateverGreen, which can perform these renames dynamically. This approach is generally safer and more effective than attempting the same renames via `config.plist`. 

**Recommendations:**

- **Use SSDTs for Hardware-Level Configurations:** For tasks that require low-level hardware interaction, such as injecting USB power properties or renaming devices, implementing these changes via SSDTs is advisable. This method ensures that the properties are applied early in the boot process, leading to more consistent behavior.

- **Use `config.plist` for Bootloader and High-Level Settings:** For configurations that pertain to the bootloader itself or high-level system settings, the `config.plist` is appropriate. This includes settings like boot arguments, enabling or disabling kexts, and other bootloader-specific options.

**Conclusion:**

While both SSDTs and the `config.plist` can be used to inject properties in OpenCore, the precedence and timing of their application differ. SSDTs, being part of the ACPI layer, are processed earlier and can override properties set later in the boot process by the `config.plist`. Therefore, for critical hardware-level property injections, SSDTs are generally the preferred method.

For more detailed guidance on configuring OpenCore and the use of SSDTs, you can refer to the [**OpenCore Configuration Documentation**](https://dortania.github.io/docs/latest/Configuration.html).  

## Avoid patches by Olarila/MalD0n 

> [!CAUTION]
> 
> Avoid using pre-made OpenCore (and Clover) EFI folders from MalD0n/Olarila as they include a generic `SSDT-OLARILA.aml` which injects all sorts of devices which your system may not even need. It also injects an "Olarila" branding into the "About this Mac" section. To get rid of it, delete `Device (_SB.PCI0.OLAR)` and `Device (_SB.PCI0.MALD)` from this SSDT. Or even better: delete the whole file and add individual SSDTs for the devices/features your system actually needs instead.

## Resources
[**DarwinDumped**](https://github.com/khronokernel/DarwinDumped) – IORegistry collection of almost any Mac model by khronokernel
