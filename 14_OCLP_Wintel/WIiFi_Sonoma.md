# How to re-enable previously supported Wifi Cards in macOS Sonoma with OpenCore Legacy Patcher

> **Applicable to**: OCLP 0.6.9 (Sonoma Development Branch)

## Technical Background
During the early stages of macOS Sonoma development, kexts and frameworks responsible for using older WiFi Cards were removed, leaving the WiFI portion of commonly used BT/WiFi cards in a non-working state.

The following WiFi card chipsets are affected:

- **"Modern"** cards:
	- Broadcom `BCM94350` (`BCM94352` works as well), `BCM94360`, `BCM43602`, `BCM94331`, `BCM943224`
- **"Legacy"** cards:
	- Atheros `AR928X`, `AR93xx`, `AR242x`/`AR542x`, `AR5418`, `AR5416` (never used by Apple)
	- Broadcom `BCM94322`, `BCM94328`

Thanks to Dortania's OpenCore Legacy Patcher, it's possible to re-enable such cards by injecting the required kexts and applying root patches to WiFi as well. If you want to know how OCLP Wifi patching works, [have a look at this post](https://www.insanelymac.com/forum/topic/357087-macos-sonoma-wireless-issues-discussion/?do=findComment&comment=2809940).

Since the Patcher for macOS Sonoma is still in development, the feature to patch WiFi is not available on the current public release (v.068). On top of that, the detection to patch WiFi is based on detecting  compatible device-ids/IONames of cards used in real Macs. So on Wintel System, the patcher won't show the option to patch WiFI if you are not using a card with a device-id/IOName used by Apple. 

Although OCLP allows enabling certain features in the app, the option to manually enable patching  Wifi has not been implemented into the GUI (yet). So we have to force-enable it manually in the Source Code and then compile a custom version to apply Wifi root patches.

## Method 1: Force-Enable WiFi-Patching in OpenCore Legacy Patcher

### 1. Prerequisites
The following steps are requireded after a clean install of macOS Sonoma (Tested on beta 5)

1. If your system is unsupported by macOS Ventura and newer (everything prior to 7th Gen Intel Kaby Lake), you need to prepare your Config and EFI first by following the [configuration guide](https://github.com/5T33Z0/OC-Little-Translated/tree/main/14_OCLP_Wintel#configuration-guides) for your CPU.
2. Connect your system via Ethernet to access the internet. Should be obvious since WiFi doesn't work at this stage…
3. Disable Gatekeeper via Terminal so macOS won't get in your way:
	```shell
	sudo spctl --master-disable
	```
4. Install [Python](https://www.python.org/). We need it to build and run the modified version of OpenCore Legacy Patcher we are going to use to patch Wifi.
5. Install Command Line Tools via Terminal:
	```shell
	xcode-select --install
	```

**IMPORTANT**: If your beta of Sonoma is too new and you didn't update from an existing installation which had Command Line Tools installed already, you might get an error message when trying to install it via Terminal. In this case you need to download the installer from Apple's Developer Site instead (which you need an account for). It's located under: [https://developer.apple.com/download/all/](https://developer.apple.com/download/all/).

### 2. Config and EFI adjustments
Apply the following changes to your config and `EFI/OC/Kexts` folder:

Config Section | Action
:-------------:|-------
**Kernel/Add** | Add the following **Kexts** from the [Sonoma Development branch](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/sonoma-development/payloads/Kexts/Wifi) of OCLP and add `MinKernel` settings as shown below: <br> ![Brcm_Sononma2](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/49c099aa-1f83-4112-a324-002e1ca2e6e7)<br> The latest available nightly build of **AirportBrcmFixup** is available [here](https://dortania.github.io/builds/?product=AirportBrcmFixup&viewall=true)
**Kernel/Block**| Block **IOSkywalkFamily**: <br> ![Brcm_Sonoma1](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/54079541-ee2e-4848-bb80-9ba062363210)
**Misc/Security** | Change `SecureBootModel` to `Disabled`
**NVRAM/Add/...-FE41995C9F82** |<ul><li> Change `csr-active-config` to `03080000` <li> Add `amfi=0x80` to `boot-args` <li> Optional: add `-brcmfxbeta` to `boot-args` (if you cannot connect to WiFi hotspots after applying root patches) <li> Optional: add `-amfipassbeta` to `boot-args` (if WiFi and BT don't work in the latest beta of Sonoma after applying root patches). 
**NVRAM/Delete...-FE41995C9F82** | <ul> <li> Add `csr-active-config` <li> Add `boot-args`

- Save your config and reboot
- Enter `kextstat | grep -v com.apple` in Terminal to check if all the kexts you added are loaded. If they are not, add `-brcmfxbeta` boot-arg to your config. Save, reboot and verify again.
- Download OCLP 0.6.9 or newer (you can find the nightly build [here](https://github.com/dortania/OpenCore-Legacy-Patcher/pull/1077#issuecomment-1646934494))
- Click on "Post-Install Root Patch". You should be greeted by this (Graphics patches vary based on the used CPU): <br>![](https://www.insanelymac.com/uploads/monthly_2023_08/403798316_Bildschirmfoto2023-08-02um11_12_24.png.7b944c8bdf5e5a1ed396b7a93fe391a9.png)
- Reboot. After that WiFi should work (if your card is supported).

**IMPORTANT**: If the "Networking: Modern Wireless" or "Networking: Legacy Wireless" option is not shown in the list of available patches, you need to force-enable the option in the Source Code and build OpenCore Patcher yourself.

### 3. Building OCLP from Source and applying Root Patches
Do this if OpenCore Legacy Patcher doesn't detect your Wifi Card (it only supports specific cards used in real Macs afterall…)

- Download the [Source Code](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/sonoma-development) of the Sonoma Development Branch and unzip it
-  Enter in Terminal:
    ```shell
    cd ~/Downloads/OpenCore-Legacy-Patcher-sonoma-development
    pip3 install -r requirements.txt
    ```
- Wait until the downloads and installations for the pip3 stuff has finished
- Next, double-click on `Build-Binary.command` &rarr; It will download `payloads.dmg` and `Universal-Bibaries.dmg`. These are files the patcher needs so patching won't fail.
- Once the download is done, navigaze to `/Downloads/OpenCore-Legacy-Patcher-sonoma-development/resources/sys_patch/`
- Open `sys_patch_detect.py` with IDLE, TextEdit, Visual Studio Code or Xcode
- Change the following setting based on the chipset your Wifi Card uses:
	- For **Modern** WiFi Cards: set `self.modern_wifi = True` 
	- For **Legacy** WiFI Cards: set `self.legacy_wifi = True`
	- :warning: Enable either **Modern** or **Legacy**, not both!!! It will break WiFi.
- Once that's done, double-click on `OpenCore-Patcher-GUI.command` to build the Patcher App. The GUI will pop-up automatically once it's done.
- Click on "Post-Install Root Patch". You should be greeted by this message (Available Graphics Patches vary based on used CPU): <br>![](https://www.insanelymac.com/uploads/monthly_2023_08/403798316_Bildschirmfoto2023-08-02um11_12_24.png.7b944c8bdf5e5a1ed396b7a93fe391a9.png)
- Start Patching. In my case, it's for a BCM94352HMB (Modern): <br>![](https://www.insanelymac.com/uploads/monthly_2023_08/366682814_Bildschirmfoto2023-08-02um11_17_12.png.ad94650eb54ff5401f2320bb89b8c24b.png)
- Once it's done, reboot
- Enjoy working WiFi again: <br>![](https://www.insanelymac.com/uploads/monthly_2023_08/1841481226_Bildschirmfoto2023-08-02um11_19_25.thumb.png.42f9df96caa57f9bcfeb1a4d596c5735.png)

## Method 2: Spoofing a compatible WiFi Card
This method uses a device spoof instead to inject a compatible **IOName** of WiFi cards used in real Macs. In theory, OpenCore Patcher then detects a supported Wifi Scard and enables the option for applying root patches for "Modern" or "Legacy" WiFi. It should be clear that patching only works if you have a card with a supported chipset. Since this method didn't work for me I won't cover it here. But if you want to try it for yourself, [take a look here](https://www.insanelymac.com/forum/topic/357087-macos-sonoma-wireless-issues-discussion/).

## Notes
- Keep in mind that incremental system updates will no longer work once you applied root patches. Instead the complete macOS installer will be downloaded (≈ 13 GB). There's a workaround for it I'll cover later.
- This workaround will probably no longer be required once the official OpenCore Patcher for macOS Sonoma is released and the option for root patching WiFi functionality can either be enabled in the GUI or the detection for used cards in Wintel machines works better. After all, OpenCore Legacy Patcher was written for real Macs.

## Credits
- Acidanthera for OpenCore and Kexts
- Dortania for OpenCore Legacy Patcher
- Acquarius13 for figuring out what to edit in the Source Code
- deeveedee for his tests and pointing towards using `brcmfxbeta` boot-arg
