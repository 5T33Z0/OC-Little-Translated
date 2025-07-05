# Enabling AMD Vega 56/64 Cards

This SSDT is derived from analyzing the .ioireg file of an iMacPro1,1. It's a simplified version without additional [performance tweaks](https://github.com/5T33Z0/OC-Little-Translated/tree/main/11_Graphics/GPU/AMD_Radeon_Tweaks).

## Instructions

- Download [**`SSDT-Vega56_64.aml`**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/GPU/AMD_Vega/SSDT-Vega56_64.aml?raw=true) 
- Add it to `EFI/OC/ACPI`and your config.plist
- SMBIOS: use `MacPro7,1` or `iMacPro1,1`
- Save and reboot

## Notes and Credits
- Check and adjust the ACPI path to match the location of the GPU in your system
- Thanks to Baio1977 for the SSDT
