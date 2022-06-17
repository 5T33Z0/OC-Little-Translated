# Slimming AppleALC Kext
This guide is for compiling AppleALC for your Codec only. This reduced the kext from 3.8 MB to around 90 kilobytes.

## Preparations
- Install and configure Xcode as [described here](https://github.com/5T33Z0/OC-Little-Translated/tree/main/L_ALC_Layout-ID#configuring-xcode)
- Install a Plist Editor
- Download [AppleALC](https://github.com/acidanthera/AppleALC) Source Code (click on "Code" and "Download Zip") 
- Unpack the .zip file
- In Terminal, enter: `cd`, hit space, drag the AppleALC folder into the Terminal window and press enter.
- Next, enter git clone `https://github.com/acidanthera/MacKernelSDK` and hit enter. This adds the MacKernelSDK in the AppleALC source folder.
- Add the Debug version of [Lilu.kext](https://github.com/acidanthera/Lilu/releases) to the AppleALC folder.
- The resulting folder structure should look like this:</br>![](https://user-images.githubusercontent.com/76865553/173291777-9bc1285d-1ffa-479f-b7bf-b74cda6f23ae.png)

## Slimming the files

### 1. Deleting unused Codecs
- Enter the Resources folder:</br>![](/Users/5t33z0/Desktop/Neuer Ordner/01.png)
- Delete the folders which are not for your Codec. In my case, I only keep the ALC269 folder:</br>![](/Users/5t33z0/Desktop/Neuer Ordner/02.png)

### 2. Removing unused Layouts and Platforms
- Next, enter the folder for your Codec:</br>![](/Users/5t33z0/Desktop/Neuer Ordner/03.png)
- Delete the layout and Platforms.xml files which are NOT the one you are using. In my case, I keep the files for Layout and Platforms 18 and 39:</br>![](/Users/5t33z0/Desktop/Neuer Ordner/05.png)
- Next, open the `Info.plist` in the same folder with a Plist Editor:</br>![](/Users/5t33z0/Desktop/Neuer Ordner/09.png)
- Delete all the entries for Layouts and Platforms you don't intend to use. You have to look inside the entries or use the search function to find yours to keep. In my case, I keep Layouts 18 and 39 and Platforms 18 and 39:</br>![](/Users/5t33z0/Desktop/Neuer Ordner/10.png)
- Save the file

### 3. Removing Layouts from `PinConfig.kext`
- Select PinConfig.kext in the AppleALC folder:</br>![](/Users/5t33z0/Desktop/Neuer Ordner/04.png)
- Right-click the `PinConfig.kext` and select "Show Package Contents":</br>![](/Users/5t33z0/Desktop/Neuer Ordner/06.png)
- Open the info.plist with a Plist Editor:</br>![](/Users/5t33z0/Desktop/Neuer Ordner/07.png)
- Delete the Dictionaries which do not contain your Layout-ID. There are about 600 Layouts in this file, so use the search function to find yours
- In my case, I keep 2 Layouts:</br>![](/Users/5t33z0/Desktop/Neuer Ordner/08.png)

Now you have removed all the unnecessary files from the AppleALC Source Code and can compile the Kext…

## Compiling the Kext
- In Terminal, `cd` into the AppleALC folder (as described previously)
- Type `xcodebuild` and hit Enter
- Wait until compiling finishes
- You custom AppleALC kext will be present under AppleALC/build/Release
- Add the kext to your EFI/OC/Kexts folder, replacing the existing one.
- Adjust the Layout-ID if necessary
- Reboot and enjoy your slimmed AppleALC kext.


