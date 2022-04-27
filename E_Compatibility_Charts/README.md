# Compatibility charts
Listed below, you find some charts containing useful information about SMBIOS, Hardware and DRM compatibility as well as NVRAM variables.

## SMBIOS Compatibility Chart
Check this [spreadsheet](https://docs.google.com/spreadsheets/d/1yLZeRFeONwDj1zMoONQAQ4rlodAnME1q5jFXE-q5H8s/edit#gid=0) to find out which SMBIOS is natively supported by which versions of macOS.

**NOTES**

This list, although helpful and informative, is not as binding for hackintoshes as it is for real Macs, because…

- …on Hackintoshes, you can use different SMBIOSes to run newer versions of macOS on officially unsupported CPUs.
- …you can run older versions of OSX/macOS on newer CPUs which are not supported by the chosen OSX/macOS by utilizing Fake CPU-IDs.
- …you can make use of macOS Monterey's virtualization capabilities to spoof a supported SMBIOS but let the hardware run on the intended SMBIOS for your CPU! Check my [**Boad-ID VMM spoof guide**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof) to find out how it works.

### Picking the right SMBIOS
Choosing an appropriate SMBIOS for your Hackintosh is crucial if you want a smooth running and efficiant system. You should chose your SMBIOS based on the following aspects:

- **CPU Vendor and product Family**: Intel? AMD? Mobile? Desktop? NUC? With or without iGPU support?
- **Discrete GPU**: Vendor and Model (ATI/AMD?, NVIDIA?)
- **macOS Version**: the used CPU family determines the optimal SMBIOS. But the latest macOS version is most likely only supported by more recent SMBIOSes.

For an in-depth guide on choosing the best SMBIOS for your system, please refer to Dortania's [**SMBIOS Guide**](https://dortania-github-io.thrrip.space/OpenCore-Install-Guide/extras/smbios-support.html#how-to-decide)

## Apple ALC Layout ID's by CODEC
This repo lists all available Apple ALC Layout IDs based on the name of the CODEC. Just open the .md file for your CODEC to find out if a Layout for your system exists already https://github.com/dreamwhite/applealc-layouts

## Intel CPUs used in real Macs
Check this [spreadsheet](https://docs.google.com/spreadsheets/d/1x09b5-DGh8ozNwN5ZjAi7TMnOp4TDm6DbmrKu86i_bQ/edit#gid=0)

## WiFi/BT Compatibility Chart
Check this [spreadsheet](https://docs.google.com/spreadsheets/d/1CNrDxBsmCbCTL_y9ZB7m3q3jHw5X2N8YaYb7IonQ3MI) to find out which wireless card are supported on macOS Lion to Monterey.

## SSD Compatibility Chart
Check this [spreadsheet](https://docs.google.com/spreadsheets/d/1B27_j9NDPU3cNlj2HKcrfpJKHkOf-Oi1DbuuQva2gT4/edit#gid=0) if you are looking for a compatible SSD for your Hackintosh.

## DRM Compatibilty (macOS 10.15+)
https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.Chart.md

## NVRAM Variables
https://docs.google.com/spreadsheets/d/1HTCBwfOBkXsHiK7os3b2CUc6k68axdJYdGl-TyXqLu0/edit#gid=0

## Credits
- Dreamwhite for Wifi/BT, SATA and NVRAM variables spreadsheets
- Acidanthera for Whatevergreen FAQs
- Dortania for SMBIOS Support Guide
