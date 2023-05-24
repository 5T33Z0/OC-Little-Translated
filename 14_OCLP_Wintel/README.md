# Installing newer versions of macOS on legacy hardware

## About

Although you can use OpenCore and the OpenCore Legacy Patcher (OCLP) to install newer versions of macOS on unsupported Wintel systems, it's not officially supported nor documented by Dortania. 

Officially, OCLP only supports end of life (or "legacy") Macs by Apple. But you can use it on Wintel systems in Post-Install as well in order to re-install iGPU/GPU drivers and required Frameworks for example. It also offers other great patches which allow: booting with the correct SMBIOS for the used CPU, re-enabling SMC CPU Power Management in macOS Ventura and working around issues with System Updates caused by disabling SIP.

As of now, I only finished the guide for Ivy Bridge systems which has been tested and confirmed working by other users. Currently, I am working on the one for Sandy Bridge. Next will be Haswell, then Skylake (which takes the least amount of effort and changes).

## Available Guides
- [Installing macOS Ventura on Sandy Bridge systems](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Sandy_Bridge_Ventura.md) (WIP)
- [Installing macOS Ventura on Ivy Bridge systems](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Ivy_Bridge-Ventura.md#installing-macos-ventura-on-ivy-bridge-systems)

