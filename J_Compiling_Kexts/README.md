# Compiling custom Kexts for reduced filesize

## About
There are a couple of essential kexts which enable non-Apple devices like on-board Audio (AppleALC), Wifi and Bluetooth (OpenIntelWireless, IntelBluetoothFirmware, BrcmFirmwareData, etc.) in macOS. These kexts can contain hundreds of different configurations and firmwares to cover all sorts of device variants. Therefore, the size of them grows bigger and bigger over time. But with a bit of effort, you can compile slimmed-down variants of these kexts tailor-made for your system.

Below you will find links to guides to compile slimmed-down versions of kext which are known to be notoriously large in size by default.

> [!NOTE]
> 
> Please direct any support requests (apart from slimming AppleALC) to the author of the respective guide.

## Requirements
- [**XCode**](https://developer.apple.com/xcode/)
- [**MacKernelSDK**](https://github.com/acidanthera/MacKernelSDK)
- [**IORegistryExplorer**](https://github.com/utopia-team/IORegistryExplorer)
- Source code of the Kext(s) you want to compile
- Additional requirements as mentioned in the respective guide

## Slimming `AppleALC.kext`
**Kext**: [**AppleALC.kext**](https://github.com/acidanthera/AppleALC/releases)</br>
**For**: On-board Audio</br>
**Filesize reduction**: From 3.8 MB to approx. 600 KB. If you strip down the the config files so that they only contain data for the one layout you are using, you can get it as small as 90 KB!</br>
**Guide**: [**Slimming AppleALC**](https://github.com/5T33Z0/AppleALC-Guides/tree/main/Slimming_AppleALC)

## Slimming Kexts for Intel WiFi/BT Cards
**Kexts**: `Itlwm`, `AirportItlwm`, `IntelBluetoothFirmware`<br>
**Filesize Reduction**: About 10 times smaller filesize<br>
**Guide**: [Slimming Intel Wi-Fi and BT kexts](https://github.com/5T33Z0/OC-Little-Translated/blob/main/J_Compiling_Kexts/Slimming_Intel_WiFI_BT_Kexts.md)

## Slimming Xcode
You can reduce Xcode to about a fifth of its regular size by [deleting unused platforms](https://github.com/5T33Z0/OC-Little-Translated/blob/main/J_Compiling_Kexts/Slimming_Xcode_for_Kexts.md#readme)

## Credits
[**dreamwhite**](https://github.com/dreamwhite) for the IntelBluetoothFirmware and itlwm slimming guides.
