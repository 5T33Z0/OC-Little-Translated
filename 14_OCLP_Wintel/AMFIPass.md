# Obtaining `AMFIPass.kext`

## About
The beta version of OpenCore Legacy patcher 0.6.7 introduced a new Kext called `AMFIPass` which allows booting macOS with SIP disabled and AMFI enabled even if root patches have been applied – which would be impossible otherwise. Having AMFI working is required in order to grant 3rd party apps access to external Webcams and Mics. So this is a pretty relevant kext to have if you applied any root patches to your system.

Since AMFIPass is not publicly available yet, we have to extract it from OCLP itself which is a bit of a pain. Once the App is started, it will create a temporary folder with a somewhat dynamic path in the hidden `privat/var/` folder which contains all the files it needs for patching macOS, etc. So it takes a bit of effort to get to the kext…

### Extracting AMFIPass from OpenCore Patcher

1. Download [**OCLP 0.6.7 beta**](https://github.com/dortania/OpenCore-Legacy-Patcher/releases/tag/amfipass-beta-test)
2. Run the App.
3. In the main window, check if you can select the option to "Build and install OpenCore". On Wintel Systems, it will probably be greyed-out: <br> ![oclp01](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/e842dd0a-987f-4f3b-8d1e-bc25d8d75804)
4. In this case, click on "Settings".
5. In the "Target" dropdown menu, change the selection from "Host Model" to any other model in the list – it doesn't matter which one. In this example, I selected Xserve3,1.
6. Next, click on "Return"
7. Back in the main Window, the option to "Build and install OpenCore" will now be available:<br> ![oclp02](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/204fc1ee-ac1c-49af-8537-174c1279b18e)
8. Click on it to start building OpenCore
9. Once building has finished a pop-up will appear: <br> ![oclp03](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/35aa5103-38fc-432c-918e-81927e4593f9)
10. :warning: Click on "View build log"! **DON'T** click on "Install to disk"!
11. Scroll down to the end of the log
12. Select the path and copy it to the clipboard. This path is created *dynamically*, so we have to it the complicated way in order to find the location of the kext: <br>![oclp04](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/1298b71a-bcf0-465a-bde7-4b7555993533)
13. In Finder, select "Go to" > "Go to folder…" (or press CMD+SHIFT+G)
14. Paste in the address and hit Enter to get to the location
15. Next, click on **"OpenCore Patcher Resources (Base)"** and navigate to Kexts/Acidanthera`. There you will finally find "AMFIPass-v1.2.1-RELEASE.zip": <br> ![location](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/25939167-f7aa-4be3-b0c9-bef50ab58983)
16. Copy it to the desktop.
17. Close the OpenCore Patcher App.

### Add AMFIPass to your EFI and Config:

- Mount your EFI
- Add the kext to `EFI/OC/Kexts` 
- Open your config.plist
- Add the kext to Kernel/Add manually or create a new OC Snapshot in ProperTree
- **Optional**: Adjust `MinKernel` to the kernel version which would require AMFI to be disabled in order to boot. For example: `20.0.0` for Big Sur, `21.0.0` for Monterey, `22.0.0` for Ventura, etc.
- Delete boot-arg `amfi_get_out_of_my_way=0x1` or `AMFI=0x80` (if present)
- Save your config and reboot

**Voilà**: Now, you can boot with AMFI enabled and grant 3rd party apps access to Mics and Cameras again!

> **Note**: Once AMFIPass is released on it's own repo, this laborious process will no longer be required.

## Furter Resources

- **More about TCC**: [What TCC does and doesn't](https://eclecticlight.co/2023/02/10/privacy-what-tcc-does-and-doesnt)
- **More about AMFI**: [AMFI: checking file integrity on your Mac](https://eclecticlight.co/2018/12/29/amfi-checking-file-integrity-on-your-mac/)
- **AMFI in macOS 13**: [How does Ventura check an app's security](https://eclecticlight.co/2023/03/09/how-does-ventura-check-an-apps-security/)
- **Another tool to add permissions**: https://github.com/jacobsalmela/tccutil
