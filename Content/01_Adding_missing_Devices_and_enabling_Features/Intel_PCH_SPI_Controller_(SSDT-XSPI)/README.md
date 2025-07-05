# Intel PCH SPI Controller (`SSDT-XSPI`)

## About
`SSDT-XSPI` adds Platform Controller Hub (PCH) to IORegistry as `XSPI`. Research showed that `XSPI` is present in the IORegistries of some (not all) 9th Gen Intel Core machines and all 10th Gen Macs (Comet/Ice Lake).

Applicable to **SMBIOS**:

- **macBookPro15,x** (9th Gen Intel Core)
- **macBookPro16,x** (9th Gen)
- **macBookAir9,x** (10th Gen)
- **iMac20,x** (10th Gen)

## Checking if you need `SSDT-XSPI` 
If your system has an existing PCH SPI Controller, it will be listed in Hackintool:

![Hackintool](https://user-images.githubusercontent.com/76865553/166139767-1a21a57b-9ea8-419d-82e6-5d1fabdefed5.png)

If the PCH SPI Controller is not present, you don't need this SSDT!

It's located at the following Addresses:

- **PCI Path**: `PciRoot(0x0)/Pci(0x1F,0x5)`
- **IOReg Path**: `IOService:/AppleACPIPlatformExpert/PCI0@0/AppleACPIPCI/pci8086,6a4@1F,5` 

Before adding `SSDT-XSPI`, it will look like this in IO Registry Explorer:

![IO_Reg_before](https://user-images.githubusercontent.com/76865553/166139773-b954babc-d26f-42bb-8c1c-1ba5dab1359d.png)

After adding `SSDT-XSPI` to my system (iMac20,2) it is still located at the same address, but will now be called `XSPI` – just like on a real iMac20,X: 

![IO_Reg_after](https://user-images.githubusercontent.com/76865553/166139780-554d5c20-6d92-4003-87fb-3bcc609b6128.png)

As you can see, the only difference seems to be that there's now a name assigned to the location. Are there any benefits to it in performance? I don't know. Probably not.

## Credits
- Baio1977 for providing the SSDT
