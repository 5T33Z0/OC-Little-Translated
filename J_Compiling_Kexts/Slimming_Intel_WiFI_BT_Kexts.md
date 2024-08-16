# How to compile slimmed `AirportItlwm`, `itlwm` and `IntelBluetoothFirmware` kexts for Intel Wi-Fi/BT Cards

The size of the Intel Wireless and BluetoothFirmare kexts for Intel Cards can be reduced drastically by about a factor of 10 by deleting all the unnecessary firmwares for other Wi-Fi cards except the one for your WiFi/BT Card.

> [!NOTE]
> 
> The screenshots in this guide show firmware files used by the Intel AC-9560 Wifi/BT card.

## Preparations

### Identifying the used firmwares
#### Wi-Fi Firmware
- Open IORegistryExplorer
- If you are using `AirportItlwm.kext`, search for `Aiport`
- Take note of the entry for `IOModel` ("iwm-…"):<br>![](/Users/5t33y0/Desktop/Airport.png)

### Bluetooth Firmware
- In IORegistryExplorer, locate the entry `InteBluetoothFirmware`
- Check the entry for `fw_name` 
- Take note of the value

> [!NOTE]
> 
> - If the field `fw_name` is empty, you need to use Linux to find the firmware.
> - Prepare a USB flash drive with Ventoy
> - Download a Linux distro of your choice (as .iso)
> - Put the .iso on the Ventoy USB Stick
> - Boot from the Ventoy USB stick
> - Select the Linux distro
> - Run Linux live, don't install it
> - Once you reach the desktop, run Terminal
> - Enter `dmesg | grep ibt`
> - This will show you the used BT Firmware files ("ibt…"):<br>![](/Users/5t33y0/Desktop/linux.png)
> - Take note of the two files, reboot into macOS and continue with the guide

### Install Xcode
- Download the correct version of [**Xcode**](https://xcodereleases.com/?scope=release) for your system. 
- Move the Xcode app to the "Programs" folder – otherwise compiling might fail.

### Prepare the `itlwm` source code
- Download [**itlwm**](https://github.com/OpenIntelWireless/itlwm) source code (click on "Code" and select "Download zip")
- Unzip the file – "itlwm-master" folder will be created
- Run Terminal
- Enter `cd ~/Downloads/itlwm-master`
- Next, enter `git clone https://github.com/acidanthera/MacKernelSDK` to download MacKernelSDK into the "itlwm-master" folder
- Leave the Terminal window open for later use
- Download the DEBUG version of Lilu, extract it and place the kext in the itlwm-master folder
- In Finder, navigate to `~/Downloads/itlwm-master/itlwm/firmware`
- Delete every file except the `iwm-…` file for your Intel Wifi/BT card.

### Prepare the `IntelBluetoothFirmware` source code
- Download [IntelBluetoothFirmware](https://github.com/OpenIntelWireless/IntelBluetoothFirmware) source code (click on "Code" and select "Download zip")
- Unzip the file – "IntelBluetoothFirmware-master" folder will be created
- Run Terminal
- Enter: `cd ~/Downloads/IntelBluetoothFirmware-master`
- Next, enter `git clone https://github.com/acidanthera/MacKernelSDK` to download MacKernelSDK into the "IntelBluetoothFirmware-master" folder
- Leave the Terminal window open for later use
- Download the DEBUG version of Lilu, extract it and place the kext in the IntelBluetoothFirmware-master folder
- In Finder, navigate to `~/Downloads//IntelBluetoothFirmware-master/IntelBluetoothFirmware/fw`
- In the `fw` folder delete all the firmware files except the two: `ibt-….ddc` and `ibt-….sfi` files for your card
- If present, also delete `FwBinary.cpp` from /IntelBluetoothFirmware-MASTER/IntelBluetoothFirmware

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

Once compiling is completed the kexts will be located at `~/Downloads/itlwm-master/itlwm/build/Release`:<br>![kexts](https://github.com/user-attachments/assets/719630a7-54db-4c3e-b214-770dd24302a3)

### Compiling `InteBluetothFirmware`

- Run Terminal 
- Enter: `cd ~/Downloads/IntelBluetoothFirmware-master`
- Next, enter ` xcodebuild -alltargets -configuration Release`to compile the kexts
- The finished kexts will be located under `~/Downloads/IntelBluetoothFirmwar-master/build/Release`:<br>![itlbtfw](https://github.com/user-attachments/assets/c9be468e-11fa-475e-9fb8-c7d7b3a348e2)

## Testing
- Copy the newly compiled kexts to `EFI/OC/Kexts`, replacing the existing ones
- Reboot
- Check if WiFi and Bluetooth are working.

> [!IMPORTANT]
> 
> - `itlw.kext` requires the [Heliport](https://github.com/OpenIntelWireless/HeliPort) app to connect to Wi-Fi Hotspots
> - If you are having issues with the slimmed itlwm.kext, use the pre-cpmpiled version from the OpenIntelWireless repo!
