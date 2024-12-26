# How to re-enable previously supported WiFi/BT cards in macOS Sonoma+ with OpenCore Legacy Patcher

> **Applicable to**: OCLP 1.0.0+

**INDEX**

- [Technical Background](#technical-background)
	- [What about Bluetooth?](#what-about-bluetooth)
	- [What about Intel?](#what-about-intel)
- [Instructions (Broadcom and Atheros)](#instructions-broadcom-and-atheros)
	- [Config and EFI adjustments](#config-and-efi-adjustments)
	- [Verifying added Kexts](#verifying-added-kexts)
	- [Applying Root Patches to re-enable Wi-Fi Cards](#applying-root-patches-to-re-enable-wi-fi-cards)
- [Instructions (Intel)](#instructions-intel)
	- [Wi-Fi](#wi-fi)
	- [Bluetooth](#bluetooth)
	- [Troubleshooting Intel BT](#troubleshooting-intel-bt)
- [Credits](#credits)

---

## Technical Background
During the early stages of macOS Sonoma development, kexts and frameworks required for driving older Wi-Fi/BT Cards were removed from the OS, leaving the Wi-Fi portion of commonly used BT/Wi-Fi cards in a non-working state.

**This affects the following Wi-Fi card chipsets**:

- **"Modern"** cards:
	- **Broadcom**:`BCM94350` (incuding `BCM94352`), `BCM94360`, `BCM43602`, `BCM94331`, `BCM943224`
	- **Required Kexts**: IOSkywalkFamily, IO80211FamilyLegacy, AirPortBrcmNIC, AirportBrcmFixup, AirPortBrcmNIC_Injector.
- **"Legacy"** cards:
	- **Atheros**: `AR928X`, `AR93xx`, `AR242x`/`AR542x`, `AR5418`, `AR5416` (never used by Apple)
	- **Broadcom**: `BCM94322`, `BCM94328`
	- **Required Kexts**: corecaptureElCap, IO80211ElCap, AirPortAtheros40 (for Atheros only)

Thanks to Dortania's OpenCore Legacy Patcher (OCLP), it's possible to re-enable these Wi-Fi cards by patching some system files (as well as injecting additional kexts via OpenCore). If you want to know how Wi-Fi patching with OCLP works, [have a look at this post](https://www.insanelymac.com/forum/topic/357087-macos-sonoma-wireless-issues-discussion/?do=findComment&comment=2809940).

Besides patching Wifi/BT cards officially used in Apple products, OCLP also supports Wi-Fi patching of systems with 3rd party Broadcom chipsets (enabled by `AirportBrcmFixup.kext`) which are often found in Hackintoshes:

- device-id `pci12e4,4357` &rarr; BCM43225
- device-id `pci12e4,43B1` &rarr; BCM4352
- device-id `pci12e4,43B2` &rarr; BCM4352 (2.4 GHz).

### What about Bluetooth?

Generally speaking, if a) your system's USB ports are mapped correctly and b) the latest kexts required for enabling Bluetooth are present in your EFI folder, BT will most likely work already  after installing macOS 14. macOS Sequoia requires additional NVRAM entries in the `config.plist` in order for BT to work.

### What about Intel?

Since Apple never used Intel Wi-Fi/BT cards in their Macs, there are no root patches available nor required. Wi-Fi and Bluetooth are handled kexts provided by the [**OpenIntelWireless**](https://openintelwireless.github.io/General/Installation.html) project (except for `BluetoolFixup.kext` which is part of [**BrcmPatchRAM**](https://github.com/acidanthera/BrcmPatchRAM)). The required kexts and config setting are also listed in the examples for [Kext Loading Sequence](https://github.com/5T33Z0/OC-Little-Translated/tree/main/10_Kexts_Loading_Sequence_Examples#example-8a-intel-wifi-airportitlwm-and-bluetooth-intelbluetoothfirmware). macOS Sequoia requires additional NVRAM entries in the `config.plist` in order for BT to work.

## Instructions (Broadcom and Atheros)

### Config and EFI adjustments
Apply the following changes to your config (or copy them over from the plist examples (&rarr; [Legacy WiFi](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/plist/Sonoma_WIFI_Legacy.plist) &rarr; [Modern WiFi](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/plist/Sonoma_WIFI_Modern.plist)) and add the listed kexts to `EFI/OC/Kexts` folder:

Config Section | Action
:-------------:|-------
**Kernel/Add** | <ul><li> For **"Modern"** Wi-Fi cards, add the following **Kexts** from the [OCLP Repo](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Wifi): <ul><li> `IOSkywalkFamily.kext` <li> `IO80211FamilyLegacy.kext` (and its Plugin `AirPortBrcmNIC.kext`) <li> `AirportBrcmFixup` (and its plugin `AirPortBrcmNIC_Injector.kext`) available [here](https://dortania.github.io/builds/?product=AirportBrcmFixup&viewall=true) <li> [`AMFIPass.kext`](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera) (if not present already) <li> Organize the kexts as shown below and add `MinKernel` settings: <br> ![wifi_modern](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/ca04bf6f-71ee-47ed-b7b4-15359b88c17e)</ul> <li> For **"Legacy"** cards, add the following kexts instead (available [here](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Wifi)):<ul> <li> `corecaptureElCap.kext` <li> `IO80211ElCap.kext` and its Plugin `AirPortAtheros40.kext` (Enable for Atheros Cards) <li> [`AMFIPass.kext`](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera) (if not present already) <li> Adjust `MinKernel` Settings as shown below: <br> ![wifi_legacy](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/ab112e90-a528-4354-a5a7-729900ebacf6)</ul><li> For **Bluetooth** (macOS 12+):<ul><li>Add [`BlueToolFixup.kext`](https://github.com/acidanthera/BrcmPatchRAM) <li> Set `MinKernel` to: `21.0.0`<li> Adjust `MinKernel` and `MaxKernel` settings for previous BT kexts accordingly:<br>![brcmbt](https://github.com/user-attachments/assets/6256e675-90c4-44ce-b6fa-13da89f6fd41)
**Kernel/Block**| <ul> <li> Block **IOSkywalkFamily** (**Modern** Wi-Fi only): <br> ![Brcm_Sonoma1](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/54079541-ee2e-4848-bb80-9ba062363210)<li> **NOTE**: If you are using an USB Ethernet dongle utilizing the ECM protocol, you also have to add [`ECM-Override.kext`](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Kexts/Misc/ECM-Override-v1.0.0.zip) to prevent a kernel panic because Apple's DriverKit stack uses IOSkywalk for ECM dongles. 
**Misc/Security** | Change `SecureBootModel` to `Disabled` to rule-out early Kernel Panics caused by security conflicts. You can re-enable it afterwards once everything is working!
**NVRAM/Add/...-FE41995C9F82** |<ul><li> Change `csr-active-config` to `03080000` <li> Optional: add `amfi=0x80` to `boot-args` if root patches can't be applied (disable afterwards) <li> Optional: add `-brcmfxbeta` to `boot-args` if you cannot connect to Wi-Fi after applying root patches. <li> Optional: add `-amfipassbeta` to `boot-args` (if AMFIPass.kext is not loaded in the latest beta of Sonoma). <li>In macOS Sequoia, also add the following entries: <ul><li> `bluetoothInternalControllerInfo` <br>**Type**: `Data` <br>**Value**: `00000000 00000000 00000000 0000`<li>`bluetoothExternalDongleFailed` <br> **Type**: `Data` <br>**Value**: `00`<li>**Screenshot**: ![](https://www.insanelymac.com/uploads/monthly_2024_12/Bildschirmfoto2024-12-15um14_18_08.png.d2057e458a2be3cefff9afe2ae40688f.png)</ul>
**NVRAM/Delete...-FE41995C9F82** | Add the following parameters: <ul> <li> `csr-active-config` <li> `boot-args` <li> `bluetoothInternalControllerInfo` <li> `bluetoothExternalDongleFailed`

> [!NOTE]
> 
> - Make sure to perform an NVRAM reset after applying these settings and after switching macOS versions (if you have different versions of macOS installed)
> - I have noticed that it can take 5 to 10 seconds or so until BT is available after applying these changes.

### Verifying added Kexts

Prior to applying root patches it's probably a good idea to verify that the kexts we added are loaded.

- Save your config and reboot
- Reset NVRAM
- Boot into macOS Sonoma+
- Next, open Termial and enter `kextstat`
- This will list *all* loaded kexts. Verify that the following kexts are present (use <kbd>CMD</kbd>+<kbd>F</kbd> for searching):
	- **For "Modern" Wi-Fi**: 
		- `IOSkywalkFamily`
		- `IO80211FamilyLegacy`
		- `AirportBrcmFixup`
		- `AirPort.BrcmNIC`
		- `Amfipass`
	- **For "Legacy" Wi-Fi**:
		- `corecaptureElCap`
		- `IO80211ElCap`
		- `AirPortAtheros40`
		- `Amfipass`
- If these kexts are not loaded, you have to check your config and EFI/OC folder again.
- If `Amfipass` is not loaded, add `-amfipassbeta` boot-arg and reboot
- If Wi-Fi is available but you cannot connect to any access points, add `-brcmfxbeta` boot-arg and reboot. 

Once you have verified that the required kext are actually loaded, you can continue with applying root patches with OCLP

### Applying Root Patches to re-enable Wi-Fi Cards 

- Download the [**latest release**](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) of **OpenCore Legacy Patcher** and install it.
- Run OCLP and click on "**Post Install Root Patch**". 
- If the option to patch "Networking: Modern Wireless" or "Networking: Legacy Wireless" is available, click on "**Start Root Patching**" (otherwise check &rarr; Troubleshooting)
- Once patching is done, reboot
- Enjoy working Wi-Fi again!

<details><summary><strong>Example: Modern Wi-Fi patching </strong> (Click to reveal!)</summary>

- Option "Networking Modern Wireless" is available: <br>![OCLP_Wifi](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/064d1ddb-fd91-4ddf-abb5-a8b00e37f3e2)
- Patching in Progress. In my case, it's for a BCM94352HMB (Modern): <br>![Progress](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/7f0ed6dc-67bf-4f89-99a1-ea72d518fbee)
- Wi-Fi is working again: <br>![access](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/11e57c0e-fd81-4aea-ae5b-475b7cf013b2)
</details>

---

## Instructions (Intel)

### Wi-Fi

For enabling Wi-Fi cards from Intel, there are actually 2 kexts available that can be used: `Itlwm.kext` and `AirportItlwm.kext`. While AirportItlwm acts as a Wi-Fi driver, the card will be detected as an Ethernet Controller when using Itlwm. Both kexts have different pros and cons, so which one to use depends on personal preference and the used OS ([**find out more**](https://openintelwireless.github.io/itlwm/FAQ.html)).

Unlike `Itlwm.kext`, `AirportItlwm.kext` requires a different variant of the kext *per macOS version* (macOS High Sierra up to Sonoma are currently supported). In macOS Sequoia, using `itlwm.kext` is mandatory to get WiFi working. When using `Itlwm.kext`, you also need an additional app called [**HeliPort**](https://github.com/OpenIntelWireless/HeliPort/releases) to connect to Wi-Fi Hotspots.

If you have multiple versions of macOS installed and want to use `AirportItlwm.kext` in all of them, you have to a) rename the kexts in order to place them all in the "kexts" folder and b) you also have to adjust their `MinKernel` and `MaxKernel` settings, so only the correct one gets loaded.

Listed below are instruction of how to cobinate itlwm and AirportIlmw kexts. In this case, itlwm is used for macOS Sequoia, while AirportItlwm is used for macOS Big Sur up to Sonoma.

1. Visit [**https://github.com/OpenIntelWireless/itlwm/releases**](https://github.com/OpenIntelWireless/itlwm/releases)
2. Click on “Assets”
3. Download the builds of the `AirportItlwm` of your choice
4. Extract and rename them: I usually add an underscore followed by the name of the OS, e.g. `AirportItlwm_Sonoma.kext` (don’t add blank spaces!)
5. Add them to `EFI/OC/Kexts` and your `config.plist`
6. Disable `itlwm.kext` (if present)
7. Next, add `MinKernel` and `MaxKernel` settings to limit the kext to only load the kext for the macOS version it’s designed for:<br>![intelwlan](https://github.com/user-attachments/assets/bf6ebd02-922b-42cf-9095-b103028ffa0d)
8. Save your config and reboot

> [!IMPORTANT]
> 
> - Use either `AirportItlwm` or `Itlwm` – never both!
> - When using `AirportItlwm`, adding the correct `MinKernel` and `MaxKernel` settings is *madatory*. Otherwise Wi-Fi won’t work and the system might crash when injecting the kext multiple times!
> - When renaming kexts, you can’t automatically fetch kext updates for them with tools like OCAT any longer.
> - When updating macOS Sonoma (14.3 and newer), you _must_ disable `AirportItlwm.kext` in favor of `itlwm.kext` and set `SecureBootModel` to `Disabled` prior to updating. Otherwise the installer will crash ([more info](https://github.com/5T33Z0/OC-Little-Translated/blob/main/W_Workarounds/macOS14.4.md)). Afterwards, you can enable `SecureBootModel` again.

### Bluetooth

If your Intel Wi-FI/BT card is [supported](https://openintelwireless.github.io/itlwm/Compat.html) by the OpenIntelWireless project, the following kexts are required for enabling Bluetooth in macOS 14+ (&rarr; [plist](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/plist/Sonoma_WIFI_Intel.plist)):

Kext | Comment | `MinKernel` | `MaxKernel`
-----|---------|:-----------:|:-----------:
[**`BlueToolFixup.kext`**](https://github.com/acidanthera/BrcmPatchRAM) | BT enabler for macOS 12 and newer | 21.0.0 | 
[**`IntelBluetoothFirmware.kext`**](https://github.com/OpenIntelWireless/IntelBluetoothFirmware) | Intel BT FIrmware |  | 

**Screenshot**:

![intelbt](https://github.com/user-attachments/assets/96062780-6a52-430c-a1ac-4b45515c81a6)

> [!NOTE]
> 
> - Make sure to perform an NVRAM reset after applying these settings and after switching macOS versions (if you have different versions of macOS installed)
> - I have noticed that it can take like 10 seconds or so until BT is available after applying these changes.
> - For using Intel Bluetooth in macOS Monterey and newer, [**read this**](https://openintelwireless.github.io/IntelBluetoothFirmware/FAQ.html#what-additional-steps-should-i-do-to-make-bluetooth-work-on-macos-monterey-and-newer).

### Troubleshooting Intel BT

If BT is not working after adding the two kexts, do the following:

- Open Terminal and enter `NVRAM -p`
- If the output contains `bluetoothExternalDongleFailed=%01`, you need to change it to `%00` in NVRAM.
- So enter: `sudo NVRAM bluetoothExternalDongleFailed=%00`
- Followed by `sudo pkill bluetoothd` to kill and restart the Bluetooth stack
 
## Credits
- Acidanthera for OpenCore and Kexts
- Dortania for OpenCore Legacy Patcher
- Acquarius13 for figuring out what to edit in OCLPs Source Code
- deeveedee for pointing me towards using `brcmfxbeta` boot-arg
- jrycm for tips with getting Intel Cards to work on Sequoia 15.2
