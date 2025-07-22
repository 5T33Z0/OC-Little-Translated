# How to compile slimmed `AirportItlwm`, `itlwm` and `IntelBluetoothFirmware` kexts for Intel Wi-Fi/BT Cards

The size of the Intel Wireless and BluetoothFirmare kexts for Intel Cards can be reduced drastically by about a factor of 10 by deleting all the unnecessary firmwares for other Wi-Fi cards except the one for your WiFi/BT Card.

> [!NOTE]
> 
> The screenshots in this guide show firmware files used by the Intel AC-9560 Wifi/BT card.

## Preparations

### Identifying the used firmwares
#### Wi-Fi Firmware
- Open IORegistryExplorer
- If you are using `AirportItlwm.kext`, search for `Airport`
- Take note of the entry for `IOModel` ("iwm-…"):<br>![Airport](https://github.com/user-attachments/assets/53c10e65-cf57-495a-af53-55862480a9d6)

> [!NOTE]
>
> Identifying the Wi-Fi firmware does not work when using `Itlwm.kext`, so you must use `AirportItlwm.kext`!

### Bluetooth Firmware

- In IORegistryExplorer, locate the entry `IntelBluetoothFirmware`
- Check the entry for `fw_name` 
- Take note of the value:<br>![btfirmware](https://github.com/user-attachments/assets/d2395b61-7a11-4494-97ec-439c26de2962)

> [!TIP]
> 
> If the field `fw_name` is empty, you need to add `DebugEnhancer.kext` to EFI/OC/Kexts and your config.plist and reboot. Next, do the following to find your device's Bluetooth firmware:
>
> - Once you reach the desktop, run Terminal
> - Enter `sudo dmesg | grep ibt`
> - Look for "Found device firmware…" as shown in this example:<br>![grep](https://github.com/user-attachments/assets/acb73cc1-a001-42dc-bb3b-0baf549ab2a4)
> - Take note of the two files, reboot into macOS and continue with the guide

> [!NOTE]
> 
> If the firmware version is not shown even with DebugEnhancer installed, you need to run Linux in Live mode to figure it out:
> 
> - Prepare a bootable USB flash drive with [**Ventoy**](https://www.ventoy.net/en/index.html)
> - Download a Linux distro of your choice (as .iso)
> - Put the .iso on the Ventoy USB Stick
> - Boot from the Ventoy USB stick
> - Select the Linux distro
> - Run Linux in live mode, don't install it
> - Once you reach the desktop, run Terminal
> - Enter `sudo dmesg | grep ibt`
> - This will show you the used BT Firmware files ("ibt…"):<br>![linux](https://github.com/user-attachments/assets/d8fc5324-e1f1-438c-8902-b4c0c8d09ef0)
> - Take note of the two files, reboot into macOS and continue with the guide

I also found a list of some of the Intel Wi-Fi/BT Cards and the Firmware files associated with them:

| Card                              | Firmware File(s)                                                                 |
|-----------------------------------|---------------------------------------------------------------------------------|
| Intel Wireless 8260 (Bluetooth)   | intel/ibt-11-5.ddc, intel/ibt-11-5.sfi                                           |
| Intel Wireless 8265 (Bluetooth)   | intel/ibt-12-16.ddc, intel/ibt-12-16.sfi                                        |
| Intel Wireless 9460/9650 (var 0 rev 1) (Bluetooth) | intel/ibt-17-0-1.ddc, intel/ibt-17-0-1.sfi                     |
| Intel Wireless 9460/9650 (var 16 rev 1) (Bluetooth) | intel/ibt-17-16-1.ddc, intel/ibt-17-16-1.sfi                 |
| Intel Wireless 3160 (B6) (Bluetooth) | intel/ibt-hw-37.7.10-fw-1.0.1.2d.d.bseq                             |
| Intel Wireless 3160 (B4) (Bluetooth) | intel/ibt-hw-37.7.10-fw-1.0.2.3.d.bseq                             |
| Intel Wireless 7260 (B5) (Bluetooth) | intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq                           |
| Intel Wireless 7260 (B3) (Bluetooth) | intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq                           |
| Intel Wireless 7260 (Bluetooth)   | intel/ibt-hw-37.7.bseq                                                         |
| Intel Wireless 7265 (C0) (Bluetooth) | intel/ibt-hw-37.8.10-fw-1.10.2.27.d.bseq                           |
| Intel Wireless 7265 (D0) (Bluetooth) | intel/ibt-hw-37.8.10-fw-1.10.3.11.e.bseq                           |
| Intel Wireless 7265 (D1) (Bluetooth) | intel/ibt-hw-37.8.10-fw-22.50.19.14.f.bseq                         |
| Intel Wireless 7265 (Bluetooth)   | intel/ibt-hw-37.8.bseq                                                         |
| Intel Wireless 100                | iwlwifi-100-5.ucode                                                            |
| Intel Wireless 105                | iwlwifi-105-6.ucode                                                            |
| Intel Wireless 135                | iwlwifi-135-6.ucode                                                            |
| Intel Wireless 1000               | iwlwifi-1000-5.ucode                                                           |
| Intel Wireless 2200               | iwlwifi-2000-6.ucode                                                           |
| Intel Wireless 2230               | iwlwifi-2030-6.ucode                                                           |
| Intel Wireless 3160               | iwlwifi-3160-9.ucode, iwlwifi-3160-17.ucode                                    |
| Intel Wireless 3168               | iwlwifi-3168-22.ucode, iwlwifi-3168-29.ucode                                   |
| Intel Wireless 3945               | iwlwifi-3945-2.ucode                                                           |

**Source**: https://packages.debian.org/bullseye/firmware-iwlwifi

### Install Xcode
- Download the correct version of [**Xcode**](https://xcodereleases.com/?scope=release)
- Move the Xcode app to the "Programs" folder – otherwise compiling might fail.

### Prepare the `itlwm` source code
- Download [**itlwm**](https://github.com/OpenIntelWireless/itlwm) source code (click on "Code" and select "Download zip")
- Unzip the file – "itlwm-master" folder will be created
- Run Terminal
- Enter:
  ```bash
  cd ~/Downloads/itlwm-master
  ```
- Next, download MacKernelSDK into the "itlwm-master" folder. Enter:
  ```bash
  git clone https://github.com/acidanthera/MacKernelSDK
  ```
- Leave the Terminal window open for later use
- Download the DEBUG version of [**Lilu**](https://github.com/acidanthera/Lilu/releases), extract it and place the kext in the itlwm-master folder
- In Finder, navigate to `~/Downloads/itlwm-master/itlwm/firmware`
- Delete every file except the `iwm-…` file for your Intel Wifi/BT card.

> [!TIP]
>
> Instead of deleting unnecessary firmware files manually, you can also use Terminal to do this. The following command deletes all firmwares _except_ the one specified under `-name 'iwm…'`. So before using it, you have to adjust the name of the firmware to match the one required by your card: `find itlwm/firmware/ -type f ! -name 'iwm-7265-*' -delete`

### Prepare the `IntelBluetoothFirmware` source code
- Download [IntelBluetoothFirmware](https://github.com/OpenIntelWireless/IntelBluetoothFirmware) source code (click on "Code" and select "Download zip")
- Unzip the file – "IntelBluetoothFirmware-master" folder will be created
- Run Terminal
- Enter: `cd ~/Downloads/IntelBluetoothFirmware-master`
- Next, download MacKernelSDK into the "IntelBluetoothFirmware-master" folder. Enter: `git clone https://github.com/acidanthera/MacKernelSDK`
- Leave the Terminal window open for later use
- Download the DEBUG version of [Lilu](https://github.com/acidanthera/Lilu/releases), extract it and place the kext in the IntelBluetoothFirmware-master folder
- In Finder, navigate to `~/Downloads/IntelBluetoothFirmware-master/IntelBluetoothFirmware/fw`
- In the `fw` folder delete all the firmware files except the two: `ibt-….ddc` and `ibt-….sfi` files for your card
- If present, also delete `FwBinary.cpp` from `/IntelBluetoothFirmware-MASTER/IntelBluetoothFirmware`

## Compiling the kexts

### Compiling `AirportItlwm` and `Itlwm`
Enter the following commands (the lines without `#`) in Terminal and execute them one by one to build itlwm as well as AirportItlwm kexts for all versions of macOS:

```
# navigate to the itlwm folder (if it is not your working directory already)
cd ~/Downloads/itlwm-master

# remove generated firmware
rm include/FwBinary.cpp

# generate firmware
xcodebuild -project itlwm.xcodeproj -target fw_gen -configuration Release -sdk macosx

# building the kexts
 xcodebuild -alltargets -configuration Release
```
Once building the kexts is completed they will be located under `~/Downloads/itlwm-master/itlwm/build/Release`:<br>![kexts](https://github.com/user-attachments/assets/719630a7-54db-4c3e-b214-770dd24302a3)

### Compiling `InteBluetothFirmware`

Enter the following commands (the lines without `#`) in Terminal and execute them one by one to build the IntelBluetoothFirmware kext:

```
# Navigate to the IntelBluetoothFirmware folder (if it is not your working directory already)
cd ~/Downloads/IntelBluetoothFirmware-master

# build the kext
xcodebuild -alltargets -configuration Release
```
The compiled kexts will be located under `~/Downloads/IntelBluetoothFirmwar-master/build/Release`:<br>![itlbtfw](https://github.com/user-attachments/assets/c9be468e-11fa-475e-9fb8-c7d7b3a348e2)

## Testing
- Copy the newly compiled kexts to `EFI/OC/Kexts`, replacing the existing ones
- Reboot
- Check if WiFi and Bluetooth are working.

> [!IMPORTANT]
> 
> - `itlwm.kext` requires the [Heliport](https://github.com/OpenIntelWireless/HeliPort) app to connect to Wi-Fi Hotspots
> - If you are having issues with the slimmed kexts, I suggest you use the pre-compiled version from the OpenIntelWireless repo instead

## Credits
- Original Guide by [dreamwhite](https://github.com/dreamwhite)
- Intel WiFi/BT Firmware from Linux: [https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git](https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git) 
