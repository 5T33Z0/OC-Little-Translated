# Force-enable GPU patching in OpenCore Legacy Patcher

> **System Requirements**: macOS 12 or newer<br>
> **OCLP**: 0.6.9 or newer

**TABLE of CONTENTS**

- [About](#about)
- [NVIDIA Kepler Patching](#nvidia-kepler-patching)
	- [Config Preparations](#config-preparations)
	- [OCLP Preparations](#oclp-preparations)
- [NVIDIA Tesla Patching](#nvidia-tesla-patching)
	- [Config Preparations](#config-preparations-1)
	- [OCLP Preparations](#oclp-preparations-1)
- [Other GPUs](#other-gpus)
- [Further Resources](#further-resources)

## About
In some cases, discrete GPUs might not be detected by OpenCore Legacy Patcher because their device-id or IOName is not in the list of supported GPUs used in real Macs. In this case, you need to force-enable GPU patching in the configuration file of the OpenCore Legacy Patcher Source Code since the GUI of the app does not include settings to enable GPU patching manually (probably for good reasons).

> [!CAUTION]
> 
> If your system does not have any of the GPUs supported by OCLP installed on your system but you apply any of the GPU patches in this section anyways, *you will brick your macOS installation* and have to [revert root patches](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Reverting_Root_Patches.md) in order to recover macOS!


## NVIDIA Kepler Patching

### Config Preparations
- Mount your EFI and open your config.plist
- Adjust the following Settings:
	- Change `Misc/Security/SecureBootModel` to: `Disabled`
	- Change `csr-active-config` to `03080000`
	- Optional: add boot-arg `amfi=0x80`
- Save your config and reboot
- Continue with the guide

> [!NOTE]
>
> Other security features and config requirements might prohibit applying root patches – OCLP will notify you about issues that need to be resolved first. In this case, refer to the corresponding [configuration guide](https://github.com/5T33Z0/OC-Little-Translated/tree/main/14_OCLP_Wintel#configuration-guides) for your CPU family to find the correct settings to prepare your config.plist for applying root patches with OCLP.

### OCLP Preparations
To force enable patching of **NVIDIA Kepler Cards** (GT(X) 7xx Series) in OCLP, do the following:

- Download the **OCLP** [Source Code](https://github.com/dortania/OpenCore-Legacy-Patcher) and unzip it
- Run Terminal and enter the following commands (line by line):
    ```shell
    cd ~/Downloads/OpenCore-Legacy-Patcher-main
    pip3 install -r requirements.txt
    ```
- Wait until the download of the pip3 stuff has finished
- In Finder, navigate to "Downloads/OpenCore-Legacy-Patcher-main"
- Double-click on `Build-Binary.command` &rarr; It will open another Terminal window and download `payloads.dmg` (≈46 MB) and `Universal-Binaries.dmg`(≈522 MB). These are required so patching won't fail.
- Once the download is complete, navigate to `/Downloads/OpenCore-Legacy-Patcher-main/resources/sys_patch/`
- Open `sys_patch_detect.py` with IDLE, TextEdit, Visual Studio Code or Xcode
- Under **"# GPU Patch Detection"**, change the following setting from `False` to `True`:
	- **`self.kepler_gpu = True`**
	- Leave the other option in this section at **`False`**
	- Save and close the .py file 
- Back in Finder, double-click on `OpenCore-Patcher-GUI.command` to run the Patcher App.
- Click on "Post-Install Root Patch". The option "Graphics: Nvidia Kepler" should now appear in the list of applicable patches:<br>![PatchKepler](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/ed1f07a7-30d7-4c5e-8720-6ae7bb89c25a)
- Start Patching. 
- Once it's done, reboot

Enjoy working GPU Acceleration again!

> [!CAUTION]
> 
> Beware when using an **Nvidia GT 730** because it comes in 2 variants: Fermi (GF108) and Kepler (GK208B). But only the Kepler variant is compatible with macOS!

## NVIDIA Tesla Patching

### Config Preparations
- Mount your EFI and open your config.plist
- Adjust the following Settings:
	- Change `Misc/Security/SecureBootModel` to: `Disabled`
	- Change `csr-active-config` to `03080000`
	- Add the following boot-args:
		- `nvda_drv_vrl=1` (Enables NVIDIA Web Drivers)  
		- `ngfxcompat=1` (Ignores compatibility check in `NVDAStartupWeb`)
		- `ngfxgl=1` (Disables Metal support on NVIDIA cards)
		- `amfi=0x80` (Optional: disables AMFI)
		- `ngfxsubmit=0` (Optional: disables interface stuttering fix on macOS 10.13)
- Save your config and reboot
- Continue with the guide

> [!NOTE]
>
> Other security features and config requirements might prohibit applying root patches – OCLP will notify you about issues that need to be resolved first. In this case, refer to the corresponding [configuration guide](https://github.com/5T33Z0/OC-Little-Translated/tree/main/14_OCLP_Wintel#configuration-guides) for your CPU family to find the correct settings to prepare your config.plist for applying root patches with OCLP.

### OCLP Preparations
To force enable patching of **NVIDIA Tesler Cards** in OCLP, do the following:

- Download the **OCLP** [Source Code](https://github.com/dortania/OpenCore-Legacy-Patcher) and unzip it
- Run Terminal and enter the following commands (line by line):
    ```shell
    cd ~/Downloads/OpenCore-Legacy-Patcher-main
    pip3 install -r requirements.txt
    ```
- Wait until the download of the pip3 stuff has finished
- In Finder, navigate to "Downloads/OpenCore-Legacy-Patcher-main"
- Double-click on `Build-Binary.command` &rarr; It will open another Terminal window and download `payloads.dmg` (≈46 MB) and `Universal-Binaries.dmg`(≈522 MB). These are required so patching won't fail.
- Once the download is complete, navigate to `/Downloads/OpenCore-Legacy-Patcher-main/resources/sys_patch/`
- Open `sys_patch_detect.py` with IDLE, TextEdit, Visual Studio Code or Xcode
- Under **"# GPU Patch Detection"**, change the following setting from `False` to `True`:
	- **`self.nvidia_tesla = True`**
	- **`self.nvidia_web = True`**
 	- Leave the other option in this section at **`False`** 
 	- Save and close the .py file 
- Back in Finder, double-click on `OpenCore-Patcher-GUI.command` to run the Patcher App.
- Click on "Post-Install Root Patch". The option "Graphics: Nvidia Kepler" should now appear in the list of applicable patches:<br>![Patch_Tesler](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/32c41807-3189-492f-886e-54e8ed486b73)
- Start Patching. 
- Once it's done, reboot

Enjoy working GPU Acceleration again!

## Other GPUs

&rarr; TO BE CONTINUED…

## Further Resources
- How to Root Patch with non-OpenCore Legacy Patcher Macs/Hackintoshes. ([**OCLP issue #348**](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/348))
- [**GPU Buyers Guide**](https://dortania.github.io/GPU-Buyers-Guide/) by Dortania
