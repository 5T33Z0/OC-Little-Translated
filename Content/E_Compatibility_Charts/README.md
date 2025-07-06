# Compatibility charts
Listed below, you find some charts containing useful information about SMBIOS, Hardware and DRM compatibility as well as NVRAM variables.

## Hardware and macOS compatibility

Component |
:----------
[**SMBIOS Compatibility** (short)](https://docs.google.com/spreadsheets/d/1DSxP1xmPTCv-fS1ihM6EDfTjIKIUypwW17Fss-o343U/edit?usp=sharing) (Google Spreadsheet)</br> [**SMBIOS Compatibility** (full)](https://docs.google.com/spreadsheets/d/1_TNfBpDFt4Q5JWGxLN1r3DWm0UVMooB6SiscN6vt6-E/edit?usp=sharing) (Google Spreadsheet)|
[**CPU Compatibility List for macOS**](https://elitemacx86.com/threads/cpu-compatibility-list-for-macos-intel-amd.863/) (Link)|
[**CPUs used in Apple Macs**](https://docs.google.com/spreadsheets/d/1x09b5-DGh8ozNwN5ZjAi7TMnOp4TDm6DbmrKu86i_bQ/edit#gid=0) (Google Spreadsheet)|
[**AMD GPU Compatibility Chart**](/Content/11_Graphics/GPU/AMD_GPU_Compatbility.md) (md)|
[**WiFi Compatibility Chart**](https://docs.google.com/spreadsheets/d/15gZttFfqgtE9ALhXSrLACh1wnjuevvTJim_vc33kuWI/edit?usp=sharing) (Google Spreadsheet)|
[**SSD Compatibility**](https://docs.google.com/spreadsheets/d/1B27_j9NDPU3cNlj2HKcrfpJKHkOf-Oi1DbuuQva2gT4/edit#gid=0) (Google Spreadsheet)|
[**DRM Compatibility**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.Chart.md) (md)|
[**NVRAM Variables**](https://docs.google.com/spreadsheets/d/1HTCBwfOBkXsHiK7os3b2CUc6k68axdJYdGl-TyXqLu0/edit#gid=0) (Google Spreadsheet)|
[**SMC Keys Knowledge Database**](https://www.insanelymac.com/forum/topic/328814-smc-keys-knowledge-database/) (Link) |

## Picking the right SMBIOS
Choosing an appropriate SMBIOS for your Hackintosh is crucial if you want a smooth running and efficient system. You should chose your SMBIOS based on the following aspects:

- **CPU Vendor and product Family**: Intel? AMD? Mobile? Desktop? NUC? With or without iGPU support?
- **Discrete GPU**: Vendor and Model (ATI/AMD?, NVIDIA?)
- **macOS Version**: 
	- The used CPU family determines the optimal SMBIOS. 
	- Newest macOS versions most likely only support more recent SMBIOSes.
	
For an in-depth guide on choosing the best SMBIOS for your system, please refer to Dortania's [**SMBIOS Guide**](https://dortania.github.io/OpenCore-Install-Guide/extras/smbios-support.html#macos-smbios-list)

### Notes regarding SMBIOS
Things you can do on Hackintoshes that you can't do on real Macs:

- Use higher/newer SMBIOSes to run newer versions of macOS on officially unsupported CPUs.
- Run older versions of macOS with newer/unknown CPUs by utilizing fake CPU-IDs.
- Make use of macOS 11.3+ virtualization capabilities to spoof a supported SMBIOS but let the hardware use the intended SMBIOS for your CPU! Check my [**Boad-ID VMM spoofing**](/Content/09_Board-ID_VMM-Spoof) guide to find out how it works.

## AppleALC Layout IDs sorted by CODEC
This [repo](https://github.com/dreamwhite/ChonkyAppleALC-Build) contains all available AppleALC Layout IDs based on the name of the CODEC, while the official AppleALC repo [lists](https://github.com/acidanthera/AppleALC/wiki/Supported-codecs) them all on one page.

1. Click on the folder for your vendor
2. Find the .md file for your CODEC 
3. Click to open it

Inside, you will find a list of all available Layout-IDs for the selected CODEC with additional info about the system/mainboard it has been created for.

So, if your mainboard uses [ALC1220](https://github.com/dreamwhite/ChonkyAppleALC-Build/blob/master/Realtek/ALC1220.md) for example, you could easily find out if someone already created a Layout ID for it.

## Credits
- Dreamwhite for [**Wifi/BT**](https://docs.google.com/spreadsheets/d/1CNrDxBsmCbCTL_y9ZB7m3q3jHw5X2N8YaYb7IonQ3MI), **SATA** and **NVRAM** variables spreadsheets
- Acidanthera for Whatevergreen FAQs
- Dortania for SMBIOS Support Guide
- Slice for SMC Keys Database
