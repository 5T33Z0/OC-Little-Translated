# Updating OpenCore and Kexts with OCAT and Kext Updater
Currently, the easiest method to keep your OpenCore Files, Config and Kexts up to date is to use a OpenCore Auxiliary Tools (OCAT). OCAT actually merges any changes made to the structure of the config-plist and feature-set, thereby updating it to the latest version, without losing settings. This saves so much time and effort compared to older methods, where you had to do all of this manually. On top of that it updates OpenCore, Drivers and Kexts. So no more additional tools are needed.

## Tools and prerequisites
- Working Internet Connection
- Downlaod and install [**OCAT**](https://github.com/ic005k/QtOpenCoreConfig/releases)
## How-to

### Updating your `config.plist`
1. Run OCAT, check for Updates (Globe Icon)
2. Mount your ESP (seletc Edit > MountESP) or ( M)
3. Open your `config.plist`. If it is outdated, should see some OC Validate warnings (indicated by red warning icon: </br>![OCAT_errors](https://user-images.githubusercontent.com/76865553/138106690-c44543f3-fe82-4369-b07c-02fab777651a.png)
4. Click on the warning symbol to see the errors: </br>![OCAT_errors2](https://user-images.githubusercontent.com/76865553/138106763-c84bfcdc-8813-46bd-9b2d-9537dc631aa2.png)
5. Close the warnings
6. Hit the Save Button (good Old Floppy Disk Icon)
7. The error may be gone, if just some features were missing:</br>
![Save](https://user-images.githubusercontent.com/76865553/138106803-0c118267-2f43-4ad6-802e-27efba7cd313.png)
8. After Saving, the icon should change and the errors should be gone: </br>
![ConfigOK](https://user-images.githubusercontent.com/76865553/138106894-a2a6de27-cc23-4203-85d0-7788e5eac6e2.png)</br>
(Any remaining erors are actually configurattion errors which you need to fix on your own.)
10. You're already done with updating your config. On to updating files…

### Updating OpenCore Files, Drivers, Kexts and Resourcse
1. Still in OCAT, ckick on the icon which looks like a Recycle symbol: ![Update](https://user-images.githubusercontent.com/76865553/138106950-faeda539-632f-4083-b8cc-fba490428069.png)
2. In the next dialog window, you can see which files will be updated: ![Updates](https://user-images.githubusercontent.com/76865553/138300386-131df05f-fd57-404b-83b2-fa2386944362.png)

3. Once you hit the "Start Sync" Button the listed Files (including Resources) will be updated and you will be notified once it's done:</br> ![Done](https://user-images.githubusercontent.com/76865553/138107072-9af89efb-2543-4f95-ab82-59748cf78306.png)
4. Done. 
