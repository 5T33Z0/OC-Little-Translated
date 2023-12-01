## Force-enable GPU patching 
> **System Requirments**: macOS 12 or newer<br>
> **OCLP**: 0.6.9 or newer

In some cases, discrete GPUs might not be detected by OpenCore Legacy Patcher because theirs device-id or IOName is not in the list supported devices used on real Macs

### Force NVIDIA Kepler Patching
To force enable patching of **NVIDIA Kepler Cards** (GT(X) 7xx Series) in OCLP, do the following:

- Download the **OCLP** [Source Code](https://github.com/dortania/OpenCore-Legacy-Patcher) and unzip it
- Run Terminal and enter the following commands (line by line):
    ```shell
    cd ~/Downloads/OpenCore-Legacy-Patcher-main
    pip3 install -r requirements.txt
    ```
- Wait unti the download of the pip3 stuff has finished
- In Finder, navigate to "Downloads/OpenCore-Legacy-Patcher-main"
- Double-click on `Build-Binary.command` &rarr; It will open another Terminal window and download `payloads.dmg` (≈46 MB) and `Universal-Bibaries.dmg`(≈522 MB). These are required so patching won't fail.
- Once the download is complete, navigate to `/Downloads/OpenCore-Legacy-Patcher-main/resources/sys_patch/`
- Open `sys_patch_detect.py` with IDLE, TextEdit, Visual Studio Code or Xcode
- Under **"# GPU Patch Detection"**, change the following setting from `False` to `True`:
	- **`self.kepler_gpu = True`**
 	- Save and close the .py file 
- Back in Finder Double-click on `OpenCore-Patcher-GUI.command` to run the Patcher App.
- Click on "Post-Install Root Patch". The option "Graphics: Nvidia Kepler" should now appear in the list of applicable patches: <br>![](/Users/stunner/Desktop/KEPLER.png)
- Start Patching. 
- Once it's done, reboot

Enjoy working GPU Acceleration again

### Force NVIDIA Tesler Patching
&rarr; Work in Progress
