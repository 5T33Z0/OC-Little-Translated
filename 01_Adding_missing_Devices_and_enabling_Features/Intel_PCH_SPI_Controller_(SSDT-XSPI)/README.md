# Intel PCH SPI Controller (`SSDT-XSPI`)
Adds Platform Controller Hub (PCH) to IORegistry as `XSPI`. My research showed that `XSPI` is present in the IORegistries of some (not all) 9th Gen Intel Core machines and all 10th Gen Macs (Comet/Ice Lake).

Appllicable to **SMBIOS**:

- macBookPro15,x (9th Gen Intel Core), macBookPro16,x (9th Gen)
- macBookAir9,x (10th Gen)
- iMac20,x (10th Gen)

## Checking if you need `SSDT-XSPI` 
If your system has an existimg PCH SPI Controller, it will be listed in Hackintool:

![](/Users/steezonics/Desktop/Hackintool.png)

If the PCH SPI Controller not present, you don't need this SSDT!

In macOS It's located at the following Addresses:

- **PCI Path**: `PciRoot(0x0)/Pci(0x1F,0x5)`
- **IOReg Path**: `IOService:/AppleACPIPlatformExpert/PCI0@0/AppleACPIPCI/pci8086,6a4@1F,5` 

Before adding `SSDT-XSPI`, it will look like this in IO Registry Explorer:

![](/Users/steezonics/Desktop/IO_Reg_before.png) 

After adding `SSDT-XSPI` to my system (iMac20,2) it is still located at the address, but will now be called `XSPI` – just like on a real iMac20,X: 

![](/Users/steezonics/Desktop/IO_Reag_after.png)

As you can see, the only difference seems to be that there's now a name assigned to the location.  Are there any benefits to it in performance? In don't know. Probably not.

## Credits
- Baio1977 for providing the SSDT
