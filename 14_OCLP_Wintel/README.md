# Installing newer versions of macOS on legacy hardware

Although you can use OpenCore and the OpenCore Legacy Patcher (OCLP) to install newer versions of macOS on unsupported Wintel systems, it's not officially supported nor documented by Dortania. 

Officially, OCLP only supports end of life or "legacy" Macs by Apple. But you can use it on Wintel systems in Post-Install as well in order to re-install iGPU/GPU drivers and required Frameworks for example. It also offers other great patches which allow: booting with the correct SMBIOS for the used CPU, re-enabling SMC CPU Power Management in macOS Ventura and working around issues with System Updates caused by disabling SIP.

As of now I only have a guide for Ivy Bridge systems. But if you have one for Sandy Bridge, Haswell or Skylake I will be pleased to add it to the database as well.

## Available Guides
- Installing macOS Ventura on Ivy Bridge systems
