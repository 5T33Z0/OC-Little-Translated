# Intel Framebuffer and Connector Flags

Listed below, you find available/known Framebuffer and Connector flags and their Hex values for Intel iGPU framebuffers. These are the same flags located in Hackintool's "Patch" section. 

These flags can be combined to calculate a bitmask for the device properties `framebuffer-flags` and `framebuffer-conx-flags` (`x` = number of controller **con0**, **con1**, **con2**, etc.) to modify/adjust an existing Framebuffer patch.

If you select any of these flags in Hackintool and click on "Generate Patch, Hackintool does the calculation and Endianness conversion automatically. When doing this manually, the values have to be summed-up and converted to Little Endian before adding the bitmask to the config.plist (see &rarr; [**OC Calculators**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/B_OC_Calculators)). 

## Framebuffer Flags
> Flags for device property `framebuffer-flags`

Framebuffer flags are used to configure various settings related to the framebuffer, such as display timings, color depth, memory allocation, and other display-related parameters. These flags can affect the initialization and communication between the graphics card and the display during the handshake process. 

Listed below, you find the available/known framebuffer flags for Intel framebuffers in macOS. They might not provide all of the mentioned functions.

`#`|Name                        | Description | Hex Value
:-:|----------------------------|-------------|-----------:
01 |**`FBAvoidFastLinkTraining`** | Disables the use of FastLinkTraining. According to joevt with zero SKL link training happens at 450 MHz else at 540 MHz  | 0x1
02 |**`FBFramebufferCommonMemory`**  | Sets the logic of `minStolenMem` calculation, when set `fStolenMemorySize` is not multiplied `fFBMemoryCount`, assuming `fStolenMemorySize` counts all framebuffers at once. | 0x2
03 |**`FBFramebufferCompression`** |This is equivalent to setting `FBC=1` in the plist `FeatureControl` section. Compression causes `fFramebufferMemorySize` to be added to `minStolenMem`.| 0x4
04 |**`FBEnableSliceFeatures`** | This is equivalent to setting `SliceSDEnable=1`, `EUSDEnable=1`, `DynamicSliceSwitch=1` in the plist `FeatureControl` section. |0x8
05 |**`FBDynamicFBCEnable`** |This is equivalent to setting `DynamicFBCEnable=1` in the plist `FeatureControl` section.|0x10
06 |**`FBUseVideoTurbo`** |This sets `fUseVideoTurbo=1`and loads GPU turbo frequency from the specific field. Defaults to `14`, can be overridden by `VideoTurboFreq` in the plist `FeatureControl` section.| 0x20
07 |**`FBForcePowerAlwaysConnected`** | Enforces display power reset even on always connected displays (&rarr; see connector flag `CNConnectorAlwaysConnected`)|0x40
08 |**`FBDisableHighBitrateMode2`**   | According to joevt this enforces High Bitrate mode 1, which limits DP bitrate to 8.64 Gbit/s instead of normal 17.28 Gbit/s (HBR2). I do not think this is used on Skylake any longer.|0x80
09 |**`FBBoostPixelFrequencyLimit`**  | This appears to boost pixel frequency limit (aka pixel clock) to 540000000 Hz (from the usual 216000000, 320000000, 360000000, 450000000)|0x100
10 |**`FBLimit4KSourceSize`** | Limits source size to 4096x4096 px| 0x200
11 |**`FBAlternatePWMIncrement1`** | This bit and FBAlternatePWMIncrement2 appear to be entirely equivalent and could be used interchangeably. Result in setting: <ul> <li> PCH_LP_PARTITION_LEVEL_DISABLE (1 << 12) bit in SOUTH_DSPCLK_GATE_D (0xc2020) <li>LPT_PWM_GRANULARITY (1 << 5) bit in SOUTH_CHICKEN2 (0xc2004) <li>See Linux driver sources (lpt_init_clock_gating, lpt_enable_backlight). <li>Since these bits are setting backlight pulse width modularity, there is no sense in setting them without a built-in display (i.e. on desktop).|0x400
12 |**`FBAlternatePWMIncrement2`** | &rarr; see FBAlternatePWMIncrement1 |0x800
13 |**`FBDisableFeatureIPS`** | This is equivalent to setting DisableFeatureIPS=1 in the plist FeatureControl section. IPS stands for Intermediate Pixel Storage | 0x1000
14 |**`FBUnknownFlag_2000`** | N/A |0x2000
15 |**`FBAllowConnectorRecover`** | Used by AppleIntelFramebufferController LinkTraining for camellia version 2. Can be overridden by `-notconrecover` boot-arg, which effectively unsets this bit. | 0x4000
16 |**`FBUnknowFlag_8000`** | N/A |0x8000
17 |**`FBUnknowFlag_10000`** | N/A |0x10000
18 |**`FBUnknownFlag_20000`** | N/A |0x20000
19 |**`FBDisableGFMPPFM`** | This takes its effect only if `GFMPPFM` in the plist FeatureControl section is set to `2`, otherwise `GFMPPFM` is off.| 0x40000
20 |**`FBUnknownFlag_80000`** | N/A |0x80000
21 |**`FBUnknownFlag_100000`** | N/A |0x100000
22 |**`FBEnableDynamicCDCLK`** | This takes effect only if `SupportDynamicCDClk` in the plist FeatureControl section is set to `1`, otherwise off. Also requires dc6config to be set to 3 (default).|0x200000
23 |**`FBUnknownFlag_400000`** | N/A |0x400000
24 |**`FBSupport5KSourceSize`** | Setting this bit increases the maximum source size from 4096x4096 px to 5120x5120 px. Most likely this enables 5K support via Intel HD. |0x800000

For reference: in Hackintool, these flags are located here:

![fb_flags](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/b5dfa501-4751-4de8-8781-e2ea9ff31d63)

## Connector Flags
> Flags for device property `framebuffer-conx-flags` (`x` = number of controller **con0**, **con1**, **con2**, etc.).

Connector flags can serve various purposes and provide configuration options for display connectors. Here are some common functions that connector flags can perform:

- Specify display connection types: Connector flags can indicate the type of display connection being used, such as LVDS (Low-Voltage Differential Signaling), HDMI (High-Definition Multimedia Interface), DisplayPort, DVI (Digital Visual Interface), etc. These flags help the system identify and configure the appropriate settings for the specific connection type.
- Enable/disable display features: Certain flags might enable or disable features like audio support, HDCP (High-bandwidth Digital Content Protection), deep color support, or specific display modes.
- Define display characteristics: Connector flags can define various display characteristics, such as resolution, refresh rate, color depth, color space, and other parameters that determine the visual output on the display.
- Configure power and signal requirements: Flags may control power management settings, signal detection thresholds, or other parameters related to power and signal requirements for the display connection.
- Optimize display performance: Some flags can be used to optimize the display performance, such as reducing latency, enabling specific display timing settings, or fine-tuning the communication between the graphics card and the display.

Listed below, you find the available/known connector flags for Intel framebuffers in macOS. They might not provide all of the mentioned functions.

`#`|Name                         | Description | Hex Value
:-:|-----------------------------|-------------|----------:
1 | **`CNAlterAppertureRequirements`** | Lets apperture memory to be not required | 0x1
2 | **`CNUnknownFlag_2`** | N/A | 0x2
3 | **`CNUnknownFlag_4`** | N/A| 0x4
4 | **`CNConnectorAlwaysConnected`** |Normally set for LVDS displays (i.e. built-in displays)|0x8
5 | **`CNUnknownFlag_10`**| N/A |0x10
6 | **`CNUnknownFlag_20`**| N/A |0x20
7 | **`CNDisableBlitTranslationTable`** | Disable blit translation table? | 0x40
8 | **`CNUseMiscIoPowerWell`** | Activates MISC IO power well (SKL_DISP_PW_MISC_IO) |0x80
9 | **`CNUsePowerWell2`** | Activates Power Well 2 usage (SKL_PW_CTL_IDX_PW_2). May help with HDMI audio configuration issues (cf. [Issue #1189](https://github.com/acidanthera/bugtracker/issues/1189))|0x100
10 | **`CNUnknownFlag_200`** |N/A|0x200
11 | **`CNUnknownFlag_400`** |N/A|0x400
12 | **`CNIncreaseLaneCount`** |Sets fAvailableLaneCount to 30 instead of 20 when specified|0x800
13 | **`CNUnknownFlag_1000`** |N/A|0x1000
14 | **`CNUnknownFlag_2000`** |N/A|0x2000
15 | **`CNUnknownFlag_4000`** |N/A|0x4000
16 | **`CNUnknownFlag_8000`** |N/A|0x8000

For reference: in Hackintool, these flags are located here:

![connectors](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/a71fc439-8518-45e0-90bd-8b7cab55bde4)

**SOURCE**: [**IntelFramebuffer.bt**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/IntelFramebuffer.bt)
