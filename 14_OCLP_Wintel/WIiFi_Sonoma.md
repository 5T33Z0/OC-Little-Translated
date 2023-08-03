# How to enable legacy Wifi Cards in macOS Sonoma with OpenCore Legacy Patcher

> **Applicable to**: OCLP 0.6.9 (Sonoma Development Branch)

## Technical Background
During the early stages of macOS Sonoma development, kexts and frameworks responsible for using older WiFi Cards were removed, leaving the WiFI portion of commonly used BT/WiFi cards in a non-working state.

The followimg WiFI card chipsets are affected:

- **"Modern"** cards :
	- Broadcom `BCM94350`, `BCM94360`, `BCM43602`, `BCM94331`, `BCM943224`
- **"Legacy"** cards:
	- Atheros chipsets
	- Broadcom `BCM94322`, `BCM94328`

Thanks to Dortania's OpenCore Legacy Patcher, it's possible to re-enable such cards by injecting the required kexts and applying root patches to WiFi as well.

But since the Patcher for macOS Sonoma is still in development, the feature to Patch WiFi is not available on the current public release (v.068). On top of that, the detection to patch WiFi is based on the compatible device-ids of cards used on real Macs. So on Winel System, the patcher won't show this option if you are not using a card with a device-id used by Apple. 

Althugh OCLP allows enabling certain features in the app, the option to patch Wifi cards has not been implemnented into the GUI. So we have to enable it manually by enabling it in the Source code and then compile a custom version to apply Wifi root patches.

## Instructions

### Config and EFI Edits
Apply the following changes to your config and EFI/OC/Kexts folder:

Config Section | Action
---------------|-------
**Kernel/Add** | Add the following **Kexts** from the [Sonoma Development branch](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/sonoma-development/payloads/Kexts/Wifi) of OCLP and add `MinKernel` settings as shown below: <br> ![Brcm_Sononma2](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/49c099aa-1f83-4112-a324-002e1ca2e6e7)
**Kernel/Block**| Block **IOSkywalkFamily**: <br> ![Brcm_Sonoma1](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/54079541-ee2e-4848-bb80-9ba062363210)
**Misc/Security** | Change `SecureBootModel` to `Disabled`
**NVRAM/Add/...-FE41995C9F82** |<ul><li> Change `csr-active-config` to `03080000` <li> Add `amfi=0x80` to boot-args <li> Add `-brcmfxbeta` boot-arg
**NVRAM/Delete...-FE41995C9F82** | <ul> <li> Add `csr-active-config` <li> Add `boot-args`

- Save your config and reboot
- Verify that all the kext listed above are loaded in macOS Sonoma. Enter `kextstat` in Terminal and check the list. If they are not loaded, add `-brcmfxbeta`boot-arg to your config. Save, reboot and verify again.
- Apply Root patches with OCLP 0.6.9 or newer (you can find the nightly build [here](https://github.com/dortania/OpenCore-Legacy-Patcher/pull/1077#issuecomment-1646934494))
- If the "Networking: Modern Wirless" or "Netwworking: Legacy Wireless" option is not shown in the list of avaialble patches, you need enable the option in the Source Code and build OpenCore Patcher yourself. Details [here](https://www.insanelymac.com/forum/topic/357087-macos-sonoma-wireless-issues-discussion/?do=findComment&comment=2809431)
- Reboot. After that WiFi should work (if your card is supported).

**Compatible Cards**: only a couple of wifi cards are support at the moment. Depending on the card you are using you have to enable the correct option for patching Wifi (modern or legacy_wifi):

- **Modern**:
	- Broadcom BCM94350, BCM94360, BCM43602, BCM94331, BCM943224
- **Legacy**:
	- Atheros Chipsets
	- Broadcom BCM94322, BCM94328

## Building OCLP from Source

- Dowlonad the [Source Code](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/sonoma-development) of the Sonoma Development Branch and unzip it
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

## Notes
This workaround will probably no longer be required once the official Patcher for Sonoma is released and the option for root patching WiFi funtionality can either be enabled in the GUI or the detection for used cards in Wintel machines works better. After all this Patcher was written for real Macs after all.

## Credits
- Acidanthera for OpenCore and Kexts
- Dortania for OpenCore Legacy Patcher
- Acquarius13 for figuring out what to edit in the Source Code
- deeveedee for his tests and pointng towards using `brcmfxbeta` boot-arg