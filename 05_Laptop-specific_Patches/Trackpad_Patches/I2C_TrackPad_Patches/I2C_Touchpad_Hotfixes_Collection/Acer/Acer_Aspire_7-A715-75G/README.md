# Acer Aspire 7 A715-75G Touchpad Patches

## Specs
**Model**: Acer Aspire 7 A715-75G-50SA </br>
**Touchpad**: ELAN

## Instructions

- Add **SSDTs**:
	- `SSDT-I2C-TPAD.aml` 
	- `SSDT-I2C1-SPED.aml`
	- `SSDT-XOSI.aml`
- Add `OSI to XOSI` rename &rarr; see `ACPI/Patch` section in `Patches.plist`
- Add **Kexts** &rarr; see `Kernel/Add` section in `Patches.plist` 

## Credits
[**AbhaySingh15**](https://github.com/AbhaySingh15/Acer-aspire-7-A715-75G-Opencore-EFI)
