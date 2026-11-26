# Comet Lake iGPU issues on 500-series mainboards

## About

400- and 500-series motherboards support both Intel Comet Lake (10th Gen Core) and Rocket Lake (11th Gen Core) CPUs. However, combining a Comet Lake CPU with a 500-series motherboard introduces two separate UHD 630 iGPU issues in macOS.

> [!IMPORTANT]
>
> Rocket Lake's Intel UHD 750 iGPU is not supported by macOS!

## Issues

### 1. Comet Lake UHD 630 + Z590 motherboard = no display output

The UHD 630 is correctly detected by macOS and can be used for `Intel Quick Sync Video (IQSV)`, but the video outputs don't work.

**Cause:** The display-detection mechanism is incompatible with the 500-series platform. macOS cannot reliably detect connected displays through the motherboard's display interfaces.

**Fix 1: EDID Injection (December 2024)**

The first documented workaround uses EDID injection to bypass the broken display-detection mechanism. By injecting the monitor's actual EDID through `DeviceProperties`, macOS can initialize the display output without relying on the normal EDID-reading process.

**Resource**:
- [Fix Intel iGPU Acceleration + Output on 500 Series Motherboards](https://github.com/p4pper/Fix-Intel-iGPU-500-Series)

**Fix 2: Blind-transmit method (July 2026)**

A newer approach bypasses display detection entirely rather than attempting to repair it. It combines:

- EDID injection using `AAPL00,override-no-connect`.
- `igfxonln=1` to force displays online.
- HDMI connector retyping.
- `-igfxhdmidivs` to avoid HDMI divider-related boot hangs.

The method was demonstrated with accelerated dual-monitor output on an ASUS PRIME H510M-E system running macOS Tahoe 26.5.2.

**Limitations:**

- Display hot-plug detection does not work.
- Monitors must be connected before boot.
- Changing monitors requires capturing and injecting their respective EDIDs again.
- Sleep/wake behavior has not been extensively tested.

The method has been demonstrated on H510. Compatibility with B560 and Z590 is suggested by its author but has not yet been independently verified.

**Resource**:
- [Intel UHD 630 accelerated display output on 500-series boards – Blind-transmit method](https://github.com/ailtonvieira07/UHD630-500series-display-fix)

### 2. Hardware Encoder/Decoder does not work with empty framebuffers

When using an empty framebuffer, such as `0300C89B`, VDADecoderChecker reports:

`Hardware acceleration is not supported`

VideoProc Converter may also report:

`H264 unsupported`

The `HEVC` decoder, on the other hand, may work with an SMBIOS that supports iGPUs, such as `iMac20,1`.

**Fix:** Use an `AAPL,ig-platform-id` with connectors, such as `07009B3E`, instead of an empty framebuffer, and reboot. Hardware video acceleration should then work.

## Credits and Resources

- **FishyFlower** – [**Explanations and discussion**](https://github.com/dortania/bugtracker/issues/277)
- [**EDID injection workaround**](https://github.com/p4pper/Fix-Intel-iGPU-500-Series)
- [**Blind-transmit method**](https://github.com/ailtonvieira07/UHD630-500series-display-fix)
- [**WhateverGreen – Intel Graphics FAQ**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md)
