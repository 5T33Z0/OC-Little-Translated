# OpenCore Calculators
This is my clumsy approach to calculate the correct values for the following bitmasks, using an Apple Numbers [Spreadsheet](https://github.com/5T33Z0/OC-Little-Translated/blob/main/B_OC_Calculators/OpenCoreCalcs.numbers):

Bitmask | Description
------|-----------
[`csr-active-config`](https://github.com/5T33Z0/OC-Little-Translated/blob/main/B_OC_Calculators/SIP_Flags_Explained.md) | Bitmask to configure (or disable) System Integrity Protection
`PickerAttributes` | Bitmask to configure the look and feel of the BootPicker
`ScanPolicy` | Bitmask to configure the device types and file systems shown in OpenCore's BootPicker 
`ExposeSensitiveData` | Bitmask to configure Sensitive data exposure to the OS
`Target` | Bitmask to configure logging capabilities
`Darkwake` | For calculating a value for darkwake

<details>
<summary><strong>Screenshots</strong> (click to reveal)</summary><br>

![csr](https://github.com/user-attachments/assets/a42ef173-aeeb-4d6f-8df1-f98002b91451)

![Bildschirmfoto 1](https://user-images.githubusercontent.com/76865553/134348928-ee19f359-c8fd-4e16-a99e-2cd652c9c64b.png)

![Bildschirmfoto 2](https://user-images.githubusercontent.com/76865553/134348939-d3eac5b2-02d3-4b98-9652-4ef52bde0c0d.png) 

![Bildschirmfoto 3](https://user-images.githubusercontent.com/76865553/134348951-c113b897-74aa-4bd1-8b46-0973119ed5e2.png)

![Bildschirmfoto 4](https://user-images.githubusercontent.com/76865553/134348958-481e2632-d417-416f-ad0b-14158137149f.png)

![Darkwake](https://user-images.githubusercontent.com/76865553/137449526-2d6ef0e4-f4da-47d1-b12a-18f03b3fc29e.png)
</details>

## Web Applications
Some of these calculators are also available as web applications:

- **ScanPolicy Generator**: https://oc-scanpolicy.vercel.app
- **ExposeSensitiveData Generator**: https://dreamwhite-oc-esd.vercel.app/

## Tools
If you are looking for an actual tool to calculate these things, check the following:

- [**OC ToolBox**](https://github.com/webfalter/OCToolBox) – App for calculating `csr-active-config`, etc.
- [**BitmaskDecode**](https://github.com/corpnewt/BitmaskDecode) – Python script which can generate most of the mentioned bitmasks (except for Darkwake).
- [**OCAuxiliaryTools**](https://github.com/ic005k/OCAuxiliaryTools) – OpenCore Configurator App which can generate `ScanPolicy`, `PickerAttributes` and `ExposeSensitiveData`
