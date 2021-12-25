## SMBIOS Compatibility Table

Check the following spreadsheet to find out which SMBIOS is natively supported by which versions of macOS:

https://docs.google.com/spreadsheets/d/1yLZeRFeONwDj1zMoONQAQ4rlodAnME1q5jFXE-q5H8s/edit#gid=0

**NOTES**
This list, although helpful and informative, is not as binding for hackintoshes as it is for real Macs, because…

- …on Hackintoshes, you can use different SMBIOSes to run newer versions of macOS on officially unsupported CPUs.
- …you can run older versions of OSX/macOS on newer CPUs which are not supported by the chosen OSX/macOS by utilizing Fake CPU-IDs.
- …you can make use of macOS Monterey's virtualization capabilities to spoof a supported SMBIOS but let the hardware run on the intended SMBIOS for your CPU! Check my [**Boad-ID VMM spoof guide**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof) to find out how it works.

## WiFi/BT Compatibility
Check the following link to find out which wireless card are supported on macOS Sierra to Monterey:

https://osxlatitude.com/forums/topic/11138-inventory-of-supportedunsupported-wireless-cards-2-sierra-monterey/

And for older Versions of OSX (Snow Leopard to El Capitan), check this list:

https://osxlatitude.com/forums/topic/2120-inventory-of-supportedunsupported-wireless-cards-1-snow-leopard-el-capitan/

## Picking the right SMBIOS
Choosing the correct SMBIOS for your Hackintosh is crucial to get a great working system. Chose your SMBIOS based on the following aspects:

- CPU Family (Intel? AMD? Mobile? Desktop? With or without iGPU support?) 
- Discrete GPU Vendor and Model (AMD? NVIDIA?)
- macOS Version (the optimal SMBIOS is decided by the used CPU but the latest macOS version is most likely only supported by newer SMBIOS.)

For an in-depth guide on choosing the best SMBIOS for your System, please refer to Dortani's [**SMBIOS Guide**](https://dortania-github-io.thrrip.space/OpenCore-Install-Guide/extras/smbios-support.html#how-to-decide)
