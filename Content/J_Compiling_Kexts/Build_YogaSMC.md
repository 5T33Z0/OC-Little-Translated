# How to Compile YogaSMC

## 1. Install Xcode

Install the latest version of [Xcode](https://developer.apple.com/xcode/) via the Mac App Store.

## 2. Download the Source Code

Download the YogaSMC source from GitHub (I am using jozews321's fork, since it fixes the PrefPane in macOS 13+):

[https://github.com/jozews321/YogaSMC](https://github.com/jozews321/YogaSMC)

## 3. Unzip the Archive

Unpack the `YogaSMC-master.zip`.

## 4. Add Required Dependencies

Download and copy the latest **debug** builds of:

* [`Lilu.kext`](https://github.com/acidanthera/Lilu/releases/latest)
* [`VirtualSMC.kext`](https://github.com/acidanthera/VirtualSMC/releases/latest)

into the `YogaSMC-master` directory.

## 5. Open Terminal and Navigate to the Project Folder

```bash
cd ~/Downloads/YogaSMC-master
```

## 6. Clone the MacKernel SDK

```bash
git clone --depth 1 https://github.com/acidanthera/MacKernelSDK
```

## 7. Build All Components

Use the following command to build all targets in **Release** mode with a compatible deployment target:

```bash
xcodebuild -project YogaSMC.xcodeproj -configuration Release -alltargets build MACOSX_DEPLOYMENT_TARGET=10.13
```

## Output

After building, you will find the following files (among others) in the `build/Release/` folder inside the project directory:

* `YogaSMC.kext` (the sensor/SMC interface) &rarr; Goes into your bootloader's kext folder
* `YogaSMC.prefPane` (for macOS System Preferences integration) &rarr; Double-Click to install it
* `YogaSMCNNC.app` (for touchpad/hotkey handling) &rarr; goes into your Applications folder. Start at Login.


