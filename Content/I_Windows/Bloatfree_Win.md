# Creating a bloatfree Windows 10/11 ISO

Recently, I looked into debloating Windows 10/11 without having to tamper with Windows in post-install using Powershell and/or Registry "hacks". One option I found was manually editing the `install.wim` file with DISM or a gui-based PowerShell script called WIMWitch. But this was not really satisfying since it takes a lot of time and effort, is rather complicated and the approach is rather outdated. So I kept looking…

## UUPDump to the rescue
I found this website called [UUPDump](https://uupdump.net/) which lets you select, the version of Windows, Language, Edition, and which additional features/apps should be included in the final ISO. 

>The Unified Update Platform (UUP) is the latest generation of Microsoft's update delivery method, catering to all devices that run modern Windows-based OSes. […]
>
>The beauty of UUP lies in limiting the size of individual downloads. Instead of downloading the same monolithic update package to every device, it downloads only the necessary set of files for the target system for which updates are available. For a full Windows build, you aren't required to download a full-fledged ISO file or an encrypted ESD package, because UUP handles it by generating a list of highly compressed payloads based on the principle of differential upgrades, and then executing the relevant staging operations after a successful download, followed by the commits.
>
> **SOURCE**: [XDA Developers](https://www.xda-developers.com/uup-dump-windows-11-10-iso-update/)

So instead of downloading and manipulating the default Windows ISO (prior to installing the OS), or removing Apps after the fact, you can use the UUPDump method to build a fully functional, clean Windows ISO from scratch, only containing the components you want/need. This way, you can have a clean vanilla Windows install without all the additional garbage like Microsoft's `AppXPackages` (aka Apps from the Microsoft Store).

>[!NOTE]
>
> Using Windows to download and convert/build the iso is recommended since macOS doesn't offer all options and also requires homebrew.

### Instructions

1. Visit [**UUPDump**](https://uupdump.net/)
2. Select the Windows Build (here Windows 11, 23H2):<br>![upload_2024-2-7_5-53-13](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/a484c05f-6fea-439b-84df-1ae7dcc4e0dc)
3. Pick an `X64` build of your choice
4. Select your preferred language and click "Next"
5. Choose the Windows edition(s) that should be included in the ISO and click "Next":<br>![aebc3140e8957b38ee7e414247a6d9f97bf1174001217268d0c1043e86e62833](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/c20d3281-cc2a-4704-b795-e18949f4affe)
6. In the next Window, set the following options (should be enabled by default):<br>![8723e80135b9ce1dd8f4df80a7a80054fd9d6c39cba0191a2990634c08adeeed](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/01704a39-206d-4e6b-aeba-038b2d446403)
7. Click on "Create Download Package"
8. Unpack the .zip file. It contains these files:<br>![12df44193729e18d042c1b21ae961ab652440287c5e7f12593eac4e3a862da6b](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/e02ae73b-300b-4f73-845d-dd9a9b4824a3)
9. Open the `ConvertConfig.ini` file and change the following Settings from `0` to `1` and save the file:
    ```PowerShell
    [Store_Apps]
    SkipApps =1
    CustomList =1
    ```
10. Next, open the `CustomApps.txt` file. It contains all the apps that are available in the selected windows build:<br>![c9cf383ed68ee6d9a9eef8e372dd8b99a11e6b8129ab2609d830da966a3fa39e](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/3b69926e-fe4e-4f8c-9582-0af9bfad3d9f)
11. Most of the apps are disabled (commented-out) by default via `#`. To enable any of them, you only have to delete the `#` in front of them.
12. Once you've decided which features you want, double-click `uup_download_windows.cmd`. The necessary files to build the ISO will be downloaded from Microsoft Servers and then the image will be compiled. This takes about an hour or so. Afterwards, you will have a super-clean vanilla Windows ISO without any garbage apps and without having to mess with powershell or the registry.

> [!TIP]
>
> If you want multimedia support, you should definitely uncomment the entries in the "Media Codecs" section of `CustomApps.txt`!

## Troubleshooting

### Reinstalling the Microsoft Store
- Open the Command Prompt as an administrator 
- Type `wsreset -i` The issue should be fixed in a few minutes.

## Bonus

### Installing Windows 10/11 with Ventoy
Once the ISO has been build, you can copy it onto a bootable USB flash drive created with [Ventoy](https://www.ventoy.net/en/index.html). Reboot the system from the USB flash drive and select the Windows iso from the menu. If you choose "Wimboot" as boot method, this even allows you to install Windows 11 on systems with Secure Boot enabled as well as on systems that don't have a TPM2 module, which is a requirement for installing Windows 11.

### XML Generator for unattended install

There's an online generator for creating an XML file for unattended Windows installs. **Link**: https://schneegans.de/windows/unattend-generator/ 

When using Ventoy for installing Windows, you have to use [Plugson](https://ventoy.net/en/plugin_plugson.html) to prepare the USB flash drive for unattended installs.



