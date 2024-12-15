# Kext Loading Sequence Examples

**TABLE of CONTENTS**

- [About](#about)
- [Processing order of Kexts and Kernel patches](#processing-order-of-kexts-and-kernel-patches)
- [Lilu and VirtualSMC first?](#lilu-and-virtualsmc-first)
- [Kernel Support Table](#kernel-support-table)
- [Examples](#examples)
	- [Example 1: Mandatory kexts (Minimal Requirements)](#example-1-mandatory-kexts-minimal-requirements)
	- [Example 2: ApplePS2SmartTouchPad + Plugins (Laptop)](#example-2-appleps2smarttouchpad--plugins-laptop)
	- [Example 3: VoodooPS2 + TrackPad (Laptop)](#example-3-voodoops2--trackpad-laptop)
	- [Example 4: VoodooPS2 + I2C (Laptop)](#example-4-voodoops2--i2c-laptop)
	- [Example 5: VoodooPS2 + VoodooRMI + VoodooSMBus (Laptop)](#example-5-voodoops2--voodoormi--voodoosmbus-laptop)
	- [Example 6: VoodooPS2 + VoodooRMI + VoodooI2C (Laptop)](#example-6-voodoops2--voodoormi--voodooi2c-laptop)
	- [Example 7: Broadcom WiFi and Bluetooth](#example-7-broadcom-wifi-and-bluetooth)
		- [:bulb: Fixing issues with AirportBrcmFixup generating a lot of crash reports](#bulb-fixing-issues-with-airportbrcmfixup-generating-a-lot-of-crash-reports)
	- [Example 8a: Intel WiFi (AirportItlwm) and Bluetooth (IntelBluetoothFIrmware)](#example-8a-intel-wifi-airportitlwm-and-bluetooth-intelbluetoothfirmware)
	- [Example 8b: Using `AirportItlwm.kext` in multiple versions of macOS](#example-8b-using-airportitlwmkext-in-multiple-versions-of-macos)
		- [Instructions](#instructions)
	- [Example 9a: Possible Desktop Kext Sequence](#example-9a-possible-desktop-kext-sequence)
	- [Example 9b: Possible Laptop Kext Sequence](#example-9b-possible-laptop-kext-sequence)
	- [Example 10: Enabling legacy Broadcom WiFi Cards in macOS 14](#example-10-enabling-legacy-broadcom-wifi-cards-in-macos-14)
	- [Example 11: CPUFriend](#example-11-cpufriend)
- [Notes and Credits](#notes-and-credits)

---

## About
This chapter contains a collection of `config.plist` examples to demonstrate the loading order for certain kexts. In contrast to Clover, where you just drop required kexts into the `Clover\kexts\other` folder, OpenCore loads kexts in the _exact_ order as listed in the `Kernel/Add` section of your `config.plist`. And if this order is incorrect, your system either won't boot, will crash during boot or the device you added the kext(s) for might not work! So it's essential to get the order right.

In general, kexts which provide additional functionality for other kexts have to be loaded first. Config 1 contains the loading sequence for the bare minimum kexts required by any Hackintosh to boot:

1. **Lilu.kext**
2. **VirtualSMC.kext** (+ Sensor Plugins) or **FakeSMC.kext** (+ optional Sensor Plugins)
3. **Whatevergreen** 
4. **AppleALC**

The config examples listed below show the loading sequences for **Bluetooth**, **Wifi**, **Keyboards**, **Trackpads**, and other kexts that have to be loaded in the correct order to work properly. Not having them in the correct order may cause Kernel Panics. Same goes for having kexts listed in your config.plist which are not present in the `EFI/OC/Kexts` folder. So it's of utmost importance that the kexts are loaded in the correct order *and* that the content of the `config.plist` reflect the kexts present in the OC folder 1 to 1. The examples listed below provide a solid guideline on how to organize and combine kexts correctly.

> [!NOTE]
>
> For additional information about available and supported kexts, read the [**Kext documentation**](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Kexts.md) on the OpenCore Github.

## Processing order of Kexts and Kernel patches
OpenCore handles the `Kernel` section of the `config.plist` in the following order (since version 0.9.2, Commit 6a65dd1):

- `Block` is processed
- `Add` and `Force` are processed
- `Emulate` and `Quirks` are processed
- `Patch` is processed

> [!NOTE]
> 
> Prior to Commit 6a65dd1, `Add` and `Force` where last in the chain which made it impossible to patch force-injected kexts.

## Lilu and VirtualSMC first?
Although it is recommended to load **Lilu** and **VirtualSMC** first in order to simplfy kext-related troubleshooting, ***this is not a requirement per se***! **Lilu** and **VirtualSMC** only need to load *prior to any kexts that rely on them*. `ProperTree` cross-references `CFBundleIdentifiers` against `OSBundleLibraries` to ensure the correct loading order of kexts when creating a config snapshot. For reviewers of configs who try to assist other users in fixing config issues, this complicates troubleshooting.

> [!TIP]
> 
> When in doubt, either create a (new) snapshot in ProperTree or place **Lilu** and **VirtualSMC** at the top in the config to eliminate kext dependency issues altogether! In my experience, placing Lilu and VirtualSMC first also improves boot times.

## Kernel Support Table
Listed below, you find the Kernel version ranges for macOS (10.4 to 14). Applying `MinKernel` and `MaxKernel` settings for kexts is very useful to maximize the compatibility of your `config.plist` with various versions of macOS without having to create multiple configs with different sets of kexts. This way, you can control which kexts are enabled for which version of macOS by specifying the kernel range. It's basically the same feature Clover provides, just a lot smarter: instead of using sub-folders labeled by the macOS Version (10.15, 11, 12, etc.), you specify the lower and upper kernel limit. This way you don't have to create duplicates of kexts (which you maybe forget to update later).

This is especially useful for:

- Bluetooth and WiFi kexts where certain macOS versions require different sets of kexts
- Kexts which are only required by certain versions of macOS, like CryptexFixup (Ventura only) or NoTouchID.kext (High Sierra to Mojave only)

This way, you can leave all kexts enabled but control which ones will be loaded by setting the Kernel range. Check "Example 7" which makes use of this technique extensively.

|OS X/macOS Version (Name) | MinKernel | MaxKernel| Architecture
|-------------------------:|:---------:|:--------:|:-----------:
OS X 10.4 (Tiger)          | 8.0.0     | 8.99.99  |PowerPC (PPC)<br>Intel (32/64-bit)
OS X 10.5 (Leopard)        | 9.0.0     | 9.99.99  | "
||
OS X 10.6 (Snow Leopard)   | 10.0.0    | 10.99.99 | Intel (32/64-bit)
OS X 10.7 (Lion)           | 11.0.0    | 11.99.99 | "
OS X 10.8 (Mountain Lion)  | 12.0.0    | 12.99.99 | "
OS X 10.9 (Mavericks)      | 13.0.0    | 13.99.99 | "
OS X 10.10 (Yosemite)      | 14.0.0    | 14.99.99 | "
OS X 10.11 (El Capitan     | 15.0.0    | 15.99.99 | "
macOS 10.12 (Sierra)       | 16.0.0    | 16.99.99 | "
macOS 10.13 (High Sierra)  | 17.0.0    | 17.99.99 | "
macOS 10.14 (Mojave)       | 18.0.0    | 18.99.99 | "
||
macOS 10.15 (Catalina)     | 19.0.0    | 19.99.99 |Intel (64-bit only)
||
macOS 11 (Big Sur)         | 20.0.0    | 20.99.99 |Intel (64-bit)</br>Apple Silicon (ARM)
macOS 12 (Monterey)        | 21.0.0    | 21.99.99 | "
macOS 13 (Ventura)         | 22.0.0    | 22.99.99 | "
macOS 14 (Sonoma)          | 23.0.0    | 23.99.99 | "
macOS 15 (Sequoia)         | 24.0.0    | 24.99.99 | "


> [!TIP]
>
> To find out which Kernel your current macOS install is using, either enter `uname -r` in Terminal or look it up in the System Profiler under "Software". Although `MaxKernel` can go up to `X.99.99`, using `X.9.9` is sufficient in most cases. So far, there hasn't been a single version of macOS which used a Kernel greater than `X.9.9`. 

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
### Example 5: VoodooPS2 + VoodooRMI + VoodooSMBus (Laptop)
For Synaptics TrackPads which are controlled via SMBus, the kext order is:

![Voodoo_RMI_SMBUS](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/5bcb3370-2094-4c91-b813-c9eab5cd2901)

**SOURCE**: [**VoodooSMBus**](https://github.com/VoodooSMBus/VoodooRMI#installation)

### Example 6: VoodooPS2 + VoodooRMI + VoodooI2C (Laptop)
For Synaptics TrackPads which are controlled via I2C, the kext order is:

![Voodoo_RMI_I2C](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/d7010ea1-89f3-4a10-b9ab-acb920bd180b)

**SOURCE**: [**VoodooSMBus**](https://github.com/VoodooSMBus/VoodooRMI#installation)

### Example 7: Broadcom WiFi and Bluetooth 

![brcmwifi+bt](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/e4ba8edf-d8bc-4c7a-b095-d8c4ec05d142)

When using Broadcom WiFi/Bluetooth cards that are not natively supported by macOS, you have to be aware about the following:

1. Kexts have to be loaded in the correct order/sequence (otherwise boot crashes). When in doubt, create an OC Snapshot in ProperTree – it can fix the order if it's incorrect.
2. You have to make use of `MinKernel` and `MaxKernel` settings to control which kexts are loaded for different versions of macOS
3. `AirportBrcomFixup` is for enabling WiFi. It contains 2 additional kexts as Plugins (only one of them should be enabled at any time):
	- `AirPortBrcmNIC_Injector.kext` (compatible with macOS 10.13 and newer)
	- `AirPortBrcm4360_Injector.kext` (compatible with macOS 10.8 to 10.15)
4. For Bluetooth, various kexts and combinations are necessary:
	- `BlueToolFixup.kext`: For macOS 12 and newer. Contains Firmware Data (MinKernel 21.0).
	- `BrcmFirmwareData.kext`: contains necessary firmware. Required for macOS 10.8 to 11.x (MaxKernel 20.9.9)
	- `BrcmPatchRAM.kext`: For 10.10 or earlier
	- `BrcmPatchRAM2.kext`: For macOS 10.11 to 10.14
	- `BrcmPatchRAM3.kext`: For macOS 10.15 to 11.x. Needs to be combined with `BrcmBluetoothInjector.kext` in order to work.
5. With the release of macOS Sonoma Developer Preview (Darwin Kernel 23.0), Apple completely dropped support for Broadcom Cards! In order to re-enable Broadcom WiFi you have to adjust some settings (see [Example 10](#example-10-enabling-legacy-broadcom-wifi-cards-in-macos-14)), add additional kexts and apply root patches with OpenCore Legacy Patcher, [as explained here](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/WIiFi_Sonoma.md).

> [!CAUTION]
> 
> Don't add `BrcmFirmwareRepo.kext` to `EFI/OC/Kexts`! It cannot be injected via Boot Managers. It needs to be *installed* in `/System/Library/Extensions` (/Library/Extensions on 10.11 and later). In this case, `BrcmFirmwareData.kext`is not required. You can use [**Kext-Droplet**](https://github.com/chris1111/Kext-Droplet-macOS) to install kext in the system library directly.

#### :bulb: Fixing issues with AirportBrcmFixup generating a lot of crash reports
I've noticed recently that a lot of crash reports for `com.apple.drive.Airport.Brcm4360.0` and `com.apple.iokit.IO80211Family` are being generated (located under /Library/Logs/CrashReporter/CoreCapture) although my WiFi card is working great in terms of connectivity and speed.

This issue is related to Smart Connect, a feature of WiFi routers which support 2,4 gHz and 5 gHz basebands to make the WiFi card switch between the two automatically depending on the signal quality. Turning off Smart Connect in the router resolves this issue.

### Example 8a: Intel WiFi (AirportItlwm) and Bluetooth (IntelBluetoothFIrmware)
![IntelBT](https://user-images.githubusercontent.com/76865553/196041542-9f6943dc-b500-408e-8d61-f15a6082d5f7.png)

> [!NOTE]
> 
> - For Intel WiFi, there are actually 2 kexts available that can be used: `Itlwm.kext` and `AirportItlwm.kext`. Both have different Pros and Cons, so which one to use depends on personal preference ([**find out more**](https://openintelwireless.github.io/itlwm/FAQ.html))
> - For using Intel Bluetooth in macOS Monterey and newer, [**read this**](https://openintelwireless.github.io/IntelBluetoothFirmware/FAQ.html#what-additional-steps-should-i-do-to-make-bluetooth-work-on-macos-monterey-and-newer).

### Example 8b: Using `AirportItlwm.kext` in multiple versions of macOS

As you may know, 2 kexts for enabling Wi-Fi support for Intel cards exist: itlwm and AirportItlwm. unlike the Itlwm, AirportItlwm requires a different variant of the kext per macOS version (macOS High Sierra up to Sonoma are currently supported).

If you have multiple versions of macOS installed and want to use AirportItlwm in all of them, you have to be able to have different builds of the kext present in your EFI folder so Wi-Fi works on all of your macOS versions.

#### Instructions       

1. Go to [https://github.com/OpenIntelWireless/itlwm/releases](https://github.com/OpenIntelWireless/itlwm/releases)
2. Click on “Assets”
3. Download the builds of the AirportItlwm of your choice
4. Extract and rename them: I usually add an underscore followed by the name of the OS, e.g. `AirportItlwm_Sonoma.kext` (don’t add empty spaces!)
5. Add them to `EFI/OC/Kexts` and your `config.plist`
6. Disable `itlwm.kext` (if present)
7. Next, add `MinKernel` and `MaxKernel` settings to limit the kext to only load the kext for the macOS version it’s designed for:<br>![Airportitlwm](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/f47386b8-34f9-42fc-bdb3-8f29b7b95777)
8. Save your config


> [!IMPORTANT]
> 
> - Adding the correct `MinKernel` and `MaxKernel` settings is *really* important. Otherwise Wi-Fi won’t work and the system might crash when injecting the kext multiple times!
> - When renaming kexts, you can’t automatically fetch kext updates for it with tools like OCAT any longer.
> - When updating macOS Sonoma (14.3 and newer), you _must_ disable `AirportItlwm.kext` in favor of `itlwm.kext` and set `SecureBootModel` to `Disabled` prior to updating. Otherwise the installer will crash ([more info](https://github.com/5T33Z0/OC-Little-Translated/blob/main/W_Workarounds/macOS14.4.md)). Afterwards, you can revert the settings.

### Example 9a: Possible Desktop Kext Sequence
![config9](https://user-images.githubusercontent.com/76865553/140826181-073a2204-aacb-435e-970c-1823cd2786d1.png)

Most Intel Desktop configs will at least contain `Lilu`, `VirtualSMC` (Plugins are optional), `WhateverGreen` and `AppleALC`. This example excludes USB Port, Ethernet and WiFi/BT kexts!

### Example 9b: Possible Laptop Kext Sequence
![config9b](https://user-images.githubusercontent.com/76865553/140829571-525840b9-f7e5-4abb-8cd9-3aa0e31867a9.png)

This is how a possible sequence of kexts for a Laptop might look. In this example, the Trackpad requires `VoodooPS2Controller`, WiFi and BT are by Intel and the Ethernet card is from Realtek. Depending on your Laptop components, Kexts 10 to 17 could be something else entirely.

> [!NOTE]
> 
> - Dell users can add `SMCDellSensors` for temperature monitoring and fan control.
> - If your laptop has a built-in compatible brightness sensor, you can add `SMCLightSensor` 

### Example 10: Enabling legacy Broadcom WiFi Cards in macOS 14

1. Block **IOSkywalkFamily**: <br> ![Brcm_Sonoma1](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/54079541-ee2e-4848-bb80-9ba062363210)
2. Add the following kexts from OCLP ([**found here**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/master/payloads/Kexts/Wifi) and [**here**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera)) (adjust `MinKernel` accordingly): <br> ![Brcm_Sononma2](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/49c099aa-1f83-4112-a324-002e1ca2e6e7)
3. Save and reboot
4. Verify that all the kext listed above are loaded. Enter `kextstat | grep -v com.apple` in Terminal and check the list. If they are not loaded, add `-brcmfxbeta` boot-arg to your config. Save, reboot and verify again.
5. Apply Root patches with OCLP 0.6.9 or newer (you can find the nightly build [here](https://github.com/dortania/OpenCore-Legacy-Patcher/pull/1077#issuecomment-1646934494))
6. If "Networking: Modern Wirless" or "Networking Legacy Wireless" (use either or depending on your card) is not shown in the list of avaialble patches you need enable the option in the Source Code manually and compile OpenCore Patcher yourself. Instructions can be found [here](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/WIiFi_Sonoma.md) 
5. Reboot. After that WiFi should work (if your card is supported).

**Compatible Cards**: only a couple of wifi cards are support at the moment. Depending on the card you are using you have to enable the correct option for patching Wifi (modern or legacy_wifi):

- **Modern**:
	- Broadcom BCM94350, BCM94360, BCM43602, BCM94331, BCM943224
- **Legacy**: 
	- Atheros Chipsets 
	- Broadcom BCM94322, BCM94328

### Example 11: CPUFriend
You can use **CPUFried.kext** and a Data Injector kext to modify the CPU Frequency Vectors used by macOS. 

By default, the frequency vecors stored in the selected SMBIOS are used to handle CPU Power Management. If your Hackintosh uses the same CPU model as the one used in the corresponding Mac model of the selected SMBIOS, you don't need to use this kext. But if the CPU used in your system doesn't match one of the CPUs defined in the selected SMBIOS of the corresponding Mac model (i.e. if your CPU is better or worse than the one used in the Mac), you should optimize the CPU Power Management so your CPU is working optimally in macOS.

**Example**: You are using the [**iMac19,1**](https://everymac.com/ultimate-mac-lookup/?search_keywords=iMac19,1) SMBIOS but your CPU is an [i7-9700](https://ark.intel.com/content/www/de/de/ark/products/191792/intel-core-i79700-processor-12m-cache-up-to-4-70-ghz.html), which is not defined in this SMBIOS. In this case, you should use CPUFriendFriend to generate a Data Provider kext which provides the correct CPU Frequency Vectors to CPUFirend which in return injects them into the selected SMBIOS. In order for this to work, CPUFriend needs to be loaded prior to CPUFriendDataprovider.

**Here's how**:

1. Download and run [**CPUFriendFriend**](https://github.com/corpnewt/CPUFriendFriend)
2. Follow the On-Screen Instructions
3. Add [**CPUFried.kext**](https://github.com/acidanthera/CPUFriend) and CPUFriendDataprovider kexts to EFI/OC/Kexts and your config.plist
4. Order of the kexts as follows: <br> ![CPUFriend](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/2189b749-cf6e-4027-a36b-95a385e2c521)

> [!NOTE]
> 
> For more info about CPU Power Management, please refer to &rarr; [**Enabling CPU Power Management**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management)

## Notes and Credits
- :warning: The plists included in this section ARE NOT for use with any system. The are only examples for demonstrating the order of the kexts listed in "Kernel/Add" section!
- Ignore the red dots in the screenshots. 
- The kexts listed in Examples 2 to 6 are for PS2 Controllers (Keyboards, Mice, Trackpads). We recommend to use `config-2-PS2-Controller` plist as a starting point.
- Thanks to Acquarius13 for showing how to enable te Wifi Root Patches in OCLP!
