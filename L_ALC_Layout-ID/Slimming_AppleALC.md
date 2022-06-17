# Slimming AppleALC Kext
This guide is for compiling AppleALC for your Codec only. This reduced the kext from 3.8 MB to around 90 kilobytes.

## Preparations
- Install and configure Xcode as [described here](https://github.com/5T33Z0/OC-Little-Translated/tree/main/L_ALC_Layout-ID#configuring-xcode)
- Install a Plist Editor
- Download [AppleALC](https://github.com/acidanthera/AppleALC) Source Code (click on "Code" and "Download Zip") 
- Unpack the .zip file
- In Terminal, enter: `cd`, hit space, drag the AppleALC folder into the Terminal window and press enter.
- Next, enter `git clone https://github.com/acidanthera/MacKernelSDK` and hit enter. This adds the MacKernelSDK in the AppleALC source folder.
- Add the Debug version of [Lilu.kext](https://github.com/acidanthera/Lilu/releases) to the AppleALC folder.
- The resulting folder structure should look like this:</br>![](https://user-images.githubusercontent.com/76865553/173291777-9bc1285d-1ffa-479f-b7bf-b74cda6f23ae.png)

## Slimming the files

### 1. Deleting unused Codecs
- Enter the Resources folder:</br>![01](https://user-images.githubusercontent.com/76865553/174393266-55d3f7ff-9e97-46a0-bc8a-75c94c39eea5.png)
- Delete the folders which are not for your Codec. In my case, I only keep the ALC269 folder:</br>![02](https://user-images.githubusercontent.com/76865553/174393321-eae1f416-16de-4b08-b70a-260f7de7e9f9.png)

### 2. Removing unused Layouts and Platforms
- Next, enter the folder for your Codec:</br>![03](https://user-images.githubusercontent.com/76865553/174393366-9587befc-b27c-45f6-8cbd-6c7fcdcf68d7.png)
- Delete the layout and Platforms.xml files which are NOT the one you are using. In my case, I keep the files for Layout and Platforms 18 and 39:</br>![05](https://user-images.githubusercontent.com/76865553/174393427-9109b99b-de52-4ffe-b244-dd4b08e49a95.png)
- Next, open the `Info.plist` in the same folder with a Plist Editor:</br>![](/Users/5t33z0/Desktop/Neuer Ordner/09.png)
- Delete all the entries for Layouts and Platforms you don't intend to use. You have to look inside the entries or use the search function to find yours to keep. In my case, I keep Layouts 18 and 39 and Platforms 18 and 39:</br>![10](https://user-images.githubusercontent.com/76865553/174393502-7fe9556e-26f9-4c73-936a-3cc024db4741.png)
- Save the file

### 3. Removing Layouts from `PinConfig.kext`
- Select PinConfig.kext in the AppleALC folder:</br>![04](https://user-images.githubusercontent.com/76865553/174393542-41458a9c-a33e-4d6d-91e3-94c0ecd05ae3.png)
- Right-click the `PinConfig.kext` and select "Show Package Contents":</br>![06](https://user-images.githubusercontent.com/76865553/174393581-d361874f-4539-4407-b208-5eb505ee2d66.png)
- Open the info.plist with a Plist Editor:</br>![07](https://user-images.githubusercontent.com/76865553/174393627-6784074e-94fd-4cc7-aabc-6a18bb5bc4e8.png)
- Delete the Dictionaries which do not contain your Layout-ID. There are about 600 Layouts in this file, so use the search function to find yours
- In my case, I keep 2 Layouts:</br>![08](https://user-images.githubusercontent.com/76865553/174393729-500ddaa2-07e7-40b4-abcb-1b5311cbd5d6.png)

Now you have removed all the unnecessary files from the AppleALC Source Code and can compile the Kext…

## Compiling the Kext
- In Terminal, `cd` into the AppleALC folder (as described previously)
- Type `xcodebuild` and hit Enter
- Wait until compiling finishes
- You custom AppleALC kext will be present under AppleALC/build/Release
- Add the kext to your EFI/OC/Kexts folder, replacing the existing one.
- Adjust the Layout-ID if necessary
- Reboot and enjoy your slimmed AppleALC kext.


