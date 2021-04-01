#  OC-Little: ACPI Hotpatch Samples for OpenCore

## Description
A compendium of ACPI Hotpatches and Binary Renames for use with the OpenCore Bootloader.

**DISCLAIMER**: This is my english translation of the [OC-Little Repo by daliansky](https://github.com/daliansky/OC-little). All credits go to her/him/them.I just added some bits in pieces here and there edited and restructured it to be more readable and more uniform in terms of layout. I also reorganized the whole content into categories which make more sense. Work in progress…

## Table of Contents

0. [**Overview**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00.%20Overview)
   
   1. [About the ACPI Form](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00.%20Overview/i%20About%20the%20ACPI%20Form)
   2. [ACPI Source Language](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00.%20Overview/ii%20ASL%20Syntax%20Basics)
   3. [SSDT Loading Sequence](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00.%20Overview/iii%20SSDT%20Loading%20Sequence)
   4. [ASL to AML Conversion](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00.%20Overview/iv%20ASL%20to%20AML%20Conversion)

1. **About AOAC**
   
   1. Prevent `S3` sleep
   2. `AOAC` disable discrete GPU
   3. Power management deep idle
   4. `AOAC` wake patch
   5. Auto power off bluetooth `WIFI` while sleep

3. **Fake Devices**
   
   1. Fake `EC`
   2. Fake `RTC0` 
   3. Fake Ambient Light Sensor (`ALS0`)
   4. Sound Card IRQ Patch (HPET)
   5. Fake Ethernet 

2. **AWAC & GPIO Fixes**
   
   1. `I2C-GPIO` Patch
   2. `AWAC` Patch

4. **Windows Compatibility Patch (`XOSI`)**

5. **Injecting Devices**
   
   1. CPU Power Management (`SSDT-PLUG`)  
   2. Brightness Control (`PNLF`)
   3. Inject SMBus (`SSDT-SBUS(SMBU)`
   
6. **Add Missing Components**
 
 - `DMAC` – DMA Controller 
 - `IMEI` – IMEI Device
 - `MCHC` 
 - `MEM2`
 - `PMCR`
 - `PPMC` – Platform Power Management Controller
 - `PWRB` – Power Button Device
 - `SBUS`/ `SMBU` – System Management Bus (see "Injecting Devices")
 - `SLPB` – Sleep Button Device

7. **Keyboard Mapping & Brightness Controls** (`RMCF`) 

8. **Battery Patches**
   
   1. ThinkPad
   2. Other brands
   3. Battery status indicator patch
   4. Example

9.  **Disabling EHCx**

10. **`PTSWAK` Sleep and Wake Fix**

11. **`PNP0C0E` Sleep Correction Method**

12. **`0D6D` Instant Wake Fix**

    1. General `060D` patch
    2. HP `060D` patch

13. **Fake Ethernet & Reset Ethernet `BSD Name`**

14. **CMOS-related Fixes**

    1. `CMOS` memory & `RTCMemoryFixup` 

15. **`ACPI`-based `USB` Patches**

16. **Disable `PCI` Devices and Set `ASPM` state**
    
    1. Disable `PCI` Devices
    2. Set `ASPM` state

17. **ACPI Debugging**

18. **Laptop Patches**

    1. `Dell` patches
    2. `XiaoXin PRO13` patches
    3. `ThinkPad` patches

19. **Fixing `I2C` Device**

20. **Disabling unspoorted GPUs**

**Reserved Patches**

   1. Audio card `IRQ` patch
   2. `CMOS` reset patch

**Common Drivers Loading Sequence Examples**

   1. config-1-Lilu-SMC-WEG-ALC load lists
   2. config-2-PS2 keyboard drives load lists
   3. config-3-BCM wireless and bluetooth drives load lists
   4. config-4-I2C+PS2 load lists
   5. config-5-PS2Smart keyboard devices load lists
   6. config-6-Intel wireless and bluetooth drives load lists

### Credits

- Special credit to：
  - @XianWu write these ACPI component patches that useable to **[OpenCore](https://github.com/acidanthera/OpenCorePkg)** 
  - @Bat.bat, @DalianSky, @athlonreg, @iStar丶Forever their proofreading and finalisation.

- Credits and thanks to：
  - @冬瓜-X1C5th
  - @OC-xlivans
  - @Air 13 IWL-GZ-Big Orange (OC perfect)
  - @子骏oc IWL
  - @大勇-小新air13-OC-划水小白
  - @xjn819
  - Acidanthera for maintaining [OpenCorePkg](https://github.com/acidanthera/OpenCorePkg)
