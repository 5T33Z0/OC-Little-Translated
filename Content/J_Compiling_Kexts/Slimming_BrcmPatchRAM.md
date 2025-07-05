# How to compile slimmed kext for Broadcom WiFi/BT Cards (`BrcmPatchRAM`) 

This guides explains how to reduce the filesize of the `BrcmFirmwareData.kext` for Broadcom WiFi/BT Cards. It contains firmwares of various Broadcom WiFi/BT cards. The idea is to delete the unnecessary firmware files and then compile the kext in order to reduce the file size from 2,8 MB to about 70 KB.

> [!NOTE]
> 
> The screenshots in this guide show firmware files used by the card in my Laptop (BCM94352HMB).

## Preparations

### Identifying the used Bluetooth Firmware
- Open System Profiler
- Under "Hardware" click on "USB"
- On the right side, find your WiFi/BT Card and select it
- Take note of the "Product-ID" and "Vendor-ID":<br>![brcm_slim](https://github.com/user-attachments/assets/1249b7cf-94a0-44a3-9cd0-6f705152f003)
- The combined values of Vendor and Product-ID will be the used firmware, here: `0a5c_21e6`

### Install Xcode
- Install the correct version of [**Xcode**](https://xcodereleases.com/?scope=release)
- Move the Xcode app to the "Programs" folder – otherwise compiling might fail.

### Prepare the `BrcmPatchRAM` source code
- Download [**BrcmPatchRAM**](https://github.com/acidanthera/BrcmPatchRAM) source code (click on "Code" and select "Download zip") and unzip it
- Run Terminal
- Enter 
	```bash
	cd ~/Downloads/BrcmPatchRAM-master
	```
- Next, download MacKernelSDK. Enter: 
	```bash
	git clone https://github.com/acidanthera/MacKernelSDK
	```
- Leave the Terminal window open for later use
- Download the DEBUG version of [**Lilu**](https://github.com/acidanthera/Lilu/releases), extract it and place the kext in the BrcmPatchRAM-master folder
- In Finder, navigate to `~/Downloads/BrcmPatchRAM-master/firmwares`
- Find the firmware for your Broadcom WiFi/BT card, you figured out earlier. In my case `0a5c_21e6`. You can use Finder's search for this:<br>![BTFW](https://github.com/user-attachments/assets/544f478e-367e-433f-b153-fc30acd6ca4f)
- Delete all other firmwares and links to subfolders from the firmwares folder until you have something like this:<br>![FW01](https://github.com/user-attachments/assets/e834a603-9433-44c9-a57a-e4f8f0851791)
- Move the `*.zhx` from the sub-folder to the `firmwares` folder
- Next, compile the kext

## Compiling the kexts and testing

To compile the kext, switch back to Terminal and enter: 

```bash
xcodebuild -configuration Release clean build ARCHS=x86_64
```

This will compile the following kexts:

- BlueToolFixup.kext
- BrcmBluetoothInjector.kext
- BrcmBluetoothInjectorLegacy.kext
- **BrcmFirmwareData.kext**
- BrcmFirmwareRepo.kext
- BrcmNonPatchRAM.kext
- BrcmNonPatchRAM2.kext
- BrcmPatchRAM.kext
- BrcmPatchRAM2.kext
- BrcmPatchRAM3.kext

Thwy will be located under: 

```
cd ~/Downloads/BrcmPatchRAM-master/build/Products/Release
```

In general you only need to replace the **BrcmFirmwareData.kext** in your EFI/OC/Kexts folder and reboot. If Bluetooth is available and you can use it, you've done evrything correctly. 

## Credits
- schrup21 for the original [Guide for slimming BrcnPatchRAM](https://www.hackintosh-forum.de/forum/thread/60336-howto-deutlich-schlankere-kexte-openintelwireless-brcmpatchram-applealc-bauen/)
