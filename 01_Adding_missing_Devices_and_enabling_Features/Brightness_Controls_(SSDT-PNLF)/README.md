# Brightness Controls (`SSDT-PNLF`)

## `PNLF` Injection Methods

To inject Brightness Control, there are several ways to do so. But no matter which one you choose, it requires the combination of a kext and a corresponding **`SSDT-PNLF`** to work. If you are using macOS Catalina or newer, you also need a Fake Ambient Light Sensor **([`SSDT-ALS0`](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Ambient_Light_Sensor_(SSDT-ALS0)))** so that the brightness level doesn't reset to maximum after rebooting.

### Method 1: **Using SSDTTime** (automated process)

With the python script **SSDTTime**, you can generate the following SSDTs by analyzing your system's `DSDT`:

* ***[SSDT-AWAC](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-AWAC))*** – Context-aware AWAC and Fake RTC
* ***[SSDT-BRG0](https://github.com/5T33Z0/OC-Little-Translated/tree/main/11_Graphics/GPU/GPU_undetected)*** – ACPI device for missing PCI bridges for passed device path
* ***[SSDT-EC](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Embedded_Controller_(SSDT-EC))*** – OS-aware fake EC for Desktops and Laptops
* ***[SSDT-USBX](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Embedded_Controller_(SSDT-EC))*** – Adds USB power properties for Skylake and newer SMBIOS
* ***[SSDT-HPET](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/IRQ_and_Timer_Fix_(SSDT-HPET))*** – Patches out IRQ Conflicts
* ***[SSDT-PLUG](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management_(SSDT-PLUG))*** – Sets plugin-type to `1` on `CPU0`/`PR00` to enable the X86PlatformPlugin for CPU Power Management
* ***[SSDT-PMC](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/PMCR_Support_(SSDT-PMCR))*** – Enables Native NVRAM on true 300-Series Boards and newer
* ***[SSDT-PNLF](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Brightness_Controls_(SSDT-PNLF))*** – PNLF device for laptop backlight control
* ***SSDT-USB-Reset*** – Resets USB controllers to allow USB port mapping

**NOTE**: When used in Windows, SSDTTime also can dump the `DSDT`.

1. Download [**SSDTTime**](https://github.com/corpnewt/SSDTTime) and run it
2. Press <kbd>D</kbd>, drag in your system's DSDT and hit and hit <kbd>Enter</kbd>
3. Generate all the SSDTs you need.
4. The SSDTs will be stored under `Results` inside the `SSDTTime-master` Folder along with `patches_OC.plist`.
5. Copy the generated SSDTs to `EFI/OC/ACPI`
6. Open `patches_OC.plist` and copy the included entries to the corresponding section(s) of your `config.plist`.
7. Add Lilu and WhateverGreen kexts to `EFI/OC/Kexts` and your `config.plist`
8. Save and Reboot.

**NOTE**: In my test on an Ivy Bridge Notebook, the maximum brightness was not as bright as what I get when using the SSDT-PNLF sample included in the OpenCore Package. So I would recommend using method 2 instead.

### Method 2: **Common injection method**

- **Kexts**: Lilu.kext + WhateverGreen.kext
- **Patch**: Custom brightness patch or RehabMan brightness patch

### Method 3: **ACPI injection method**:

- **Kext**: ACPIBacklight.kext (Disable WhateverGreen's built-in brightness driver.)
- **Patch**: See "ACPI Brightness Patch" method

### **Other methods:** Follow the kext + patch principle and try for yourself.

**NOTE**: The official OpenCore package contains pre-compiled `SSDT-PNFL.aml` patches under "Docs". So in case you're not sure what to do you can use these instead.

## Required Kexts

**I. Kexts:** pick *one* of them, *not* all!

- [**Lilu**](https://github.com/acidanthera/Lilu/releases) plus [**WhateverGreen.kext**](https://github.com/acidanthera/WhateverGreen/releases) (has a built-in brightness driver **or**
- [**IntelBacklight.kext**](https://bitbucket.org/RehabMan/os-x-intel-backlight/src/master/) **or**
- [**ACPIBacklight.kext**](https://bitbucket.org/RehabMan/os-x-acpi-backlight/src/master/) (Deprecated. Predecessor of IntelBacklight.kext.)

By default, `WhateverGreen.kext` will load the brightness driver. If you want to use other brightness drivers you should disable Whatevergreen's built-in backlight control. To disable it, do the following:

- Add the boot-arg: `applbkl=0`
- Modify the driver's settings (right-click on the kext and select "Show Package Contents"), open the `Info.plist` and look for: `\IOKitPersonalities\AppleIntelPanelA\IOProbeScore=5500`.

**II. Patches:** (either or, based on the chosen injection method)
  
  - Acidanthera's Brightnes Patch:
  	- ***SSDT-PNLF*** (included in OpenCore Package. Recommended.)
  - Custom Brightness Patches:
    - ***SSDT-PNLF-SNB_IVY***: For 2nd and 3rd Gen Intel CPUs
    - ***SSDT-PNLF-Haswell_Broadwell***: For 4th and 5th Gen
    - ***SSDT-PNLF-SKL_KBL***: 6th and 7th Gen
    - ***SSDT-PNLF-CFL***: 8th gen and newer

    The above patches are inserted in `_SB.PCI0.GFX0`(Fixes starting WIN from OpenCore).

  - RehabMan Brightness Patches from his [RehabMan's Laptop Hotpatch Collection](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/tree/master/hotpatch):
  
    - [**SSDT-PNLF.dsl**](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-PNLF.dsl) 
    - [**SSDT-PNLFCFL.dsl**](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-PNLFCFL.dsl) (For Coffee Lake+)
    - [**SSDT-RMCF.dsl**](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-RMCF.dsl) (Rehabman Cofiguration File)
  
	RehabMan's luminance patches are inserted into `_SB.PCI0.IGPU`, so rename the `IGPU` of the patch file to the original name in ACPI (e.g. `GFX0`) when using them. RehabMan's PNLF Patches require the following rename:

	```text
	Name: PNLF to XNLF  
	Find: 504E4C46  
	Replace: 584E4C46
	```

## Notes
- When choosing an injection method, you should clear the driver, patch, and settings related to other methods.
- When using custom brightness patches, make sure that the `PNLF` device is injected under `_SB`. When there is a `PNLF` field in the original `ACPI`, you need to rename it, otherwise it will affect Windows boot process. 
- You can also use the SSDT-PNLF variants included in [RehabMan's Laptop Hotpatch Collection](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/tree/master/hotpatch).
