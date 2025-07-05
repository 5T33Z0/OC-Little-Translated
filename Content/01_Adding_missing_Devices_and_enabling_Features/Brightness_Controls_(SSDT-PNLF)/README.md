# Brightness Controls (`SSDT-PNLF`)

- [About](#about)
- [**Using SSDTTime** (automated process, recommended)](#using-ssdttime-automated-process-recommended)
	- [Modifiying max brightness](#modifiying-max-brightness)
- [Other Methods](#other-methods)
	- [Acidanthera's Brightnes Patch](#acidantheras-brightnes-patch)
	- [IntelBacklight Patch (outdated)](#intelbacklight-patch-outdated)
	- [ACPI Brightness Patch (deprecated)](#acpi-brightness-patch-deprecated)
- [NOTES](#notes)

---
## About

In order to enable backlight controls on laptops, there are several ways to do so. It requires a combination of one or two kexts and a corresponding **`SSDT-PNLF`** to work. 

macOS Catalina and newer also require a Fake Ambient Light Sensor ([**`SSDT-ALS0`**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Ambient_Light_Sensor_(SSDT-ALS0))) so that the brightness level doesn't reset to maximum after rebooting.

## **Using SSDTTime** (automated process, recommended)

The python script **SSDTTime** can analyze your system's `DSDT` and generate a working custom `SSDT-PNLF` automatically. This is the easiest method which also produces the smallest amount of code. You don't need to make any manual edits to make it work. 

**Kext Requirements**: [**Lilu**](https://github.com/acidanthera/Lilu/releases) and [**WhateverGreen**](https://github.com/acidanthera/WhateverGreen/releases) 

**HOW TO:**

1. Download [**SSDTTime**](https://github.com/corpnewt/SSDTTime) and run it
2. Press <kbd>D</kbd>, drag in your system's DSDT and hit and hit <kbd>Enter</kbd>
3. Generate all the SSDTs you need.
4. The SSDTs will be stored under `Results` inside the `SSDTTime-master` Folder along with `patches_OC.plist`.
5. Copy the generated SSDTs to `EFI/OC/ACPI`
6. Open `patches_OC.plist` and copy the included entries to the corresponding section(s) of your `config.plist`.
7. Add Lilu and WhateverGreen kexts to `EFI/OC/Kexts` and your `config.plist`
8. Save and Reboot.

### Modifiying max brightness

SSDTTime's `Results` folder also contains the disassembled ASL file `SSDT-PNLF.dsl`. If you open it in maciASL, you see a section which is commented out:

```asl
// _UID |     Supported Platform(s)       | PWMMax
// ----------------------------------------------
//  14  | Arrandale, Sandy/Ivy Bridge     | 0x0710
//  15  | Haswell/Broadwell               | 0x0AD9
//  16  | Skylake/Kaby Lake, some Haswell | 0x056C
//  17  | Custom LMAX                     | 0x07A1
//  18  | Custom LMAX                     | 0x1499
//  19  | CoffeeLake and newer            | 0xFFFF
//  99  | Other (requires custom applbkl-name/applbkl-data dev props)

Name (_UID, 14)  // _UID: Unique ID: 19 
```

This `_UID` can be used to select different brightness curves stored in Whatevergreen with different levels of max brightness. In my test on an Ivy Bridge Notebook, the maximum brightness was not bright enough when using `_UID` 14, so I changed it to 15 for Haswell/Broadwell which allowed it to be brighter.

> [!IMPORTANT]
> 
> When working with the .dsl file, the `_UID` is shown as a *decimal* number. Once you export the file to .aml, this number will be converted to *hexadecimal*, so `14` will become `0x0E`, for example. So keep in mind that you have to convert the value to hex when changing it in the .aml directly!

## Other Methods

Listed below are manual approaches for fixing Laptop backlight controls. Try either or, not all!

### Acidanthera's Brightnes Patch

- Add ***SSDT-PNLF*** (included in OpenCore Package)
- Follow [**Dortania's guide**](https://dortania.github.io/Getting-Started-With-ACPI/Laptops/backlight-methods/manual.html#edits-to-the-sample-ssdt) to edit the SSDT

### IntelBacklight Patch (outdated)
- Add [**IntelBacklight.kext**](https://bitbucket.org/RehabMan/os-x-intel-backlight/src/master/)
- Disable `WhateverGreens` brightness driver:
	- Add the boot-arg: `applbkl=0` or add DeviceProperty `applbkl` and set it to `0`.
	- Modify the kext's settings: 
		- Right-click on the kext and select "Show Package Contents")
		- Open the `Info.plist` and look for: `\IOKitPersonalities\AppleIntelPanelA\IOProbeScore=5500`
- Add a Brightness Patch from [RehabMan's Laptop Hotpatch Collection](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/tree/master/hotpatch):  
    - [**SSDT-PNLF.dsl**](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-PNLF.dsl) 
    - [**SSDT-PNLFCFL.dsl**](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-PNLFCFL.dsl) (For Coffee Lake+)
    - [**SSDT-RMCF.dsl**](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-RMCF.dsl) (Rehabman Configuration File)
- Edit `SSDT-RMCF` to configure the actual `SSDT-PNLF` file. 

> [!IMPORTANT]
> 
> - RehabMan's luminance patches are inserted into `_SB.PCI0.IGPU`, so rename the `IGPU` of the patch file to the original name in ACPI (e.g. `GFX0`) when using them. 
> - RehabMan's PNLF Patches require the following binary rename:
>   ```
> 	Name: PNLF to XNLF
> 	Find: 504E4C46
> 	Replace: 584E4C46
> 	```

### [ACPI Brightness Patch](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Brightness_Controls_(SSDT-PNLF)/ACPI_Brightness_Patch#acpi-brightness-patch) (deprecated)

## NOTES
- When choosing an injection method, you should clear the driver, patch, and settings related to other methods.
- When using custom brightness patches, make sure that the `PNLF` device is injected under `_SB`. When there is a `PNLF` field in the original `ACPI`, you need to rename it, otherwise it will affect Windows boot process. 
- You can also use the SSDT-PNLF variants included in [RehabMan's Laptop Hotpatch Collection](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/tree/master/hotpatch).
