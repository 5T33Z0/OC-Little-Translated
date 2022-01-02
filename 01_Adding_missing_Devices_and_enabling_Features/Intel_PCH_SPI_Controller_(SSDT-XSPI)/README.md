# Intel PCH SPI Controller (`SSDT-XSPI`) 
Adds Platform Controller Hub (PCH) to IORegistry. My research showed that `XSPI` is present in the IORegistries of some (not all) 9th Gen Intel Core machines and all 10th Gen Macs (Comet/Ice Lake). When added to iMac20,x it is listed in Hackintool's PCIe Tab as "Comet Lake PCH SPI Controller".

Appllicable to **SMBIOS**:

- macBookPro15,x (9th Gen Intel Core), macBookPro16,x (9th Gen)
- macBookAir9,x (10th Gen)
- iMac20,x (10th Gen)

## Screenshot
Here's a screenshot when applied to an **iMac20,2** Hackintosh:

![PCH](https://user-images.githubusercontent.com/76865553/145789067-966c9a2b-39f1-4233-9f4a-a19b3d39c1e0.png)

## Credits
- Baio1977 for providing the SSDT
