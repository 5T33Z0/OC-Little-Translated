# Compiling custom Kexts for reduced filesize

## About
There are a couple of essential kexts which enable non-Apple devices like on-board Audio (AppleALC), Wifi and Bluetooth (OpenIntelWireless), BrcmFirmwareData, etc.) in macOS that contain hundreds of different configurations and firmware varians to cover all sorts of device variants. Therefore, the size of these kexts grows bigger and bigger over time. But with a bit of knowledge you can compile custom variants of these kexts tailor-made for your hardware setup.

Below you will find links to guides to compile slimmed-down versions of kext which are known to be notoriously large in size by default.

**NOTE**: Since I have almost no experience with coding besides following instruction, please don't ask me for support – I simply cannot provide it. Ask the respective author of the guide instead.

## Requirements

- Knowledge of working with Terminal and Source Code
- [**XCode**](https://developer.apple.com/xcode/)
- [**MacKernelSDK**](https://github.com/acidanthera/MacKernelSDK)
- [**IORegistryExplorer**](https://github.com/utopia-team/IORegistryExplorer)
- Source code of the Kext(s) you want to compile
- Additional requirements as mentioned in the respecitive guide(s)

## Slimming `IntelBluetoothFirmware.kext` 
**Kext**: [**IntelBluetoothFirmware**](https://github.com/OpenIntelWireless/IntelBluetoothFirmware)</br>
**For**: pretty self-explanatory…</br>
**Filesize reduction**:  From 7.2 MB to less than 1 MB</br>
**Guide**: https://github.com/dreamwhite/ChonkyIntelBluetoothFirmware-Build

## Slimming `itlwm.kext`
**Kext**: [**itlwm.kext**](https://github.com/OpenIntelWireless/itlwm)</br>
**For**: Intel WiFi (Firmware)</br>
**Filesize reduction**: From approxy. 15 MB to 2 MB </br>
**Guide**: https://github.com/dreamwhite/Chonky-itlwm-Build

## Slimming `AppleALC.kext`
Work in Progress…

## Credits
Dreamwhite for the Guides and terminal wizardry
