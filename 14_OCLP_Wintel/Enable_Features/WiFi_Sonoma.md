# How to re-enable previously supported WiFi/BT Cards in macOS Sonoma+ with OpenCore Legacy Patcher

> **Applicable to**: OCLP 1.0.0+

## Technical Background
During the early stages of macOS Sonoma development, kexts and frameworks required for driving older Wi-Fi Cards were removed, leaving the Wi-Fi portion of commonly used BT/Wi-Fi cards in a non-working state.

**This affects the following Wi-Fi card chipsets**:

- **"Modern"** cards:
	- **Broadcom**:`BCM94350` (incuding `BCM94352`), `BCM94360`, `BCM43602`, `BCM94331`, `BCM943224`
	- **Required Kexts**: IOSkywalkFamily, IO80211FamilyLegacy, AirPortBrcmNIC, AirportBrcmFixup, AirPortBrcmNIC_Injector.
- **"Legacy"** cards:
	- **Atheros**: `AR928X`, `AR93xx`, `AR242x`/`AR542x`, `AR5418`, `AR5416` (never used by Apple)
	- **Broadcom**: `BCM94322`, `BCM94328`
	- **Required Kexts**: corecaptureElCap, IO80211ElCap, AirPortAtheros40 (for Atheros only)

Thanks to Dortania's OpenCore Legacy Patcher (OCLP), it's possible to re-enable these Wi-Fi cards by patching some system files (as well as injecting additional kexts via OpenCore). If you want to know how Wi-Fi patching with OCLP works, [have a look at this post](https://www.insanelymac.com/forum/topic/357087-macos-sonoma-wireless-issues-discussion/?do=findComment&comment=2809940).

## Instructions

### 1. Config and EFI adjustments
Apply the following changes to your config (or copy them over from the plist examples (&rarr;[Legacy WiFi](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/plist/Sonoma_WIFI_Legacy.plist) &rarr;[Modern WiFI](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/plist/Sonoma_WIFI_Modern.plist)) and add the listed kexts to `EFI/OC/Kexts` folder:

Config Section | Action
:-------------:|-------
**Kernel/Add** | <ul> <li> For **"Modern"** Wi-Fi cards, add the following **Kexts** from the [OCLP Repo](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Wifi): <ul><li> `IOSkywalkFamily.kext` <li> `IO80211FamilyLegacy.kext` (and its Plugin `AirPortBrcmNIC.kext`) <li> `AirportBrcmFixup` (and its plugin `AirPortBrcmNIC_Injector.kext`) available [here](https://dortania.github.io/builds/?product=AirportBrcmFixup&viewall=true) <li> [`AMFIPass.kext`](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera) (if not present already) <li> Organize the kexts as shown below and add `MinKernel` settings: <br> ![wifi_modern](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/ca04bf6f-71ee-47ed-b7b4-15359b88c17e)</ul> <li> For **"Legacy"** cards, add the following kexts instead (available [here](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Wifi)):<ul> <li> `corecaptureElCap.kext` <li> `IO80211ElCap.kext` and its Plugin `AirPortAtheros40.kext` (Enable for Atheros Cards) <li> [`AMFIPass.kext`](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera) (if not present already) <li> Adjust `MinKernel` Settings as shown below: <br> ![wifi_legacy](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/ab112e90-a528-4354-a5a7-729900ebacf6)
**Kernel/Block**| <ul> <li> Block **IOSkywalkFamily** (**Modern** Wi-Fi only): <br> ![Brcm_Sonoma1](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/54079541-ee2e-4848-bb80-9ba062363210)<li> **NOTE**: If you are using an USB Ethernet dongle utilizing the ECM protocol, you also have to add [`ECM-Override.kext`](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Kexts/Misc/ECM-Override-v1.0.0.zip) to prevent a kernel panic because Apple's DriverKit stack uses IOSkywalk for ECM dongles. 
**Misc/Security** | Change `SecureBootModel` to `Disabled` to rule-out early Kernel Panics caused by security conflicts. You can re-enable it afterwards once everything is working!
**NVRAM/Add/...-FE41995C9F82** |<ul><li> Change `csr-active-config` to `03080000` <li> If Bluetoth is still not working after aadding kexts, settings and applying root patches, add the following keys: <ul><li> **`bluetoothInternalControllerInfo`**, Type: `Data`, Value: `00000000 00000000 00000000 0000`<li>**`bluetoothExternalDongleFailed`**, Type: `Data`, Value: `00`</UL><li> Optional: add `amfi=0x80` to `boot-args` if root patches can't be applied (disable afterwards) <li> Optional: add `-brcmfxbeta` to `boot-args` if you cannot connect to Wi-Fi after applying root patches. <li> Optional: add `-amfipassbeta` to `boot-args` (if AMFIPass.kext is not loaded in the latest beta of Sonoma). 
**NVRAM/Delete...-FE41995C9F82** | <ul> <li> Add `csr-active-config` <li> Add `boot-args`

- Save your config and reboot
- Enter `kextstat | grep -v com.apple` in Terminal to check if all the required kexts you added are loaded. If not add `-amfipassbeta` (if AMFIPass.kext is not present) and `-brcmfxbeta` (if Wireless is working but you cannot connect to access points) 

### 2. Applying Root Patches to re-enable Wi-Fi Cards 

- Download the [**latest release**](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) of **OpenCore Legacy Patcher** and run it.
- Click on "**Post Install Root Patch**". 
- If the option to patch "Networking: Modern Wireless" or "Networking: Legacy Wireless" is available, click on "**Start Root Patching**" (otherwise check &rarr; Troubleshooting)
- Once patching is done, reboot
- Enjoy working Wi-Fi again!

<details>
<summary><strong>Example: Modern Wi-Fi patching </strong> (Click to reveal!)</summary>

- Option "Networking Modern Wireless" is available: <br>![OCLP_Wifi](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/064d1ddb-fd91-4ddf-abb5-a8b00e37f3e2)
- Patching in Progress. In my case, it's for a BCM94352HMB (Modern): <br>![Progress](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/7f0ed6dc-67bf-4f89-99a1-ea72d518fbee)
- Wi-Fi is working again: <br>![access](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/11e57c0e-fd81-4aea-ae5b-475b7cf013b2)

</details>

## Troubleshooting: Force-enable Wi-Fi Patching in OCLP
If you have one of the compatible and previously supported Broadcom or Atheros Wi-Fi Cards but it is not detected by OCLP, you need to force-enable Wi-Fi patching in OCLP's Source Code and then build a custom version of the patcher by following the steps below. In my experience this is only an issue in OCLP 0.6.9 and older. Once version 1.0.0 was released it detects the Broadcom card in my system automatically.

- Download the OCLP [Source Code](https://github.com/dortania/OpenCore-Legacy-Patcher) and unzip it
-  Enter in Terminal (line by line):
    ```shell
    cd ~/Downloads/OpenCore-Legacy-Patcher-main
    pip3 install -r requirements.txt
    ```
- Wait until the downloads and installations for the pip3 stuff has finished
- Next, double-click on `Build-Binary.command` &rarr; It will download `payloads.dmg` and `Universal-Bibaries.dmg`. These are required files so patching won't fail.
- Once the download is complete, navigate to `/Downloads/OpenCore-Legacy-Patcher-main/resources/sys_patch/`
- Open `sys_patch_detect.py` with IDLE, TextEdit, Visual Studio Code or Xcode
- Under **"# Misc Patch Detection"**, change the following setting based on the chipset your Wi-Fi Card uses:
	- For **Modern** Wi-Fi Cards: set `self.modern_wifi = True` 
	- For **Legacy** Wi-Fi Cards: set `self.legacy_wifi = True`
	- :warning: Enable either **Modern** or **Legacy**, not both! It will break Wi-Fi.
	- Close the .py file and double-click on `OpenCore-Patcher-GUI.command` to run the Patcher App.
- Click on "Post-Install Root Patch". Depending on your Wi-Fi Card the option "Networking Modern Wireless" or "Networking Legacy Wireless" should now appear in the list of applicable patches.
- Start Patching. 
- Once it's done, reboot
- Enjoy working Wi-Fi again!

## Notes
- Keep in mind that incremental system updates will no longer work once you applied root patches. Instead the complete macOS installer will be downloaded (≈ 13 GB). [There's a workaround](https://github.com/5T33Z0/OC-Little-Translated/blob/main/S_System_Updates/OTA_Updates.md) that allows incremental updates to work temporarily.
- This workaround will probably no longer be required once the official OpenCore Patcher for macOS Sonoma is released and the option for root patching Wi-Fi functionality can either be enabled in the GUI or the detection for used cards in Wintel machines works better. After all, OpenCore Legacy Patcher was written for real Macs.
- For enabling modern Wi-Fi on macOS Sonoma, there's also a semi-automated [patch](https://github.com/AppleOSX/PatchSonomaWiFiOnTheFly) avavailable.

## Credits
- Acidanthera for OpenCore and Kexts
- Dortania for OpenCore Legacy Patcher
- Acquarius13 for figuring out what to edit in OCLPs Source Code
- deeveedee for pointing me towards using `brcmfxbeta` boot-arg and the method for spoofing a compatible `IOName`.
