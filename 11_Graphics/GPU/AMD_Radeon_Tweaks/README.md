# AMD Radeon Performance Tweaks

**TABLE of CONTENTS**

- [About](#about)
	- [SSDTs vs. `DeviceProperties` – some considerations](#ssdts-vs-deviceproperties--some-considerations)
- [Method 1: Using AMD Radeon Patches by mattystonnie](#method-1-using-amd-radeon-patches-by-mattystonnie)
- [Method 2a: Selecting specific AMD Framebuffers via `DeviceProperties`](#method-2a-selecting-specific-amd-framebuffers-via-deviceproperties)
	- [Finding the PCIe path](#finding-the-pcie-path)
	- [Config Edits](#config-edits)
- [Method 2b: Using PowerPlay Tables](#method-2b-using-powerplay-tables)
	- [Creating PowerPlay Tables for AMD Polaris Cards (RX 500-series)](#creating-powerplay-tables-for-amd-polaris-cards-rx-500-series)
	- [PowerPlay Table Generators for Radeon RX5700, Radeon VII and Vega 64](#powerplay-table-generators-for-radeon-rx5700-radeon-vii-and-vega-64)
	- [Adjusting the `Workload policy`](#adjusting-the-workload-policy)
	- [`PP,PP_WorkLoadPolicyMask` vs. `PP_WorkLoadPolicyMask`](#pppp_workloadpolicymask-vs-pp_workloadpolicymask)
- [Addendum: SSDT vs. `DeviceProperties`](#addendum-ssdt-vs-deviceproperties)
- [Credits](#credits)
- [Further Resources](#further-resources)

## About
This chapter contains 2 methods for improving the performance of AMD Radeon Graphics Cards when running macOS:

- **Method 1**: Utilizes **SSDTs** to inject GPU Properties and PowerPlay data into macOS to optimize performance in OpenCL and Metal applications while lowering the overall power consumption of the card. This method tries to mimic how the GPU would operate in a real Mac. 
- **Method 2** (recommended): Utilizes **`DeviceProperties`** to select specific Framebuffers (method 2a) and inject PowerPlayInfo tables (method 2b). Methods 2a and b can be combined.

> [!IMPORTANT]
> 
> According to Whatevergreen's [**Radeon FAQs**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.Radeon.en.md), using named framebuffers is not recommended: "Named framebuffers (Baladi, Futomaki, Lotus, etc.), enabled by Clover's GPU injection or any other methods should never ever be used. This way of GPU injection is a common mistake, preventing automatic configuration of various important GPU parameters. This will inavoidably lead to borked GPU functioning in quite a number of cases."

### SSDTs vs. `DeviceProperties` – some considerations
- Combining methods 1 and 2 can be problematic *if* the SSDT also injects values for the same device properties as the config.plist.
- At best, the value(s) injected via the SSDT would be overwritten by the one(s) defined by `DeviceProperties` in the config.plist.
- In the worst case, you could inject conflicting settings.
- However, if you only need the SSDT to inject the correct ACPI path into macOS to get the card working, you can combine both. 
- If you want to inject properties into macOS *only*, doing it via `config.plist` is the way to go. Because injecting variables via ACPI affects the whole system and could affect other Operating Systems and in some cases does have no effect in Catalina and newer (&rarr; see ["Addendum"](#addendum-ssdt-vs-deviceproperties))
 
In my experience using an AMD RX 580 card, combining methods 2a and 2b give he best results.

## Method 1: Using AMD Radeon Patches by mattystonnie
> **Disclaimer**: Use at your own risk! In general, these patches have to be regarded as "experimental". They may work as intended but that's not guaranteed.

1. Select the SSDT corresponding to your GPU model located in the "mattystonnie" folder, export it as `.aml` and add it to add `EFI/OC/ACPI` and config.plist.
    - For **RX 580**: add `SSDT-RX580.aml`
    - For **RX 5500/5500XT**: add `SSDT-RX5500XT.aml` 
    - For **RX 5600/5700/5700XT**: add`SSDT-RX5700XT.aml`
    - For **RX Vega 64**: add `SSDT-RXVega64.aml`
2. Add the following Kexts to `EFI/OC/Kexts` and config.plist:
    - `DAGPM.kext` &rarr; Enables `AGPM` (Apple Graphics Power Management) Controller for AMD Cards which optimizes power consumption.
    - `Lilu.kext`
    - `Whatevergreen.kext`
3. Add Boot-arg `agdpmod=pikera` (Navi GPUs only!) &rarr; Fixes black screen issues on some GPUs.
4. Save your config, reboot and run some benchmark tests for comparison.

**NOTE**: These are slightly modified and improved variants of mattystonnie's tables. The following has been added to them:

- The `PEGP` to `EGP0` rename is integrated in the SSDTs (where required), so you don't need to add any binary renames. 
- The `DTGP` method which is required by `SSDT-RX580` is contained within the table itself now, so you no longer need `SSDT-DTGP`.

## Method 2a: Selecting specific AMD Framebuffers via `DeviceProperties`

With this method, you don't need Whatevergreen and DRM works when using SMBIOS `iMacPro1,1` or `MacPro7,1`. 

:warning: Before attempting this, ensure you have a backup of your current EFI folder on a FAT32 formatted USB flash drive to boot from in case something goes wrong.

### Finding the PCIe path
- Run Hackintool
- Click on the "PCIe" Tab
- Find your GPU (should be listed as "Display Controller")
- Right-click the entry and select "Copy Device Path":</br>![PCIpath](https://user-images.githubusercontent.com/76865553/174430790-a35272cb-70fe-4756-a116-06c0f048e7a0.png)

### Config Edits
- Mount your EFI
- For Navi Cards, add `SSDT-NAVI.aml` to `EFI/OC/ACPI` and the config.plist
- Disable `Whatevergreen.kext`
- Disable boot-arg `agdpmod=pikera`
- Under `DeviceProperties/Add` create a new child
- Set it to "Dictionary"
- Double Click its name and paste the PCI path:</br>![DevProps01](https://user-images.githubusercontent.com/76865553/174430804-b750e59a-46c7-4f38-aa0f-60977500b976.png)
- Double Click its name and paste the PCI path
- Create a new child
	- **Type**: String
	- **Name**: @0,name
	- **Value**: select the one for your GPU model from the list below:
		- **RX6900** &rarr; `ATY,Carswell`
		- **RX6800** &rarr; `ATY,Belknap`
 		- **RX6600/XT** &rarr; `ATY,Henbury`
		- **Radeon 7** &rarr; `ATY,Donguil`
		- **RX5700** &rarr; `ATY,Adder`
		- **RX5500** &rarr; `ATY,Python`
		- **RX570/580** &rarr; `ATY,Orinoco`
	- In this example, we use `ATI,Henbury` (without blank space):</br>![DevProps02](https://user-images.githubusercontent.com/76865553/174430822-f63c0cf0-c8a1-463f-901d-9053e8c7a981.png)
- Save and reboot.

**SOURCE**: [Insanelymac](https://www.insanelymac.com/forum/topic/351969-pre-release-macos-ventura/?do=findComment&comment=2786122)

> [!NOTE]
> 
> The Framebuffers listed above have been removed from macOS Sonoma, so this setting no longer has any effect.

## Method 2b: Using PowerPlay Tables
With this method, you can inject all sorts of parameters into macOS to optimize the performance of your card such as: Power Limits, Clock Speeds, Fan Control and more without having to flash a modified vBIOS on your card. Combined with selecting specific AMD Framebuffers via the `@0,name` property, this is probably the best solution to optimize the performance of your AMD card under macOS.

### Creating PowerPlay Tables for AMD Polaris Cards (RX 500-series)
&rarr; [**Follow this Guide**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/GPU/AMD_Radeon_Tweaks/Polaris_PowerPlay_Tables.md)

### PowerPlay Table Generators for Radeon RX5700, Radeon VII and Vega 64

You can use PowerPlay Table Generators by MMChris to generate a `PP_PhmSoftPowerPlayTable` device property for [**Radeon VII**](https://www.insanelymac.com/forum/topic/340009-tool-radeon-vii-powerplay-table-generator-oc-uv-fan-curve/), [**Vega64**](https://www.hackintosh-forum.de/forum/thread/39923-tool-vega-64-powerplaytable-generator/) and [**RX5700**](https://www.insanelymac.com/forum/topic/340909-tool-amd-radeon-rx-5700-xt-powerplay-table-generator/) cards. These are basically Excel spreadsheets which generate the necessary hex values. 

There's another [**method**](https://www.insanelymac.com/forum/topic/351276-rx-6600-xt-on-macos-zero-rpm-with-softpowerplaytable/#comment-2779094) for obtaining PowerPlay Tables for Navi Cards under Windows using Tools and Registry Editor.

### Adjusting the `Workload policy`
The Workload policy lets you select what type of workload or tasks the GPU is primarily used for. Depending on the selected policy, your GPU may require less power (Compute) or more (for 3D and VR Applications). 

The Workload Policy can be added as a `DeviceProperty`. The following policies are available:

Value (HEX)| Number (DEC) |Workload Policy
:---------:|:------------:|---------------
0x01       | 1            | DEFAULT_WORKLOAD (default)
0x02       | 2            | FULLSCREEN3D_WORKLOAD 
0x04       | 4            | POWERSAVING_WORKLOAD
0x08       | 8            | VIDEO_WORKLOAD
0x10       | 16           | VR_WORKLOAD
0x20       | 32           | COMPUTE_WORKLOAD
0x40       | 64           | CUSTOM_WORKLOAD

**To specify a Workload policy, do the following**:

- Mount your EFI
- Open your `config.plist`
- Add Key `PP,PP_WorkLoadPolicyMask` to the `DeviceProperties` of your GPU
- Data Type: Number
- Add the corresponding Number (Dec) of the Workload Policy you want to use.
- Save your config.plist and reboot.

**Example**: I use `4` since I use the GPU simply for running two displays. Occasionally, I might switch it to `8` if I need to render some video:

![WorkLoadpPlcy](https://user-images.githubusercontent.com/76865553/180636520-2a147de1-d741-4913-8727-4f21a4a28633.png)

### `PP,PP_WorkLoadPolicyMask` vs. `PP_WorkLoadPolicyMask`

Acidanthera's AMD Radeon FAQs suggests calling the property `PP,PP_WorkLoadPolicyMask`, but I have seen configs and guides which use `PP_WorkLoadPolicyMask` instead. It seems that both methods work. The only difference is that when using `PP,PP_`, the property is listed alphabetically among other PowerPlay Table entries, while using `PP_` puts the entry in a different position in the list. 

You can check this yourself: in IORegistryExplorer, search for `GFX0`. The property is listed as `PP_WorkLoadPolicy` in both cases, just sorted differently. It seems that the comma can be utilized as a modifier for sorting entries in the IO Registry.

When using `PP,PP_WorkLoadPolicyMask`:</br>
![PP_comma](https://user-images.githubusercontent.com/76865553/180637390-6833c6c1-bd70-4a2f-a9d9-6e2a902c509c.png)

When using `PP_WorkLoadPolicyMask`:</br>
![PP_](https://user-images.githubusercontent.com/76865553/180637402-c478a12a-86ec-4656-b2f2-ea0c5bba3a9a.png)

## Addendum: SSDT vs. `DeviceProperties`

I've noticed that **SSDT-RX580** doesn't work as expected in macOS Catalina and beyond. In my tests, the performance didn't improve noticeably and power consumption wasn't reduced as well – around 100 Watts in idle which seems too high, imo. Also, `AGPMController` was present in IO Registry already without `DAGPM.kext`, so it's not a requirement (same goes for `AGPMInjector.kext` by Pavo-IM).   

On page [35 and following](https://www.tonymacx86.com/threads/amd-radeon-performance-enhanced-ssdt.296555/page-35#post-2114578), I found another approach utilizing `DeviceProperties` to inject the data into macOS instead. This worked. It improves performance and reduces power consumption as well (70 Watts in idle instead of 100). 

I've added plists for both Clover and OpenCore to the "mattystonnie" folder. You can copy the included properties to the corresponding section of your config.plist. Ensure that the PCI paths and `AAPL,slot-name`[^1] match the ones used in your system and adjust them accordingly. Disable/delete the SSDTs and `DAGPM.kext` when using this method. 

[^1]: Follow this [**guide**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/11_Graphics/Metal_3#3-obtaining-aaplslot-name-for-igpu-and-gpu) to obtain the PCI path of a device and its `AAPL,slot-name` using Hackintool.

## Credits
- Acidanthera for Lilu and WhateverGreen.kext
- mattystonnie for the SSDTs and original [**Guide**](https://www.tonymacx86.com/threads/amd-radeon-performance-enhanced-ssdt.296555/)
- Baio1977 for implementing device renames into the mattystonnie SSDTs
- Toleda for `DAGPM.kext`
- CMMMChris for PowerPlay Table Generators
- hush-vv for [**Radeon VII Device Properties**](https://www.tonymacx86.com/threads/amd-radeon-performance-enhanced-ssdt.296555/post-2315543)

## Further Resources
- [**AMD Radeon FAQs**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.Radeon.en.md) (Very informative)
- [**Video Bitrate Test Files**](https://jell.yfish.us/)
- [**Enabling XFX RX 6600 XT in macOS Monterey**](https://github.com/perez987/rx6600xt-on-macos-monterey)
