# Compiling Slimmed `AirportItlwm`, `itlwm` and `IntelBluetoothFirmware` Kexts

**TABLE of CONTENTS**

- [About](#about)
- [1. Identify the used firmware](#1-identify-the-used-firmware)
  - [1.1 Identify Your Wi-Fi Firmware](#11-identify-your-wi-fi-firmware)
  - [1.2 Identify Your Bluetooth Firmware](#12-identify-your-bluetooth-firmware)
- [2. Prepare the Source Code](#2-prepare-the-source-code)
  - [2.1 Prepare the `itlwm` source code](#21-prepare-the-itlwm-source-code)
  - [2.2 Prepare the `IntelBluetoothFirmware` source code](#22-prepare-the-intelbluetoothfirmware-source-code)
- [3. Compile the kexts](#3-compile-the-kexts)
  - [3.1 Install Xcode](#31-install-xcode)
  - [3.2 Compile `AirportItlwm` and `Itlwm`](#32-compile-airportitlwm-and-itlwm)
  - [3.3 Compile `InteBluetothFirmware`](#33-compile-intebluetothfirmware)
- [4. Test](#4-test)
- [Credits and Resources](#credits-and-resources)

---

## About

The size of the Intel Wi-Fi and Bluetooth firmware kexts can be reduced significantly by removing unnecessary firmware. The resulting kexts contain only the firmware files required by your Intel Wi-Fi/Bluetooth card, reducing their size by up to 16x depending on the used model.

If you only want to compile the latest versions of the Intel Wi-Fi and Bluetooth kexts without slimming them down, consider using Chris1111's [**Intel Wi-Fi KextsBuilder**](https://github.com/chris1111/Wifi-Intel-KextsBuilder). It automatically downloads and builds the latest versions of the kexts.

> [!IMPORTANT]
>
> Slimming the firmware is entirely optional. It only reduces the size of the kexts and **does not** improve performance or compatibility. If you remove the wrong firmware file(s), your Wi-Fi or Bluetooth device will fail to initialize.

---

## 1. Identify the used firmware

To build slimmed-down, tailor-made versions of **AirportItlwm**, **Itlwm**, and **IntelBluetoothFirmware** for your Intel Wi-Fi/Bluetooth card, you first need to identify the firmware files required by your hardware. Once identified, remove all unused firmware files from the source code before compiling the kexts.

> [!NOTE]
> 
> The screenshots in this guide use the firmware files required by an **Intel AC 9560** Wi-Fi/Bluetooth card. If you have a different Intel card, use the firmware files corresponding to your model instead.

### 1.1 Identify Your Wi-Fi Firmware
- Run [**IORegistryExplorer**](https://github.com/utopia-team/IORegistryExplorer/releases)
- If you are using `AirportItlwm.kext`, search for `Airport`
- Take note of the entry for `IOModel` ("iwm-…"):<br>![Airport](https://github.com/user-attachments/assets/53c10e65-cf57-495a-af53-55862480a9d6)

> [!IMPORTANT]
>
> The firmware identifier is only exposed when using `AirportItlwm.kext`. If you are currently using `itlwm.kext`, this won't work. In this case, use the table below to find the wireless firmware file(s) used by your Wi-FI/BT card.

<details>
<summary><strong>Intel Wi-Fi adapters and firmware files</strong> (Click to reveal)</summary><br>

| Intel Wi-Fi Adapter(s)           | Firmware file(s)                                             |
| -------------------------------- | ------------------------------------------------------------ |
| Centrino Wireless-N 1000         | `iwlwifi-1000-*.ucode`                                       |
| Centrino Wireless-N 1030         | `iwlwifi-1000-*.ucode`                                       |
| Centrino Wireless-N 105          | `iwlwifi-105-*.ucode`                                        |
| Centrino Wireless-N 130          | `iwlwifi-100-*.ucode`                                        |
| Centrino Wireless-N 135          | `iwlwifi-135-*.ucode`                                        |
| Centrino Wireless-N 2200         | `iwlwifi-2000-*.ucode`                                       |
| Centrino Wireless-N 2230         | `iwlwifi-2030-*.ucode`                                       |
| Centrino Advanced-N 6200         | `iwlwifi-6000-*.ucode`                                       |
| Centrino Ultimate-N 6300         | `iwlwifi-6000-*.ucode`                                       |
| Centrino Advanced-N 6230         | `iwlwifi-6000g2a-*.ucode`                                    |
| Centrino Advanced-N 6235         | `iwlwifi-6000g2b-*.ucode`                                    |
| Centrino Wireless-N + WiMAX 6150 | `iwlwifi-6150-*.ucode`                                       |
| Dual Band Wireless-N 7260        | `iwlwifi-7260-*.ucode`                                       |
| Dual Band Wireless-AC 7260       | `iwlwifi-7260-*.ucode`                                       |
| Dual Band Wireless-AC 7265       | `iwlwifi-7265-*.ucode`                                       |
| Dual Band Wireless-AC 3160       | `iwlwifi-3160-*.ucode`                                       |
| Dual Band Wireless-AC 3165       | `iwlwifi-7265D-*.ucode`                                      |
| Dual Band Wireless-AC 3168       | `iwlwifi-3168-*.ucode`                                       |
| Dual Band Wireless-AC 8260       | `iwlwifi-8000C-*.ucode`                                      |
| Dual Band Wireless-AC 8265       | `iwlwifi-8265-*.ucode`                                       |
| Dual Band Wireless-AC 8275       | `iwlwifi-8265-*.ucode`                                       |
| Wireless-AC 9260                 | `iwlwifi-9000-pu-b0-jf-b0-*.ucode`                           |
| Wireless-AC 9461                 | `iwlwifi-9000-pu-b0-jf-b0-*.ucode`                           |
| Wireless-AC 9462                 | `iwlwifi-9000-pu-b0-jf-b0-*.ucode`                           |
| Wireless-AC 9560                 | `iwlwifi-9000-pu-b0-jf-b0-*.ucode`                           |
| Wi-Fi 6 AX200                    | `iwlwifi-cc-a0-*.ucode`                                      |
| Killer AX1650                    | `iwlwifi-cc-a0-*.ucode`                                      |
| Wi-Fi 6 AX201                    | `iwlwifi-QuZ-a0-hr-b0-*.ucode` + `iwlwifi-QuZ-a0-hr-b0.pnvm` |
| Wi-Fi 6 AX101                    | `iwlwifi-QuZ-a0-hr-b0-*.ucode` + `iwlwifi-QuZ-a0-hr-b0.pnvm` |
| Killer AX1650i                   | `iwlwifi-QuZ-a0-hr-b0-*.ucode` + `iwlwifi-QuZ-a0-hr-b0.pnvm` |
| Killer AX1675                    | `iwlwifi-QuZ-a0-hr-b0-*.ucode` + `iwlwifi-QuZ-a0-hr-b0.pnvm` |
| Wi-Fi 6 AX210                    | `iwlwifi-ty-a0-gf-a0-*.ucode` + `iwlwifi-ty-a0-gf-a0.pnvm`   |
| Killer AX1675x                   | `iwlwifi-ty-a0-gf-a0-*.ucode` + `iwlwifi-ty-a0-gf-a0.pnvm`   |
| Wi-Fi 6E AX211                   | `iwlwifi-so-a0-gf4-a0-*.ucode` + `iwlwifi-so-a0-gf4-a0.pnvm` |
| Killer AX1690 series             | `iwlwifi-so-a0-gf4-a0-*.ucode` + `iwlwifi-so-a0-gf4-a0.pnvm` |

</details>

> [!TIP]
> 
> For additional information about the naming scheme of Intel Wireless and Bluetooth Firmware files check [Understanding Intel Wireless Firmware Names](/Content/J_Compiling_Kexts/Understanding_Intel_Wireless_Firmware_Names.md).

### 1.2 Identify Your Bluetooth Firmware

The diagram below shows the decision path for identifying the Bluetooth firmware used by your Intel card.

<img width="1536" height="1024" alt="identifyitlbtfw" src="https://github.com/user-attachments/assets/e770b9b8-eb16-40e3-b4c5-e18180dd5e6f" />

1. **Check IORegistryExplorer (primary method)**

   * Open **IORegistryExplorer**
   * Search for "firmware"
   * This should bring `IntelBluetoothFirmware` entry in focus
   * Look for the property `fw_name`
   * If `fw_name` is present → **use the listed firmware and continue with section &rarr; [Compile the kexts](#3-compile-the-kexts)**
     
2. **If `fw_name` is missing**
   * The `fw_name` field might be empty:<br> ![btfirmware](https://github.com/user-attachments/assets/d2395b61-7a11-4494-97ec-439c26de2962)
   * Check whether your Intel Wi-Fi/Bluetooth card is listed in the firmware mapping table below
   * If it is listed → use the corresponding firmware files

    <details>
    <summary><strong>Intel Bluetooth firmware mapping table</strong>(Click to reveal)</summary><br>

    | Intel Wi-Fi Card                 | Bluetooth Firmware Files                  |
    | -------------------------------- | ----------------------------------------- |
    | Intel 8260                       | `ibt-11-5.sfi` + `ibt-11-5.ddc`           |
    | Intel 8265                       | `ibt-12-16.sfi` + `ibt-12-16.ddc`         |
    | Intel 9460 / 9560 (var 0 rev 1)  | `ibt-17-0-1.sfi` + `ibt-17-0-1.ddc`       |
    | Intel 9460 / 9560 (var 16 rev 1) | `ibt-17-16-1.sfi` + `ibt-17-16-1.ddc`     |
    | Intel 9160 / 9260 (var 0 rev 1)  | `ibt-18-0-1.sfi` + `ibt-18-0-1.ddc`       |
    | Intel 9160 / 9260 (var 16 rev 1) | `ibt-18-16-1.sfi` + `ibt-18-16-1.ddc`     |
    | Intel AX201 (var 0 rev 0)        | `ibt-19-0-0.sfi` + `ibt-19-0-0.ddc`       |
    | Intel AX201 (var 0 rev 1)        | `ibt-19-0-1.sfi` + `ibt-19-0-1.ddc`       |
    | Intel AX201 (var 0 rev 4)        | `ibt-19-0-4.sfi` + `ibt-19-0-4.ddc`       |
    | Intel AX201 (var 16 rev 4)       | `ibt-19-16-4.sfi` + `ibt-19-16-4.ddc`     |
    | Intel AX201                      | `ibt-19-240-1.sfi` + `ibt-19-240-1.ddc`   |
    | Intel AX201                      | `ibt-19-240-4.sfi` + `ibt-19-240-4.ddc`   |
    | Intel AX201 (var 32 rev 0)       | `ibt-19-32-0.sfi` + `ibt-19-32-0.ddc`     |
    | Intel AX201 (var 32 rev 1)       | `ibt-19-32-1.sfi` + `ibt-19-32-1.ddc`     |
    | Intel AX201 (var 32 rev 4)       | `ibt-19-32-4.sfi` + `ibt-19-32-4.ddc`     |
    | Intel 22161 (var 0 rev 3)        | `ibt-20-0-3.sfi` + `ibt-20-0-3.ddc`       |
    | Intel 22161 (var 1 rev 3)        | `ibt-20-1-3.sfi` + `ibt-20-1-3.ddc`       |
    | Intel 22161 (var 1 rev 4)        | `ibt-20-1-4.sfi` + `ibt-20-1-4.ddc`       |
    | Intel AX210                      | `ibt-0041-0041.sfi` + `ibt-0041-0041.ddc` |

    For the complete list, check: [https://packages.debian.org/bullseye/firmware-iwlwifi](https://packages.debian.org/bullseye/firmware-iwlwifi)
	
	</details>
	
3. **If your card is NOT listed in the table**

   * Download [`DebugEnhancer.kext`](https://github.com/acidanthera/DebugEnhancer)
   * Place it in `EFI/OC/Kexts`
   * Add it to `config.plist`
   * Reboot macOS

   **Then**:

   * Open Terminal and Run:
     ```bash
     sudo dmesg | grep ibt
     ```
   * Look for output like:
     ```
     Found device firmware: ibt-XX-XX.sfi / ibt-XX-XX.ddc
     ```
   * Record both firmware files
      
      **Example**:<br>
      ![grep](https://github.com/user-attachments/assets/acb73cc1-a001-42dc-bb3b-0baf549ab2a4)


4. **If firmware is still not shown**

   * Boot into a **Linux Live system** (I like to use a USB flash drive created with [**Ventoy**](https://www.ventoy.net/en/index.html) to boot directly form a Linux ISO)
   * Run:
     ```bash
     sudo dmesg | grep ibt
     ```
   * Output (example):<br>![linux](https://github.com/user-attachments/assets/d8fc5324-e1f1-438c-8902-b4c0c8d09ef0)
   * Use those files for your kext build

---

## 2. Prepare the Source Code

### 2.1 Prepare the `itlwm` source code
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

### 2.2 Prepare the `IntelBluetoothFirmware` source code
- Download [IntelBluetoothFirmware](https://github.com/OpenIntelWireless/IntelBluetoothFirmware) source code (click on "Code" and select "Download zip")
- Unzip the file – "IntelBluetoothFirmware-master" folder will be created
- Run Terminal and enter:
	```bash
	cd ~/Downloads/IntelBluetoothFirmware-master
	```
- Next, download MacKernelSDK into the "IntelBluetoothFirmware-master" folder. Enter: 
	```bash
	git clone https://github.com/acidanthera/MacKernelSDK
	```
- Leave the Terminal window open for later use
- Download the DEBUG version of [**Lilu**](https://github.com/acidanthera/Lilu/releases), extract it and place the kext in the IntelBluetoothFirmware-master folder
- In Finder, navigate to `~/Downloads/IntelBluetoothFirmware-master/IntelBluetoothFirmware/fw`
- In the `fw` folder delete all the firmware files except the two: `ibt-….ddc` and `ibt-….sfi` files for your card
- If present, also delete `FwBinary.cpp` from `/IntelBluetoothFirmware-MASTER/IntelBluetoothFirmware`

---

## 3. Compile the kexts

### 3.1 Install Xcode
- Download the correct version of [**Xcode**](https://xcodereleases.com/?scope=release) and extract it.
- Move the Xcode app to the "Programs" folder – otherwise compiling might fail.

### 3.2 Compile `AirportItlwm` and `Itlwm`
Enter the following commands (the lines without `#`) in Terminal and execute them one by one to build itlwm as well as AirportItlwm kexts for all versions of macOS:

- Navigate to the itlwm folder (if it is not your working directory already):
  ```bash
  cd ~/Downloads/itlwm-master
  ```
- Remove generated firmware (if present):
  ```bash
  rm include/FwBinary.cpp
  ```
- Generate Firmware:
  ```bash
  xcodebuild -project itlwm.xcodeproj -target fw_gen -configuration Release -sdk macosx
  ```
- Build the kexts:
  ```bash
  xcodebuild -alltargets -configuration Release
  ```
Once building the kexts is completed they will be located under `~/Downloads/itlwm-master/itlwm/build/Release`:<br>![kexts](https://github.com/user-attachments/assets/719630a7-54db-4c3e-b214-770dd24302a3)

### 3.3 Compile `InteBluetothFirmware`

Enter the following commands (the lines without `#`) in Terminal and execute them one by one to build the IntelBluetoothFirmware kext:

- Navigate to the IntelBluetoothFirmware folder:
  ```bash
  cd ~/Downloads/IntelBluetoothFirmware-master
  ```
- Build the kexts:
  ```bash
  xcodebuild -alltargets -configuration Release
  ```
The compiled kexts will be located under `~/Downloads/IntelBluetoothFirmwar-master/build/Release`:<br>![itlbtfw](https://github.com/user-attachments/assets/c9be468e-11fa-475e-9fb8-c7d7b3a348e2)

---

## 4. Test
- Copy the newly compiled kexts to `EFI/OC/Kexts`, replacing existing ones
- Reboot
- Check if WiFi and Bluetooth are still working. If not, you probably used an incorrect firmware  — revert to the prebuilt kexts from the OpenIntelWireless repo.

> [!IMPORTANT]
> 
> - `itlwm.kext` requires the [Heliport](https://github.com/OpenIntelWireless/HeliPort) app to connect to Wi-Fi Hotspots
> - If you are having issues with the slimmed kexts, I suggest you use the pre-compiled version from the OpenIntelWireless repo instead

---

## Credits and Resources
- Original Guide by [dreamwhite](https://github.com/dreamwhite)
- Intel WiFi/BT Firmware from Linux: [https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git](https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git)
- Linux Wireless Documentation for Intel WiFi: [https://wireless.docs.kernel.org/en/latest/en/users/drivers/iwlwifi.html](https://wireless.docs.kernel.org/en/latest/en/users/drivers/iwlwifi.html)
