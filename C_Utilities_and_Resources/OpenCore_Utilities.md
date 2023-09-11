# OpenCore Utilities
The OpenCore package contains lot of additional utilities to set-up, configure and troubleshoot your system. Unfortunately, the `Documentation.pdf` does not include a separate chapter for these utilities. Below you find a table with the included utilities and what they are for with references to the corresponding chapters in the documentation.

Utility | Description
-------:|------------
**acdtinfo** | Lists Kexts by Acidanthera and if they are installed or not.
**ACPIe** | For debugging ACPI tables (cf. Chpt. 4.5: "Patch Properties").
**CreateVault** | For creating a secure vault (cf. Chpt. 8.5: "Security Properties").
**disklabel** | Tool for changing the disk label displayed in BootPicker (cf. Chpts. 8.3 and 11.4).
[**EnableGop**](https://github.com/acidanthera/OpenCorePkg/tree/master/Staging/EnableGop)| Provides standalone GOP driver for EFI era Mac Pro and iMac.
**FindSerialPort** | Script to find PCIe serial ports and their paths (cf. Chpt. 8.6.1: "Serial Custom Properties").
**icnspack** |Tool for generating `.icns` files for items displayed in BootPicker (cf. Chpt. 11.4: "OpenCanopy").
**kpdescribe** | Tool to print the stack trace from an OS X kernel panic diagnostic report, along with as much symbol translation as your mach_kernel version provides (cf. Chpt. 8.4: "Debug Properties").
**LegacyBoot** | Tools for [**setting up OpenCore on legacy/Non-UEFI systems**](https://github.com/dortania/OpenCore-Install-Guide/blob/master/installer-guide/mac-install.md#legacy-setup) (32 and 64 bit).
**LogoutHook** | For troubleshooting NVRAM. Installs as launch daemon on Yosemite and newer, which allows to read NVRAM parameters on shutdown after macOS installer vars are set (cf. Chpt. 11.9: "OpenVariableRuntimeDxe").
**macrecovery** | Python Script to download the macOS online Recovery partition (cf. Chpt. 12.5: "Tips and Tricks"). There's also a [**gibMacRecovery**](https://github.com/corpnewt/gibMacRecovery) available which provides a GUI for this script.
**macserial** | Tool to generate SMBIOS data (cf. Chpt. 10.6: "SMBIOS Properties"). Also availably as python script called [**GenSMBIOS**](https://github.com/corpnewt/GenSMBIOS) which provides a GUI.
**ocpasswordgen** | Tool for generating a password which has to be entered on boot prior to reaching the BootPicker (cf. Chpt. 8.5: "Security Properties").
**ocvalidate** | Utility to validate whether a `config.plist` matches requirements and conventions imposed by OpenCore (cf. Chpt. 2.3 "Configuration Structure").
**ShimUtils** | Set of utilities to prepare your system to boot Linux from within OpenCore and sign security certificates so Secure Boot can be used. For details, read the included README.md file and check chapter 11.7: "OpenLinuxBoot" of the Configuration.pdf.
