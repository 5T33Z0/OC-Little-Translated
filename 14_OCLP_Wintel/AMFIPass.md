# Obtaining `AMFIPass.kext`

## About
The beta version of OpenCore Legacy patcher 0.6.7 introduced a new Kext called `AMFIPass` which allows booting macOS with SIP disabled and AMFI enabled even if root patches have been applied – which would be impossible otherwise. Having AMFI working is required in order to grant 3rd party apps access to external Webcams and Mics. So this is a pretty relevant kext to have if you applied any root patches to your system.

Since AMFIPass is not publicly available yet, we have to extract it from the OpenCore Patcher itself. This used to be a real drag but Chriss1111 has written a [bash script](https://github.com/5T33Z0/OC-Little-Translated/issues/75) which makes the process a lot easier.

### Extracting AMFIPass from OpenCore Patcher
1. Download and unzip [**OCLP 0.6.7 beta**](https://github.com/dortania/OpenCore-Legacy-Patcher/releases/tag/amfipass-beta-test)
2. Download and unzip [**AMFIPass-v1.2.1-Extract.zip**](https://github.com/5T33Z0/OC-Little-Translated/files/11611061/AMFIPass-v1.2.1-Extract.zip)
3. Right-click the OpenCore-Patcher app to bring up the context menu
4. Hold <kbd>Alt</kbd> to show additional options. This changes the option "Copy" to "Copy as path"
5. Select "Copy OpenCore-Patcher as path name" (or similar)
6. Now run AMFIPass-v1.2.1-Extract
7. Press <kbd>CMD</kbd>+<kbd>V</kbd> to paste in the path to the OpenCore-Patcher.app and hit <kbd>Enter</kbd>.
8. Once the extraction is done, `AMFIPass-v1.2.1-RELEASE.zip` will be available on your desktop  

### Add AMFIPass to your EFI and Config:

- Mount your EFI
- Add the kext to `EFI/OC/Kexts` 
- Open your config.plist
- Add the kext to Kernel/Add manually or create a new OC Snapshot in ProperTree
- **Optional**: Adjust `MinKernel` to the kernel version which would require AMFI to be disabled in order to boot. For example: `20.0.0` for Big Sur, `21.0.0` for Monterey, `22.0.0` for Ventura, etc.
- Delete boot-arg `amfi_get_out_of_my_way=0x1` or `AMFI=0x80` (if present)
- Save your config and reboot

**Voilà**: Now, you can boot with AMFI enabled and grant 3rd party apps access to Mics and Cameras again!

> **Note**: 
> <ul><li> You will still need `AMFI=0x80` before re-applying root patches after installing system updates
> <li> Once AMFIPass is released on it's own repo, this laborious process will no longer be required.

## Furter Resources

- **More about TCC**: [What TCC does and doesn't](https://eclecticlight.co/2023/02/10/privacy-what-tcc-does-and-doesnt)
- **More about AMFI**: [AMFI: checking file integrity on your Mac](https://eclecticlight.co/2018/12/29/amfi-checking-file-integrity-on-your-mac/)
- **AMFI in macOS 13**: [How does Ventura check an app's security](https://eclecticlight.co/2023/03/09/how-does-ventura-check-an-apps-security/)
- **Another tool to add permissions**: https://github.com/jacobsalmela/tccutil

## Credits
- Dortania for OpenCore Legacy Patcher and Guide
- dhinakg for AMFIPass
- Chriss1111 for AMFIPass Extract
