# How to re-enable previously supported Wi-Fi Cards in macOS Sonoma with OpenCore Legacy Patcher

> **Applicable to**: OCLP 0.6.9+

## Technical Background
During the early stages of macOS Sonoma development, kexts and frameworks responsible for using older Wi-Fi Cards were removed, leaving the Wi-Fi portion of commonly used BT/Wi-Fi cards in a non-working state.

The following Wi-Fi card chipsets are affected:

- **"Modern"** cards:
	- **Broadcom**:`BCM94350` (incuding `BCM94352`), `BCM94360`, `BCM43602`, `BCM94331`, `BCM943224`
	- **Required Kexts**: IOSkywalkFamily, IO80211FamilyLegacy, AirPortBrcmNIC, AirportBrcmFixup, AirPortBrcmNIC_Injector.
- **"Legacy"** cards:
	- **Atheros**: `AR928X`, `AR93xx`, `AR242x`/`AR542x`, `AR5418`, `AR5416` (never used by Apple)
	- **Broadcom**: `BCM94322`, `BCM94328`
	- **Required Kexts**: corecaptureElCap, IO80211ElCap, AirPortAtheros40 (for Atheros only)

Thanks to Dortania's OpenCore Legacy Patcher, it's possible to re-enable these Wi-Fi cards by patching some system files (as well as injecting additional kexts via OpenCore). If you want to know how OCLP Wi-Fi patching works, [have a look at this post](https://www.insanelymac.com/forum/topic/357087-macos-sonoma-wireless-issues-discussion/?do=findComment&comment=2809940).

Although OCLP allows changing some settings in the app, the option to manually enable Wi-Fi patching has not been implemented (yet). So we have to either force-enable it manually in the Source Code and then run OCLP with modified settings to apply Wi-Fi root patches (Method 1) or spoof a compatible Wi-Fi device (Mehod 2) so OCLP detects a compatible Wi-Fi war it can patch. However, the 2nd method did not work for me. 

## Method 1: Force-Enable Wi-Fi-Patching in OpenCore Legacy Patcher

### 1. Prerequisites
The following prerequisites have to be met in order to get "Modern" and "Legacy" wireless working in macOS Sonoma:

1. **Mandatory**: if your system is unsupported by macOS 12 and newer (everything prior to 7th Gen Intel Kaby Lake), you need to prepare your Config and EFI first by following the [configuration guide](https://github.com/5T33Z0/OC-Little-Translated/tree/main/14_OCLP_Wintel#configuration-guides) for your CPU family.
2. Connect your system via Ethernet to access the internet since Wi-Fi doesn't work at this stage.
3. Disable Gatekeeper via Terminal so macOS won't get in your way:
	```shell
	sudo spctl --master-disable
	```
4. Install [Python](https://www.python.org/). We need it to build and run the modified version of OpenCore Legacy Patcher to force-enable Wi-Fi patching.
5. Install Command Line Tools via Terminal. It's needed to build OCLP as well:
	```shell
	xcode-select --install
	```
6. Since we are working with beta software here, it's strongly adviced to use the latest nightly builds of OpenCore and *all* kexts you are using in order to maximize compatibilty. This can be achieved by [switching OCAT to DEV Mode](https://github.com/5T33Z0/OC-Little-Translated/tree/main/D_Updating_OpenCore#2-pick-an-opencore-variant) before updating OpenCore and Kexts or by downloading the [latest builds from Dortania](https://dortania.github.io/builds/) and updating them manually (tedious).

> [!NOTE]
> If you cannot install Command Line Tools via Terminal, you need to download the installer from Apple's Developer Site instead (which you need an account for). It's located under: [https://developer.apple.com/download/all/](https://developer.apple.com/download/all/).

### 2. Config and EFI adjustments
Apply the following changes to your config (or copy them over from the [plist example](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/plist/Sonoma_WIFI.plist)) and add the listed kexts to`EFI/OC/Kexts` folder:

Config Section | Action
:-------------:|-------
**Kernel/Add** | <ul> <li> For **"Modern"** Wi-Fi cards, add the following **Kexts** from the [OCLP Repo](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Wifi): <ul><li> `IOSkywalkFamily.kext` <li> `IO80211FamilyLegacy.kext` (and its Plugin `AirPortBrcmNIC.kext`) <li> `AirportBrcmFixup` (and its plugin `AirPortBrcmNIC_Injector.kext`) available [here](https://dortania.github.io/builds/?product=AirportBrcmFixup&viewall=true) <li> [`AMFIPass.kext`](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera) (if not present already) <li> Organize the kexts as shown below and add `MinKernel` settings: <br> ![wifi_modern](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/ca04bf6f-71ee-47ed-b7b4-15359b88c17e)</ul> <li> For **"Legacy"** cards, add the following kexts instead (avaialble [here](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Wifi)):<ul> <li> `corecaptureElCap.kext` <li> `IO80211ElCap.kext` and its Plugin `AirPortAtheros40.kext` (Enable for Atheros Cards) <li> [`AMFIPass.kext`](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera) (if not present already) <li> Adjust `MinKernel` Settings as shown below: <br> ![wifi_legacy](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/ab112e90-a528-4354-a5a7-729900ebacf6)
**Kernel/Block**| <ul> <li> Block **IOSkywalkFamily** (**Modern** Wi-Fi only): <br> ![Brcm_Sonoma1](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/54079541-ee2e-4848-bb80-9ba062363210)<li> **NOTE**: If you are using an USB Ethernet dongle utilizing the ECM protocol, you also have to add [`ECM-Override.kext`](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Kexts/Misc/ECM-Override-v1.0.0.zip) to prevent a kernel panic because Apple's DriverKit stack uses IOSkywalk for ECM dongles. 
**Misc/Security** | Change `SecureBootModel` to `Disabled` to rule-out early Kernel Panics caused by security conflicts. You can re-enable it afterwards once everything is working!
**NVRAM/Add/...-FE41995C9F82** |<ul><li> Change `csr-active-config` to `03080000` <li> Optional: add `amfi=0x80` to `boot-args` if root patches can't be applied (disable afterwards) <li> Optional: add `-brcmfxbeta` to `boot-args` if you cannot connect to Wi-Fi after applying root patches. <li> Optional: add `-amfipassbeta` to `boot-args` (if AMFIPass.kext is not loaded in the latest beta of Sonoma). 
**NVRAM/Delete...-FE41995C9F82** | <ul> <li> Add `csr-active-config` <li> Add `boot-args`

- Save your config and reboot
- Enter `kextstat | grep -v com.apple` in Terminal to check if all the required kexts you added are loaded. If not add `-amfipassbeta` (if AMFIPass.kext is not present) and `-brcmfxbeta` (if Wireless is working but you cannot connect to access points) 

### 3. Applying Root Patches to re-enable Wi-Fi Cards 

- Download the [latest release](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) of OpenCore Legacy Patcher
- Run OpenCore Legacy Patcher and click on "Post Install Root Patch". If the option to patch "Networking Modern Wireless" or "Networking Legacy Wireless" is available, apply the root patches:<br> ![OCLP_Wifi](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/e1495929-945a-400e-961d-6263f15c3fde)
- Once patching is done, reboot
- Enjoy working Wi-Fi again!

> [!NOTE]
> If the "Networking: Modern Wireless" or "Networking: Legacy Wireless" option is not available, then OCLP couldn't detect a compatible Wi-Fi card. In this case you need to either force-enable the option in the Source Code, build OCLP Patcher yourself and then apply the root patches (Step 4) or spoof a compatible Wi-Fi device into macOS (Method 2).

### 4. Workaround: Force-enable Wi-Fi Patching in OCLP
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
- Under "# Misc Patch Detection", change the following setting based on the chipset your Wi-Fi Card uses:
	- For **Modern** Wi-Fi Cards: set `self.modern_wifi = True` 
	- For **Legacy** Wi-Fi Cards: set `self.legacy_wifi = True`
	- :warning: Enable either **Modern** or **Legacy**, not both! It will break Wi-Fi.
	- Close the .py file and double-click on `OpenCore-Patcher-GUI.command` to run the Patcher App.
- Click on "Post-Install Root Patch". Depending on your Wi-Fi Card the option "Networking Modern Wireless" or "Networking Legacy Wireless" should now appear in the list of applicable patches.
- Start Patching. 
- Once it's done, reboot
- Enjoy working Wi-Fi again!

<details>
<summary><strong>Modern Wifi patching example</strong> (Click to reveal!)</summary>

- Option "Networking Modern Wireless" is available: <br>![OCLP_Wifi](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/064d1ddb-fd91-4ddf-abb5-a8b00e37f3e2)
- Patching in Progress. In my case, it's for a BCM94352HMB (Modern): <br>![Progress](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/7f0ed6dc-67bf-4f89-99a1-ea72d518fbee)
- WiFi again: <br>![access](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/11e57c0e-fd81-4aea-ae5b-475b7cf013b2)

</details>

## Method 2: Spoofing a compatible WiFi Card
This method uses a spoof instead to inject a compatible `IOName` of Wi-Fi cards used in real Macs. This way, OpenCore Patcher detects a supported card and enables the option for applying root patches for "Modern" or "Legacy" Wi-Fi cards so compiling a modified version of OCLP is not necessary. Unfortunately, this approach didn't work for me. But I cover it here anyway so you can try it for yourself.

### 1. Prerequisites
&rarr; Same as for Method 1

### 2. Config and EFI adjustments
&rarr; Same as for Method 1. But if the option to patch Wifi is not available, we will add an `IOName` spoof instead of modifying OCLP.

### 3. Finding an `IOName` spoof
In order to trigger OCLPs Wi-Fi patching, it needs to detect a compatible device-id. So in this section, we will find a suitable device-id and then inject it into macOS.

1. Download and run Hackintool [Hackintool](https://github.com/benbaker76/Hackintool)
2. Click on the "PCIe" Tab
3. Check the columns Class/Sub-Class to find "Network Controller":<br>![Hackintool01](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/e5f8f4cc-69e8-4b8e-8785-fe15ef5ed04d)
4. Take note of its "IOReg IOName". In this example, it's `pci14e4,43b1`. **Explanation**: Here, `IOName` is a combination of the pci device's Vendor-ID (`pci14e4` for Broadcom) as well as its device-id (`43b1`). In this case, it's from an BCM94352HMB DW1550 card not used in real Macs so OCLP won't detect if as "patchable".
5. The [pci_data.py](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/data/pci_data.py) file contains the device-ids we need:
	- For patching **Broadcom** cards, the relevant IDs are located under "class broadcom_ids": 
		```
  		AirPortBrcmNIC = [ // >> MODERN Wi-Fi
  		0x43BA,  # BCM43602
  		0x43A3,  # BCM4350 // For me, this device-id is the closest match to my Wi-Fi card
  		0x43A0,  # BCM4360
  		]
  		AirPortBrcm4360 = [ // >> LEGACY Wi-Fi
  		0x4331,  # BCM94331
  		0x4353,  # BCM943224
  		]
		``` 
	- For patching **Legacy Atheros** cards, the relevant IDs are located in the "class atheros_ids" section:
		```
  		# AirPortAtheros40 IDs
  		0x0030,  # AR93xx
  		0x002A,  # AR928X
  		0x001C,  # AR242x / AR542x
  		0x0023,  # AR5416 - never used by Apple
  		0x0024,  # AR5418
		```
9. The required device-id to trigger OCLP's Modern Wi-Fi Patching in my case is `0x43A3`. 
10. This results in the following `IOName`: `pci14e4,43A3` (= pci path + new device-id without `0x` prefix)

Next, we will create `DeviceProperties` to inject our newly found `IOName` spoof into macOS

### 4. Adding `DeviceProperties` for spoofing a compatible Wi-Fi Card

1. Run Hackintool again
2. Click on the "PCIe" Tab
3. Click on the "Export" button at the bottom of the Window. This will export the device list in various formats to the desktop
4. Open the `pcidevices.plist` with ProperTree
5. Press CMD+F to bring uo the search function
6. Change "Find" to `String` and search for `Wireless. This should take you right to the correct device entry:<br>![ProperTree01](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/f1600b8c-d5ad-4416-b13b-ad09b6058edb)
7. Select the Dictionary with the device path and copy into memory (CMD+C)
8. Mount your EFI, open your config.plist and paste the entry into the `DeviceProperties/Add` section:<br>![config01](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/24a7825d-bcd8-4d04-a795-59c29fd5b3bb)
9. Next, add a new "Child" to the entry (press CMD+)
10. Call it "IOName", select "String" as type and add the value for your Wi-Fi card:<br>![config02](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/25fe9818-b58a-4b7c-8ec9-293561558d43)
11. Save your config.plist and reboot
12. Run OpenCore Legacy Patcher and click on "Post Install Root Patch". If the spoof worked, the option "Networking Modern Wireless" or "Networking Legacy Wireless" should now appear in the list of patches:<br>![OCLP_Wi-Fi](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/2a053ee5-dba6-4ff6-b087-f10f55f9a616)
13. Apply the Root patches, reboot and enjoy your newly working Wi-Fi in macOS Sonoma!

> [!NOTE]
> If the Patcher does not show you the option to patch Wi-Fi, then the spoof doesn't work. In this case you need to try a different spoof or use Method 1 instead!

### Tipps for Troubleshooting 
- Download and open [IORegistryExplorer](https://github.com/khronokernel/IORegistryClone)
- Search for `ARPT`
- Select the `ARPT` entry and look for the property `IOName` in the right column
- If the listed `IOName` is identical with the one you injected via `DeviceProperties`, then the spoof is working and the problem must be something else
- If it still shows the original `IOName`, the spoof doesn't work

## Notes
- Keep in mind that incremental system updates will no longer work once you applied root patches. Instead the complete macOS installer will be downloaded (≈ 13 GB). [There's a workaround](https://github.com/5T33Z0/OC-Little-Translated/blob/main/S_System_Updates/OTA_Updates.md) that allows incremental updates to work temporarily.
- This workaround will probably no longer be required once the official OpenCore Patcher for macOS Sonoma is released and the option for root patching Wi-Fi functionality can either be enabled in the GUI or the detection for used cards in Wintel machines works better. After all, OpenCore Legacy Patcher was written for real Macs.

## Credits
- Acidanthera for OpenCore and Kexts
- Dortania for OpenCore Legacy Patcher
- Acquarius13 for figuring out what to edit in OCLPs Source Code
- deeveedee for pointing me towards using `brcmfxbeta` boot-arg and the method for spoofing a compatible `IOName`.
