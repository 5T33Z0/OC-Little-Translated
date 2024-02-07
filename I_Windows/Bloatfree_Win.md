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
2. Select the Windows Build (here Windows 11, 23H2):<br>![alt text](upload_2024-2-7_5-53-13.png)
3. Pick an `X64` build of your choice
4. Select your preferred language and click "Next"
5. Choose the Windows edition(s) that should be included in the ISO and click "Next":<br>![picture 0](images/aebc3140e8957b38ee7e414247a6d9f97bf1174001217268d0c1043e86e62833.png)
6. In the next Window, set the following options (should be enabled by default):<br>![picture 1](images/8723e80135b9ce1dd8f4df80a7a80054fd9d6c39cba0191a2990634c08adeeed.png)
7. Click on "Create Download Package"
8. Unpack the .zip file. It contains these files:<br>![picture 2](images/12df44193729e18d042c1b21ae961ab652440287c5e7f12593eac4e3a862da6b.png)  
9. Open the `ConvertConfig.ini` file and change the following Settings from `0` to `1` and save the file:
    ```PowerShell
    [Store_Apps]
    SkipApps =1
    CustomList =1
    ```
10. Next, open the `CustomApps.txt` file. It contains all the apps that are available in the selected windows build: <br> ![picture 3](images/c9cf383ed68ee6d9a9eef8e372dd8b99a11e6b8129ab2609d830da966a3fa39e.png)  
11. Most of the apps are disabled (commented-out) by default via `#`. To enable any of them, you only have to delete the `#` in front of them.
12. Once you've decided which features you want, double-click the `uup_download_windows.cmd` to start the download and build process.

The necessary files wll be downloaded from Microsoft Servers and the iso will be compiled. This takes about an hour or so. Afterwards you will have a super-clean vanilla Windows ISO without any garbage apps and without having to mess with powershell or the registry.

> [!TIP]
>
> If you want multimedia support, you should definitely uncomment the entries in the "Media Codecs" section of `CustomApps.txt`!

## Bonus: Installing Windows 10/11 with Ventoy
Once the ISO has been build, you can copy it onto a bootable USB flash drive created with [Ventoy](https://www.ventoy.net/en/index.html) and boot directly from the ISO. If you choose "Wimboot" as an option, this even allows you to install Windows 11 on systems without Secureboot or a TPM2 module.