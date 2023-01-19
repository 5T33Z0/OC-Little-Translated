# Boot arguments explained
Incomplete list of commonly used (and rather uncommon) boot-args and device properties that can be injected by boot managers such as OpenCore and Clover. These are not simply copied and pasted from their respective repositories; I tried to provide additional information about where I could gather it.

**TABLE of CONTENTS**

- [Boot arguments explained](#boot-arguments-explained)
	- [Debugging](#debugging)
	- [Network-specific boot arguments](#network-specific-boot-arguments)
	- [Other useful boot arguments](#other-useful-boot-arguments)
	- [Boot-args and device properties provided by Kexts](#boot-args-and-device-properties-provided-by-kexts)
		- [Lilu.kext](#lilukext)
		- [VirtualSMC.kext](#virtualsmckext)
		- [Whatevergreen.kext](#whatevergreenkext)
			- [Global](#global)
			- [Board-id related](#board-id-related)
			- [Switching GPUs](#switching-gpus)
			- [Intel HD Graphics](#intel-hd-graphics)
			- [AMD Radeon](#amd-radeon)
			- [NVIDIA](#nvidia)
			- [Backlight](#backlight)
			- [2nd Boot stage](#2nd-boot-stage)
		- [AppleALC](#applealc)
		- [RestrictEvents](#restrictevents)
	- [Credits](#credits)

## Debugging
|Boot-arg|Description|
|:------:|-----------|
**`-v`**|_V_erbose Mode. Replaces the progress bar with a terminal output with a bootlog which helps resolving issues. Combine with `debug=0x100` and `keepsyms=1`
**`-f`**|_F_orce-rebuild kext cache on boot.
**`-s`**|_S_ingle User Mode. This mode will start the terminal mode, which can be used to repair your system. Should be disabled with a Quirk since you can use it to bypass the Admin account password.
**`-x`**|Safe Mode. Boots macOS with a minimal set of system extensions and features. It can also check your startup disk to find and fix errors like running First Aid in Disk Utility. Can be triggered from OC's Boot Picker by holding a key combination if `PollAppleHotkeys` is enabled.
**`debug=0x100`**|Disables macOS'es watchdog. Prevents the machine from restarting on a kernel panic. That way you can hopefully glean some useful info and follow the breadcrumbs to get past the issues.
**`keepsyms=1`**|Companion setting to `debug=0x100` that tells the OS to also print the symbols on a kernel panic. That can give some more helpful insight as to what's causing the panic itself.
**`dart=0`**|Disables VT-x/VT-d. Nowadays, `DisableIOMapper` Quirk is used instead.
**`cpus=1`**|Limits the number of CPU cores to 1. Helpful in cases where macOS won't boot or install otherwise.
**`npci=0x2000`**/ **`npci=0x3000`**|Disables PCI debugging related to `kIOPCIConfiguratorPFM64`. Alternatively, use `npci=0x3000` which also disables debugging of `gIOPCITunnelledKey`. Required when stuck at `PCI Start Configuration` as there are IRQ conflicts related to your PCI lanes. **Not needed if `Above4GDecoding` can be enabled in BIOS**
**`-no_compat_check`**|Disables macOS compatibility checks. Allows installing and booting macOS with unsupported SMBIOS/board-ids. Downside: you can't install system updates if this boot-arg is active. But this restriction can be worked around by adding `RestrictEvents.kext` and boot-arg `revpatch=sbvmm` ([requires macOS 11.3 or newer](https://github.com/5T33Z0/OC-Little-Translated/tree/main/S_System_Updates))

## Network-specific boot arguments
|Boot-arg|Description|
|:------:|-----------|
**`dk.e1000=0`/`e1000=0`** (Big Sur and Monterey only)| Prohibits Intel I225-V Ethernet Controller from using `com.apple.DriverKit-AppleEthernetE1000.dext` (Apple's new Driver Extension) and use `AppleIntelI210Ethernet.kext` instead. This is optional since most boards with an I225-V NIC are compatible with the .dext version of the driver. It's required on some Gigabyte boards which can only use the .kext driver.</br>:warning: These boot-args no longer work in macOS Ventura, since the .kext version was removed from the `IONetworkingFamily.kext` located under /S/L/E/!

## Other useful boot arguments
|Boot-arg|Description|
|:------:|-----------|
**`alcid=1`**|For selecting a layout-id for AppleALC, whereas the numerical value specifies the layout-id. See [supported codecs](https://github.com/acidanthera/applealc/wiki/supported-codecs) to figure out which layout to use for your specific system.
**`amfi_get_out_of_my_way=1`**|Combines wit disabled SIP, this disables Apple Mobile File Integrity. AMFI is a macOS kernel module enforcing code-signing validation and library validation which strengthens security. Even after disabling these services, AMFI is still checking the signatures of every app that is run and will cause non-Apple apps to crash when they touch extra-sensitive areas of the system. There's also a [kext](https://github.com/osy/AMFIExemption) which does this on a per-app-basis.
**`-force_uni_control`**|Force-enables the Universal Control service in macOS Monterey 12.3+.

## Boot-args and device properties provided by Kexts

### Lilu.kext
Lilu boot-args. Remember that Lilu acts as a patch engine providing functionality for other kexts in the hackintosh universe, so you got to be aware of that if you use any of these commands!

| Boot-arg | Description |
|----------|-------------|
**`-liluoff`**| Disables Lilu.
**`-lilubeta`**| Enables Lilu on unsupported macOS versions (macOS 13 and below are supported by default).
**`-lilubetaall`**| Enables Lilu and *all* loaded plugins on unsupported macOS (use _very_ carefully).
**`-liluforce`** | Enables Lilu regardless of the mode, OS, installer, or recovery.
**`-liludbg`** | Enables debug printing (requires DEBUG version of Lilu).
**`liludelay=1000`**| Adds a 1 second (1000 ms) delay after each print for troubleshooting.
**`lilucpu=N`**| Lets Lilu and plugins assume Nth CPUInfo::CpuGeneration.
**`liludump=N`** | Lets Lilu DEBUG version dump log to `/var/log/Lilu_VERSION_KERN_MAJOR.KERN_MINOR.txt` after N seconds
**`-liluuseroff`** | Disables Lilu user patcher (for e.g. dyld_shared_cache manipulations).
**`-liluslow`** | Enables legacy user patcher.
**`-lilulowmem`** | Disables kernel unpack (disables Lilu in recovery mode).
**`liludelay=1000`** | Enables 1 second delay after each print for troubleshooting.

### VirtualSMC.kext
| Boot-arg | Description |
|----------|-------------|
**`-vsmcdbg`** | Enables debug printing (requires DEBUG version of VirtualSMC).
**`-vsmcbeta`** | Enables Lilu enhancements on unsupported OS (13 and below are enabled by default).
**`-vsmcoff`** | Disables all Lilu enhancements.
**`-vsmcrpt`** | Reports missing SMC keys to the system log.
**`-vsmccomp`** | Prefer existing hardware SMC implementation if found.
**`vsmcgen=X`** | Forces exposing X-gen SMC device (1 and 2 are supported).
**`vsmchbkp=X`** | Sets HBKP dumping mode (0 = off, 1 = normal, 2 = without encryption).
**`vsmcslvl=X`** | Sets value serialisation level (0 = off, 1 = normal, 2 = with sensitive data (default)).
**`smcdebug=0xff`** | Enables AppleSMC debug information printing.
**`watchdog=0`** | Disables WatchDog timer (if you get accidental reboots).

### Whatevergreen.kext 
The following boot-args are provided by and require Whatevergreen.kext to work! Check the [complete list](https://github.com/acidanthera/WhateverGreen/blob/master/README.md#boot-arguments) to find many, many more.

#### Global

boot-arg | DeviceProperty | Description 
---------|:--------------:|------------
**`-cdfon`** | `enable-hdmi20`| Enables HDMI 2.0 patches on iGPU and dGPU (not implemented in macOS 11+)
**`-wegbeta`**| N/A| Enables WhateverGreen on unsupported versions of macOS (macOS 13 and below are enabled by default) 
**`-wegdbg`** | N/A | Enables debug printing (requires DEBUG version of WEG)
**`-wegoff`** | N/A | Disables WhateverGreen

#### Board-id related

boot-arg | DeviceProperty | Description 
---------|:--------------:|------------
**`agdpmod=ignore`** | `agdpmod`| Disables AGDP patches (`vit9696,pikera` value is implicit default for external GPUs) 
**`agdpmod=pikera`** | `agdpmod`| Replaces `board-id` with `board-ix`. Disables Board-ID checks on AMD Navi (RX 5000/6000 series) to fix black screen issues due to the difference in framework with the x6000 drivers. Although not necessary for Polaris or Vega Cards, it can be used to resolve black screen issues in multi-monitor setups.
**`agdpmod=vit9696`** | `agdpmod` | Disables check for `board-id`. Useful if screen turns black after booting macOS.

#### Switching GPUs

boot-arg | DeviceProperty | Description 
---------|----------------|------------
**`-wegnoegpu`** | `disable-gpu` | Disables all external GPUs but the integrated graphics on Intel CPUS. Use if GPU is incompatible with macOS. Doesn't work all the time. Using an SSDT to disable it in macOS is the recommended procedure.
**`-wegnoigpu`** | `disable-gpu` | Disables internal GPU
**`-wegswitchgpu`** | `switch-to-external-gpu`| Disables internal GPU when external GPU is detected.

#### Intel HD Graphics

boot-arg | DeviceProperty | Description 
---------|:--------------:|------------
**`-igfxblr`** | `enable-backlight-registers-fix` | Fix backlight registers on Kaby Lake, Coffee Lake and Ice Lake 
**`-igfxbls`** | `enable-backlight-smoother` | Make brightness transitions smoother on Ivy Bridge and newer. [Read the manual](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#customize-the-behavior-of-the-backlight-smoother-to-improve-your-experience)
**`-igfxcdc`** | `enable-cdclk-frequency-fix` |Support all valid Core Display Clock (CDCLK) frequencies on ICL platforms. [Read the manual](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#support-all-possible-core-display-clock-cdclk-frequencies-on-icl-platforms)
**`-igfxdbeo`** | `enable-dbuf-early-optimizer` | Fix Display Data Buffer (DBUF) issues on Ice Lake and newer. [Read the manual](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#fix-the-issue-that-the-builtin-display-remains-garbled-after-the-system-boots-on-icl-platforms)
**`-igfxdump`** | N/A | Dump IGPU framebuffer kext to `/var/log/AppleIntelFramebuffer_X_Y` (requires in DEBUG version of WEG)
**`-igfxdvmt`** | `enable-dvmt-calc-fix`  | Fix the kernel panic caused by an incorrectly calculated amount of DVMT pre-allocated memory on Intel Ice Lake platforms
**`-igfxfbdump`** | N/A | Dump native and patched framebuffer table to ioreg at `IOService:/IOResources/WhateverGreen`
**`-igfxhdmidivs`** | `enable-hdmi-dividers-fix`  | Fix the infinite loop on establishing Intel HDMI connections with a higher pixel clock rate on SKL, KBL and CFL platforms
**`-igfxi2cdbg`** | N/A | Enable verbose output in I2C-over-AUX transactions (only for debugging purposes)
**`-igfxlspcon`** | `enable-lspcon-support`  | Enable the driver support for onboard LSPCON chips.<br> [Read the manual](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#lspcon-driver-support-to-enable-displayport-to-hdmi-20-output-on-igpu)
**`-igfxmlr`** | `enable-dpcd-max-link-rate-fix`  | Apply the maximum link rate fix
**`-igfxmpc`** | `enable-max-pixel-clock-override` and `max-pixel-clock-frequency` | Increase max pixel clock (as an alternative to patching `CoreDisplay.framework`
**`-igfxnohdmi`** | `disable-hdmi-patches` | Disables DP to HDMI conversion patches for digital audio
**`-igfxsklaskbl`** | N/A | Enforce Kaby Lake (KBL) graphics kext being loaded and used on Skylake models (KBL `device-id` and `ig-platform-id` are required. Not required on macOS 13 and above)
**`-igfxtypec`** | N/A | Force DP connectivity for Type-C platforms
**`-igfxvesa`** | N/A | Disables graphics acceleration in favor of software rendering. Useful if iGPU and dGPU are incompatible or if you are using an NVIDIA GeForce Card and the WebDrivers are outdated after updating macOS, so the display won't turn on during boot.
**`igfxagdc=0`** | `disable-agdc`  | Disables AGDC
**`igfxfcms=1`** | `complete-modeset`  | Force complete modeset on Skylake or Apple firmwares
**`igfxfcmsfbs=`** | `complete-modeset-framebuffers`  | Specify indices of connectors for which complete modeset must be enforced. Each index is a byte in a 64-bit word; for example, value `0x010203` specifies connectors 1, 2, 3. If a connector is not in the list, the driver's logic is used to determine whether complete modeset is needed. Pass `-1` to disable. 
**`igfxframe=frame`** | `AAPL,ig-platform-id` or `AAPL,snb-platform-id`  | Inject a dedicated framebuffer identifier into IGPU (for testing purposes ONLY)
**`igfxfw=2`** | `igfxfw` | Forces loading of Apple Graphics Unit Control (GUC) firmware. Requires (true) 300-series or newer chipset, so realistically 9th and 10th gen Intel Core CPUs with iGPU only. It's [bugged](https://github.com/acidanthera/bugtracker/issues/800) and not advisable to use. `igfxfw` takes precedence over `igfxrpsc=1` when both are set. Combine with `wegtree=1`
**`wegtree=1`** | `rebuild-device-tree` | Forces device renaming on Apple FW
**`igfxgl=1`** | `disable-metal` 	| Disable Metal support on Intel
**`igfxmetal=1`**| `enable-metal` | Force enable Metal support on Intel for offline rendering
**`igfxonln=1`** | `force-online` | Forces all displays online. Resolves screen wake issues after quitting sleep in macOS 10.15.4 and newer when using Intel UHD 630.
**`igfxonlnfbs=MASK`** | `force-online-framebuffers` | Specify indices of connectors for which online status is enforced. Format is similar to `igfxfcmsfbs`
**`igfxpavp=1`** | `igfxpavp`  | Force enable PAVP output 
**`igfxrpsc=1`** | `rps-control`  | Enables RPS control patch which improves iGPU performance. RPS control seems preferable over `igfxfw` in Big Sur and newer because of a bug in the Apple GUC firmware. 
**`igfxsnb=0`** | N/A | Disable IntelAccelerator name fix for Sandy Bridge CPUs 

#### AMD Radeon

boot-arg | DeviceProperty | Description 
---------|:--------------:|------------
**`-rad24`** | N/A | Forces 24-bit display mode
**`-radcodec`** | N/A | Forces the spoofed PID to be used in AMDRadeonVADriver 
**`-raddvi`** | N/A | Enables DVI transmitter correction (required for 290X, 370, etc.)
**`-radvesa`** | N/A | Disable ATI/AMD video acceleration completely and forces the GPU into VESA mode. Useful if the card is not supported by macOS and for trouleshooting. Apple's built in version of this flag is `-amd_no_dgpu_accel`
**`radpg=15`** | N/A | Disables several power-gating modes. Required for Cape Verde GPUs: Radeon HD 7730/7750/7770, R7 250/250X  (see [Radeon FAQ](https://github.com/dreamwhite/WhateverGreen/blob/master/Manual/FAQ.Radeon.en.md))
**`shikigva=40`** +</br>**`shiki-id=Mac-7BA5B2D9E42DDD94`**| N/A |Swaps boardID with `iMacPro1,1`. Allows for Polaris, Vega and Navi GPUs to handle all types of rendering, useful for SMBIOS which expect an iGPU. Not supported in macOS 11+ More info: [**Fixing DRM**](https://dortania.github.io/OpenCore-Post-Install/universal/drm.html#testing-hardware-acceleration-and-decoding)
**'unfairgva=x'** (x = number from 1 to 7 )| N/A| Replaces `shikigva` in macOS 11+ to address issues with [**DRM**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.Chart.md). It's a bitmask with 3 bits (1, 2 and 4) which can be combined to enable/select different features as [explained here](https://www.insanelymac.com/forum/topic/351752-amd-gpu-unfairgva-drm-sidecar-featureunlock-and-gb5-compute-help/)

#### NVIDIA

boot-arg | DeviceProperty | Description 
---------|:--------------:|------------
**~~`nvda_drv=1`~~**</br>(≤ macOS 10.11)| N/A |Deprecated. macOS Siera and newer require an NVRAM key instead. </br>**OpenCore**: Add `NVRAM/Add/7C436110-AB2A-4BBB-A880-FE41995C9F82/nvda_drv: 31` (**Type**: Data).</br> **Clover**: enable `NvidiaWeb` in the System Parameters section.
**`-ngfxdbg`** | N/A | Enables NVIDIA driver error logging 
**`ngfxcompat=1`** | `force-compat` 	| Ignore compatibility check in NVDAStartupWeb
**`ngfxgl=1`** | `disable-metal` 	| Disable Metal support on NVIDIA 
**`ngfxsubmit=0`** | `disable-gfx-submit` | Disable interface stuttering fix on 10.13
**`nv_disable=1`**| N/A | Disables NVIDIA GPUs (***don't*** combine this with `nvda_drv=1`)
**`agdpmod=pikera`**|`agdpmod` |Swaps `board-id `for `board-ix`, needed for disabling string comparison which is useful for non-iMac13,2/iMac14,2 SMBIOS.
**`agdpmod=vit9696`**|`agdpmod` |Disables `board-id` check, may be needed for when screen turns black after finishing booting
**`shikigva=1`**| N/A |Needed if you want to use your iGPU's display out along with your dGPU, allows the iGPU to handle hardware decoding even when not using a connector-less framebuffer
**`shikigva=4`**| N/A |Needed to support hardware accelerated video decoding on systems that are newer than Haswell. May needs to be combined with `shikigva=12` to patch the needed processes 
**`shikigva=40`**| N/A |Swaps boardID with iMac14,2. Useful for SMBIOS that don't expect a Nvidia GPU, however WhateverGreen should handle patching by itself.

#### Backlight

boot-arg | DeviceProperty | Description 
---------|:--------------:|------------
**`applbkl=3`** | `applbkl` | Enable PWM backlight control of AMD Radeon RX 5000 series graphic cards [read here.](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.Radeon.en.md) 
**`applbkl=0`** | `applbkl` | Disable AppleBacklight.kext patches for IGPU. <br>In case of custom AppleBacklight profile [read here](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.OldPlugins.en.md)

#### 2nd Boot stage

boot-arg | DeviceProperty | Description 
---------|:--------------:|------------
**`gfxrst=1`** | N/A | Prefer drawing Apple logo at 2nd boot stage instead of framebuffer copying
**`gfxrst=4`** | N/A | Disables framebuffer init interaction during 2nd boot stage

**SOURCES**: [Dortania](https://dortania.github.io/GPU-Buyers-Guide/misc/bootflag.html) and [Whatevergreen](https://github.com/acidanthera/WhateverGreen)

### AppleALC
Boot-args for your favorite audio-enabler kext. All the Lilu boot arguments affect AppleALC as well.

boot-arg | DeviceProperty | Description 
---------|:--------------:|------------
**`alcid=X`**| `layout-id` |To select a layout-id, where `X` stands for the number of the Layout ID, e.g. `alcid=1`. A list with all existing layout-ids sorted by vendor and codec model can be found [here](https://github.com/dreamwhite/ChonkyAppleALC-Build).
**`-alcoff`**| N/A |Disables AppleALC (Bootmode `-x` and `-s` will also disable it)
**`-alcbeta`**| N/A |Enables AppleALC on unsupported systems (usually unreleased or old ones)
**`alcverbs=1`**| N/A |Enables alc-verb support (also alc-verbs device property)

### RestrictEvents
boot-arg | NVRAM Variable| Description 
---------|:--------------:|------------
`-revoff`| –| Disables the kext
`-revdbg`| – | Enables verbose logging (in DEBUG builds)
`-revbeta`| – | Enables the kext on macOS < 10.8 or greater than 13
`-revproc`|–| Enables verbose process logging (in DEBUG builds)
`revpatch=value` |–| Enables patching as comma separated options. Default value is `auto`.
`revpatch=auto` |YES| Enables `memtab,pci,cpuname`, without `memtab` and `pci` patches being applied on a real Mac.
`revpatch=memtab` |YES|Enables memory tab in System Information on `MacBookAir` and `MacBookPro10,x`.
`revpatch=pci`|YES|Prevents PCI configuration warnings in System Settings on `MacPro7,1`
`revpatch=cpuname`|YES| Allows Custom CPU name in System Information
`revpatch=diskread` |YES| Disables "Uninitialized disk" warning in Finder
`revpatch=asset` |YES| Allows Content Caching when `sysctl kern.hv_vmm_present` returns `1` on macOS 11.3 or newer
`revpatch=sbvmm` |YES| Forces VMM SB model, allowing OTA updates for unsupported models on macOS 11.3 or newer
`revpatch=none` |YES| Disables all patching
`revcpu=value` |YES| Enables or disables CPU brand string patching. `1` = non-Intel default, `0` = Intel default
`revcpuname=value` |YES| Custom CPU brand string (max 48 characters, 20 or less recommended, taken from CPUID otherwise)
`revblock=value` |–| To block processes as comma separated options. Default value is `auto`.
`revblock=pci`|YES| Prevents PCI and RAM configuration notifications on `MacPro7,1`
`revblock=gmux` |YES| Blocks `displaypolicyd` on Big Sur+ (for genuine MacBookPro9,1/10,1)
`revblock=media` |YES| Block `mediaanalysisd` on Ventura+ (for Metal 1 GPUs)
`revblock=auto` |YES| Same as `pci`
`revblock=none`|YES| Disables all blocking

**NOTE**: NVRAM variables work the same as the boot arguments, but have lower priority.
They have be added to the config under `NVRAM/Add/D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102` as a String: </br> 
![revpatch](https://user-images.githubusercontent.com/76865553/209659515-14579ada-85b0-4e89-8443-c5047ee5d828.png)

**To be continued…**

## Credits
- Acidanthera for Lilu, VirtalSMC, Whatevergreen, AppleALC and other Kexts
- Miliuco for additional details about `igfxfw` and `rps-control=01` properties
