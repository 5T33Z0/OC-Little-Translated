## Framebuffer Flags

:warning: :construction: WORK IN PROGRESS… 

Listed below, you find available/known Framebuffer flags and their corresponding Hex values. These values can be used to calculate a bitmask for the property `framebuffer-conx-flags` (x=number of controller **con0**, **con1**, **con2**, etc.). But the value has to be converted to Little Endian first. See &rarr; [OC Calculators](https://github.com/5T33Z0/OC-Little-Translated/tree/main/B_OC_Calculators) section for details. Hackintool provides this feature as well but doesn't really show how it works.

`#`|Name                        | Description | Hex Value
:-:|----------------------------|-------------|:----------:
01 |**`FBAvoidFastLinkTraining`** | Sets the logic of `minStolenMem` calculation, when set StolenMemorySize is not multiplied by FBMemoryCount, assuming StolenMemorySize counts all framebuffers at once. | 0x1
02 |**`FBFramebufferCommonMemory`**  | This is equivalent to setting FBC=1 in the plist FeatureControl section. | 0x2
03 |**`FBFramebufferCompression`** |Equivalent to setting `SliceSDEnable=1`, `EUSDEnable=1`, `DynamicSliceSwitch=1` in the plist FeatureControl section. | 0x4
04 |**`FBEnableSliceFeatures`** | Equivalent to setting `DynamicFBCEnable=1` in the plist FeatureControl section |0x8
05 |**`FBDynamicFBCEnable`** |Sets `fUseVideoTurbo=1` and loads GPU turbo frequency from the specific field. Defaults to 14, can be overridden by `VideoTurboFreq` in the plist FeatureControl section.|0x10
06 |**`FBUseVideoTurbo`**       |Todo… |0x20
07 |**`FBForcePowerAlwaysConnected`** | |0x40
08 |**`FBDisableHighBitrateMode2`**   | |0x80
09 |**`FBBoostPixelFrequencyLimit`**  | |0x100
10 |**`FBLimit4KSourceSize`**         | |0x200
11 |**`FBAlternatePWMIncrement1`**    | |0x400
12 |**`FBAlternatePWMIncrement2`**    | |0x800
13 |**`FBDisableFeatureIPS`**         | |0x1000
14 |**`FBUnknownFlag_2000`**          | |0x2000
15 |**`FBAllowConnectorRecover`**     | |0x4000
16 |**`FBUnknowFlag_8000`**           | |0x8000
17 |**`FBUnknowFlag_10000`**          | |0x10000
18 |**`FBUnknownFlag_20000`**         | |0x20000
19 |**`FBDisableGFMPPFM`**            | |0x40000
20 |**`FBUnknownFlag_80000`**         | |0x80000
21 |**`FBUnknownFlag_100000`**        | |0x100000
22 |**`FBEnableDynamicCDCLK`**        | |0x200000
23 |**`FBUnknownFlag_400000`**        | |0x400000
24 |**`FBSupport5KSourceSize`**       | |0x800000

**SOURCE**: [**IntelFramebuffer.bt**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/IntelFramebuffer.bt)
