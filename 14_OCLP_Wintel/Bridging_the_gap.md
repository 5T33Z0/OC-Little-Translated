# Bridging the macOS compatibility gap when using OpenCore Legacy Patcher

## Problem description

As you may know, OpenCore Legacy Patcher utilizes virtualization technology introduced in macOS Big Sur 11.3 to make it "think" that it is running in a virtual environment. Combined with a Booter patch to skip board-id checks, this allows installing newer versions of macOS on unsupported systems without the need to change the SMBIOS. Not having to change the SMBIOS is crucial for running newer versions of macOS on *real* Apple Macs. Because otherwise you run into all sorts of hardware related issues on these machines. 

On Wintel systems it's not a big deal. Still, the overall performance of your system, especially CPU and GPU power management is best if you are using an SMBIOS that matches your CPU family.

## What is this gap you are yapping about?

Since the virtualization technology cannot be utilized prior to Big Sur 11.3, installing older versions of macOS requires another approach. So between macOS High Sierra (which a lot of macOS can use) and Big Sur there's a macOS comaptibility gap of two OSes that cannot be installed easily, for example: 

- macOS Mojave (last macOS with 32 bit Intel support). Owners of a real Mac can use [Mojave Patcher](https://dosdude1.com/mojave/) to install it.
- macOS Catalina (slimemst macOS since it only contains 64 bit Intel code). Owners of a real Mac can use [Catalina Patcher](https://dosdude1.com/catalina/) to install it.

## Bridging the Gap
The following Settings need to be changed in your `config.plist` to install macOS prio to Big Sur 11.3. This mainly concerns SMBIOS, SIP and APFS driver settings:

Section | Setting
:--------:|----------------
**SMBIOS** | Pick a suitalbe SMBIOS for your machine and the OS you want to run based on [this chart](https://docs.google.com/spreadsheets/d/1DSxP1xmPTCv-fS1ihM6EDfTjIKIUypwW17Fss-o343U/edit?pli=1&gid=483826077#gid=483826077) and adjust `PlatFormInfo/Generic/SystemProductName` accordingly.
**SIP** | Change `csr-active-config` as well: <ul><li> **macOS 10.11 and 10.12**: `67000000` <li>m**acOS 10.13**: `EF030000`<li>**macOS 10.14/10.15**: `EF070000` <li> **macOS 11+**: `03080000` 
**UEFI** | In order for the APFS driver to load in older versions of macOS (everything prior to macOS Big Sur), you need to change the following settings in `UEFI/APFS`, otherwise the partitions with the older macOS won't be displayed in the boot menu:<ul><li> **MinDate**: `-1` <li> **MinVersion**: `-1`
**NVRAM** | Add to **boot-args**: `-no_compat_check`

> [!TIP]
> 
> - Additional steps may be required to get it working (device-id of the iGPU or switching Wi-Fi/Bluetooth kexts, etc.). 
> - As a precaution, create a backup of your current EFI folder on a FAT32-formatted USB drive. **Edit the configuration on the USB drive** and boot from it. This way, you can make changes without affecting your main system. If the changes cause issues, you can simply reboot from your hard drive or SSD.
> - To ensure that you are really booting from your USB flash drive you might want to use a different theme for it so to seperate it visually from the one on your hdd/ssd

