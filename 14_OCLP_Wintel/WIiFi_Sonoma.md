# How to enable legacy Wifi Cards in macOS Sonoma with OpenCore Legacy Patcher

> **Applicable to**: OCLP 0.6.9 (Sonoma Development Branch)

## Technical Background
During the early stages of macOS Sonoma development, kexts and frameworks responsible for using older WiFi Cards were removed, leaving the WiFI portion of commonly used BT/WiFi cards in a non-working state.

The following WiFi card chipsets are affected:

- **"Modern"** cards:
	- Broadcom `BCM94350` (`BCM94352` works as well), `BCM94360`, `BCM43602`, `BCM94331`, `BCM943224`
- **"Legacy"** cards:
	- Atheros chipsets
	- Broadcom `BCM94322`, `BCM94328`

Thanks to Dortania's OpenCore Legacy Patcher, it's possible to re-enable such cards by injecting the required kexts and applying root patches to WiFi as well.

But since the Patcher for macOS Sonoma is still in development, the feature to Patch WiFi is not available on the current public release (v.068). On top of that, the detection to patch WiFi is based on the compatible device-ids of cards used on real Macs. So on Wintel System, the patcher won't show this option if you are not using a card with a device-id used by Apple. 

Although OCLP allows enabling certain features in the app, the option to patch Wifi cards has not been implemented into the GUI. So we have to enable it manually by enabling it in the Source code and then compile a custom version to apply Wifi root patches.

## Method 1: Force-Enable WiFi-Patching in OpenCore Legacy Patcher

### Config and EFI
Apply the following changes to your config and EFI/OC/Kexts folder:

Config Section | Action
---------------|-------
**Kernel/Add** | Add the following **Kexts** from the [Sonoma Development branch](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/sonoma-development/payloads/Kexts/Wifi) of OCLP and add `MinKernel` settings as shown below: <br> ![Brcm_Sononma2](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/49c099aa-1f83-4112-a324-002e1ca2e6e7)
**Kernel/Block**| Block **IOSkywalkFamily**: <br> ![Brcm_Sonoma1](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/54079541-ee2e-4848-bb80-9ba062363210)
**Misc/Security** | Change `SecureBootModel` to `Disabled`
**NVRAM/Add/...-FE41995C9F82** |<ul><li> Change `csr-active-config` to `03080000` <li> Add `amfi=0x80` to `boot-args` <li> Add `-brcmfxbeta` to `boot-args` <li> Add `-amfipassbeta` to `boot-args` (if WiFi and BT don't work in latest beta of Sonoma after applying root patches). 
**NVRAM/Delete...-FE41995C9F82** | <ul> <li> Add `csr-active-config` <li> Add `boot-args`

- Save your config and reboot
- Verify that all the kext listed above are loaded in macOS Sonoma. Enter `kextstat` in Terminal and check the list. If they are not loaded, add `-brcmfxbeta`boot-arg to your config. Save, reboot and verify again.
- Apply Root patches with OCLP 0.6.9 or newer (you can find the nightly build [here](https://github.com/dortania/OpenCore-Legacy-Patcher/pull/1077#issuecomment-1646934494))
- If the "Networking: Modern Wireless" or "Networking: Legacy Wireless" option is not shown in the list of available patches, you need enable the option in the Source Code and build OpenCore Patcher yourself. Details [here](https://www.insanelymac.com/forum/topic/357087-macos-sonoma-wireless-issues-discussion/?do=findComment&comment=2809431)
- Reboot. After that WiFi should work (if your card is supported).

### Building OCLP from Source

- Download the [Source Code](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/sonoma-development) of the Sonoma Development Branch and unzip it
-  Enter in Terminal:

    ```
    cd ~/Downloads/OpenCore-Legacy-Patcher-sonoma-development
    pip3 install -r requirements.txt
    ```

- Wait until the downloads and installations for the pip3 stuff has finished
- In `/Downloads/OpenCore-Legacy-Patcher-sonoma-development/resources/sys_patch/sys_patch_detect.py`, change the following (open the file with IDLE or TextEdit or Visual Studio Code or Xcode):
	- For **Modern** WiFi Cards: `set self.modern_wifi = True` 
	- For **Legacy** WiFI Cards: `self.legacy_wifi  = True`
	- :warning: Enable either **Modern** or **Legacy**, not both!!! It will break WiFi.
- Next, build the Patcher App (Double-Click on OpenCore-Patcher-GUI.command). The GUI will pop-up automatically.
- Click on "Post-Install Root Patch". You should be greeted by this (Graphics patches vary based on used CPU): <br>![](https://www.insanelymac.com/uploads/monthly_2023_08/403798316_Bildschirmfoto2023-08-02um11_12_24.png.7b944c8bdf5e5a1ed396b7a93fe391a9.png)
- Start Patching. In my case, it's for a BCM94352HMB (Modern): <br>![](https://www.insanelymac.com/uploads/monthly_2023_08/366682814_Bildschirmfoto2023-08-02um11_17_12.png.ad94650eb54ff5401f2320bb89b8c24b.png)
- Once it's done, reboot
- WiFi should now be working again: <br>![](https://www.insanelymac.com/uploads/monthly_2023_08/1841481226_Bildschirmfoto2023-08-02um11_19_25.thumb.png.42f9df96caa57f9bcfeb1a4d596c5735.png)

## Method 2: Spoofing a compatible WiFi Card
This method uses a spoof instead to inject a compatible IOName of WiFi cards used in real Macs. This way, the OpenCore Patcher just detects a supported card and sets the option for applying root patches for "Modern" or "Legacy" WiFi. It should be clear that patching only works if you have a card with a supported chipset. 

### Modern WiFi

For patching "Modern" Broadcom cards, [a spoof has been found](https://www.insanelymac.com/forum/topic/357087-macos-sonoma-wireless-issues-discussion/?do=findComment&comment=2809611). Use either the `SSDT` or `DeviceProperties` approach to spoof a compatible device. Then apply the following changes to your config and EFI/OC/Kexts folder:

Config Section | Action
---------------|-------
**Kernel/Add** | Add the following **Kexts** from the [Sonoma Development branch](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/sonoma-development/payloads/Kexts/Wifi) of OCLP and add `MinKernel` settings as shown below: <br> ![Brcm_Sononma2](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/49c099aa-1f83-4112-a324-002e1ca2e6e7)
**Kernel/Block**| Block **IOSkywalkFamily**: <br> ![Brcm_Sonoma1](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/54079541-ee2e-4848-bb80-9ba062363210)
**Misc/Security** | Change `SecureBootModel` to `Disabled`
**NVRAM/Add/...-FE41995C9F82** |<ul><li> Change `csr-active-config` to `03080000` <li> Add `amfi=0x80` to `boot-args` <li> Add `-brcmfxbeta` to `boot-args` <li> Add `-amfipassbeta` to `boot-args` (if WiFi and BT don't work in latest beta of Sonoma after applying root patches)
**NVRAM/Delete...-FE41995C9F82** | <ul> <li> Add `csr-active-config` <li> Add `boot-args`

- Save your config and reboot
- Verify that all the kext listed above are loaded in macOS Sonoma. Enter `kextstat` in Terminal and check the list. If they are not loaded, add `-brcmfxbeta`boot-arg to your config. Save, reboot and verify again.
- Apply Root patches with OCLP 0.6.9 or newer (you can find the nightly build [here](https://github.com/dortania/OpenCore-Legacy-Patcher/pull/1077#issuecomment-1646934494))
- If the "Networking: Modern Wireless" or "Networking: Legacy Wireless" option is not shown in the list of available patches, you need enable the option in the Source Code and build OpenCore Patcher yourself. Details [here](https://www.insanelymac.com/forum/topic/357087-macos-sonoma-wireless-issues-discussion/?do=findComment&comment=2809431)
- Reboot. After that WiFi should work (if your card is supported).

### Legacy Wifi

For patching legacy cards a spoof hasn't been implemented yet. Probably due to the lack of in-use legacy cards in the Hackintosh scene. But spoofing an **IOName** of legacy Broadcom and Atheros cards used in real Macs could be a possible solution [as outlined in this post](https://www.insanelymac.com/forum/topic/357087-macos-sonoma-wireless-issues-discussion/?do=findComment&comment=2809940).

## Notes
- Keep in mind that incremental system updates will no longer work once you applied root patches. Instead the complete macOS installer will be downloaded (≈ 13 GB).
- This workaround will probably no longer be required once the official OpenCore Patcher for macOS Sonoma is released and the option for root patching WiFi functionality can either be enabled in the GUI or the detection for used cards in Wintel machines works better. After all, OpenCore Legacy Patcher was written for real Macs.

## Credits
- Acidanthera for OpenCore and Kexts
- Dortania for OpenCore Legacy Patcher
- Acquarius13 for figuring out what to edit in the Source Code
- deeveedee for his tests and pointing towards using `brcmfxbeta` boot-arg
