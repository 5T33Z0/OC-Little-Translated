# Compiling custom Kexts for reduced filesize

## About
There are a couple of essential kexts which enable non-Apple devices like on-board Audio (AppleALC), Wifi and Bluetooth (OpenIntelWireless, IntelBluetoothFirmware, BrcmFirmwareData, etc.) in macOS. These kexts can contain hundreds of different configurations and firmwares to cover all sorts of device variants. Therefore, the size of them grows bigger and bigger over time. But with a bit of effort, you can compile slimmed-down variants of these kexts tailor-made for your system.

Below you will find links to guides to compile slimmed-down versions of kext which are known to be notoriously large in size by default.

## Requirements
- [**XCode**](https://developer.apple.com/xcode/)
- [**MacKernelSDK**](https://github.com/acidanthera/MacKernelSDK)
- [**IORegistryExplorer**](https://github.com/utopia-team/IORegistryExplorer)
- Source code of the Kext(s) you want to compile
- Additional requirements as mentioned in the respective guide

## Slimming `AppleALC.kext`
**Kext**: [**`AppleALC`**](https://github.com/acidanthera/AppleALC/releases)</br>
**For**: On-board Audio</br>
**Filesize reduction**: From 3.8 MB to approx. 90 KB, if you strip down the the config files so that they only contain data for the one layout you are using!</br>
**Guide**: [**Slimming AppleALC**](https://github.com/5T33Z0/AppleALC-Guides/tree/main/Slimming_AppleALC)

## Slimming Kexts for Intel WiFi/BT Cards
**Kexts**: [**`Itlwm`/`AirportItlwm`**](https://github.com/OpenIntelWireless/itlwm), [**`IntelBluetoothFirmware`**](https://github.com/OpenIntelWireless/IntelBluetoothFirmware)<br>
**Filesize reduction**: approx. 10 times smaller than the original<br>
**Guide**: [**Slimming Intel Wi-Fi and BT kexts**](/Content/J_Compiling_Kexts/Slimming_Intel_WiFI_BT_Kexts.md)

## Slimming Broadcom Bluetooth kexts (`BrcmPatchRAM`)
**Kext**: `BrcmFirmwareData.kext`<br>
**Filesize reduction**: From 2,8 MB to around 70 KB<br>
**Guide**: [**Slimming BrcmPatchRAM**](/Content//J_Compiling_Kexts/Slimming_BrcmPatchRAM.md)


## Slimming Xcode
You can reduce Xcode to about a fifth of its regular size by [deleting unused platforms](/Content//J_Compiling_Kexts/Slimming_Xcode_for_Kexts.md#readme)

## Credits
[**dreamwhite**](https://github.com/dreamwhite) for the original IntelBluetoothFirmware and itlwm slimming guides.
