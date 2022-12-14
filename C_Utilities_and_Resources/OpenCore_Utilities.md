# OpenCore Utilities
The OpenCore package contains lot of additional utilities to set-up, configure and troubleshoot your system. Unfortunately, the `Documentation.pdf` does not include a seperate chapter for these utilities. Below you find a table with the included utilities and what they are for.

Utility | Description
-------:|------------
**acdtinfo** | Lists Kexts by Acidanthera and if they are installed or not.
**ACPIe** | For debugging ACPI tables (cf. Chpt. 4.5: "Patch Properties").
**CreateVault** | For creating a secure vault (cf. Chpt. 8.5: "Security Properties").
**disklabel** | Tool for changing the disk label displayed in BootPicker (cf. Chpts. 8.3 and 11.4).
**FindSerialPort** | Script to find PCIe serial ports and their paths.
**icnspack** |Tool for generating `.icns` files for items displayed in BootPicker (cf. Chpt. 11.4: "OpenCanopy").
**kpdescribe** | Tool to print the stack trace from an OS X kernel panic diagnostic report, along with as much symbol translation as your mach_kernel version provides.
**LegacyBoot** | Tools for [setting up OpenCore on non-UEF systems](https://github.com/dortania/OpenCore-Install-Guide/blob/master/installer-guide/mac-install.md#legacy-setup) (32 and 64 bit).
**LogoutHook** | For troubleshooting NVRAM. Installs as launch daemon on Yosemite and newer, which allows to read NVRAM parametes on shutdown after macOS installer vars are set.
**macrecovery** | Python Script to download the macOS online Recovery partition.
**macserial** | Tool to generate Mac Serials, etc.
**ocpasswordgen** | Tool for generating a password which has to be entered on boot prior to reaching the BootPicker.
**ocvalidate** | Utility to validate whether a `config.plist` matches requirements and conventions imposed by OpenCore.
**Shim-To-Cert** | Utility to extract the public key needed to boot a Linux distro’s kernel directly, as done when using OpenCore with `OpenLinuxBoot`, rather than via GRUB shim.
