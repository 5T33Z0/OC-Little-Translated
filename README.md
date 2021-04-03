# OC-Little: ACPI Hotpatch Samples for OpenCore

A compendium of ACPI Hotpatches and Binary Renames for use with the OpenCore Bootloader.

**DISCLAIMER**: This is my english translation of the OC-Little Repo by [daliansky](https://github.com/daliansky/OC-little). All credits go to her/him/them. All Binary Renames, ACPI Hotpatches and everything else related to ASL/AML code remains untouched! The chinese READMEs are included as references as well.

**ABOUT THIS TRANSLATION:**

- I reorganized the Repo into more plausible categories and sub-categories based on types of issues, components, etc.
- restructured most of the texts so that they are more logical and readable
- re-wrote sections which were confusing/misleading
- added further explanation where necessary
- added new texts where there were missing (work in progress)
- added contents which was not present (work in progress)

**NOTE**: Although this repo looks smaller than the original, believe me it is not, it's just re-organized and re-structured into more useful categories. All of the content – and more – is present!

## Table of Contents

0. [**Overview**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00.%20Overview)
   1. [About the ACPI Form](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00.%20Overview/i%20About%20the%20ACPI%20Form)
   2. [ACPI Source Language](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00.%20Overview/ii%20ASL%20Syntax%20Basics)
   3. [SSDT Loading Sequence](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00.%20Overview/iii%20SSDT%20Loading%20Sequence)
   4. [ASL to AML Conversion](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00.%20Overview/iv%20ASL%20to%20AML%20Conversion)

1. [**Adding Fake Devices**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01.%20Adding%20Fake%20Devices)
	* [Ambient Light Sensor (ALS0)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01.%20Adding%20Fake%20Devices/Ambient%20Light%20Sensor%20(ALS0))
	* [Embedded Controller (EC)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01.%20Adding%20Fake%20Devices)
	* [Ethernet Controller (NullEthernet)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01.%20Adding%20Fake%20Devices/Ethernet%20Controller%20(LAN))
	* [Soundcard IRQ & Timer Fixes (HPET)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01.%20Adding%20Fake%20Devices/IRQ%20and%20Timer%20Fix%20(HPET))
	* [OCI2C-GPIO Patch](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01.%20Adding%20Fake%20Devices/OCI2C-GPIO%20Patch)
	* [System Clock (AWAC)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01.%20Adding%20Fake%20Devices/System%20Clock%20(AWAC))
	* [System Clock (RTC0)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01.%20Adding%20Fake%20Devices/System%20Clock%20(RTC0))

2. [**Disabling unsupported Devices**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/02.%20Disabling%20unsupported%20devices)

3. [**Enabling Features**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03.%20Enabling%20Features)
	- [Enabling CPU Power Management (SSDT-PLUG)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03.%20Enabling%20Features/How%20to%20enabe%20CPU%20Power%20Management%20(SSDT-PLUG))
	- [Enabling Brightness Controls (PNLF)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03.%20Enabling%20Features/How%20to%20enable%20Brightness%20Controls%20(PNLF))
	- [Adding System Management Bus (SMBus)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03.%20Enabling%20Features/How%20to%20enabel%20System%20Management%20Bus%20(SMBus))
	- [Windows Compatibility Patch (XOSI)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03.%20Enabling%20Features/Windows%20Compatibiliity%20Patch%20(XOSI))

4. [**Adding Missing Components**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04.%20Adding%20missing%20components)
	- DMAC – DMA Controller
	- IMEI – Intel MEI
	- MCHC – Memory Controller
	- MEM2 – ? missing explanation…
	- PMCR - Fixes NVRAM on 300-series Mainboards
	- PPMC – Platform Power Management Controller
	- PWRB - Power Button Device
	- SLPB – Sleep Button Device
	- SBUS/SMBU – System Management Bus

5. [**USB Patches**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05.%20USB%20Fixes)

6. [**Fixing Sleep and Wake Issues**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/06.%20Fixing%20Sleep%20and%20Wake%20Issues)
	- 06/0D Instant Wake Fix
	- Fixing AOAC Machines
	- PNP0C0E Sleep Correction Method
	- PTSWAKTTS Sleep and Wake Fix

7. [**Laptop-specific Patches**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/07.%20Laptop-specific%20Patches)

	- **Battery Patches**:

		- Lenovo ThinkPads
    	- other brands
    	- Patches for Battery Status Information

	- **Brand-specific Patches for the following Laptop Models**:

    	- Dell Machine Special Patch
    	- Xiaoxin PRO13 Special Patch
    	- Asus Machine Special Patch

	- **Fixing Keyboard Mappings and Brightness Keys**

	- **TrackPad Patches for various Models**
		- I2C TrackPad Patches
		- ThinkPad Click and TrackPad Patches

8. [**CMOS-related Fixes**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/08.%20CMOS-related%20Fixes)

9. [**ACPI Debugging**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09.%20ACPI%20Debugging)

10. [**Config Tips: Kexts Loading Sequence Examples**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/Config%20Tips:%20Kexts%20Loading%20Sequence%20Examples)
___

## 5T33Z0's 5H0U7 0U75:

- sascha_77 for Kext Upater, ANYmacOS and helping me to unbrick my Lenovo T530 BIOS!
- Apfelnico for introducing me to ASL/AML Basics
- Bluebyte for having good conversations
- insanelymac.com for being a really nice community with kind mods

Daliansky's original Shout Outs and Credits:

> - Special credit to：
>	- @XianWu write these ACPI component patches that useable to OpenCore
>	- @Bat.bat, @DalianSky, @athlonreg, @iStar丶Forever their proofreading and finalisation.
>	- Credits and thanks to：
>	-  @冬瓜-X1C5th
>	- @OC-xlivans
>	- @Air 13 IWL-GZ-Big Orange (OC perfect)
>	- @子骏oc IWL
>	- @大勇-小新air13-OC-划水小白
>	- @xjn819
>	- Acidanthera for maintaining OpenCorePkg
