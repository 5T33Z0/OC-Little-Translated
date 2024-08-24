# Fetching kext upates from the OpenCore Legacy Patcher repo with OCAT

## About

As you may or my not know, you can add kexts to check for updates in OpenCore Auxiliary Tools. Usually, you do this in the app: just add the name of the kext and the corresponding repo URL to OCAT's "Kext Upgrade URL" list accessible from the "Sync" window and the next time you check for kext it can fetch it. If it doesn't know a kext's URL it's marked grey. But adding every single entry for kexts available on OCLP's repo to OCAT manually is quite a pain. So instead of adding the kexts one by one in the app, we can edit the textfile that contains the URLs directly and just paste a list of kext URLs. 

## Instructions

1. Right-click on OCAT App and select "Show Package contentes" 
2. Navidate to `/OCAuxiliaryTools.app/Contents/MacOS/Database/preset/KextUrl.txt`
3. Open `KextUrl.txt`
4. Add the following entries:
    ```
    AMFIPass.kext | https://github.com/dortania/OpenCore-Legacy-Patcher
    AppleIntelCPUPowerManagement.kext | https://github.com/dortania/OpenCore-Legacy-Patcher
    AppleIntelCPUPowerManagementClient.kext | https://github.com/dortania/OpenCore-Legacy-Patcher
    ASPP-Override.kext | https://github.com/dortania/OpenCore-Legacy-Patcher
    AutoPkgInstaller.kext | https://github.com/dortania/OpenCore-Legacy-Patcher
    BacklightInjector.kext | https://github.com/dortania/OpenCore-Legacy-Patcher
    Bluetooth-Spoof.kext | https://github.com/dortania/OpenCore-Legacy-Patcher
    CatalinaBCM5701Ethernet.kext | https://github.com/dortania/OpenCore-Legacy-Patcher
    CatalinaIntelI210Ethernet.kext | https://github.com/dortania/OpenCore-Legacy-Patcher
    CryptexFixup.kext | https://github.com/dortania/OpenCore-Legacy-Patcher
    corecaptureElCap.kext | https://github.com/dortania/OpenCore-Legacy-Patcher
    AppleIntelCPUPowerManagement.kext | https://github.com/dortania/OpenCore-Legacy-Patcher
    AppleIntelCPUPowerManagementClient.kext | https://github.com/dortania/OpenCore-Legacy-Patcher
    ECM-Override.kext | https://github.com/dortania/OpenCore-Legacy-Patcher
    IO80211ElCap.kext | https://github.com/dortania/OpenCore-Legacy-Patcher
    IO80211FamilyLegacy.kext | https://github.com/dortania/OpenCore-Legacy-Patcher
    IOSkywalkFamily.kext | https://github.com/dortania/OpenCore-Legacy-Patcher 
    KDKlessWorkaround.kext | https://github.com/dortania/OpenCore-Legacy-Patcher
    RSRHelper.kext | https://github.com/dortania/OpenCore-Legacy-Patcher
    USB-Map.kext | https://github.com/dortania/OpenCore-Legacy-Patcher
    ```
5. Save the file
6. Restart OCAT
7. Open your config.plisst
8. Check for kext updates
9. Kexts from the OCLP repo that had a grey indicator should now be green.
10. Update kexts

## Notes
This list is incomplete. So, if you need additional kexts for the OCLP repo, just add a new line to `KextUrl.txt`, enter the name of the kext followd by `|` and the URL of the OCLP repo.
