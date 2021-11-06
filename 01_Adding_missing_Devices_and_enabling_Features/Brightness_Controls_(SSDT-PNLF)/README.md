# Injecting Brightness Control (`PNLF`)

## `PNLF` Injection Methods

To inject Brightness Control, there are several ways to do so. But no matter which one you choose, it requires the combination of a Kext and a corresponding ACPI Hotpatch to work.

1. Common injection method:

	- **Kext**: WhateverGreen.kext
	- **Patch**: Custom brightness patch or RehabMan brightness patch

2. ACPI injection method:

	- **Kext**: ACPIBacklight.kext (need to disable WhateverGreen.kext built-in brightness driver, see Disable method above)
	- **Patch**: See "ACPI Brightness Patch" method

3. Other methods: Follow the Kext + patch principle and try for yourself.

**NOTE**: The official OpenCore package contains pre-compiled `SSDT-PNFL.aml` patches under "Docs". So in case you're not sure what to do you can use these instead.

## Required Kexts

**I. Kexts:** pick one of them, not all!

- [**WhateverGreen.kext**](https://github.com/acidanthera/WhateverGreen/releases) (has a built-in brightness driver. Requires [**Lilu**](https://github.com/acidanthera/Lilu/releases)) **or**
- [**IntelBacklight.kext**](https://bitbucket.org/RehabMan/os-x-intel-backlight/src/master/) **or**
- [**ACPIBacklight.kext**](https://bitbucket.org/RehabMan/os-x-acpi-backlight/src/master/)

By default, `WhateverGreen.kext` will load the brightness driver. If you want to use other brightness drivers you should disable their built-in brightness drivers. To disable it, do the following:

- Add the boot-arg: `applbkl=0`
- Modify the driver's settings (right-click on the kext and select "show package contents"): `Info.plist\IOKitPersonalities\AppleIntelPanelA\IOProbeScore=5500`.

**II. Patches:** (either or, based on the chosen injection method)

  - Custom Brightness Patches:

    - ***SSDT-PNLF-SNB_IVY***: For 2nd and 3rd Gen Intel CPUs
    - ***SSDT-PNLF-Haswell_Broadwell***: For 4th and 5th Gen
    - ***SSDT-PNLF-SKL_KBL***: 6th and 7th Gen
    - ***SSDT-PNLF-CFL***: 8th gen and newer

    The above patches are inserted in `_SB.PCI0.GFX0`(Fixes starting WIN from Opencore).

  - RehabMan Brightness Patches from his [RehabMan's Laptop Hotpach Collection](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/tree/master/hotpatch):
  
    - [**SSDT-PNLF.dsl**](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-PNLF.dsl) 
    - [**SSDT-PNLFCFL.dsl**](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-PNLFCFL.dsl) (For Coffee Lake+)
    - [**SSDT-RMCF.dsl**](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-RMCF.dsl) (Rehabman Cofiguration File)
  
	Rehabman's luminance patches are inserted into `_SB.PCI0.IGPU`, so rename the `IGPU` of the patch file to the original name in ACPI (e.g. `GFX0`) when using them. Rehabman's PNLF Patches require the following rename:

	```swift
		Name: PNLF to XNLF  
		Find: 504E4C46  
		Replace: 584E4C46
	```

## Caution

- When choosing a certain injection method, you should clear the driver, patch, and settings related to other methods.
- When using custom brightness patch, you need to pay attention that the patches are all `PNLF` devices injected under `_SB`. When there is a `PNLF` field in the original `ACPI`, you need to rename it, otherwise it will affect `Windows` boot. You can also use [RehabMan's Laptop Hotpach Collection](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/tree/master/hotpatch). 
