# Kext Loading Sequence Examples

This Chapter contains a collection of `config.plist` examples to demonstrate the loading sequences for certain kexts and family of kexts. 

In contrast to Clover, where just drop required kexts to `Clover\kexts\other` folder, OpenCore loads kexts in the exact order as listed in the `Kernel/Add` section of the `config.plist`. And if this order is incorrect, your system either won't boot or will crash during boot!

In general, kexts which provide additional functionality for other kexts have to be loaded first. Config 1 contains the loading sequence for the most essential kexts that are required by almost every Hackintosh to boot. These are:

1. **Lilu.kext**
2. **VirtualSMC.kext** (+ Sensor Plugins) or **FakeSMC.kext** (+ Sensor Plugins)
3. **Whatevergreen**

The rest of the config examples show the loading sequences for `Bluetooth`, `Wifi`, `Keyboards` and `Trackpad` kexts because these contain additional kexts nested inside them which have to be loaded in the correct order to work correctly. Not having them in the correct order may cause Kernel Panics. 

Same goes for having kexts in the list which aren't present in the `OC/Kexts` folder. So it's of utmost importance that the kexts are loaded in the correct order and that the content of the `config.plist` reflect the kexts present in the OC folder 1:1. The examples listed below provide a solid guideline on how to organize and combine kexts.

For additional information about available kexts, read the [**Kext documentation**](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Kexts.md) on the OpenCore Github.

## Lilu and VirtualSMC first?
Although it is recommended to load **Lilu** and **VirtualSMC** first in order to simplfy kext-related troubleshooting, ***this is not a requirement per se***. **Lilu** and **VirtualSMC** only need to load *prior to any kexts that rely on them*. `ProperTree` cross-references `CFBundleIdentifiers` against `OSBundleLibraries` to ensure the correct load order when creating a config snapshot. For reviewers of configs who try to assist others in fixing config issues this complicates troubleshooting.

:bulb: **Tip**: When in doubt, either create a (new) snapshot in ProperTree or place **Lilu** and **VirtualSMC** first to eliminate kext dependency issues altogether! In my experience, placing Lilu and VirtualSMC first also improves boot times.

## Kernel Support Table
Listed below, you will find the Kernel ranges of macOS 10.4 to macOS 12. Setting `MinKernel` and `MaxKernel` for kext is very useful to set up your `config.plist` to be compatible with various versions of macOS without having to create multiple configs, since you can control which kext are loaded for which macOS by specifying the kernel range. It's basically the same feature Clover provides. But instead of using sub-folders labeled by the macOS Version (10.15, 11, 12, etc.) you specify the lower and upper limit which is a lot smarter because this way you don't create duplicate kexts (which you maybe forget to update later).

This is especially useful for Bluetooth and WiFi kexts where certain macOS versions require different sets of kexts. So you can leave them all enabled but control which kexts will be loaded for the specified Kernel range (aka the chosen macOS version). See "Example 7" which makes use of this feature extensively.

|macOS            | MinKernel | MaxKernel
|----------------:|:---------:|:--------:|
10.4 Tiger        | 8.0.0     | 8.99.99
10.5 Leopard      | 9.0.0     | 9.99.99
10.6 Snow Leopard | 10.0.0    | 10.99.99
10.7 Lion         | 11.0.0    | 11.99.99
10.8 Mountain Lion| 12.0.0    | 12.99.99
10.9 Mavericks    | 13.0.0    | 13.99.99
10.10 Yosemite    | 14.0.0    | 14.99.99
10.11 El Capitan  | 15.0.0    | 15.99.99
10.12 Sierra      | 16.0.0    | 16.99.99
10.13 High Sierra | 17.0.0    | 17.99.99
10.14 Mojave      | 18.0.0    | 18.99.99
10.15 Catalina    | 19.0.0    | 19.99.99
11 Big Sur        | 20.0.0    | 20.99.99
12 Monterey       | 21.0.0    | 21.99.99
13 Ventura        | 22.0.0    | 22.99.99

:bulb: To find out which Kernel your current macOS install is running, either enter `uname -r` in Terminal or look it up in the System Profiler under "Software". Although `MaxKernel` can go up to `X.99.99`, in most cases using `X.9.9` is sufficient. So far, there hasn't been a version of macOS which uses a Kernel that is greater than `X.9.9`. 

## Examples
### Example 1: Mandatory kexts (Minimal Requirements)
![config01](https://user-images.githubusercontent.com/76865553/140840864-e7596685-d2bf-426d-af92-4f23fa01f18a.png)</br>
Any additional kexts must be placed after the mandatory kexts.
### Example 2: ApplePS2SmartTouchPad + Plugins (Laptop)
![Config2](https://user-images.githubusercontent.com/76865553/140813746-3d3ab6aa-949a-4b91-8c9b-c3dcd0fef77d.png)
### Example 3: VoodooPS2 + TrackPad (Laptop)
![config3](https://user-images.githubusercontent.com/76865553/140813775-eb6ff60f-9ec3-4c9b-a768-f5e5a9e6868e.png)
### Example 4: VoodooPS2 + I2C (Laptop)
![config4](https://user-images.githubusercontent.com/76865553/140813798-a403f299-e85d-4fed-90f7-bea045384db5.png)
### Example 5: VoodooPS2 + VoodooRMI (Laptop)
![Config 5](https://user-images.githubusercontent.com/76865553/140813835-d9cd3e9c-ee55-43f1-b33f-2ae292b53b17.png)
### Example 6: VoodooPS2 + VoodooRMI + I2C (Laptop)
![Config6](https://user-images.githubusercontent.com/76865553/140813861-4ffce7a5-d636-4bec-a496-cefe85b2a9a0.png)
### Example 7: Broadcom WiFi and Bluetooth 
![Brcmkexts](https://user-images.githubusercontent.com/76865553/161415791-dbe0356d-a5d5-4bb5-9cad-98efbbaf782a.png)

When using Broadcom WiFi/Bluetooth cards that are not natively supported by macOS, you have to be aware about the following:

- Kexts have to be loaded in the correct order/sequence (otherwise boot crashes)
- You have to make use of `MinKernel` and `MaxKernel` sections to control which kexts are loaded for different versions of macOS 
- `AirportBrcomFixup`:
	- Is for enabling WiFi
	- Contains 2 additional kexts as Plugins (only one of them should be enabled at any time):
		- `AirPortBrcmNIC_Injector.kext` (compatible with macOS 10.13 and newer)
		- `AirPortBrcm4360_Injector.kext` (compatible with macOS 10.8 to 10.15)
- For Bluetooth, various kexts and combinations are necessary:
	- `BlueToolFixup.kext`: For macOS 12 and newer. Contains Firmware Data (MinKernel 21.0 and newer only).
	- `BrcmFirmwareData.kext`: contains necessary firmware. Required for macOS 10.8 to 11.x (MaxKernel 20.9.9)
	- `BrcmPatchRAM.kext`: For 10.10 or earlier.
	- `BrcmPatchRAM2.kext`: For macOS 10.11 to 10.14
	- `BrcmPatchRAM3.kext`: For macOS 10.15 to 11.6.x. Needs to be combined with `BrcmBluetoothInjector.kext` in order to work.

:warning: **CAUTION**: Don't add `BrcmFirmwareRepo.kext` to `EFI/OC/Kexts`! It cannot be injected via Boot Managers and needs to be installed to `/System/Library/Extensions` (/Library/Extensions on 10.11 and later) instead. In this case, `BrcmFirmwareData.kext`is not required.

### Example 8: Intel WiFi and Bluetooth 
![IntelBT](https://user-images.githubusercontent.com/76865553/196041542-9f6943dc-b500-408e-8d61-f15a6082d5f7.png)

For macOS Monterey and newer, [**read this**](https://openintelwireless.github.io/IntelBluetoothFirmware/FAQ.html#what-additional-steps-should-i-do-to-make-bluetooth-work-on-macos-monterey-and-newer).

### Example 9a: Possible Desktop Kext Sequence
![config9](https://user-images.githubusercontent.com/76865553/140826181-073a2204-aacb-435e-970c-1823cd2786d1.png)

Most Intel Desktop configs will at least contain `Lilu`, `VirtualSMC` (Plugins are optional), `WhateverGreen` and `AppleALC`. This example excludes USB Port, Ethernet and WiFi/BT kexts!

### Example 9b: Possible Laptop Kext Sequence
![config9b](https://user-images.githubusercontent.com/76865553/140829571-525840b9-f7e5-4abb-8cd9-3aa0e31867a9.png)
This is how a possible sequence of kexts for a Laptop might look like. In this example, the Trackpad requires `VoodooPS2Controller`, WiFi and BT are by Intel and the Ethernet card is from Realtek. Depending on your Laptop components, Kexts 10 to 17 could be something else entirely.

## Notes
- :warning: The configs included in this section ARE NOT configured for use with any system. It's only about the order of the kexts listed in "Kernel > Add" section!
- Ignore the red dots in the screenshots. 
- The kexts listed in Config 2 to 6 are for PS2 Controllers (Keyboards, Mice, Trackpads). We recommend to use `config-2-PS2-Controller`list as a starting point.
