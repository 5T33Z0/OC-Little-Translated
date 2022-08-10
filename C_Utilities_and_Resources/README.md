# Utilities and Resources
Incomplete list of useful freeware Apps, Tools and resources for hackintoshing.

## Boot Managers
- [**OpenCore Releases**](https://github.com/acidanthera/OpenCorePkg/releases)
- [**OpenCore Nightly Builds**](https://dortania.github.io/builds/?product=OpenCorePkg&viewall=true)
- [**Clover Boot Manager**](https://github.com/CloverHackyColor/CloverBootloader/releases)
- [**Clover Suite Builder**](https://www.insanelymac.com/forum/topic/347872-introducing-clover-suite-builder/) – Tool for compiling Clover from Source
- [**Bootloader Chooser**](https://github.com/jief666/BootloaderChooser) – A pre-bootloader which lets you pick the actual Boot Manager you want to run. This way you can have multiple "Clover" and/or "OC" folders with different configs.

## Apps and Tools
### macOS (General)
- [**MountEFI**](https://github.com/corpnewt/MountEFI) – Tool for mounting the ESP partition
- [**MaciASL**](https://github.com/acidanthera/MaciASL) – ASL/AML Editor
- [**IORegistryExplorer**](https://github.com/utopia-team/IORegistryExplorer) – App for gathering infos about I/O on macOS.
- [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) – Python Script to generate a SSDT for Power Management (for older Intel CPUs)
- [**Hackintool**](https://github.com/headkaze/Hackintool) – Powerful post-install utility that everyone should have in their Hackintosh tool box
- [**Kext Updater**](https://www.sl-soft.de/en/kext-updater/) – Great App for checking and downloading Kext updates, Boot Manager files, etc.
- [**ANYmacOS**](https://www.sl-soft.de/en/anymacos/) – App for downloading current macOS, creating an USB Installer and changing the Update Seed which can help resolving issues with system updates
- [**DarwinDumper**](https://bitbucket.org/blackosx/darwindumper/downloads/) – App for dumping ACPI tables, I/O Registry and more from real Macs.
- [**MacCPUID**](https://www.intel.com/content/www/us/en/download/674424/maccpuid.html) –  Shows detailed information of Intel CPUs (Model, Features, Cache, etc.)
- [**unpkg**](https://www.timdoug.com/unpkg/) – Utility to unpack .pkg files into a folder instead of installing them on the system.
- [**PinConfigurator**](https://github.com/headkaze/PinConfigurator) – App for importing and editing PinConfig Data for AppleALC Layout-IDs.
- [**DevCleaner for Xcode**](https://github.com/vashpan/xcode-dev-cleaner) - App for clearing various Xcode caches to reclaim tens of gigabytes of storage.
- [**StartOSInstall**](https://github.com/chris1111/Startosinstall-Ventura) – Script to turn an external SSD into a macOS Installer. For Big Sur and newer.

### macOS Monterey
- [**GeForce Kepler Patcher**](https://github.com/chris1111/Geforce-Kepler-patcher) – Brings back NVIDIA GeForce Drivers for Kepler Cards in macOS Monterey
- [**Intel HD 4000 Patcher**](https://github.com/chris1111/Patch-HD4000-Monterey) – Tool for installing Intel HD 4000 iGPU drivers which have been removed from macOS 12.

### Cross-Platform
- [**OpenCore Auxiliary Tools (OCAT)**](https://github.com/ic005k/QtOpenCoreConfig) – Recommended Configurator for editing the OpenCore `config.plist`. Migrates config.plist to the latest form when saving. So no more tedious manual updating of the config is required. Can update kexts and OpenCore files to the latest version. Basically, it's the only editor you need.
- [**PlistEDPlus**](https://github.com/ic005k/PlistEDPlus) – Freeware Plist Editor
- [**QtiASL**](https://github.com/ic005k/QtiASL) – ASL/AML Editor
- [**Python Installer**](https://www.python.org/downloads/) – Necessary for running a lot of the python-based tools in this list
- [**ProperTree**](https://github.com/corpnewt/ProperTree) – Python-based config.plist Editor with unique features like snapshot generation
- [**SSDTTime**](https://github.com/corpnewt/SSDTTime) – Python-based Tool for dumping DSDT and automated ACPI Hotpatch generation
- [**BitmaskDecode**](https://github.com/corpnewt/BitmaskDecode) – Python-based bitmask Calculator for OpenCore (CsrActiveConfig, ScanPolicy, PickerAttributes, etc.)
- [**gibMacOS**](https://github.com/corpnewt/gibMacOS) – Python-based Tool for downloading macOS
- [**GenSMBIOS**](https://github.com/corpnewt/GenSMBIOS) – Python-based Tool for generating SMBIOS data
- [**USBToolbox**](https://github.com/USBToolBox/tool) – USB Port mapping tool. Makes port mapping under macOS 11.3+ easier.
- [**freqVectorsEdit**](https://github.com/Piker-Alpha/freqVectorsEdit.sh) – Python Script for editing frequency Vectors of Board-ID plists contained in the X86PlatformPlugin.kext
- [**OC Anonymizer**](https://github.com/dreamwhite/OC-Anonymizer) – Python Script for removing sensitive data from a config.plist as well as restoring some default settings.

### Windows
Suggest some. Otherwise refer to "Cross-Platform" Section.

### Web-based applications
- [**Sanity Checker**](https://sanitychecker.ocutils.me/) (beta) – The popular tool for checking the consistency of OpenCore configs online has returned!
- [**OpenCore ScanPolicy Generator**](https://oc-scanpolicy.vercel.app/)
- [**OpenCore ExposeSensitiveData Generator**](https://dreamwhite-oc-esd.vercel.app/)
- [**Clover Cloud Editor**](https://cloudclovereditor.altervista.org/cce/cce/index.php) – Although the name implies otherwise, this is for editing OpenCore Configs online.
- [**OpenCore Configurator Online**](https://galada.gitee.io/opencoreconfiguratoronline/) – Compatible with OC ≤ 0.8.0
- [**Big <> Little Endian Converter**](https://www.save-editor.com/tools/wse_hex.html)
- [**Base64 Decoder/Encoder**](https://www.base64decode.org/)

## Resources
- [**OpenCore Install Guide**](https://dortania.github.io/OpenCore-Install-Guide/)
- [**Acidanthera Documents**](https://github.com/acidanthera/bugtracker/blob/master/DOCUMENTS.md)
- [**I/O Kit Fundamentals**](https://developer.apple.com/library/archive/documentation/DeviceDrivers/Conceptual/IOKitFundamentals/Introduction/Introduction.html#//apple_ref/doc/uid/TP0000011-CH204-TPXREF101) – Includes explanations about the I/O Registry.
