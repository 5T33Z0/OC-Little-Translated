# Utilities and Resources
Incomplete list of useful freeware Apps, Tools and Resources for hackintoshing.

- [Boot Managers](#boot-managers)
- [Apps and Tools](#apps-and-tools)
  - [Getting macOS](#getting-macos)
  - [Troubleshooting/Debugging](#troubleshootingdebugging)
  - [Editing plists, updating OpenCore and kexts](#editing-plists-updating-opencore-and-kexts)
  - [ACPI-related tools](#acpi-related-tools)
  - [Audio](#audio)
  - [Laptop-specific](#laptop-specific)
  - [macOS Apps (General)](#macos-apps-general)
  - [macOS Virtualization](#macos-virtualization)
  - [Post-Install Patcher Apps](#post-install-patcher-apps)
  - [Cross-Platform](#cross-platform)
  - [CPU-related](#cpu-related)
  - [Windows](#windows)
  - [Web-based applications](#web-based-applications)
- [Further Resources](#further-resources)

---

## Boot Managers
- [**OpenCore Releases**](https://github.com/acidanthera/OpenCorePkg/releases) – Official RELEASE and DEBUG versions of OpenCore.
- [**OpenCore Nightly Builds**](https://dortania.github.io/builds/?product=OpenCorePkg&viewall=true) – Latest Nightly Builds from Dortania's Repo.
- [**OpenCore_NO_ACPI_Build**](https://github.com/wjz304/OpenCore_NO_ACPI_Build/releases) – Unofficial fork of OpenCore which allows to not inject ACPI Tables in other Operating Systems.
- [**Bootloader Chooser**](https://github.com/jief666/BootloaderChooser) – A pre-bootloader which lets you pick the actual Boot Manager you want to run. This way, you can switch between Clover and OpenCore easily.
- [**Utilities**](/Content/OpenCore_Utilities.md) included in the OpenCore Package.

## Apps and Tools

### Getting macOS
Tools for downloading macOS directly from Apple Servers as well as creating installation media.

- [**OpenCore Legacy Patcher**](https://github.com/dortania/OpenCore-Legacy-Patcher) – App for patching macOS so it can run on unsupported systems. Can also download macOS (Big Sur and newer) and prepare a USB Installer.
- [**TINU**](https://github.com/ITzTravelInTime/TINU) – Open Tool to create bootable macOS installers.
- [**MIST**](https://github.com/ninxsoft/Mist) (macOS Installer Super Tool) – So far the only App that can download ipsw Firmwares (ARM) as well as macOS Installers for Intel-based systems (OSX 10.7.5 and newer). Also the one with the best GUI and most options. Check the "Settings…" menu to select the diplayed seed(s) of the Software Update Catalog, etc. Requires macOS Monterey or newer.
- [**Create macOS Install**](https://github.com/LAbyOne/Create-MacOS-Install) - CLI-based Tool to download and prepare macOS (Snow Leopard or newer), Bootloaders and USB Installers.
- [**gibMacOS**](https://github.com/corpnewt/gibMacOS) – Python script for downloading macOS (10.13 to 13). Only tool that can be used from within Windows to create an Internet Recovery USB installer!
- [**StartOSInstall**](https://github.com/chris1111/Startosinstall-Ventura) – Script to turn an external SSD into a macOS Installer (Big Sur and newer).
- [**ISO Image Creator**](https://macmeup.com/create-iso-images/) – App to convert macOS Installers to .iso images.

### Troubleshooting/Debugging
- [**IORegistryExplorer**](https://github.com/utopia-team/IORegistryExplorer) – App for gathering infos from the [**I/OKit**](https://developer.apple.com/library/archive/documentation/DeviceDrivers/Conceptual/IOKitFundamentals/Introduction/Introduction.html#//apple_ref/doc/uid/TP0000011) in macOS.
- [**Hackintool**](https://github.com/headkaze/Hackintool) – Powerful post-install utility that everyone should have in their Hackintosh tool box
- [**FindMask**](https://www.insanelymac.com/forum/topic/343572-for-hackers-an-utility-to-search-a-masked-string/?do=findComment&comment=2719931) – CLI to search byte sequences in a file containing masked code.
- [**Disk Drill**](https://www.cleverfiles.com/) – Tool to recover deleted/damaged files.

### Editing plists, updating OpenCore and kexts
Tools for keeping your OpenCore EFI folder so fresh and so clean, clean!

- [**OpenCore Auxiliary Tools (OCAT)**](https://github.com/ic005k/QtOpenCoreConfig) – My goto tool for editing the OpenCore `config.plist`. Mounts EFI, migrates the config to the latest version when saving. Can update OpenCore, Drivers and Kexts to the latest version (Release/Debug/Dev) as well. Highly Recommended.
- [**ProperTree**](https://github.com/corpnewt/ProperTree) – Python-based .plist Editor with unique features like snapshot generation and error checking for OpenCore configs.
- [**PlistEDPlus**](https://github.com/ic005k/PlistEDPlus) – Freeware .plist Editor
- [**PlistOxide**](https://github.com/ChefKissInc/PlistOxide) – Freeware plist Editor build in Rust.
- [**BitmaskDecode**](https://github.com/corpnewt/BitmaskDecode) – Python-based bitmask Calculator for OpenCore (CsrActiveConfig, ScanPolicy, PickerAttributes, etc.)
- [**Meld for macOS**](https://yousseb.github.io/meld/) – Useful app for comparing two config files with one another.
- [**Kext Updater**](https://www.sl-soft.de/en/kext-updater/) – Great App for checking and downloading Kext updates, Boot Manager files, etc.
- [**MountEFI**](https://github.com/corpnewt/MountEFI) – Python Script for mounting the ESP partition
- [**OCConfigCompare**](https://github.com/corpnewt/OCConfigCompare) – Compares your  config with latest sample.plist to migrate (and validate) it. For those who love the drudgery of updating the config manually…
- [**OC Anonymizer**](https://github.com/dreamwhite/OC-Anonymizer) – Python Script for removing sensitive data from a config.plist as well as restoring some default settings.
- [**GenSMBIOS**](https://github.com/corpnewt/GenSMBIOS) – Python-based Tool for generating SMBIOS data.
- [**OpCore Simplify**](https://github.com/lzhoang2801/OpCore-Simplify) – The first tool that automates OpenCore EFI generation based on the detected hardware, including config settings, adding ACPI patches, drivers and kexts. I have tested it on 6 systems now and it works incredibly well – especially on desktop systems. So far, it's the closest thing to having a fully automated OpenCore EFI creation we have to date! Don't sleep on it!

### ACPI-related tools
Tools for getting, generating and editing ACPI tables.

**Editors** (IDE)

- [**MaciASL**](https://github.com/acidanthera/MaciASL) – ASL/AML editor for working with ACPI Tables
- [**Xiasl**](https://github.com/ic005k/Xiasl) – Cross-platform ASL/AML editor with some unique properties.

**Tools**

- [**SSDTTime**](https://github.com/corpnewt/SSDTTime) – Python-Script for dumping DSDT and automated ACPI Hotpatch generation
- [**MmioDevirt**](https://github.com/corpnewt/MmioDevirt) – Python script that can analyse the OC bootlog to generate entries for the MMIO Whitelist.
- [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) – Python Script to generate a SSDT for Legacy CPU Power Management
- [**ACPI Rename**](https://github.com/corpnewt/ACPIRename) – Handy Python script to analyze a `DSDT`. It can list Devices, Methods and Name Paths and can generate HEX values for binray renames.
- [**DarwinDumper**](https://bitbucket.org/blackosx/darwindumper/downloads/) – App for dumping ACPI tables, I/O Registry and more from real Macs.
- [**HackinDROM**](https://hackindrom.zapto.org/) – Online-Tool for generating an SSDT for getting non-Apple Thunderbolt Controllers to work in macOS.

### Audio
- [**PinConfigurator**](https://github.com/headkaze/PinConfigurator) – App for importing and editing PinConfig Data for AppleALC Layout-IDs.

### Laptop-specific
- [**GenI2C_Refresh**](https://github.com/Baio1977/GenI2C) – Updated tool for generating SSDT hotpatches for I2C controlled TouchPads for use with the VoodooI2C.kext.

### macOS Apps (General)
- [**About this Hack**](https://github.com/0xCUB3/About-This-Hack) – Simple app to view your exact hardware in macOS. Similar to how the "About This Mac" window looked prior to macOS 13 but with more features. 
- [**DevCleaner for Xcode**](https://github.com/vashpan/xcode-dev-cleaner) - App for clearing various Xcode caches to reclaim tens of gigabytes of storage.
- [**unpkg**](https://www.timdoug.com/unpkg/) – Utility to unpack .pkg files into a folder instead of installing them on the system.
- [**LuLu**](https://github.com/objective-see/LuLu) – Free open-source macOS firewall.
- [**Find Any File**](https://findanyfile.app/) – FAF can find files that Spotlight doesn't, e.g. on network (NAS) and other external volumes, hidden ones inside bundles and packages, and those in folders that are usually excluded from Spotlight search, such as the System and Library folders.
- [**MonitorControl**](https://github.com/MonitorControl/MonitorControl) – Enables brightness controls for external displays via keyboard/menu bar.

### macOS Virtualization
- [**Create macOS VM Install**](https://github.com/rtrouton/create_macos_vm_install_dmg) – Script to prepare macOS installer disk images for use with virtualization software like VMware Fusion or Parallels Desktop.

### Post-Install Patcher Apps
Tools for patching macOS in Post-Install so it can run on eol/legacy systems.

- [**OpenCore Legacy Patcher**](https://github.com/dortania/OpenCore-Legacy-Patcher) –  OCLP can install NVIDIA and Intel Graphics Drivers removed from macOS 12 and newer as well as re-enable previously working WiFi/BT cards.
- ~~[**GeForce Kepler Patcher**](https://github.com/chris1111/Geforce-Kepler-patcher) – Brings back NVIDIA GeForce Drivers for Kepler Cards in macOS 12 and newer.~~ Superseeded by OCLP
- ~~[**Intel HD 4000 Patcher**](https://github.com/chris1111/Patch-HD4000-Monterey) – For installing Intel HD 4000 iGPU drivers which have been removed from macOS 12 and newer.~~ Superseeded by OCLP

### Cross-Platform
- [**Python Installer**](https://www.python.org/downloads/) – Necessary for running the python-based tools in this list
- [**USBToolbox**](https://github.com/USBToolBox/tool) – USB Port mapping tool. Makes port mapping under macOS 11.3+ easier.

### CPU-related
- [**freqVectorsEdit**](https://github.com/Piker-Alpha/freqVectorsEdit.sh) – Python Script for editing frequency Vectors of Board-ID plists contained in the X86PlatformPlugin.kext
- [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) – Python Script to generate a SSDT for Legacy CPU Power Management
- [**MacCPUID**](https://www.intel.com/content/www/us/en/download/674424/maccpuid.html) –  Shows detailed information of Intel CPUs (Model, Features, Cache, etc.)

### Windows
- [**Windows Install**](https://sourceforge.net/projects/windows-install/) – Easy to use tool to install Windows from an .iso from within macOS.
- [**BlueScreenView**](https://www.nirsoft.net/utils/blue_screen_view.html) –  Displays information about `blue screen of death' crashes containing details about the driver or module that possibly caused the crash.
- [**USB Device Tree Viewer**](https://www.uwe-sieber.de/usbtreeview_e.html) – Helpful tool for analyzing USB ports
- [**CrystalDiskInfo**](https://crystalmark.info/en/software/crystaldiskinfo/) – Great tool for checking the health of hard disks, SSDs and NVMEs.
- [**GPU-Z**](https://www.techpowerup.com/gpuz/) – Provides useful information about your GPU
- [**HWiNFO**](https://www.hwinfo.com/) – Great Tool for getting in-depth info about your system and components
- [**Intel Processor Identification Utility**](https://www.intel.com/content/www/us/en/download/12136/intel-processor-identification-utility-windows-version.html)  – As the name suggests…

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
