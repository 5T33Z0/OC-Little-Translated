# OC-Little: ACPI Hotpatch Samples for OpenCore

![](https://raw.githubusercontent.com/5T33Z0/OC-Little-Translated/main/08_Config_Tips_and_Tricks/maciasl.png)

Compendium of ACPI Hotpatches and Binary Renames for use with the OpenCore Bootloader based on [**OC-Little by Daliansky**](https://github.com/daliansky/OC-little). All Binary Renames, ACPI Hotpatches and everything else related to ASL/AML code remains untouched except where indicated. The chinese READMEs are included for reference as well.

<details>
<summary><strong>About the Translation</strong></summary>

## About the Translation:

- AI-based translation using deepL, google translator and manual copyediting.
- Restructured the repository into more plausible sections and (sub-)categories based on types of issues, components, methods, etc.
- Rearranged Text for better readability and comprehensibility
- Rewrote sections which were confusing/misleading
- Added missing descriptions
- Added further explanations where necessary
- Added new content (Chapters 8 to 11)

**NOTE**: Due to the fact that I don't speak chinese some of the translation might not be 100% accurate.
</details>

## Table of Contents
#### 0. [**Overview**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00_Overview)
- ACPI Explained
- ACPI Patches in OpenCore
- ASL to AML Conversion Table
- SSDT Loading Sequence
- Important Patches
#### 1. [**Adding Fake Devices and enabling Features**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features)
- Ambient Light Sensor (SSDT-ALS0)
- Brightness Controls (SSDT-PNLF)
- CPU Power Management (SSDT-PLUG)
- DMA Controller (SSDT-DMAC)
- Embedded Controller (SSDT-EC)
- Fake Ethernet Controller
- Intel MEI (SSDT-IMEI)
- IRQ and Timer Fix (SSDT-HPET)
- MEM2 - Laptop iGPU related (SSDT-MEM2)
- NVRAM Fix (SSDT-PMCR)
- OCI2C-GPIO Patch
- Platform Power Management (SSDT-PPMC)
- Power Button (SSDT-PWRB) & Sleep Button (SSDT-SLPB)
- System Clock (SSDT-AWAC)
- System Clock (SSDT-RTC0)
- System Management Bus (SMBus) & Memory Controller (MCHC)
- OS Compatibility Patch (XOSI)
- Xtra: Enabling XCPM on Ivy Bridge CPUs
#### 2. [**Disabling unsupported Devices**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/02_Disabling_unsupported_devices)
#### 3. [**USB Port Mapping**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03_USB_Fixes)
#### 4. [**Fixing Sleep and Wake Issues**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues)
- 06/0D Instant Wake Fix
- Fixing AOAC Machines
- PNP0C0E Sleep Correction Method
- PTSWAKTTS Sleep and Wake Fix
#### 5. [**Laptop-specific Patches**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05.%20Laptop-specific%20Patches)
- [**Battery Patches**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05.%20Laptop-specific%20Patches/Battery%20Patches)

	- Lenovo ThinkPads
   	- Other brands
   	- Patches for Battery Status

- [**Brand-specific Patches for various Laptop Models**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05.%20Laptop-specific%20Patches/Brand-specific%20Patches)
	
	- Dell Laptop Special Patch
	- Xiaoxin PRO13 Special Patch
	- Asus Laptop Special Patch

- [**Fixing Keyboard Mappings and Brightness Keys**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/07.%20Laptop-specific%20Patches/Fixing%20Keyboard%20Mappings%20and%20Brightness%20Keys)

- [**TrackPad Patches for various Models**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05.%20Laptop-specific%20Patches/Fixing%20Keyboard%20Mappings%20and%20Brightness%20Keys)
	- I2C TrackPad Patches
	- ThinkPad Click and TrackPad Patches
#### 6. [**CMOS-related Fixes**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/06.%20CMOS-related%20Fixes)
#### 7. [**ACPI Debugging**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/07.%20ACPI%20Debugging)
#### 8. [**Config Tips & Tricks**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/08.%20Config%20Tips%20%26%20Tricks)
- Config.plist tips
- Kext Loading Sequence Examples 	
#### 9. [**Terminal Commands**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09.%20Terminal%20Commands)
#### 10. [**OpenCore Calculators**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/10.%20Calculators)
#### 11. [**Essential Apps and Tools**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/11.%20Essential%20Tools%20and%20Apps)

## 5T33Z0's 5H0UT 0UT5:

- sascha_77 for Kext Updater, ANYmacOS and helping me to unbrick my Lenovo T530 BIOS!
- Apfelnico for introducing me to ASL/AML Basics
- Bluebyte for having good conversations
- insanelymac.com for being a really nice community with kind mods

<details>
<summary><strong>Daliansky's original Credits</strong></summary>

> - Special credit to：
>	- @XianWu write these ACPI component patches that useable to OpenCore
>	- @Bat.bat, @DalianSky, @athlonreg, @iStar丶Forever their proofreading and finalization.
>	- Credits and thanks to：
>	-  @冬瓜-X1C5th
>	- @OC-xlivans
>	- @Air 13 IWL-GZ-Big Orange (OC perfect)
>	- @子骏oc IWL
>	- @大勇-小新air13-OC-划水小白
>	- @xjn819
>	- Acidanthera for maintaining OpenCorePkg
</details>
