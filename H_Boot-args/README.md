# Boot arguments explained
Incomplete list of commonly used (and rather uncommon) boot-args and device properties that can be injected by boot managers such as OpenCore and Clover. These are not simply copied and pasted from their respective repositories; I tried to provide additional information about where I could gather it. I also used tables instead of lists to separate boot-args, properties and descriptions more clearly, which makes it easier to copy entries and identify additional parameters associated with a boot-arg/property (such as switches and bitmasks).

<details>
<summary><b>TABLE of CONTENTS</b> (Click to reveal)</summary>

**TABLE of CONTENTS**

- [Debugging](#debugging)
- [Network-specific boot arguments](#network-specific-boot-arguments)
- [Other useful boot arguments](#other-useful-boot-arguments)
- [Boot-args and device properties provided by Kexts](#boot-args-and-device-properties-provided-by-kexts)
	- [Lilu](#lilu)
	- [VirtualSMC](#virtualsmc)
	- [Whatevergreen](#whatevergreen)
		- [Global](#global)
		- [Board-id related](#board-id-related)
		- [Switching GPUs](#switching-gpus)
		- [Intel HD Graphics](#intel-hd-graphics)
		- [AMD Radeon](#amd-radeon)
			- [`unfairgva` Overrides](#unfairgva-overrides)
		- [NVIDIA](#nvidia)
		- [Backlight](#backlight)
		- [2nd Boot stage](#2nd-boot-stage)
	- [AirportBrcmFixup](#airportbrcmfixup)
	- [AppleALC](#applealc)
	- [BrcmPatchRAM](#brcmpatchram)
	- [BrightnessKeys](#brightnesskeys)
	- [CPUFriend](#cpufriend)
	- [CpuTscSync](#cputscsync)
	- [CryptexFixup](#cryptexfixup)
	- [DebugEnhancer](#debugenhancer)
	- [ECEnabler](#ecenabler)
	- [HibernationFixup](#hibernationfixup)
	- [NootedRed](#nootedred)
	- [NVMeFix](#nvmefix)
	- [RestrictEvents](#restrictevents)
	- [RTCMemoryFixup](#rtcmemoryfixup)
- [Credits](#credits)

</details>

## Debugging

|Boot-arg | Description|
|:-------:|-----------|
**`-v`**|Verbose Mode. Replaces the progress bar with a text output of the boot process which helps identifying issues. Combine with `debug=0x100` and `keepsyms=1`
**`-s`**|Single User Mode. This mode will start the terminal mode, which can be used to repair your system. Should be disabled with a Quirk since you can use it to bypass the Admin account password.
**`-x`**|Safe Mode. Boots macOS with a minimal set of system extensions and features. Very useful if Root Patches applied by OpenCore Legacy Patcher no longer work and macOS won't boot after applying the patches. Just boot into Safe Mode, revert the root patches, delete the boot-arg, reboot (and wait for an updated version of OCLP that fixes the issue).
**`-f`**| Enables cacheless booting in Clover. OpenCore uses a different option: change `Kernel/Scheme/KernelCache` from `Auto` to `Cacheless`. Only applicable to macOS 10.6 to 10.9!
**`debug=0x100`**|Disables WatchDog. Prevents the machine from restarting after a kernel panic so you can check the errors on screen (if verbose mode is enabled).
**`keepsyms=1`**|Companion setting to `debug=0x100` that tells the OS to also print the symbols on a kernel panic. This can give some more helpful insight as to what's causing the panic.
**`dart=0`**|Disables VT-x/VT-d. Nowadays, `DisableIOMapper` Quirk is used instead.
**`cpus=1`**|Limits the number of CPU cores to 1. Helpful in cases where macOS won't boot or install otherwise.
**`npci=0x2000`**/ **`npci=0x3000`**|Disables PCI debugging related to kIOPCIConfiguratorPFM64. Alternatively, use `npci=0x3000` which also disables debugging of gIOPCITunnelledKey. Required when stuck at **`PCI Start Configuration`** as there are IRQ conflicts related to PCI Lanes. **Not needed if `Above4GDecoding` can be enabled in BIOS**
**`-no_compat_check`**|Disables macOS compatibility checks. Allows booting macOS with unsupported SMBIOS/board-ids. **Downsides**:<ul><li>For installing macOS, you still need a supported SMBIOS temporarily</li><li>You can't install system updates if this boot-arg is active. This restriction can be lifted by adding `RestrictEvents.kext` and boot-arg `revpatch=sbvmm` but it [**requires macOS 11.3 or newer**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/S_System_Updates)</li></ul>
**`-liludbgall`** | For debugging Lilu kext and plugins (requires DEBUG build of Lilu and asociated plugins)

> [!TIP]
>
> - Recommended boot-arg for installing macOS the first time: `-v`, `keepsyms=1` and `debug=0x100`
> - A more in-depth debugging guide can be found [**here**](https://caizhiyuan.gitee.io/opencore-install-guide/troubleshooting/kernel-debugging.html#efi-setup)

</details>

## Network-specific boot arguments
|Boot-arg|Description|
|------|-----------|
**`dk.e1000=0`** (Big Sur)</br> **`e1000=0`** (Monterey)| Prohibits Intel I225-V Ethernet Controller from using `com.apple.DriverKit-AppleEthernetE1000.dext` (Apple's new Driver Extension) and uses `AppleIntelI210Ethernet.kext` instead. This is optional since most 400-series mainboards (and newer) with an I225-V NIC are compatible with the `.dext` version of the driver. It's required on some Gigabyte boards which can only use the `.kext` driver.</br>:warning: These boot-args no longer work in macOS Ventura, since the .kext version was removed from the `IONetworkingFamily.kext` (located under /S/L/E/)!

## Other useful boot arguments
|Boot-arg|Description|
|--------|-----------|
**`alcid=X`**|For selecting a layout-id for AppleALC, where `X` needs to be a numerical value specifying the layout-id. See [supported codecs](https://github.com/acidanthera/applealc/wiki/supported-codecs) to figure out which layout to use for your system's audio CODEC.
**`amfi=0x80`** or <br> **`amfi_get_out_of_my_way=1`**| Both args are identical. It's [actually a bitmask](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/data/amfi_data.py). Setting it to `0x80` disables Apple Mobile File Integrity (AMFI). AMFI is a macOS kernel module enforcing code-signing and library validation which strengthens security. **Requires `SIP` to be disabled as well!**
**`-force_uni_control`**| Force-enables Universal Control service in macOS Monterey 12.3+

## Boot-args and device properties provided by Kexts

### Lilu
Lilu boot-args. Remember that Lilu operates as a patch engine providing functionality for a lot of other kexts in the hackintosh universe. So be aware of that if you use any of these commands, especially `-liluoff`!

| Boot-arg | Description |
|----------|--------------|
**`-liludbg`** | Enables debug printing (requires DEBUG version of Lilu)
**`-liludbgall`** | Enables debug printing in Lilu and all loaded plugins (available in DEBUG binaries only)
**`-liluoff`**| Disables Lilu (and all plugin kexts that make use of it as well)
**`-liluuseroff`** | Disables Lilu user patcher (for e.g. dyld_shared_cache manipulations).
**`-liluslow`** | Enables legacy user patcher
**`-lilulowmem`** | Disables kernel unpack (disables Lilu in recovery mode)
**`-lilubeta`**| Enables Lilu on unsupported macOS versions (macOS 13 and below are supported by default)
**`-lilubetaall`**| Enables Lilu and *all* loaded plugins on unsupported macOS (use _very_ carefully)
**`-liluforce`** | Enables Lilu regardless of the mode, OS, installer, or recovery
**`liludelay=1000`**| Adds a 1 second (1000 ms) delay after each print for troubleshooting
**`liludelay=1000`** | Enables 1 second delay after each print for troubleshooting
**`lilucpu=N`**| Lets Lilu and plugins assume Nth CPUInfo::CpuGeneration.
**`liludump=N`** | Lets Lilu DEBUG version dump log to `/var/log/Lilu_VERSION_KERN_MAJOR.KERN_MINOR.txt` after N seconds

### VirtualSMC
Advanced Apple SMC emulator kext. Requires Lilu for full functionality. Included additional [**Sensor plugins**](https://github.com/acidanthera/VirtualSMC/tree/master/Sensors)

| Boot-arg | Description |
|---------|------------|
**`-vsmcdbg`** | Enables debug printing (requires DEBUG version of VirtualSMC)
**`-vsmcbeta`** | Enables Lilu enhancements on unsupported OS (13 and below are enabled by default)
**`-vsmcoff`** | Disables all Lilu enhancements.
**`-vsmcrpt`** | Reports missing SMC keys to the system log
**`-vsmccomp`** | Prefer existing hardware SMC implementation if found
**`vsmcgen=X`** | Forces exposing X-gen SMC device (1 and 2 are supported)
**`vsmchbkp=X`** | Sets HBKP dumping mode (0 = off, 1 = normal, 2 = without encryption)
**`vsmcslvl=X`** | Sets value serialisation level (0 = off, 1 = normal, 2 = with sensitive data (default))
**`smcdebug=0xff`** | Enables AppleSMC debug information printing
**`watchdog=0`** | Disables WatchDog timer (if you get accidental reboots)

[**Source**](https://github.com/acidanthera/VirtualSMC)

### Whatevergreen
The following boot-args are provided by and require Whatevergreen.kext to work! Check the [complete list](https://github.com/acidanthera/WhateverGreen/blob/master/README.md#boot-arguments) to find many, many more.

#### Global

boot-arg | Property | Description 
:--------|:--------:|:------------
**`-cdfon`** | `enable-hdmi20`| Enables HDMI 2.0 patches on iGPU and dGPU (not implemented in macOS 11+)
**`-wegbeta`**| N/A| Enables WhateverGreen on unsupported versions of macOS (macOS 13 and below are enabled by default) 
**`-wegdbg`** | N/A | Enables debug printing (requires DEBUG version of WEG)
**`-wegoff`** | N/A | Disables WhateverGreen

#### Board-id related

boot-arg | Property | Description 
--------|:---------:|------------
**`agdpmod=ignore`** | `agdpmod`| Disables AGDP patches (`vit9696,pikera` value is implicit default for external GPUs) 
**`agdpmod=pikera`** | `agdpmod`| Replaces `board-id` with `board-ix`. Disables Board-ID checks on AMD Navi (RX 5000/6000 series) to fix black screen issues due to the difference in framework with the x6000 drivers. Although not necessary for Polaris or Vega Cards, it can be used to resolve black screen issues in multi-monitor setups.
**`agdpmod=vit9696`** | `agdpmod` | Disables check for `board-id`. Useful if screen turns black after booting macOS.

#### Switching GPUs

boot-arg | Property | Description 
---------|:--------:|------------
**`-wegnoegpu`** | `disable-gpu` | Disables all external GPUs but the integrated graphics on Intel CPUS. Use if GPU is incompatible with macOS. Doesn't work all the time. Using an SSDT to disable it in macOS is the recommended procedure.
**`-wegnoigpu`** | `disable-gpu` | Disables internal GPU
**`-wegswitchgpu`** | `switch-to-external-gpu`| Disables internal GPU when external GPU is detected.

#### Intel HD Graphics

boot-arg | Property | Description 
---------|:---------:|-------------
**`-igfxblr`** | `enable-backlight-registers-fix` | Fixes backlight registers on Kaby Lake, Coffee Lake and Ice Lake 
**`-igfxbls`** | `enable-backlight-smoother` | Smoothens brightness transitions on Ivy Bridge and newer. [Check the manual for details](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#customize-the-behavior-of-the-backlight-smoother-to-improve-your-experience)
**`-igfxcdc`** | `enable-cdclk-frequency-fix` |Enables support for all valid Core Display Clock (CDCLK) supported by the Ice Lake CPU family. [Read the manual](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#support-all-possible-core-display-clock-cdclk-frequencies-on-icl-platforms)
**`-igfxdbeo`** | `enable-dbuf-early-optimizer` | Fixes Display Data Buffer (DBUF) issues on Ice Lake. [Check the manual for details](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#fix-the-issue-that-the-builtin-display-remains-garbled-after-the-system-boots-on-icl-platforms)
**`-igfxdump`** | N/A | Dump IGPU framebuffer kext to `/var/log/AppleIntelFramebuffer_X_Y` (requires in DEBUG version of WEG)
**`-igfxdvmt`** | `enable-dvmt-calc-fix`  | Fixes kernel panic caused by an incorrectly calculated amount of DVMT pre-allocated memory on Intel Ice Lake platforms
**`-igfxfbdump`** | N/A | Dump native and patched framebuffer table to ioreg at `IOService:/IOResources/WhateverGreen`
**`-igfxhdmidivs`** | `enable-hdmi-dividers-fix`  | Fixes the infinite loop on establishing Intel HDMI connections with a higher pixel clock rate on Skylake, Kaby Lake and Coffee Lake platforms
**`-igfxi2cdbg`** | N/A | Enables verbose output in I2C-over-AUX transactions (only for debugging purposes)
**`-igfxlspcon`** | `enable-lspcon-support`  | Enables driver support for onboard LSPCON chips.<br> [Check the manual for details](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#lspcon-driver-support-to-enable-displayport-to-hdmi-20-output-on-igpu)
**`-igfxmlr`** | `enable-dpcd-max-link-rate-fix`  | Applies the maximum link rate fix
**`-igfxmpc`** | `enable-max-pixel-clock-override` and `max-pixel-clock-frequency` | Increases max pixel clock (as an alternative to patching `CoreDisplay.framework`
**`-igfxnohdmi`** | `disable-hdmi-patches` | Disables DP to HDMI conversion patches for digital audio
**`-igfxsklaskbl`** | N/A | Enforces Kaby Lake graphics kext to be used on Skylake platforms (KBL `device-id` and `ig-platform-id` are required. Not required on macOS 13+)
**`-igfxtypec`** | N/A | Force DP connectivity for Type-C platforms
**`-igfxvesa`** | N/A | Disables graphics acceleration in favor of software rendering. Useful if iGPU and dGPU are incompatible or if you are using an NVIDIA GeForce Card and the WebDrivers are outdated after updating macOS, so the display won't turn on during boot.
**`igfxagdc=0`** | `disable-agdc`  | Disables AGDC (Apple Automatic Device Gating Control) for the iGPU to fix wake issues with 4K displays.
**`igfxfcms=1`** | `complete-modeset` | Forces complete modeset on Skylake or Apple firmwares
**`igfxfcmsfbs=`** | `complete-modeset-framebuffers` | Specify indices of connectors for which complete modeset must be enforced. Each index is a byte in a 64-bit word; for example, value `0x010203` specifies connectors 1, 2, 3. If a connector is not in the list, the driver's logic is used to determine whether complete modeset is needed. Pass `-1` to disable. 
**`igfxframe=frame`** | `AAPL,ig-platform-id` (Ivy Bridge+) or `AAPL,snb-platform-id` (Sandy Bridge only) | Inject a dedicated framebuffer identifier into IGPU (for testing purposes ONLY)
**`igfxfw=2`** | `igfxfw` | Forces loading of Apple's Graphics Unit Control (GUC) firmware. Improves Intel Quick Sync Video performance. Requires chipset supporting Intel ME v12 or newer (Z390, B360, H370, H310, Q370, C246, Z490, etc.). It's [buggy](https://github.com/acidanthera/bugtracker/issues/800) and not advisable to use. Should be tested on a case by case basis. `igfxfw` takes precedence over `igfxrpsc=1` when both are set.
**`igfxrpsc=1`** | `rps-control` | Enables RPS control patch which improves iGPU performance on Kaby Lake+ using chipsets without ME v12 support (Z370 and others) 
**`wegtree=1`** | `rebuild-device-tree` | Forces WEG to rename the device tree of the iGPU after Apple GUC Firmware is loaded. Useful if the iGPU doesn't work after applying `igfxfw=2` (on a compatible CPU and chipset, of course). 
**`igfxgl=1`** | `disable-metal` | Disable Metal support on Intel
**`igfxmetal=1`**| `enable-metal` | Force enable Metal support on Intel for offline rendering
**`igfxonln=1`** | `force-online` | Forces all displays online. Resolves screen wake issues after quitting sleep in macOS 10.15.4 and newer when using Intel UHD 630.
**`igfxonlnfbs=MASK`** | `force-online-framebuffers` | Specify indices of connectors for which online status is enforced. Format is similar to `igfxfcmsfbs`
**`igfxpavp=1`** | `igfxpavp`  | Force enable PAVP output 
**`igfxsnb=0`** | N/A | Disable IntelAccelerator name fix for Sandy Bridge CPUs 

#### AMD Radeon

boot-arg | Property | Description 
:---------|:--------:|------------
**`-rad24`** | N/A | Forces 24-bit display mode
**`-radcodec`** | N/A | Forces the spoofed PID to be used in AMDRadeonVADriver 
**`-raddvi`** | N/A | Enables DVI transmitter correction (required for 290X, 370, etc.)
**`-radvesa`** | N/A | Disable ATI/AMD video acceleration completely and forces the GPU into VESA mode. Useful if the card is not supported by macOS and for trouleshooting. Apple's built in version of this flag is called `-amd_no_dgpu_accel`
**`radpg=15`** | N/A | Disables several power-gating modes. Required for Cape Verde GPUs: Radeon HD 7730/7750/7770, R7 250/250X  (see [Radeon FAQ](https://github.com/dreamwhite/WhateverGreen/blob/master/Manual/FAQ.Radeon.en.md))
**`shikigva=40`** + **`shiki-id=Mac-7BA5B2D9E42DDD94`**| N/A |Swaps boardID with `iMacPro1,1`. Allows Polaris, Vega and Navi GPUs to handle all types of rendering, useful for SMBIOS which expect an iGPU. Obsolete in macOS 11+. More info: [**Fixing DRM**](https://dortania.github.io/OpenCore-Post-Install/universal/drm.html#testing-hardware-acceleration-and-decoding)
**–** | `CFG,CFG_USE_AGDC` (Type: Data; Value: 00)| Disabbles AGDC (Apple Automatic Device Gating Control) for the AMD GPUs to fix wake issues when using 4K displays.
**'unfairgva=x'** (x = number from 1 to 7 )| N/A| Replaces `shikigva` in macOS 11+ to address issues with [**DRM**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.Chart.md). It's a bitmask with 3 bits (1, 2 and 4) which can be combined to enable/select different features as [**explained here**](https://www.insanelymac.com/forum/topic/351752-amd-gpu-unfairgva-drm-sidecar-featureunlock-and-gb5-compute-help/)

##### `unfairgva` Overrides

The `unfairgva` boot-arg supports overrides to configure the video decoder preferences of AMD GPUs for different types of content using [**DRM**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.Chart.md) (e.g. Apple TV and iTunes movie streaming). These prferences may not always be compatible with the rest of the operating system and may cause problems with other ways of hardware media decoding and encoding. Therefore, using unfairgva overrides is not recommended for daily use and should only be enabled on demand.

- **Force AMD DRM decoder for streaming services (like Apple TV and iTunes movie streaming)**:
	
	```shell
	defaults write com.apple.AppleGVA gvaForceAMDKE -boolean yes
	``` 
- **Force AMD AVC accelerated decoder**:
	
	```shell
	defaults write com.apple.AppleGVA gvaForceAMDAVCDecode -boolean yes
	```
- **Force AMD AVC accelerated encoder**:
	
	```shell
	defaults write com.apple.AppleGVA gvaForceAMDAVCEncode -boolean yes
	```
- **Force AMD HEVC accelerated decoder**:
	
	```shell
	defaults write com.apple.AppleGVA gvaForceAMDHEVCDecode -boolean yes
	```
- **Force AMD HEVC accelerated encodrer**:
	
	```shell
	defaults write com.apple.AppleGVA disableGVAEncryption -string yes
	```
- **Force hardware accelerated video decoder** (any resolution):

	```shell
	defaults write com.apple.coremedia hardwareVideoDecoder -string force
	``` 
- **Disable hardware accelerated video decoder** (in QuickTime/Apple TV):
	
	```shell 
	defaults write com.apple.coremedia hardwareVideoDecoder -string disable
	```

#### NVIDIA

boot-arg | Property | Description 
---------|:--------:|------------
**~~`nvda_drv=1`~~**</br>(≤ macOS 10.11)| N/A | Deprecated. macOS Siera and newer require an NVRAM key instead.<ul><li>**OpenCore**: `NVRAM/Add/7C436110-AB2A-4BBB-A880-FE41995C9F82/nvda_drv: 31` (**Type**: Data)</li><li>**Clover**: Enable `NvidiaWeb` under `System Parameters`</li></ul>
**`-ngfxdbg`** | N/A | Enables NVIDIA driver error logging 
**`ngfxcompat=1`** | `force-compat` 	| Ignore compatibility check in NVDAStartupWeb
**`ngfxgl=1`** | `disable-metal` 	| Disable Metal suppoPropertyrt on NVIDIA 
**`ngfxsubmit=0`** | `disable-gfx-submit` | Disable interface stuttering fix on 10.13
**`nv_disable=1`**| N/A | Disables hardware acceleration and enables VESA mode instead. Required when upgrading macOS so the card will display an image before drivers are reinstalled. ***Don't*** combine with `nvda_drv=1`.
**`agdpmod=pikera`**|`agdpmod` |Swaps `board-id `for `board-ix`, needed for disabling string comparison which is useful for non-iMac13,2/iMac14,2 SMBIOS.
**`agdpmod=vit9696`**|`agdpmod` |Disables `board-id` check, may be needed for when screen turns black after finishing booting
**`shikigva=1`**| N/A |Needed if you want to use your iGPU's display out along with your dGPU, allows the iGPU to handle hardware decoding even when not using a connector-less framebuffer
**`shikigva=4`**| N/A |Needed to support hardware accelerated video decoding on systems that are newer than Haswell. May needs to be combined with `shikigva=12` to patch the needed processes 
**`shikigva=40`**| N/A |Swaps boardID with iMac14,2. Useful for SMBIOS that don't expect a Nvidia GPU, however WhateverGreen should handle patching by itself.

#### Backlight

boot-arg | Property | Description 
---------|:--------:|-------------
**`applbkl=3`** | `applbkl` | Enable PWM backlight control of AMD Radeon RX 5000 series graphic cards [read here.](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.Radeon.en.md) 
**`applbkl=0`** | `applbkl` | Disable AppleBacklight.kext patches for IGPU. <br>In case of custom AppleBacklight profile [read here](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.OldPlugins.en.md)

#### 2nd Boot stage

boot-arg | Description 
---------|------------
**`gfxrst=1`** | Prefer drawing Apple logo at 2nd boot stage instead of framebuffer copying
**`gfxrst=4`** | Disables framebuffer init interaction during 2nd boot stage

**SOURCES**: [**Dortania**](https://dortania.github.io/GPU-Buyers-Guide/misc/bootflag.html) and [**Whatevergreen**](https://github.com/acidanthera/WhateverGreen)

### AirportBrcmFixup
Open source kext providing patches required for non-native Airport Broadcom WiFi cards.

boot-arg | NVRAM Variable| Description 
---------|:--------------:|------------
**`-brcmfxdbg`** |N/A| Enables debugging output
**`-brcmfxbeta`** |N/A| Enables loading on unsupported macOS
**`-brcmfxoff`** |N/A| Disables kext
**`-brcmfxwowl`** |N/A| Enables WOWL (Wake on WLAN) - disabled by default
**`-brcmfx-alldrv`** |N/A| Allows patching for all supported drivers, disregarding current system version (&rarr; See [Matching device-id and kext name in different macOS versions](https://github.com/acidanthera/AirportBrcmFixup#matching-device-id-and-kext-name-in-different-macos-versions))
**`brcmfx-country=XX`** |`brcmfx-country=XX`| Changes the country code to `XX` (can be US, CN, DE, etc. or #a for generic)
**`brcmfx-aspm`** | |Overrides value used for pci-aspm-default
**`brcmfx-wowl`** | |Enables/disables WoWLAN patch
**`brcmfx-delay`** | |Delays start of native broadcom driver for specified amount of milliseconds. Can solve panics or missing Wi-Fi device in Monterey. Start with 15 seconds (`brcmfx-delay=15000`) and successively reduce the delay until you notice instability in boot.
**`brcmfx-alldrv`** | |Allows patching for all supported drivers, disregarding current system version (&rarr; See [Matching device-id and kext name in different macOS versions](https://github.com/acidanthera/AirportBrcmFixup#matching-device-id-and-kext-name-in-different-macos-versions))
**`brcmfx-driver=0/1/2/3`** |Same| Enables only one kext for loading: </br> `0` = AirPortBrcmNIC-MFG </br> `1` = AirPortBrcm4360 </br> `2` = AirPortBrcmNIC </br> `3` = AirPortBrcm4331

[**Source**](https://github.com/acidanthera/AirportBrcmFixup)

### AppleALC
Boot-args for your favorite audio-enabler kext. Note that all Lilu boot arguments affect AppleALC as well.

boot-arg | Property | Description 
---------|:--------:|------------
**`alcid=X`**| `layout-id` |To select a layout-id, where `X` stands for the number of the Layout ID, e.g. `alcid=1`. A list with all existing layout-ids sorted by vendor and codec model can be found [here](https://github.com/dreamwhite/ChonkyAppleALC-Build).
**`-alcoff`**| N/A |Disables AppleALC (Bootmode `-x` and `-s` will also disable it)
**`-alcbeta`**| N/A |Enables AppleALC on unsupported systems (usually unreleased or old ones)
**`-alcdbg`** |N/A | Print the debugging information (requires DEBUG version)
**`alcverbs=1`**| `alc-verbs` |Enables alc-verb support

[**Source**](https://github.com/acidanthera/AppleALC/wiki/Installation-and-usage)

### BrcmPatchRAM
BrcmPatchRAM kext is a macOS driver which applies PatchRAM updates for Broadcom RAMUSB based devices. It will apply the firmware update to your Broadcom Bluetooth device on every startup/wakeup. Since this kext includes different kexts which need to be [combined in different ways](https://github.com/5T33Z0/OC-Little-Translated/tree/main/10_Kexts_Loading_Sequence_Examples#example-7-broadcom-wifi-and-bluetooth) – depending on the hardware and macOS version used – please follow the instrunctions on the repo to configure it correctly.

boot-arg | Description  
---------|------------
**`-btlfxallowanyaddr`** | Disables address check in macOS 12.4 and newer. Apple introduced a new address check in `bluetoothd`, which will trigger an error if *two* Bluetooth devices have the same address.
**`bpr_initialdelay=X`** | Changes the `mInitialDelay`, where `X` describes delay in ms before any communication with the device happems. Default value is `100`.</br> </br> **Example**: `bpr_initialdelay=300`
**`bpr_handshake=X`** | Overrides `mSupportsHandshake`. 2 options are avaialable: </br> `0` means wait `bpr_preresetdelay` ms after uploading firmware, and then reset the device. </br>`1` means wait for a specific response from the device and then reset the device. Default value depends on the device identifier. 
**`bpr_preresetdelay=X`** | Changes `mPreResetDelay`. X describes the delay in ms assumed to be needed for the device to accept the firmware. The value is unused when `bpr_handshake` is `1` (passed manually or applied automatically based on the device identifier). Default value is `250`. </br></br> **Example**: `bpr_preresetdelay=500`
**`bpr_postresetdelay=X`** | Changes `mPostResetDelay`, where `X` describes the delay in ms assumed to be needed for the firmware to initialise after reseting the device upon firmware upload. Default value is `100`. </br></br> **Example**: `bpr_postresetdelay=400`
**`bpr_probedelay=X`** | Changes `mProbeDelay` (removed in BrcmPatchRAM3), where X describes the delay in ms before probing the device. Default value is `0`.

> [!CAUTION]
>
> From BrcmPatchRAM 2.7.0 onward, the board-id patches required by many Broadcom cards for Bluetooth to work have been disabled, as Intel cards do not require these patches. So if Bluetooth stops working in macOS Sonoma and newer _after_ updating your BrcmPatchRAM kexts, add the following boot-arg: `-btlfxboardid`

> [!TIP]
>
> Some users with typical "wake from sleep" problems reported success with the following settings:
>
> - `bpr_probedelay=100 bpr_initialdelay=300 bpr_postresetdelay=300` or
> - `bpr_probedelay=200 bpr_initialdelay=400 bpr_postresetdelay=400` (slightly longer delays)

[**Source**](https://github.com/acidanthera/BrcmPatchRAM)

### BrightnessKeys
Automatic handling of brightness key shortcuts based on ACPI Specification, Appendix B: Video Extensions. Requires Lilu 1.2.0 or newer.

`-brkeysdbg` &rarr; Enables debug printing (available in DEBUG binaries only)

[**Source**](https://github.com/acidanthera/BrightnessKeys)

### CPUFriend
Kext for optimizing CPU Power Management for Intel CPUs supporting XCPM (Haswell and newer).

boot-arg | Description 
---------|------------
**`-cpufdbg`** | Enables debug logging (only available in DEBUG binaries)
**`-cpufoff`** | Disables CPUFriend entirely
**`-cpufbeta`** | Enables CPUFriend on unsupported macOS versions

[**Source**](https://github.com/acidanthera/CPUFriend/)

### CpuTscSync
Lilu plugin combining functionality of VoodooTSCSync and disabling xcpm_urgency if TSC is not in sync. It should solve some kernel panics after wake.

boot-arg | Description 
---------|------------
**`-cputsdbg`** | Enable debugging output[](https://github.com/acidanthera/CryptexFixup)
**`-cputsbeta`** | Enables loading on unsupported macOS 
**`-cputsoff`** | Disables kext loading
**`-cputsclock`** | Forces using of method clock_get_calendar_microtime to sync TSC (the same method is used when boot-arg `TSC_sync_margin` is specified)

[**Source**](https://github.com/acidanthera/CpuTscSync)

### CryptexFixup
Lilu Kernel extension for installing Rosetta Cryptex in macOS Ventura. It's required for installing and booting macOS 13 on legacy Intel (Ivy Bridge and older) and AMD (Bulldozer/Piledriver/Steamroller and older) CPUs. [More details](https://dortania.github.io/OpenCore-Install-Guide/extras/ventura.html#dropped-cpu-support)

boot-arg | Description 
---------|------------
`-cryptoff` | Disables the kext
`-cryptdbg` | Enables verbose logging (in DEBUG builds only)
`-cryptbeta`| Enable on macOS newer than 13
`-crypt_allow_hash_validation` | Disables `APFS.kext` patching
`-crypt_force_avx` | Force installs Rosetta Cryptex on AVX2.0 systems

[**Source**](https://github.com/acidanthera/CryptexFixup)

### DebugEnhancer
Lilu plugin intended to enable debug output in the macOS kernel.

boot-arg | Description 
---------|------------
**`-dbgenhdbg`** | Enables debugging output
**`-dbgenhbeta`** | Enables loading on unsupported macOS
**`-dbgenhoff`** | Disables kext loading
**`-dbgenhiolog`** | Redirects IOLog output to kernel vprintf (the same as for kdb_printf and kprintf)

[**Source**](https://github.com/acidanthera/DebugEnhancer)

### ECEnabler
Allows reading Embedded Controller fields over 1 byte long, vastly reducing the amount of ACPI modification needed (if any) for working battery status of Laptops. 

boot-arg | Description 
---------|------------
**`-eceoff`** | Disables ECEnabler  
**`-ecedbg`** | Enables debug logs  
**`-ecebeta`**| Removes upper macoOS limit (for macOS betas)  

[**Source**](https://github.com/1Revenger1/ECEnabler)

### HibernationFixup
Lilu plugin kext intended to fix hibernation compatibility issues. It's pretty complex in terms of configuration, so you're best to read the info provided in the repo!

boot-arg | Description 
---------|------------
**`-hbfx-dump-nvram`** | Saves NVRAM to a file nvram.plist before hibernation and after kernel panic (with panic info)
**`-hbfx-disable-patch-pci`**| Disables patching of IOPCIFamily (this patch helps to avoid hang & black screen after resume (restoreMachineState won't be called for all devices)
**`hbfx-patch-pci=XHC,IMEI,IGPU`** | Allows to specify explicit device list (and restoreMachineState won't  be called only for these devices). Also supports values `none`, `false`, `off`.
**`-hbfxdbg`**| Enables debugging output
**`-hbfxbeta`** | Enables loading on unsupported osx
**`-hbfxoff`** | Disables kext loading
**`hbfx-ahbm=abhm_value`** | Controls auto-hibernation feature, where "abhm_value" represenst an *arithmetic sum* (bitmask) of the following values: </br></br> `1` = `EnableAutoHibernation`: If this flag is set, system will hibernate instead of regular sleep (flags below can be used to limit this behavior)</br>  `2` = `WhenLidIsClosed` : Auto hibernation can happen when lid is closed (if bit is not set - no matter which status lid has)</br> `4` = `WhenExternalPowerIsDisconnected`: Auto hibernation can happen when external power is disconnected (if bit is not set - no matter whether it is connected) </br> `8` = `WhenBatteryIsNotCharging`: Auto hibernation can happen when battery is not charging (if bit is not set - no matter whether it is charging) </br> `16` = `WhenBatteryIsAtWarnLevel`: Auto hibernation can happen when battery is at warning level (macOS and battery kext are responsible for this level)</br> `32` = `WhenBatteryAtCriticalLevel`: Auto hibernation can happen when battery is at critical level (macOS and battery kext are responsible for this level) </br> `64` = `DoNotOverrideWakeUpTime`:	Do not alter next wake up time, macOS is fully responsible for sleep maintenance dark wakes </br> `128` = `DisableStimulusDarkWakeActivityTickle`: Disable power event kStimulusDarkWakeActivityTickle in kernel, so this event cannot trigger a switching from dark wake to full wake </br></br> **EXAMPLE**: `hbfx-ahbm=135`  would enable options associated with values `1`, `2`, `4` and `128`.

The following options can be stored in NVRAM and can be used instead of respective boot-args:

**GUID**: `NVRAM/Add/E09B9297-7928-4440-9AAB-D1F8536FBF0A`

NVRAM Key |Type  
----------|:---:
**`hbfx-dump-nvram`** | Boolean
**`hbfx-disable-patch-pci`** | Boolean
**`hbfx-patch-pci=XHC,IMEI,IGPU,none,false,off`**| String
**`hbfx-ahbm`** | Number

[**Source**](https://github.com/acidanthera/HibernationFixup)

### NootedRed
 Lilu plugin for AMD Vega iGPUs.

boot-arg | Description 
---------|------------
 `-CKFBOnly` | Enables "partial" acceleration 
 `-NRedDPDelay` | Adds delay to the boot sequence, useful if experiencing black screen on boot
 `-NRedDebug` | Enables detailed logging for `DEBUG` build

[**Source**](https://github.com/NootInc/NootedRed)

### NVMeFix
A set of patches for the Apple NVMe storage driver, IONVMeFamily. Its goal is to improve compatibility with non-Apple SSDs.

boot-arg | Description 
---------|------------
**`-nvmefdbg`** | Enables detailed logging for `DEBUG` build
**`-nvmefoff`** | Disables the kext
**`-nvmefaspm`** | forces ASPM L1 on all the devices. This argument is recommended exclusively for testing purposes!  For daily usage, inject `pci-aspm-default` device property with `<02 00 00 00>` value into SSD and bridge devices they are connected to instead. &rarr; &rarr; See [**Configuration**](https://github.com/acidanthera/NVMeFix/blob/master/README.md#configuration) for more details.

[**Source**](https://github.com/acidanthera/NVMeFix)

### RestrictEvents
boot-arg | NVRAM Key| Description 
---------|:--------:|------------
**`-revoff`**| –| Disables the kext
**`-revdbg`**| – | Enables verbose logging (in DEBUG builds)
**`-revbeta`**| – | Enables the kext on macOS < 10.8 or greater than 13
**`-revproc`**|–| Enables verbose process logging (in DEBUG builds)
**`revpatch=value`** |–| Enables patching as comma separated options. Default value is `auto`. See available values below.
**`revpatch=auto`** |YES| Enables `memtab,pci,cpuname`, without `memtab` and `pci` patches being applied on a real Mac.
**`revpatch=none`** |YES| Disables all patching 
**`revpatch=asset`** |YES| Allows Content Caching when `sysctl kern.hv_vmm_present` returns `1` on macOS 11.3 or newer
**`revpatch=cpuname`**|YES| Allows Custom CPU name in System Information
**`revpatch=diskread`** |YES| Disables "Uninitialized disk" warning in Finder
**`revpatch=f16c`** |YES| Resolves CoreGraphics crashing on Ivy Bridge CPUs by disabling f16c instruction set reporting in macOS 13.3 or newer
**`revpatch=memtab`** |YES|Enables memory tab in System Information on `MacBookAir` and `MacBookPro10,x`.
**`revpatch=pci`**|YES|Prevents PCI configuration warnings in System Settings on `MacPro7,1`
**`revpatch=sbvmm`** |YES| Forces VMM SB model, allowing OTA updates for unsupported models on macOS 11.3 or newer
**`revcpu=value`** |YES| Enables or disables CPU brand string patching. `1` = non-Intel default, `0` = Intel default
**`revcpuname=value`** |YES| Custom CPU brand string (max 48 characters, 20 or less recommended, taken from CPUID otherwise)
**`revblock=value`** |–| To block processes as comma separated options. Default value is `auto`.
**`revblock=auto`** |YES| Same as `pci`
**`revblock=none`**|YES| Disables all blocking
**`revblock=pci`**|YES| Prevents PCI and RAM configuration notifications on `MacPro7,1`
**`revblock=gmux`** |YES| Blocks `displaypolicyd` on Big Sur+ (for genuine MacBookPro9,1/10,1)
**`revblock=media`** |YES| Block `mediaanalysisd` on Ventura+ (for Metal 1 GPUs)

**NOTE**: NVRAM variables work the same way as the boot arguments, but have lower priority. They need to be added to the config under `NVRAM/Add/4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102`:

![revpatchrevblock](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/dcfad4c5-f646-4463-b6dc-2248d23c49cf)

[**Source**](https://github.com/acidanthera/RestrictEvents)

### RTCMemoryFixup
Kext providing a way to emulate some offsets in your CMOS (RTC) memory. 
More details about CMOS-related isses fan be found [here](https://github.com/5T33Z0/OC-Little-Translated/tree/main/06_CMOS-related_Fixes).

boot-arg | Description 
:-------|------------
**`rtcfx_exclude=`** | The `=` is followed by values for offsets ranging from `00` to `FF` &rarr; Check repo description for details
**`-rtcfxdbg`** | Turns on debugging output

[**Source**](https://github.com/acidanthera/RTCMemoryFixup)

**To be continued…**

## Credits
- 1Revenger1 for ECEnabler
- Acidanthera for Lilu, VirtalSMC, Whatevergreen and others
- Miliuco and Andrey1970AppleLife for additional details about `igfxfw` and `rps-control` properties
