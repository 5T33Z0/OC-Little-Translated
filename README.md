#  OC-Little: ACPI Hotpatch Samples for OpenCore

## Description
A compendium of ACPI Hotpatches and Binary Renames for use with the OpenCore Bootloader.

**DISCLAIMER**: This is my english translation of the [OC-Little Repo by daliansky](https://github.com/daliansky/OC-little). All credits go to her/him/them.I just added some bits in pieces here and there edited and restructured it to be more readable and more unifor in terms of layout. Work in progress…

**NOTE**: Although this repo looks smaller than the original, beleive me it is not, it's just re-organized and re-structured into more useful categories. All of the content – and more – is present! 

## Table of Contents

0. [**Overview**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00.%20Overview)
   
   1. [About the ACPI Form](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00.%20Overview/i%20About%20the%20ACPI%20Form)
   2. [ACPI Source Language](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00.%20Overview/ii%20ASL%20Syntax%20Basics)
   3. [SSDT Loading Sequence](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00.%20Overview/iii%20SSDT%20Loading%20Sequence)
   4. [ASL to AML Conversion](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00.%20Overview/iv%20ASL%20to%20AML%20Conversion)

1. [**Adding Fake Devices**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01.%20Adding%20Fake%20Devices)
   
   - [Ambient Light Sensor (`ALS0`)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01.%20Adding%20Fake%20Devices/Ambient%20Light%20Sensor%20(ALS0))
   - [Embedded Controller (`EC`)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01.%20Adding%20Fake%20Devices/Embedded%20Controller%20(EC))
   - [Ethernet Controller (`NullEthernet`)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01.%20Adding%20Fake%20Devices/Ethernet%20Controller%20(LAN))
   - [Soundcard IRQ & Timer Fixes (`HPET`)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01.%20Adding%20Fake%20Devices/IRQ%20and%20Timer%20Fix%20(HPET)) 
   - [OCI2C-GPIO Patch](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01.%20Adding%20Fake%20Devices/OCI2C-GPIO%20Patch)
   - [System Clock (`AWAC`)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01.%20Adding%20Fake%20Devices/System%20Clock%20(AWAC))
   - [System Clock (`RTC0`)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01.%20Adding%20Fake%20Devices/System%20Clock%20(RTC0))

2. [**Disabling unsupported Devices**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/02.%20Disabling%20unsupported%20devices)
  
   - [Disable PCI devices](https://github.com/5T33Z0/OC-Little-Translated/tree/main/02.%20Disabling%20unsupported%20devices/Disabling%20PCI%20Sevices%20and%20ASPM/i%20Disabling%20PCI%20devices)
   - [Configuring Active State Power Managemen (`ASPM`)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/02.%20Disabling%20unsupported%20devices/Disabling%20PCI%20Sevices%20and%20ASPM/ii%20Setting%20the%20ASPM%20Operating%20Mode)
   
3. [**Adding Features**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03.%20Adding%20Features)
   - [Adding Brightness Controls (PNLF)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03.%20Adding%20Features/Adding%20Brightness%20Controls%20(PNLF))
   - [Adding CPU Power Management (SSDT-PLUG)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03.%20Adding%20Features/Adding%20CPU%20Power%20Management%20(SSDT-PLUG))
   - [Adding System Management Bus (SMBus)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03.%20Adding%20Features/Adding%20System%20Management%20Bus%20(SMBus))
   -  [Windows Compatibiliity Patch (XOSI)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03.%20Adding%20Features/Windows%20Compatibiliity%20Patch%20(XOSI))

4. [**Adding Missing Components**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04.%20Adding%20missing%20components)
 
 - `DMAC` – DMA Controller 
 - `IMEI` – IMEI Device
 - `MCHC` 
 - `MEM2`
 - `PMCR`
 - `PPMC` – Platform Power Management Controller
 - `PWRB` – Power Button Device
 - `SBUS`/ `SMBU` – System Management Bus (see "Injecting Devices")
 - `SLPB` – Sleep Button Device

5. [**USB Patches**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05.%20USB%20Fixes)

7. [**Fixing Sleep and Wake Issues**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/06.%20Fixing%20Sleep%20and%20Wake%20Issues)
	- [**06/0D Instant Wake Fix**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/06.%20Fixing%20Sleep%20and%20Wake%20Issues/060D%20Instant%20Wake%20Fix)
	- [**Fixing AOAC Machines**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/06.%20Fixing%20Sleep%20and%20Wake%20Issues/Fixing%20AOAC%20Machines)
	- [**PNP0C0E Sleep Correction Method**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/06.%20Fixing%20Sleep%20and%20Wake%20Issues/PNP0C0E%20Sleep%20Correction%20Method)
	- [**PTSWAK Sleep and Wake Fix**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/06.%20Fixing%20Sleep%20and%20Wake%20Issues/PTSWAK%20Sleep%20and%20Wake%20Fix)
   
8. [**Laptop-specific Patchesx**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/07.%20Laptop-specific%20Patches)
	-  Battery Patches
	-  Brand-specific Patches
	-  Fixing Keyboard Mappings and Brightness Keys
	-  I2C TrackPad Patches

9. **CMOS-related Fixes**

10. **ACPI Debugging**

11. [**Config Tips: Kexts Loading Sequence Examples**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/Config%20Tips:%20Kexts%20Loading%20Sequence%20Examples)

 	- config-1-Lilu-SMC-WEG-ALC load lists
   	- config-2-PS2 keyboard drives load lists
   	- config-3-BCM wireless and bluetooth drives load lists
   	- config-4-I2C+PS2 load lists
   	- config-5-PS2Smart keyboard devices load lists
   	- config-6-Intel wireless and bluetooth drives load lists

## Credits

**5T33Z0's 5H0UT 0UT5**:

- sascha_77 for Kext Upater, ANYmacOS and helping me in unbricking my Lenovo T530!
- Apfelnico for introducing me to ASL/AML Basics
- Bluebyte for having good conversations
- insanelymac.com for being a really nice community with kind mods

> **Dahliansky's original Shout Outs**
>
> - @XianWu write these ACPI component patches that useable to **[OpenCore](https://github.com/acidanthera/OpenCorePkg)** 
> - @Bat.bat, @DalianSky, @athlonreg, @iStar丶Forever their proofreading and finalisation.
> - Credits and thanks to：
>   - @冬瓜-X1C5th
>   - @OC-xlivans
>   - @Air 13 IWL-GZ-Big Orange (OC perfect)
>   - @子骏oc IWL
>   - @大勇-小新air13-OC-划水小白
>   - @xjn819
>   - Acidanthera for maintaining [OpenCorePkg](https://github.com/acidanthera/OpenCorePkg)
