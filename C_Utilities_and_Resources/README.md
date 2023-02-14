# Utilities and Resources
Incomplete list of useful freeware Apps, Tools and Resources for hackintoshing.

## Boot Managers
- [**OpenCore Releases**](https://github.com/acidanthera/OpenCorePkg/releases) – Official RELEASE and DEBUG versions of OpenCore
- [**OpenCore Nightly Builds**](https://dortania.github.io/builds/?product=OpenCorePkg&viewall=true) – Latest Nightly Builds from Dortania's Repo
- [**OpenCore_NO_ACPI_Build**](https://github.com/wjz304/OpenCore_NO_ACPI_Build/releases) – Unofficial fork of OpenCore which allows to not inject ACPI Tables in other Operating Systems
- [**Bootloader Chooser**](https://github.com/jief666/BootloaderChooser) – A pre-bootloader which lets you pick the actual Boot Manager you want to run. This way, you can switch between Clover and OpenCore easily.
- [**Utilities**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/C_Utilities_and_Resources/OpenCore_Utilities.md) included in the OpenCore Package

## Apps and Tools
### Getting macOS
Tools for downloading macOS directly from Apple Servers as well as cretaing insatllation media.

- [**ANYmacOS**](https://www.sl-soft.de/en/anymacos/) – App for downloading macOS High Sierra and newer. Can create USB Installers. Allows switching Update Seeds (Customer/Developer/Public).
- [**Create macOS Install**](https://github.com/LAbyOne/Create-MacOS-Install) – App for downlaoding macOS (10.7.5 to 13). Can create USB Installer as well. (Downloads are stored under `private/tmp`)
- [**gibMacOS**](https://github.com/corpnewt/gibMacOS) – Python script for downloading macOS (10.13 to 13). Only tool that can be used from within Windows to create an Internet Recovery USB installer!
- [**OpenCore Legacy Patcher**](https://github.com/dortania/OpenCore-Legacy-Patcher) – App for patching macOS so it can run on unsupported systems. Can download macOS (Big Sur and newer) and create a USB Installer.
- [**StartOSInstall**](https://github.com/chris1111/Startosinstall-Ventura) – Script to turn an external SSD into a macOS Installer. For Big Sur and newer.

### macOS (General)
- [**MountEFI**](https://github.com/corpnewt/MountEFI) – Tool for mounting the ESP partition
- [**MaciASL**](https://github.com/acidanthera/MaciASL) – ASL/AML Editor
- [**IORegistryExplorer**](https://github.com/utopia-team/IORegistryExplorer) – App for gathering infos about I/O on macOS.
- [**Hackintool**](https://github.com/headkaze/Hackintool) – Powerful post-install utility that everyone should have in their Hackintosh tool box
- [**Kext Updater**](https://www.sl-soft.de/en/kext-updater/) – Great App for checking and downloading Kext updates, Boot Manager files, etc.
- [**DarwinDumper**](https://bitbucket.org/blackosx/darwindumper/downloads/) – App for dumping ACPI tables, I/O Registry and more from real Macs.
- [**GenI2C**](https://github.com/DogAndPot/GenI2C) (Info) – Helpfu tool for enabling VoodooI2C Touchpads ([**Download**](https://github.com/quynkk5/GenI2C/blob/main/GenI2C.zip?raw=true))
- [**MacCPUID**](https://www.intel.com/content/www/us/en/download/674424/maccpuid.html) –  Shows detailed information of Intel CPUs (Model, Features, Cache, etc.)
- [**PinConfigurator**](https://github.com/headkaze/PinConfigurator) – App for importing and editing PinConfig Data for AppleALC Layout-IDs.
- [**DevCleaner for Xcode**](https://github.com/vashpan/xcode-dev-cleaner) - App for clearing various Xcode caches to reclaim tens of gigabytes of storage.
- [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) – Python Script to generate a SSDT for Power Management (for older Intel CPUs)
- [**unpkg**](https://www.timdoug.com/unpkg/) – Utility to unpack .pkg files into a folder instead of installing them on the system.
- [**Meld for macOS**](https://yousseb.github.io/meld/) – Useful app for comparing two config files with one another.

### Patcher Apps
Tools for patching macOS in Post-Install so it can run on eol/legacy systems.

- [**OpenCore Legacy Patcher**](https://github.com/dortania/OpenCore-Legacy-Patcher) –  Can install NVIDIA and Intel Graphics Drivers removed from macOS 12 and newer.
- [**GeForce Kepler Patcher**](https://github.com/chris1111/Geforce-Kepler-patcher) – Brings back NVIDIA GeForce Drivers for Kepler Cards in macOS 12 and newer.
- [**Intel HD 4000 Patcher**](https://github.com/chris1111/Patch-HD4000-Monterey) – For installing Intel HD 4000 iGPU drivers which have been removed from macOS 12 and newer.

### Cross-Platform
- [**OpenCore Auxiliary Tools (OCAT)**](https://github.com/ic005k/QtOpenCoreConfig) –The only Configurator for editing the OpenCore `config.plist` you need. Migrates the config to the latest version when saving. Can update OpenCore, Drivers and Kexts to the latest version as well. Highly Recommended.
- [**Python Installer**](https://www.python.org/downloads/) – Necessary for running the python-based tools in this list
- [**ProperTree**](https://github.com/corpnewt/ProperTree) – Python-based .plist Editor with unique features like snapshot generation for OpenCore configs.
- [**OCConfigCompare**](https://github.com/corpnewt/OCConfigCompare) – Compares your  config with latest sample.plist to migrate (and validate) it. For those who love the drudgery of updating the config manually…
- [**SSDTTime**](https://github.com/corpnewt/SSDTTime) – Python-based Tool for dumping DSDT and automated ACPI Hotpatch generation
- [**PlistEDPlus**](https://github.com/ic005k/PlistEDPlus) – Freeware .plist Editor
- [**Xiasl**](https://github.com/ic005k/Xiasl) – ASL/AML Editor
- [**ACPI Rename**](https://github.com/corpnewt/ACPIRename) – Handy Python script to analyze a `DSDT`. It can list its Device, Method and Name Paths and can generate HEX values for binray renames.
- [**BitmaskDecode**](https://github.com/corpnewt/BitmaskDecode) – Python-based bitmask Calculator for OpenCore (CsrActiveConfig, ScanPolicy, PickerAttributes, etc.)
- [**GenSMBIOS**](https://github.com/corpnewt/GenSMBIOS) – Python-based Tool for generating SMBIOS data
- [**USBToolbox**](https://github.com/USBToolBox/tool) – USB Port mapping tool. Makes port mapping under macOS 11.3+ easier.
- [**freqVectorsEdit**](https://github.com/Piker-Alpha/freqVectorsEdit.sh) – Python Script for editing frequency Vectors of Board-ID plists contained in the X86PlatformPlugin.kext
- [**OC Anonymizer**](https://github.com/dreamwhite/OC-Anonymizer) – Python Script for removing sensitive data from a config.plist as well as restoring some default settings.

### Windows
- [**BlueScreenView**](https://www.nirsoft.net/utils/blue_screen_view.html) –  Displays information about `blue screen of death' crashes containing details about the driver or module that possibly caused the crash.
- [**USB Device Tree Viewer**](https://www.uwe-sieber.de/usbtreeview_e.html) – Helpful tool for analyzing USB ports
- [**CrystalDiskInfo**](https://crystalmark.info/en/software/crystaldiskinfo/) – Great tool for checking the health of hard disks, SSDs and NVMEs.
- [**GPU-Z**](https://www.techpowerup.com/gpuz/) – Provides useful information about your GPU
- [**HWiNFO**](https://www.hwinfo.com/) – Great Tool for getting in-depth info about your system and components

### Web-based applications
- [**Sanity Checker**](https://sanitychecker.ocutils.me/) – The popular tool for checking the consistency of OpenCore configs online has returned!
- [**OpenCore ScanPolicy Generator**](https://oc-scanpolicy.vercel.app/)
- [**AnyPlist**](https://www.anyplist.com/#/) – Online Plist Editor
- [**OpenCore ExposeSensitiveData Generator**](https://dreamwhite-oc-esd.vercel.app/)
- [**Clover Cloud Editor**](https://cloudclovereditor.altervista.org/cce/cce/index.php) – Although the name implies otherwise, this is for editing OpenCore Configs online.
- [**OpenCore Configurator Online**](https://galada.gitee.io/opencoreconfiguratoronline/) – Compatible with OC ≤ 0.8.0
- [**Big <> Little Endian Converter**](https://www.save-editor.com/tools/wse_hex.html)
- [**Base64 Decoder/Encoder**](https://www.base64decode.org/)

## Further Resources
- [**OpenCore Install Guide**](https://dortania.github.io/OpenCore-Install-Guide/)
- [**Acidanthera Documents**](https://github.com/acidanthera/bugtracker/blob/master/DOCUMENTS.md)
- [**I/O Kit Fundamentals**](https://developer.apple.com/library/archive/documentation/DeviceDrivers/Conceptual/IOKitFundamentals/Introduction/Introduction.html#//apple_ref/doc/uid/TP0000011-CH204-TPXREF101) – Includes explanations about the I/O Registry.
