# Acer Swift 3 Touchpad Patch
> **Patch by**: shekoski

## Laptop specs

**Model**: Acer Swift 3 SF314-56G-59A4 </br>
**Touchpad**: ELAN0504

## Instructions:

- Add **SSDTs**:
	- `SSDT-IRQFix.aml` 
	- `SSDT-TPD1.aml`
	- `SSDT-I2CxConf`
- Add **Touchpad Kexts**:
	- VoodooI2C.kext
	- VoodooI2CHID.kext
- Add Patches to `config.plist`:
	- &rarr; see `Patches.plist`
