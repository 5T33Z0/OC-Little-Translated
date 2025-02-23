# macOS Sequoia Notes
This section covers the current status of OCLP for macOS Sequoia.

## (Officially) Supported Mac Models

![macos15_b](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/7e741e5b-64fc-4456-ac02-37b258d68216)

### Intel CPU requirements:

-  Kabey Lake-R or newer

## Features unavailable on Intel Systems

- Basically everything "AI", incuding:
	- Apple Intelligence
	- Siri 2.0
 	- Live Audio Transcription in Notes
- Logic Pro 11: Stem Splitter, Mastering Assistant, etc.

## New issues
- ⚠️ Don't install macOS 14.4 beta yet, if your system requires iGPU (Ivy Bridge, Haswell) and/or GPU patches (Kepler). Boot stalls during 2nd phase. Wait for OCLP Update!

- **Dual Socket CPUs**
	- Systems with 1st Gen Xeon CPUs (Harpertown) are limited to using 4 cores in total, otherwise macOS panics. So macOS Sequoia is pretty much useless on Dual Socket Systems with more cores. This also means that the config has to be adjusted as well in order to boot these systems. 
 	- When building OpenCore for older OSes, this limitation can be disabled in Settings > Build > "MacPro3,1/Xserve2,1 Workaround".
- **Graphics support**
	- [Legacy-Metal](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/1008)
	- [Non-Metal](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/108)
