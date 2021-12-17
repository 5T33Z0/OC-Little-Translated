# AMD Radeon Performance Tweaks
## About

This chapter contains a few SSDTs and a Kext which improve the performance of AMD Radeon GPUs in OpenCL and Metal applications and lowers the power consumption as well. This method tries to mimic a real working mac.

- SSDT-Navi = indispensable for all Navi 5000-6000 series GPUs.
- SSDT-Matty = as these SSDTs are very invasive and don't always guarantee decent performance.

### Disclaimer

- Use at your own risk! In general, these patches have to be regarded as "experimental". They may work as intentend but that's not guaranteed. 

## Recommended method RX5000\6000 series

- Add `SSDT-NAVI.aml` &rarr; Rename "PEGP" to "EGP0" emulates real Macs with Navi GPUs (only needed for RX 5000/6000 series cards).
- Add Boot-arg `agdpmod=pikera` to config.plist &rarr; Fixes black screen issues on some GPUS).
 
## Alternative method 
- Source [Guide](https://www.tonymacx86.com/threads/amd-radeon-performance-enhanced-ssdt.296555/)

	- For **RX 580**: Use `SSDT-RX580.dsl`
	- For **RX 5500/5500XT**: Use `SSDT-RX5500XT.dsl` 
	- For **RX 5600/5700/5700XT**: Use `SSDT-RX5700XT.dsl`
	- For **RX Vega 64**: Use `SSDT-RXVega64.dsl`
	
- Add the following Kexts to `/Volumes/EFI/EFI/OC/Kexts` and config.plist

	- `DAGPM.kext` (dummy kext which will help with power management for the GPU)
	- `Whatevergreen.kext`

- Add Boot-arg `agdpmod=pikera` to config.plist &rarr; Fixes black screen issues on some GPUS)

## Credits

- mattystonie for the SSDTs and original guide.
- Toleda for `DAGPM.kext`
- Acidanthera for `WhateverGreen.kext`
- Baio1977 for `SSDT-NAVI.aml`
 
