# OC-Little: ACPI Hotpatch Samples for OpenCore

![](https://raw.githubusercontent.com/5T33Z0/OC-Little-Translated/main/08.%20Config%20Tips%20%26%20Tricks/maciasl.png)

Compendium of ACPI Hotpatches and Binary Renames for use with the OpenCore Bootloader based on [**OC-Little by Daliansky**](https://github.com/daliansky/OC-little). All Binary Renames, ACPI Hotpatches and everything else related to ASL/AML code remains untouched except where indicated. The chinese READMEs are included for reference as well.

<details>
<summary><strong>About the Translation</strong></summary>

**ABOUT THIS TRANSLATION:**

- I reorganized the Repo into more plausible (sub-)categories based on types of issues, components, etc.
- restructured most of the texts so that they are more logical and readable
- re-wrote sections which were confusing/misleading
- added further explanations where necessary
- added new description where there were missing
- added new content (chapters 8 to 10)

**NOTE**: Although this repo might look smaller than the original, it is not! It's just re-organized and re-structured into more useful categories. All of the content of the original is present – and then some!
</details>

## Table of Contents
#### 0. [Overview](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00.%20Overview)
- ACPI Explained
- ACPI Patches in OpenCore
- ASL to AML Conversion Table
- SSDT Loading Sequence
- Important Patches

#### 1. [Adding Fake Devices and enabling Features](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01.%20Adding%20missing%20Devices%20and%20enabling%20Features)
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

#### 2. [**Disabling unsupported Devices**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/02.%20Disabling%20unsupported%20devices)

#### 3. [**USB Port Mapping**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03.%20USB%20Fixes)

#### 4. [**Fixing Sleep and Wake Issues**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04.%20Fixing%20Sleep%20and%20Wake%20Issues)
- 06/0D Instant Wake Fix
- Fixing AOAC Machines
- PNP0C0E Sleep Correction Method
- PTSWAKTTS Sleep and Wake Fix

#### 5. [**Laptop-specific Patches**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05.%20Laptop-specific%20Patches)
- [**Battery Patches**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05.%20Laptop-specific%20Patches/Battery%20Patches)

	- Lenovo ThinkPads
   	- other brands
   	- Patches for Battery Status Information

- [**Brand-specific Patches for various Laptop Models**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05.%20Laptop-specific%20Patches/Brand-specific%20Patches)
	
	- Dell Machine Special Patch
	- Xiaoxin PRO13 Special Patch
	- Asus Machine Special Patch

- [**Fixing Keyboard Mappings and Brightness Keys**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/07.%20Laptop-specific%20Patches/Fixing%20Keyboard%20Mappings%20and%20Brightness%20Keys)

- [**TrackPad Patches for various Models**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05.%20Laptop-specific%20Patches/Fixing%20Keyboard%20Mappings%20and%20Brightness%20Keys)
	- I2C TrackPad Patches
	- ThinkPad Click and TrackPad Patches

#### 6. [**CMOS-related Fixes**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/06.%20CMOS-related%20Fixes)

#### 7. [**ACPI Debugging**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/07.%20ACPI%20Debugging)

#### 8. [**Config Tips & Tricks**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/08.%20Config%20Tips%20%26%20Tricks)
- Config.plist tipps
- Kext Loading Sequence Examples 	

#### 9. [**Terminal Commands**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09.%20Terminal%20Commands)

#### 10. [**OpenCore Calculators**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/10.%20Calculators)

## 5T33Z0's 5H0UT 0UT5:

- sascha_77 for Kext Upater, ANYmacOS and helping me to unbrick my Lenovo T530 BIOS!
- Apfelnico for introducing me to ASL/AML Basics
- Bluebyte for having good conversations
- insanelymac.com for being a really nice community with kind mods

<details>
<summary><strong>Daliansky's original Credits</strong></summary>

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
</details>
