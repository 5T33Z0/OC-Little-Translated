# Accessing ESP Partition from within Windows

In cases where you can no longer access your EFI folder from within macOS for whatever reason – because you were too lazy to store a backup of your working EFI folder on a FAT32 formatted USB stick *before* messing up your config so now you can't get into macOS any more – there is an easy method to access it via Windows.

Usually, mounting the ESP Partition under Windows is a major pain in the ass. With OCAT however, it's super easy.

## Instructions

1. Boot into Windows
2. Run [**OCAT**](https://github.com/ic005k/OCAuxiliaryTools/releases)
3. Click on "Mount ESP":</br>![](/Users/5t33z0/Desktop/Neuer_Ordner/01.png)
4. From the File Manager, select your EFI Partition from the Dropdown Menu:</br>![](/Users/5t33z0/Desktop/Neuer_Ordner/02.png)
5. Navigate to the config.plist:</br>![](/Users/5t33z0/Desktop/Neuer_Ordner/03.png)
6. Open and fix it
7. Save the config.plist and reboot into macOS
