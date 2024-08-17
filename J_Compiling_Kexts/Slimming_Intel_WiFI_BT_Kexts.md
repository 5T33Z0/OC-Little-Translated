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

- In IORegistryExplorer, locate the entry `InteBluetoothFirmware`
- Check the entry for `fw_name` 
- Take note of the value:<br>![btfirmware](https://github.com/user-attachments/assets/d2395b61-7a11-4494-97ec-439c26de2962)

> [!NOTE]
> 
> If the field `fw_name` is empty, you need to use Linux to find the firmware:
> - Prepare a bootable USB flash drive with [**Ventoy**](https://www.ventoy.net/en/index.html)
> - Download a Linux distro of your choice (as .iso)
> - Put the .iso on the Ventoy USB Stick
> - Boot from the Ventoy USB stick
> - Select the Linux distro
> - Run Linux in live mode, don't install it
> - Once you reach the desktop, run Terminal
> - Enter `dmesg | grep ibt`
> - This will show you the used BT Firmware files ("ibt…"):<br>![linux](https://github.com/user-attachments/assets/d8fc5324-e1f1-438c-8902-b4c0c8d09ef0)
> - Take note of the two files, reboot into macOS and continue with the guide

### Install Xcode
- Download the correct version of [**Xcode**](https://xcodereleases.com/?scope=release)
- Move the Xcode app to the "Programs" folder – otherwise compiling might fail.

### Prepare the `itlwm` source code
- Download [**itlwm**](https://github.com/OpenIntelWireless/itlwm) source code (click on "Code" and select "Download zip")
- Unzip the file – "itlwm-master" folder will be created
- Run Terminal
- Enter `cd ~/Downloads/itlwm-master`
- Next, download MacKernelSDK into the "itlwm-master" folder. Enter: `git clone https://github.com/acidanthera/MacKernelSDK`
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
# remove generated firmware
rm include/FwBinary.cpp

# generate firmware
xcodebuild -project itlwm.xcodeproj -target fw_gen -configuration Release -sdk macosx

# building the kexts
 xcodebuild -alltargets -configuration Release
```

Once compiling is completed the kexts will be located under `~/Downloads/itlwm-master/itlwm/build/Release`:<br>![kexts](https://github.com/user-attachments/assets/719630a7-54db-4c3e-b214-770dd24302a3)

### Compiling `InteBluetothFirmware`

Enter the following commands (the lines without `#`) in Terminal and execute them one by one to build the IntelBluetoothFirmware kext:

```
# Navigate to the folder
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
- Original Guides by [dreamwhite](https://github.com/dreamwhite)
