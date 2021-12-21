# AMD Radeon Performance Tweaks

## About
This chapter contains a few SSDTs and a Kext which improve the performance of AMD Radeon GPUs in OpenCL and Metal applications and lowers the power consumption as well. This method tries to mimic a real working mac.

### Disclaimer
- Use at your own risk! In general, these patches have to be regarded as "experimental". They may work as intentend but that's not guaranteed. 

## Patching GPU Navi (Recommended)

1. Add `SSDT-NAVI.aml` &rarr; Renames `PEGP` to `EGP0` so the GPU works (required for RX 5000/6000 Series Cards only).
2. Add Boot-arg agdpmod=pikera to config.plist → Fixes black screen issues on some GPUS).


## Patching GPU by Matty

1.Choose SSDT based on the appropriate GPU model

  - For **RX 580**: Use `SSDT-RX580.aml
  - For **RX 5500/5500XT**: Use `SSDT-RX5500XT.aml` 
  - For **RX 5600/5700/5700XT**: Use `SSDT-RX5700XT.aml`
  - For **RX Vega 64**: Use `SSDT-RXVega64.aml`
	
2. Add the following Kexts to `/Volumes/EFI/EFI/OC/Kexts` and config.plist

  - `DAGPM.kext` (dummy kext which will help with power management for the GPU)
  - `Whatevergreen.kext`

3. Only GPU Navi add Boot-arg `agdpmod=pikera` to config.plist &rarr; Fixes black screen issues on some GPUS)

## Credits
- mattystonie for the SSDTs and original [Guide](https://www.tonymacx86.com/threads/amd-radeon-performance-enhanced-ssdt.296555/)
- Toleda for `DAGPM.kext`
- Acidanthera for `WhateverGreen.kext`
- Baio1977 for `SSDT-NAVI.aml`
 
