# iGPU Framebuffer DeviceProperties

List of Intel iGPU Device Properties for 2nd to 10th Gen Intel Desktop and Mobile CPUs as provided by the OpenCore Install Guide. The Framebuffer Data is already converted to Little Endian so you can use it as is.

**TABLE of CONTENTS**

- [General Configuration Notes](#general-configuration-notes)
	- [About the used properties](#about-the-used-properties)
- [**Empty Framebuffers** (for Desktop)](#empty-framebuffers-for-desktop)
- [**Framebuffers (Desktop)**](#framebuffers-desktop)
	- [Coffee Lake and Comet Lake](#coffee-lake-and-comet-lake)
	- [Kaby Lake](#kaby-lake)
	- [Skylake](#skylake)
	- [Haswell and Broadwell](#haswell-and-broadwell)
	- [Ivy Bridge](#ivy-bridge)
	- [Sandy Bridge](#sandy-bridge)
- [**Framebuffers (Laptop/NUC)**](#framebuffers-laptopnuc)
	- [Ice Lake](#ice-lake)
	- [Coffee Lake Plus and Comet Lake](#coffee-lake-plus-and-comet-lake)
	- [Coffee Lake and Whiskey Lake](#coffee-lake-and-whiskey-lake)
	- [Kaby Lake and Amber Lake Y](#kaby-lake-and-amber-lake-y)
		- [Connector Patches for HD 6XX models (not UHD!)](#connector-patches-for-hd-6xx-models-not-uhd)
	- [Skylake](#skylake-1)
	- [Broadwell](#broadwell)
	- [Haswell](#haswell)
	- [Ivy Bridge](#ivy-bridge-1)
		- [Connector Patches for `04006601`](#connector-patches-for-04006601)
		- [Connector Patches for `03006601`](#connector-patches-for-03006601)
	- [Sandy Bridge](#sandy-bridge-1)
- [About VGA](#about-vga)
- [Credits and Resources](#credits-and-resources)

## General Configuration Notes
Most of the Framebuffer patches listed below (besides empty framebuffers) represent the bare minimum configuration to get on-board graphics and hardware acceleration working. In cases where your display output does not work, you may have to change the `AAPL,ig-platform-id` and/or add display connector data using Hackintool and following a general framebuffer patching guide [**such as this**](https://www.tonymacx86.com/threads/guide-general-framebuffer-patching-guide-hdmi-black-screen-problem.269149/). 

For more Framebuffer options, please refer to Whatevergreen's [**Intel HD FAQs**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md). But keep in mind that the Framebuffer Data in WEG's FAQs is provided in Big Endian, so you can't use it as is – you have to [**convert it to Little Endian**](https://www.save-editor.com/tools/wse_hex.html#littleendian) first!

### About the used properties

 Key | Function |
 ----| -------- |
`AAPL,ig-platform-id` |Platform identifier of the iGPU you are using/spoofing.
`AAPL,snb-platform-id`|Same as above but for Sandy Bridge CPUs ONLY. 
`device-id` | Device identifier. Only required if the device-id of your CPU is not *natively* supported by macOS. If this is the case, you must add a supported device-id (needs to be converted to Little Endian) of the CPU which is the closest match to yours so that macOS cann assign a driver to it. Refer to the [**Intel HD FAQ**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md) for details.
`framebuffer-patch-enable` | Switch to enable framebuffer patching. Required when setting properties like `fbmem`, `stolenmem` or `unifiedmem`. 
`framebuffer-fbmem` | Patches framebuffer memory. Required if you cannot set DVMT to 64 MB in the BIOS. ⚠️ Don't use if the DVMT option is available in the BIOS.
`framebuffer-stolenmem` | Patches framebuffer stolen memory. Required if you cannot adjust DVMT to 64MB in the BIOS. ⚠️ Don't use if the DVMT option is available in the BIOS.
`framebuffer-unifiedmem` | Can be used to increase the amount of assigned VRAM. ⚠️ Don't use `framebuffer-unifiedmem` and `framebuffer-stolenmem` together at the same time – use either or!

## Empty Framebuffers (for Desktop)

List of empty Framebuffers for utilizing the iGPU for computing tasks only (e.g. Intel QuickSync Video, HEVC), while the discrete GPU is handling graphics.

**Address**: `PciRoot(0x0)/Pci(0x2,0x0)`

CPU Family (iGPU variant)| Type | AAPL,ig-platform-id | device-id | Notes
-------------------------|:----:|:-------------------:|-----------|------
[**Comet Lake**](https://ark.intel.com/content/www/us/en/ark/products/codename/90354/products-formerly-comet-lake.html?wapkw=comet%20lake#@Desktop) |Data|`0300C89B`
[**Coffee Lake**](https://ark.intel.com/content/www/us/en/ark/products/codename/97787/products-formerly-coffee-lake.html?wapkw=coffee%20lake#@Desktop) | Data |`0300913E`
[**Kaby Lake**](https://ark.intel.com/content/www/us/en/ark/products/codename/82879/products-formerly-kaby-lake.html?wapkw=kaby%20lake#@Desktop) | Data |`03001259`
[**Skylake**](https://ark.intel.com/content/www/us/en/ark/products/codename/37572/products-formerly-skylake.html?wapkw=Skylake#@Desktop) | Data |`01001219`
**Skylake** <br>(Intel HD P530) | Data |`01001219`| `1B190000` | The Intel P530 is not natively supported so you need to add the device-id as well.
[**Haswell**](https://ark.intel.com/content/www/us/en/ark/products/codename/42174/products-formerly-haswell.html?wapkw=Haswell#@Desktop) | Data| `04001204`
Haswell (HD 4400)| Data| `04001204`|`12040000`|HD 4400 is unsupported in macOS so the device-id is needed to spoof it as HD 4600 instead.
[**Ivy Bridge**](https://ark.intel.com/content/www/us/en/ark/products/codename/29902/products-formerly-ivy-bridge.html?wapkw=Ivy%20Bridge#@Desktop) | Data| `07006201`|

CPU Family | Type | AAPL,snb-platform-id | device-id
-----------|:----:|:--------------------:|-----------
[**Sandy Bridge**](https://ark.intel.com/content/www/us/en/ark/products/codename/29900/products-formerly-sandy-bridge.html?wapkw=sandy%20bridge#@Desktop)| Data | `00000500`|`02010000`

**Address**: PciRoot(0x0)/Pci(0x16,0x0)	

- If you are using a **Sandy Bridge CPU with a 7-series mainboard** (ie. B75, Q75, Z75, H77, Q77, Z77), you need to spoof the device ID of the `IMEI` device: 

	CPU Family | PCI Address|Key | Type | Value
	-----------|-----|----|:----:|:----:
	Sandy Bridge|PciRoot(0x0)/Pci(0x16,0x0)|`device-id` | Data | `3A1C0000`

- If you are using an **Ivy Bridge CPU with a 6-series mainboard** (ie. H61, B65, Q65, P67, H67, Q67, Z68), you need to spoof the device ID of the `IMEI` device: 

	CPU Family | PCI Address|Key | Type | Value
	-----------|-----|----|:----:|:----:
	Ivy Bridge|PciRoot(0x0)/Pci(0x16,0x0)|`device-id` | Data | `3A1C0000`

----

## Framebuffers (Desktop)
AMD and 11th gen and newer Intel CPUs are unsupported! Since High End Desktop (HEDT) CPUs don't feature integrated graphics, there are no Device Properties to add for these!

### Coffee Lake and Comet Lake
>For Intel UHD-630. 8th to 10th Gen Intel Core CPUs

**Address**: `PciRoot(0x0)/Pci(0x2,0x0)`

Key | Type | Value| Notes 
----|:----:|:-------:|-----
`AAPL,ig-platform-id` | Data | `07009B3E`| Default
`AAPL,ig-platform-id `| Data| `00009B3E`| If the default causes black screen issues
||||
`framebuffer-patch-enable`| Data | `01000000`
`framebuffer-stolenmem` | Data | `00003001`

**NOTE**: The following mainboards/chipsets require [BusID patches](https://dortania.github.io/OpenCore-Post-Install/gpu-patching/intel-patching/busid.html#parsing-the-framebuffer) if the screen turns black after booting in verbose mode: **B360, B365, H310, H370, Z390**.

### Kaby Lake
>For Intel HD-630. 7th Gen Intel Core.

**Address**: `PciRoot(0x0)/Pci(0x2,0x0)`

Key | Type | Value
----|:----:|:----:
`AAPL,ig-platform-id` | Data | `00001259`|
||||
`framebuffer-patch-enable`| Data | `01000000`
`framebuffer-stolenmem` | Data | `00003001`

### Skylake
>For Intel HD-510-580 and Intel HD P530. 6th Gen Intel Core.</br>
>Officially supported since macOS 10.11.4 to macOS 12.x.

**Address**: `PciRoot(0x0)/Pci(0x2,0x0)`

Key | Type | Value| Notes 
----|:----:|:----:|------
`AAPL,ig-platform-id`| Data| `00001219` 
||||
`framebuffer-patch-enable`| Data | `01000000`
`framebuffer-stolenmem` | Data | `00003001`
`framebuffer-fbmem`| Data | `00009000`
||||
`device-id` | Data | `1B190000` | ⚠️ Only needed when using Intel HD P530!

> [!NOTE]
> 
> For enabling Skylake graphics on macOS Ventura, you need a [spoof](https://github.com/5T33Z0/OC-Little-Translated/tree/main/11_Graphics/iGPU/Skylake_Spoofing_macOS13).

### Haswell and Broadwell
>For HD 4400, HD 4600 and Iris Pro 6200. 4th and 5th Gen Intel Core.

**Address**: `PciRoot(0x0)/Pci(0x2,0x0)`

Key | Type | Value| Notes 
----|:----:|:----:|------
`AAPL,ig-platform-id`| Data | `0300220D` | For Haswell, Haswell Refresh and [Devil's Canyon](https://ark.intel.com/content/www/us/en/ark/products/codename/81246/products-formerly-devils-canyon.html?wapkw=Devil%27s%20Canyon#@Desktop) CPUs
`AAPL,ig-platform-id`| Data | `07002216` | For Broadwell CPUs
||||
`framebuffer-patch-enable`| Data | `01000000`
`framebuffer-stolenmem` | Data | `00003001`
`framebuffer-fbmem`| Data | `00009000`
||||
`device-id`| Data| `12040000` | ⚠️ Only needed when using HD Intel HD 4400!

> [!NOTE]
> 
> macOS 12 and newer require re-installing the iGPU drivers in Post-Install with [OpenCore Legacy Patcher](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Haswell-Broadwell_Ventura.md#installing-intel-haswellbroadwell-graphics-acceleration-patches)

### Ivy Bridge
>For Intel HD 2500/4000. 3rd Gen Intel Core</br>
>Supported from OS X 10.8.x to macOS 11.x (officially), macOS 12 with Post-Install patches

**Address**: `PciRoot(0x0)/Pci(0x2,0x0)`

Key | Type | Value|
----|:----:|:----:|
`AAPL,ig-platform-id`| Data | `0A006601`

If you are using an **Ivy Bridge CPU with a 6-series mainboard** (ie. H61, B65, Q65, P67, H67, Q67, Z68), you also need to spoof the device ID of the `IMEI` device: 

**Address**: `PciRoot(0x0)/Pci(0x16,0x0)`

Key | Type | Value
----|:----:|:----:
`device-id` | Data | `3A1C0000`

> [!NOTE]
> 
> macOS 12 and newer require re-installing the iGPU drivers in Post-Install with [OpenCore Legacy Patcher](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Ivy_Bridge-Ventura.md#installing-intel-hd4000-drivers)

### Sandy Bridge
>Intel HD 3000. 2nd Gen Intel Core.</br>
>Supported from macOS 10.6.7 to macOS 10.13

**Address**: `PciRoot(0x0)/Pci(0x2,0x0)`

Key | Type | Value
----|:----:|:----:
`AAPL,snb-platform-id`| Data | `10000300`
`device-id` | Data | `26010000`

If you are using a **Sandy Bridge CPU with a 7-series mainboard** (ie. B75, Q75, Z75, H77, Q77, Z77), you also need to spoof the device ID of the `IMEI` device: 

**Address**: `PciRoot(0x0)/Pci(0x16,0x0)`

Key | Type | Value
----|:----:|:----:
`device-id` | Data | `3A1C0000`

> [!NOTE]
> 
> macOS 12 and newer require re-installing the iGPU drivers in Post-Install with [OpenCore Legacy Patcher](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Sandy_Bridge_Ventura.md#installing-intel-hd-20003000-drivers)

----

## Framebuffers (Laptop/NUC)
Framebuffer patches for Mobile iGPUs. AMD as well as 11th Gen Intel and newer CPUs are not support by macOS!

### [Ice Lake](https://ark.intel.com/content/www/us/en/ark/products/codename/74979/products-formerly-ice-lake.html?wapkw=Ice%20Lake#@Mobile)
>Intel Iris Plus Graphics. 10th Gen Intel Core Mobile</br>
>Supported since: macOS 10.15.4

**Address**: `PciRoot(0x0)/Pci(0x2,0x0)`

Key | Type | Value
----|:----:|:----:
`AAPL,ig-platform-id`|Data| `0000528A`
||||
`framebuffer-patch-enable`| Data | `01000000`
`framebuffer-stolenmem` | Data | `00003001`
`framebuffer-fbmem`| Data | `00009000`|

### Coffee Lake Plus and [Comet Lake](https://ark.intel.com/content/www/us/en/ark/products/codename/90354/products-formerly-comet-lake.html?wapkw=comet%20lake#@Mobile)
>For Intel UHD-630. 8th to 10th Gen Intel Core Mobile.

**Address**: `PciRoot(0x0)/Pci(0x2,0x0)`

Key | Type | Value| Notes
----|:----:|:----:|------
`AAPL,ig-platform-id`| Data | `0900A53E` | For Laptops with UHD 630
`AAPL,ig-platform-id`| Data | `00009B3E` | For Laptops with UHD 620
`AAPL,ig-platform-id`| Data | `07009B3E` | For NUCs with UHD 620/630
`AAPL,ig-platform-id`| Data | `0000A53E` | For NUCs with UHD 655
||||
`framebuffer-patch-enable`| Data | `01000000`
`framebuffer-stolenmem` | Data | `00003001`
`framebuffer-fbmem`| Data | `00009000`
||||
`device-id` | Data | `9B3E0000` | ⚠️ Only required for UHD 620 and UHD 655!

### [Coffee Lake](https://ark.intel.com/content/www/us/en/ark/products/codename/97787/products-formerly-coffee-lake.html?wapkw=coffee%20lake#@Mobile) and [Whiskey Lake](https://ark.intel.com/content/www/us/en/ark/products/codename/135883/products-formerly-whiskey-lake.html?wapkw=whiskey%20lake#@Mobile)
>For Intel UHD 620/630/655. 8th and 9th Gen Intel Core Mobile.</br>
>Supported since: Coffee Lake: macOS 10.13; Whiskey Lake: macOS 10.14.1

**Address**: `PciRoot(0x0)/Pci(0x2,0x0)`

Key | Type | Value| Notes
----|:----:|:----:|------
`AAPL,ig-platform-id`|Data| `0900A53E` |For Laptops with UHD 630
`AAPL,ig-platform-id`|Data| `00009B3E` |For Laptops with UHD 620
`AAPL,ig-platform-id`|Data| `07009B3E` |For NUCs with UHD 620/630
`AAPL,ig-platform-id`|Data| `0000A53E` |For NUCs with UHD 655
||||
`framebuffer-patch-enable`| Data | `01000000`
`framebuffer-stolenmem` | Data | `00003001`
`framebuffer-fbmem`| Data | `00009000`
||||
`device-id`|Data|`9B3E0000`| ⚠️ For UHD 630: only required if the Device-iD IS NOT `0x3E9B`. Under Windows, open Device Manager, bring up the iGPU, open the properties, select details and click on Hardware IDs and check.
`device-id`|Data|`9B3E0000`| ⚠️ Required for 8th/9th Gen CPUs with UHD 620 iGPUs to spoof as Intel UHD 630.

:bulb: The recommendet settings for **Intel UHD 620** listed in the Intel HD FAQs differ from those in Dortania's guide and worked better for me:

Key | Type | Value| Notes
----|:----:|:----:|------
`AAPL,ig-platform-id`|Data| `0900A53E ` |For Laptops with UHD 620
||||
`device-id `| Data|`A53E0000` | Spoof Intel UHD 620 as Intel Iris 655

> [!NOTE]
> 
> For **Lenovo T490**: add and enable the patch located in the `UEFI/ReservedMemory` section of the sample.plist to fix black screen issues after waking from hibernation. 

### [Kaby Lake](https://ark.intel.com/content/www/us/en/ark/products/codename/82879/products-formerly-kaby-lake.html?wapkw=kaby%20lake#@Mobile) and [Amber Lake Y](https://ark.intel.com/content/www/us/en/ark/products/codename/186968/products-formerly-amber-lake-y.html?wapkw=amber%20lake#@Mobile)
>For Intel HD 615/617/620/630/640/650</br>
>Supported since: macOS 10.12

**Address**: `PciRoot(0x0)/Pci(0x2,0x0)`

Key | Type | Value| Notes
----|:----:|:----:|------
`AAPL,ig-platform-id`|Data| `00001B59`| For Laptops with HD 615, HD 620, HD 630, HD 640 and HD 650 UHD 630.
`AAPL,ig-platform-id`|Data| `00001659` |Alternative to `00001B59` if you have acceleration issues, and for all HD and UHD 620 NUCs.
`AAPL,ig-platform-id`|Data| `0000C087`| For Laptops with Amber Lake's UHD 617 and Kaby Lake-R's UHD 620.
`AAPL,ig-platform-id`|Data| `00001E59`| For NUCs with HD 615
`AAPL,ig-platform-id`|Data| `00001B59`| For NUCs with HD 630
`AAPL,ig-platform-id`|Data| `02002659`| For NUCs with HD 640/650
||||
`framebuffer-patch-enable`| Data | `01000000`
`framebuffer-stolenmem` | Data | `00003001`
`framebuffer-fbmem`| Data | `00009000`
||||
`device-id`|Data|`16590000`| ⚠️ All UHD 620 with Kaby Lake-R require a device-id spoof!

<details>
<summary><b>Connector Patches</b> (Click to reveal)</summary>

#### Connector Patches for HD 6XX models (not UHD!)
HD 6xx users (UHD 6xx users are not concerned) may face some issues with the output where plugging in a display causes a lock up (kernel panic). Listed below are some patches to mitigate that (credits to RehabMan). If you're facing lock ups, try the following sets of patches (try both, but only one set at a time): 

- **con1** as 105, **con2** as 204, both HDMI:

	Key | Type | Value
	----|:----:|:----
	`framebuffer-patch-enable`| Data | `01000000`
	`framebuffer-con1-alldata` | Data | `01050A00 00080000 87010000`
	`framebuffer-con2-enable`| Data | `01000000`
	`framebuffer-con2-alldata` |Data| `02040A00 00080000 87010000`

- **con1** as 105, **con2** as 306, HDMI and DP:

	Key | Type | Value
	----|:----:|:----
	`framebuffer-patch-enable`| Data | `01000000`
	`framebuffer-con1-alldata` | Data | `01050A00 00080000 87010000`
	`framebuffer-con2-enable`| Data | `01000000`
	`framebuffer-con2-alldata` |Data| `03060A00 00040000 87010000`

</details>

### [Skylake](https://ark.intel.com/content/www/us/en/ark/products/codename/37572/products-formerly-skylake.html?wapkw=Skylake#@Mobile)
>For Intel HD 510/515/520/530/540/550/580 and P530. 6th Gen Intel Core Mobile.</br>
>Supported since: macOS 10.11

**Address**: `PciRoot(0x0)/Pci(0x2,0x0)`

Key | Type | Value| Notes
----|:----:|:----:|------
`AAPL,ig-platform-id`|Data| `00001619` | For Laptops with HD 515, HD 520, HD 530, HD 540, HD 550 and P530.
`AAPL,ig-platform-id`|Data| `00001E19` | Alternative for HD 515 if you have issues with the above entry.
`AAPL,ig-platform-id`|Data| `00001B19` | For Laptops with HD 510
`AAPL,ig-platform-id`|Data| `00001E19` | For NUCs with HD 515
`AAPL,ig-platform-id`|Data| `02001619` | For NUCs with HD 520/530
`AAPL,ig-platform-id`|Data| `02002619` | For NUCs with HD 540/550
`AAPL,ig-platform-id`|Data| `05003B19` | For NUCs with HD 580
||||
`framebuffer-patch-enable`| Data | `01000000`
`framebuffer-stolenmem` | Data | `00003001`
`framebuffer-fbmem`| Data | `00009000`
||||
`device-id` |Data |`02190000` | ⚠️ Required for HD 510
`device-id` |Data |`16190000` | ⚠️ Required for HD 550 and P530 

> [!NOTE]
> 
> For enabling Skylake graphics on macOS Ventura, you need a [spoof](https://github.com/5T33Z0/OC-Little-Translated/tree/main/11_Graphics/iGPU/Skylake_Spoofing_macOS13).

### [Broadwell](https://ark.intel.com/content/www/us/en/ark/products/codename/38530/products-formerly-broadwell.html?wapkw=Broadwell#@Mobile)
>For Intel HD 5500/5600/6000 and Iris (Pro) 6100/6200. 5th Gen Intel Core Mobile.</br>
>Supported since: macOS 10.10

**Address**: `PciRoot(0x0)/Pci(0x2,0x0)`

Key | Type | Value| Notes
----|:----:|:----:|------
`AAPL,ig-platform-id`|Data| `06002616` | For Broadwell Laptops
`AAPL,ig-platform-id`|Data| `02001616` | For Broadwell NUCs
||||
`framebuffer-patch-enable`| Data | `01000000`
`framebuffer-stolenmem` | Data | `00003001`
`framebuffer-fbmem`| Data | `00009000`
||||
`device-id` | Data |`26160000` | Required For HD 5600

> [!NOTE]
> 
> macOS 12 and newer require re-installing the iGPU drivers in Post-Install with [OpenCore Legacy Patcher](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Haswell-Broadwell_Ventura.md#installing-intel-haswellbroadwell-graphics-acceleration-patches)

### [Haswell](https://ark.intel.com/content/www/us/en/ark/products/codename/42174/products-formerly-haswell.html?wapkw=haswell#@Mobile)
>For Intel HD 4200/4400/4600 and HD 5000/5100/5200. 4th Gen Intel Core Mobile.</br>
>Supported since: macOS 10.8

**Address**: `PciRoot(0x0)/Pci(0x2,0x0)`

Key | Type | Value| Notes
----|:----:|:----:|------
`AAPL,ig-platform-id`|Data| `0500260A` | For Laptops with HD 5000/5100/5200
`AAPL,ig-platform-id`|Data| `0600260A` | For Laptops with HD 4200/4400/4600. Requires device-id!
`AAPL,ig-platform-id`|Data| `0300220D` | For all Haswell NUCs with HD 4200/4400/4600. Requires device-id!
||||
`framebuffer-patch-enable`| Data | `01000000`
`framebuffer-fbmem`| Data | `00009000`
||||
`device-id` | Data |`12040000` | Required for HD 4200/4400/4600.

> [!NOTE]
> 
> macOS 12 and newer require re-installing the iGPU drivers in Post-Install with [OpenCore Legacy Patcher](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Haswell-Broadwell_Ventura.md#installing-intel-haswellbroadwell-graphics-acceleration-patches)

### [Ivy Bridge](https://ark.intel.com/content/www/us/en/ark/products/codename/29902/products-formerly-ivy-bridge.html?wapkw=Ivy%20Bridge#@Mobile)
>For Intel HD 4000. 3rd Gen Intel Core Mobile.</br>
>Supported from OS X 10.8.x to macOS 11.x (officially), macOS 12 with Post-Install patches.

**Address**: `PciRoot(0x0)/Pci(0x2,0x0)`

Key | Type | Value| Notes
----|:----:|:----:|------
`AAPL,ig-platform-id`|Data| `03006601` | For Laptop display panels with 1366x768 px or lower (SD).
`AAPL,ig-platform-id`|Data| `04006601` | For Laptop display panels with 1600x900 px or higher (HD+ and Full HD).
`AAPL,ig-platform-id`|Data| `09006601` | For Laptops which use eDP to connect to the display (contrary to classical LVDS). Test with `03006601` and `04006601` first, before trying this!
`AAPL,ig-platform-id`|Data| `0B006601` | For NUCs

If you are using an **Ivy Bridge CPU with a 6-series mainboard** (ie. H61, B65, Q65, P67, H67, Q67, Z68) you also need to spoof the device ID of the `IMEI` device: 

**Address**: `PciRoot(0x0)/Pci(0x16,0x0)`

Key | Type | Value
----|:----:|:----:
`device-id` | Data | `3A1C0000`

Additionally, you need one of the following sets of Connector patches so external monitors work (including clamshell mode, etc.).

<details>
<summary><b>Connector Patches</b> (Click to reveal)</summary>

#### Connector Patches for `04006601`
Copy the entry below into the `DeviceProperties/Add/` section of your `config.plist` using ProperTree:

```xml
<key>PciRoot(0x0)/Pci(0x2,0x0)</key>
	<dict>
		<key>#framebuffer-stolenmem</key>
		<data>AAAABA==</data>
		<key>AAPL,ig-platform-id</key>
		<data>BABmAQ==</data>
		<key>framebuffer-con1-alldata</key>
		<data>AgUAAAAEAAAHBAAAAwQAAAAEAACBAAAABAYAAAAEAACBAAAA</data>
		<key>framebuffer-con1-enable</key>
		<integer>1</integer>
		<key>framebuffer-memorycount</key>
		<integer>2</integer>
		<key>framebuffer-patch-enable</key>
		<integer>1</integer>
		<key>framebuffer-pipecount</key>
		<integer>2</integer>
		<key>framebuffer-portcount</key>
		<integer>4</integer>
		<key>framebuffer-unifiedmem</key>
		<data>AAAAgA==</data>
		<key>model</key>
		<string>Intel HD Graphics 4000</string>
	</dict>
```
#### Connector Patches for `03006601`
Copy the entry below into the `DeviceProperties/Add/` section of your `config.plist` using ProperTree:

```xml
<key>PciRoot(0x0)/Pci(0x2,0x0)</key>
	<dict>
		<key>#device-id</key>
		<data>ZgEAAA==</data>
		<key>AAPL,ig-platform-id</key>
		<data>AwBmAQ==</data>
		<key>AAPL,slot-name</key>
		<string>Internal</string>
		<key>framebuffer-con1-enable</key>
		<integer>1</integer>
		<key>framebuffer-con1-flags</key>
		<data>BgAAAA==</data>
		<key>framebuffer-con1-type</key>
		<data>AAgAAA==</data>
		<key>framebuffer-con2-enable</key>
		<integer>1</integer>
		<key>framebuffer-con2-flags</key>
		<data>BgAAAA==</data>
		<key>framebuffer-con2-type</key>
		<data>AAgAAA==</data>
		<key>framebuffer-con3-enable</key>
		<integer>1</integer>
		<key>framebuffer-con3-flags</key>
		<data>BgAAAA==</data>
		<key>framebuffer-con3-type</key>
		<data>AAgAAA==</data>
		<key>framebuffer-patch-enable</key>
		<integer>1</integer>
		<key>framebuffer-unifiedmem</key>
		<data>AAAAgA==</data>
		<key>#framebuffer-stolenmem</key>
		<data>AAAABA==</data>
		<key>model</key>
		<string>Intel HD Graphics 4000</string>
	</dict>
```
</details>

> [!NOTE]
> 
> - `framebuffer-unifiedmem` value `00000080` increases VRAM to 2048 MB (instead of 1536 MB). To use the default value, disable it and re-enable `framebuffer-stolenmem` instead!
> - Don't use `framebuffer-unifiedmem` and `framebuffer-stolenmem` together at the same time – use either or!
> - You can enable/disable keys by removing/putting `#` in front of them.
> - macOS 12+ require re-installing the iGPU drivers in Post-Install with [OpenCore Legacy Patcher](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Ivy_Bridge-Ventura.md#installing-intel-hd4000-drivers)

### [Sandy Bridge](https://ark.intel.com/content/www/us/en/ark/products/codename/29900/products-formerly-sandy-bridge.html?wapkw=Sandy%20Bridge#@Mobile)
>Intel HD 3000. 2nd Gen Intel Core Mobile.</br>
>Supported from macOS 10.6.7 to macOS 10.13

**Address**: `PciRoot(0x0)/Pci(0x2,0x0)`

Key | Type | Value| Notes
----|:----:|:----:|------
`AAPL,snb-platform-id`| Data | `00000100` | For Laptops
`AAPL,snb-platform-id`| Data | `10000300` | For NUCs

If you are using a **Sandy Bridge CPU with a 7-series mainboard** (ie. B75, Q75, Z75, H77, Q77, Z77), you also need to spoof the device ID of the `IMEI` device: 

**Address**: `PciRoot(0x0)/Pci(0x16,0x0)`

Key | Type | Value
----|:----:|:----:
`device-id` | Data | `3A1C0000`

> [!NOTE]
> 
> macOS 12 and newer require re-installing the iGPU drivers in Post-Install with [OpenCore Legacy Patcher](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Sandy_Bridge_Ventura.md#installing-intel-hd-20003000-drivers)

## About VGA

Whether or not your VGA port can be used depends on 2 factors: macOS and the CPU/iGPU.

- VGA support was dropped from macOS since OSX 10.8.2.
- On Ivy Bridge and others, you can try [these Connector Patches](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#vga-support) to enable it (if OSX is < 10.8.2).
- With the release of the Skylake CPU family, Intel dropped VGA support from their iGPUs completely. But manufacturers continued to service it for their devices. In order to do so, they used a DisplayPort connection and a small digital-to-analog RAMDAC to convert the signal from digital to analog so the VGA connector could still be utilized.

## Credits and Resources
- Acidanthera for [**Intel HD FAQ**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md) and [**OpenCore Legacy Patcher**](https://github.com/dortania/OpenCore-Legacy-Patcher)
- CaseySJ for [**Genral Framebuffer Patching Guide**](https://www.tonymacx86.com/threads/guide-general-framebuffer-patching-guide-hdmi-black-screen-problem.269149/)
- Chris1111 for [**Patch HD4000 Monterey**](https://github.com/chris1111/Patch-HD4000-Monterey)
- Dortania for [**OpenCore Install Guide**](https://dortania.github.io/OpenCore-Install-Guide/)
- RehabMan for [**Laptop Framebuffer Patches**](https://github.com/RehabMan/OS-X-Clover-Laptop-Config)
- List of [**GPU/iGPU drivers installed by OCLP**](https://dortania.github.io/OpenCore-Legacy-Patcher/PATCHEXPLAIN.html#on-disk-patches)
- More details about [**DVMT, stolenmem, fbmem, unifiedmem, etc.**](https://osxlatitude.com/forums/topic/17804-what-are-dvmt-stolenmem-fbmem-cursormem-why-do-we-patch-these-for-broadwell-and-later/)
