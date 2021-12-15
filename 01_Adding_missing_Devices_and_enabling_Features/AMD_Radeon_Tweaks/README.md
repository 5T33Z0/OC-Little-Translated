# AMD Radeon Performance Tweaks
## About
This Chapter contains a few SSDTs and a Kext which improve the performance with OpenCL and Metal applications and lowers the power consumption as well. This method tries to mimic a real working mac.

## Partching Principle

1. Add the correct SSDT for your graphics card to `/Volumes/EFI /EFI/OC/ACPI` and config.plist:

	- For **RX 580**: Use `SSDT-RX580.aml`
	- For **RX 5500/5500XT**: Use `SSDT-RX5500XT.aml` 
	- For **RX 5600/5700/5700XT**: Use `SSDT-RX5700XT.aml`
	- For **RX Vega 64**: Use `SSDT-RXVega64.aml`
	
	**NOTE**: Don't use on RX 6800XT – it won't work.

2. Add the following Kexts to `/Volumes/EFI/EFI/OC/Kexts` and config.plist

	- `DAGPM.kext` (dummy kext which will help with power management for the GPU)
	- `Whatevergreen.kext`

3. Add the following binary rename to ACPI > Patch:
	
	```
	Find: 50454750
	Replace: 45475030
	Comment: Rename PEGP to EGP0

3. Add Boot-arg `agdpmod=pikera` to config.plist &rarr; Fixes black screen issues on some GPUS)

## Credits
- mattystonie for the SSDTs and original [Guide](https://www.tonymacx86.com/threads/amd-radeon-performance-enhanced-ssdt.296555/)
- Toleda for `DAGPM.kext`
- Acidanthera for `WhateverGreen.kext` 
 