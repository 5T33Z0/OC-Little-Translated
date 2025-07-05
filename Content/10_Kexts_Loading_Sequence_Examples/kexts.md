# Kexts

| Category               | Kext Name                                                                                                                                                         | Description                                                       |
|------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------|
| **Required**           | [**Lilu**](https://github.com/acidanthera/Lilu)                                                                                                                   | For arbitrary kext, library, and program patching                 |
|                        | [**VirtualSMC**](https://github.com/acidanthera/VirtualSMC) <br> Contains [additional Plugins](https://github.com/acidanthera/VirtualSMC/blob/master/Docs/FAQ.md) | Advanced Apple SMC emulator.. Requires Lilu for full functioning. |
| **VirtualSMC Plugins** | SMCBatteryManager                                                                                                                                                 | Manages, monitors, and reports on battery status                  |
|                        | SMCDellSensors                                                                                                                                                    | Enables fan monitoring and control on Dell computers              |
|                             | SMCLightSensor                      | Allows system utilize ambient light sensor device    
|                             | SMCProcessor                        | Manages Intel CPU temperature sensors                 
|                             | SMCRadeonSensors                    | Provides temperature readings for AMD GPUs            |
|                             | SMCSuperIO                          | Monitoring hardware sensors and controlling fan speeds
| **Graphics**                | [**NootRX**](https://github.com/ChefKissInc/NootRX/) | AMD rDNA 2 dedicated GPU kext |
|                             | [**NootedRed**](https://github.com/ChefKissInc/NootedRed) | AMD Vega iGPU support kext |
|                             | [**WhateverGreen**](https://github.com/acidanthera/WhateverGreen) |  Various patches necessary for certain ATI/AMD/Intel/Nvidia GPUs   
| **Audio**                   | [**AppleALC**](https://github.com/acidanthera/AppleALC)                            | Native macOS HD audio for not officially supported codecs | 
| **Wi-Fi**                   | [**AirportBrcmFixup**](https://github.com/acidanthera/AirportBrcmFixup) | Patches required for non-native Airport Broadcom Wi-Fi cards  |
|                             | [**AirportItlwm**](https://github.com/OpenIntelWireless/itlwm)                        | Intel Wi-Fi drivers support the native macOS Wi-Fi interface | 
|                             | [**IO80211FamilyLegacy**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Wifi)                 | Enable legacy native Apple Wireless adapters         |
|                             | [**IOSkywalkFamily**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Wifi)                     | Enable legacy native Apple Wireless adapters         |
|                             | [**itlwm**](https://github.com/OpenIntelWireless/itlwm) | Intel Wi-Fi drivers. Spoofs as Ethernet and connects to Wi-Fi via Heliport 
|**Bluetooth**                | [**BrcmPatchRAM**](https://github.com/acidanthera/BrcmPatchRAM) <br> Contains: <ul><li>BlueToolFixup (macOS 12+)<li>BrcmBluetoothInjector <li> BrcmBluetoothInjectorLegacy <li> BrcmFirmwareData <li> BrcmFirmwareRepo <li> BrcmPatchRAM (macOS ≤ 10.10)<li> BrcmPatchRAM2 (macOS 10.11-10.14.)<li> BrcmPatchRAM3 (macOS 10.15)|  Collection of kexts for enabling RAMUSB-based Broadcom Bluetooth cards in various versions of macOS ([**config instructions**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/10_Kexts_Loading_Sequence_Examples/README.md#example-7-broadcom-wifi-and-bluetooth)),| 
|                             | [**IntelBluetoothFirmware**](https://github.com/OpenIntelWireless/IntelBluetoothFirmware) <br> Contains:<ul><li>IntelBluetoothFirmware<li>IntelBluetoothInjector<li>IntelBTPatcher| Uploads firmware to enable Intel Bluetooth support ([**config instructions**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/10_Kexts_Loading_Sequence_Examples#example-8a-intel-wifi-airportitlwm-and-bluetooth-intelbluetoothfirmware))  
| **Ethernet**                | AppleIGB (&rarr; Use IntelMausiEthernet instead!) | Provides support for Intel's IGB Ethernet controllers |
|                             | [**AppleIGC**](https://github.com/SongXiaoXi/AppleIGC) | Provides support for Intel 2.5G NICs (I-225/I-226)   |
|                             | [**AtherosE2200Ethernet**](https://github.com/Mieze/AtherosE2200Ethernet) | Provides support for Atheros E2200 family |
|                             | [**CatalinaBCM5701Ethernet**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Ethernet)               | Provides support for Broadcom BCM57XX Ethernet series|
|                             | [**HoRNDIS**](https://github.com/jwise/HoRNDIS)                             | Use the USB tethering mode of the Android phone to access the Internet | 
|                             | [**IntelMausiEthernet**](https://github.com/CloverHackyColor/IntelMausiEthernet) | LAN driver for various Intel 1 Gbit NICS                   
|                             | [**LucyRTL8125Ethernet**](https://github.com/Mieze/LucyRTL8125Ethernet)                 | Provides support for Realtek RTL8125 family           |
|                             | [**NullEthernet**](https://github.com/RehabMan/OS-X-Null-Ethernet) | Creates a Null Ethernet when no supported network hardware is present | 
|                             | [**RealtekRTL8100**](https://github.com/Mieze/RealtekRTL8100)                      | Provides support for Realtek RTL8100 family           |
|                             | [**RealtekRTL8111**](https://github.com/Mieze/RTL8111_driver_for_OS_X)                      | Provides support for Realtek RTL8111/8168 family      |
| **USB**                     | [**GenericUSBXHCI**](https://github.com/RehabMan/OS-X-Generic-USB3)                      | Fixes USB 3.0 issues found on some Ryzen APU-based systems. |
|                             | [**XHCI-unsupported**](https://github.com/RehabMan/OS-X-Generic-USB3)                    | Enables USB 3.0 support for unsupported xHCI controllers 
| **Input** (HID)             | [**AlpsHID**](https://github.com/blankmac/AlpsHID)                             | Brings native multitouch support to the Alps I2C touchpads. | No    |
|                             | [**VoodooInput**](https://github.com/acidanthera/VoodooInput)                         | Provides Magic Trackpad 2 software emulation for arbitrary input sources. Included as plugin in `VoodooPS2Controller` and `VoodooRMI`.| No   |
|                             | [**VoodooPS2Controller**](https://github.com/acidanthera/VoodooPS2)                 | Provides support for PS/2 keyboards, trackpads, and mice 
|                             | [**VoodooRMI**](https://github.com/VoodooSMBus/VoodooRMI)                           | Synaptic Trackpad kext over SMBus/I2C                |
|                             | [**VoodooSMBus**](https://github.com/VoodooSMBus/VoodooSMBus)                         | i2c-i801 + ELAN SMBus Touchpad kext                 |
|                             | [**VoodooI2C**](https://github.com/VoodooI2C/VoodooI2C) (and Sattelite kexts)                           | Intel I2C controller and slave device drivers        |
|                             | VoodooI2CAtmelMXT                   | A satellite kext for Atmel MXT I2C touchscreen        |
|                             | VoodooI2CELAN                       | A satellite kext for ELAN I2C touchpads              |
|                             | VoodooI2CFTE                        | A satellite kext for FTE based touchpads             |
|                             | VoodooI2CHID                        | A satellite kext for HID I2C or ELAN1200+ input devices | 
|                             | VoodooI2CSynaptics                  | A satellite kext for Synaptics I2C touchpads         |
| **Brand Specific**          | [**AsusSMC**](https://github.com/hieplpvip/AsusSMC) |  VirtualSMC plugin that provides native macOS support for ALS, keyboard backlight and Fn keys on Asus laptops.| 
|                             | [**BigSurface**](https://github.com/Xiashangning/BigSurface) | A fully integrated kext for Microsoft Surface (Pro) devices| 
|                             | [**YogaSMC**](https://github.com/zhen-zen/YogaSMC) |  ACPI driver for Lenovo ThinkPads and IdeaPads. Enables keyboard shortcuts, fan control and DYTC control.
| **Storage**                 | [**CtlnaAHCIPort**](https://github.com/HeaDragon/CtlnaAHCIPort/releases) | Improves support for certain SATA controllers dropped from macOS Big Sur+        |
|                             | [**SATAUnsupported**](https://github.com/HeaDragon/SATA-unsupported/releases) | Adds support for a large variety of SATA controllers, mainly relevant for laptops which have issues seeing the SATA drive in macOS. Testing without this kext first is recommended.
|                             | [**NVMeFix**](https://github.com/acidanthera/NVMeFix/releases)                             | Addresses compatibility and power management issues with Non-Apple NVMe SSDs (macOS 10.14+)| 
| **Card Reader**             | [**RealtekCardReader**](https://github.com/0xFireWolf/RealtekCardReader)                   | Realtek PCIe/USB-based SD card reader driver         |
|                             | [**RealtekCardReaderFriend**](https://github.com/0xFireWolf/RealtekCardReaderFriend)             | Makes System Information recognize your Realtek card reader |
|                             | [**Sinetek-rtsx**](https://github.com/0xFireWolf/RealtekCardReader)                        | Realtek PCIe-based SD card reader driver             |
| **TSC Synchronization**     | [**AmdTscSync**](https://github.com/naveenkrdy/AmdTscSync)                          | A modified version of VoodooTSCSync for AMD CPUs      |
|                             | [**VoodooTSCSync**](https://github.com/RehabMan/VoodooTSCSync)                       | A kernel extension which will synchronize the TSC on Intel CPUs | 
|                             | [**CpuTscSync**](https://github.com/acidanthera/CpuTscSync)                          | Lilu plugin for TSC sync and disabling xcpm_urgency on Intel CPUs |
|                             | [**ForgedInvariant**](https://github.com/ChefKissInc/ForgedInvariant)                     | The plug & play kext for syncing the TSC on AMD & Intel | No    |
| **Extras**                  | [**AMFIPass**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera)                            | A replacement for amfi=0x80 boot argument            |
|                             | [**ASPP-Override**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Misc)| Re-enables legacy CPU power management for Intel Sandy Bridge CPUs. Forces `ACPI_SMC_PlatformPlugin` to outmatch `X86PlatformPlugin` and disable firmware throttling. | 
|                             | [**AppleIntelCPUPowerManagement**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Misc) in combination with [**AppleIntelCPUPowerManagementClient**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Misc)       | Re-enable CPU power management on legacy Intel CPUs  |
|                             | [**AppleMCEReporterDisabler**](https://github.com/acidanthera/bugtracker/files/3703498/AppleMCEReporterDisabler.kext.zip) | Required in macOS 12.3+ on AMD systems, and on macOS 10.15 and later on dual-socket Intel systems.  Affected SMBIOSes: MacPro6,1, MacPro7,1, iMacPro1,1 
|                             | [**BrightnessKeys**](https://github.com/acidanthera/BrightnessKeys) | Handler for brightness keys without DSDT patches     
|                             | [**CPUFriend**](https://github.com/acidanthera/CPUFriend) | Dynamic power management data injection (requires CPUFriendDataProvider) |
|                             | [**CpuTopologyRebuild**](https://github.com/b00t0x/CpuTopologyRebuild)                  | Optimizes the core configuration of Intel Alder Lake CPUs+ | No   |
|                             | [**CryptexFixup**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera)                        | Installs non AVX2.0 Cryptex on non AVX2.0 CPUs (Ivy Bridge and older). Required for running macOS 13+ on Wintel systems           
|                             | [**ECEnabler**](https://github.com/1Revenger1/ECEnabler) | Allows reading Embedded Controller fields over 1 byte long | 
|                             | [**FeatureUnlock**](https://github.com/acidanthera/FeatureUnlock) | Enable additional features on unsupported hardware  |
|                             | [**HibernationFixup**](https://github.com/acidanthera/HibernationFixup) | Fixes hibernation compatibility issues               |
|                             | [**IntelMKLFixup**](https://github.com/Carnations-Botanica/IntelMKLFixup) | Dead-simple Intel(tm) Math Kernel Library patcher for AMD CPU systems | 
|                             | [**NoTouchID**](https://github.com/al3xtjames/NoTouchID) | Avoid lag in authentication dialogs for board IDs with Touch ID sensors (only needed on macOS 10.14 and older)| 
|                             | [**RestrictEvents**](https://github.com/acidanthera/RestrictEvents) | Blocking unwanted processes and unlocking features  
|                             | [**RTCMemoryFixup**](https://github.com/acidanthera/RTCMemoryFixup) | Emulate some offsets in your CMOS (RTC) memory       |
