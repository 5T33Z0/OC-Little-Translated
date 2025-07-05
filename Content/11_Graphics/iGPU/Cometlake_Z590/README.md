# Comet Lake iGPU issues on 500-series mainboards

## About

As you may or may not know, 400- and 500-series mainboards are compatible with both Intel Comet Lake (10th gen Intel Core) and Rocket Lake (11th gen) CPUs. But when combining 10th Gen Intel Core CPUs with the newer 500-series mainboards, this causes issues with the UHD 630 iGPU in macOS.

**NOTE**: Rocket Lake's Intel UHD 750 iGPU is not supported by macOS! So don't combine an 11th gen Intel Core CPU with a 400-series mainboard!

## Issues

### 1. Comet Lake UHD 630 + Z590 mainboard = no picture

The UHD 630 is correctly detected by macOS and can be used for `Intel Quick Sync Video (IQSV)`, but the video outputs don't work.

**Fix**: None yet. Under investigation.

### 2. Hardware Encoder/Decoder does not work with empty framebuffers
When using an empty framebuffer, such as `0300C89B`, VDADecoderChecker will report that "Hardware acceleration is not supported" (so does VideoProc Converter: "H264 unsupported"). 

The `HEVC` decoder on the other hand works fine with an SMBIOS that supports iGPUs, such as `iMac20,1`.

**Fix**: Use an `AAPL,ig-platform-id` with connectors, such as `07009B3E` and reboot. After that hardware acceleration should work.

## Credits and Resources

- FishyFlower for his [explanations](https://github.com/dortania/bugtracker/issues/277)
