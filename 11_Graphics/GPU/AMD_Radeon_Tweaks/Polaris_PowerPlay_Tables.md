# Creating Custom PowerPlay Tables for AMD Polaris Cards
> **DISCLAIMER**: Use this guide on your own risk! Playing around with the parameters of your vBIOS can cause irreparable damage to your Graphics Card if you don't know what you are doing. Since I don't know which GPU you are using and I don't know which parameters you want to modify, I am only showing you ***how*** to change them but ***not*** which settings to use specifically. It's up to you to figure that out. You can use the example files contained in the PowerPlayInfo.zip file for reference. They contain further explanations about the structure of the PowerPlayInfo data contained in the vBIOS.

**TABLE of CONTENTS**

- [Creating Custom PowerPlay Tables for AMD Polaris Cards](#creating-custom-powerplay-tables-for-amd-polaris-cards)
	- [About](#about)
		- [How it works](#how-it-works)
	- [Requirements](#requirements)
	- [Instructions](#instructions)
		- [Dumping the vBIOS](#dumping-the-vbios)
		- [Modifying the vBIOS](#modifying-the-vbios)
		- [Locating the `PowerPlayInfo` inside the modded .rom file](#locating-the-powerplayinfo-inside-the-modded-rom-file)
		- [Extracting `PowerPlayInfo` from the modded vBIOS .rom](#extracting-powerplayinfo-from-the-modded-vbios-rom)
		- [Gathering the PCI path of your dGPU](#gathering-the-pci-path-of-your-dgpu)
		- [Editing the config.plist](#editing-the-configplist)
	- [Testing](#testing)
		- [Enable GPU Monitoring](#enable-gpu-monitoring)
		- [Run some Benchmark Tests](#run-some-benchmark-tests)
		- [Test results](#test-results)
	- [Example Files](#example-files)
	- [Credits and Thank Yous](#credits-and-thank-yous)

## About
Guide for creating a `PP_PhmSoftPowerPlayTable` Device Property for Radeon Polaris cards to inject into macOS. This way you can modify things like Clock Speeds, Fan Curves and Power Limits to optimize performance while reducing power consumption at the same time which wouldn't be possible otherwise. On top of that you don't have to flash a modified BIOS on your GPU.

### How it works
Basically, you dump the vBIOS ROM from your GPU, modify it, save it. Then you extract the PowerPlayInfo table from the modded ROM with a Hex Editor and inject into macOS via `DeviceProperties`. Combined with [`@0,name`](https://github.com/5T33Z0/OC-Little-Translated/tree/main/11_Graphics/GPU/AMD_Radeon_Tweaks#method-2-selecting-specific-amd-framebuffers-via-deviceproperties) property to select a specific Framebuffer this is probably the best method to optimize performance and power consumption of AMD cards under macOS

## Requirements

- 500-series AMD GPU with Polaris BIOS (usually Radeon RX 570 to RX 590) 
- Windows Installation
- **Software** (Windows):
	- [**amdvbflash**](https://www.techpowerup.com/download/ati-atiflash/)  &rarr; for dumping vBIOS ROM(s) from the GPU
	- [**ATOMBIOSReader**](https://github.com/kizwan/ATOMBIOSReader) &rarr; for generating a list of command and data tables from a vBIOS
	- [**PolarisBiosEditor**](https://github.com/IndeedMiners/PolarisBiosEditor) &rarr; for editing the vBIOS ROM
	- [**HxD**](https://mh-nexus.de/en/hxd/) &rarr; Hex Editor for extracting data from the ROM file for the `PP_PhmSoftPowerPlayTable` property 
- **Software** (macOS)
	- [**Hackintool**](https://github.com/headkaze/Hackintool) &rarr; for finding the PCI Path of your discrete GPU
	- Plist Editor ([**ProperTree**](https://github.com/corpnewt/ProperTree) or [**OpenCore Auxiliary Tools**](https://github.com/ic005k/OCAuxiliaryTools)) for editing `DeviceProperties`
	- [**LuxMark**](http://wiki.luxcorerender.org/LuxMark_v3) (see "Binaries" section) &rarr; for OpenCL Benchmark test
	- [**Geekbench**](https://www.geekbench.com/) &rarr; for Benchmarking Metal
	- [**HWMonitorSMC2**](https://github.com/CloverHackyColor/HWMonitorSMC2) &rarr; For monitoring CPU and GPU Performance, Power Consumption and Temps.
	- [**Intel Power Gadget**](https://www.insanelymac.com/forum/files/file/1056-intel-power-gadget/) &rarr; installs `EnergyDriver.kext` into S/L/E which can be utilized by HWMonitorSMC2 for monitoring (select "Intel Power Gadget" in options).

## Instructions

### Dumping the vBIOS
1. Boot Windows
2. Run `amdvbflashWin.exe` as Admin:</br>![ATIWinFlash](https://user-images.githubusercontent.com/76865553/178274110-f868d4fe-52b1-4d95-b4cd-351a8122d509.PNG)
3. Press "Save" to dump the vBIOS ROM
4. Give it a reasonable name like "BIOS_stock" and save it.

:bulb: **NOTE**: If your GPU has a BIOS switch (the Sapphire Nitro+ RX580 has one), shutdown your Computer, change the position of the switch and repeat steps 1 to 4, so you have backups of both BIOS files.

### Modifying the vBIOS
1. Open `PolarisBiosEditor`
2. Click on "Open BIOS" and open the BIOS dumped previously:</br>![RX580_mod](https://user-images.githubusercontent.com/76865553/178274228-4beeb3b4-e6d9-4f86-a83c-c7924c2905aa.PNG)
3. Select the parameter you want to change and enter its new value
4. Once you done editing click on "SAVE AS"
5. Save the file as "BIOS_Mod". Don't override the original vBIOS file

:bulb: For suggestions on which parameters to modify, you can check out the BIOS mods presented in this [thread](https://forums.macrumors.com/threads/sapphire-pulse-rx580-8gb-vbios-study.2133607/). But don't flash the actual modified ROM(s) as suggested  in that guide – this is only necessary on real Macs, not Hackintoshes! We will inject `DeviceProperties` instead.

### Locating the `PowerPlayInfo` inside the modded .rom file
1. Run `ATOMBIOSReader.exe`:</br>![AtomBIOS01](https://user-images.githubusercontent.com/76865553/178274627-7efa0663-c93a-40bf-bcd8-076443f99663.png)
2. Open you `BIOS_Mod.rom` file &rarr; this will generate a .txt file. It contains a list of all the Command Tables of the ROM ass well as the addresses they are located at in memory.
3. Open the `BIOS_Mod.rom.txt` file and search for "PowerPlayInfo":</br>![txtfile](https://user-images.githubusercontent.com/76865553/178274713-c22c7e4e-5892-46cd-9c0b-b496e2fbf865.png)
4. It says **9bba  Len 0341** in my case.

This means the `PowerPlayInfo` starts at position `9bba` (hex) of the ROM and has a length of `341`. So we have to copy the code starting at position `9bba` for the length of 341.

### Extracting `PowerPlayInfo` from the modded vBIOS .rom
1. Run HxD Hex Editor 
2. Open your patched "BIOS_MOD.rom" file
3. In the lower lef corner, double-click on "Offset(h)".
4. Paste the offset you gathered from the text file (in Hex) into the dialog Window and click "OK":</br>![HxD003](https://user-images.githubusercontent.com/76865553/178274929-f36b150b-761d-4b30-b54f-5b8d53cee05b.png)
5. This puts the cursor to the correct location
6. Select the code starting from the Offset for the length you found previously. In my case 341:</br>![HxD04](https://user-images.githubusercontent.com/76865553/178275828-0f27f7bb-fae6-4da6-ac0b-9210ab3c302f.png)
7. Copy the value to memory (CTRL+C)
8. Open Editor, paste in the value and save the file as `PPT01.txt` or similar at a location which you can access from within macOS:</br>![PPT01](https://user-images.githubusercontent.com/76865553/178275032-fbd01753-44b2-4d49-8b4b-20c983e468b7.png)
9. Reboot into macOS

### Gathering the PCI path of your dGPU
- Run Hackintool
- Click on the "PCIe" Tab
- Find your GPU – it should be listed as "VGA Compatible Controller" – the Vendor should be AMD, not Intel! Intel = iGPU.
- Right-click the entry and select "Copy Device Path":</br>![PCIpath](https://user-images.githubusercontent.com/76865553/174430790-a35272cb-70fe-4756-a116-06c0f048e7a0.png)

### Editing the config.plist
- Next, Mount your EFI
- Open your config.plist with a Plist Editor
- Create a new and Dictionary under `DeviceProperties/Add`
- Double-click its name and paste in the Device Path (CMD+V). Usually it's `PciRoot(0x0)/Pci(0x1,0x0)/Pci(0x0,0x0)`.
- Next, create a new Key called `PP_PhmSoftPowerPlayTable` (Type: DATA)
- Paste in the data from the `PPT01.txt`
- The resulting entry should look similar to this:</br>![propertree01](https://user-images.githubusercontent.com/76865553/178275171-7f32aaf9-8d90-4cc3-b3be-034fb0b2b15d.png)
- Save your config.plist and reboot

## Testing
### Enable GPU Monitoring
To get a bit more insight on what's happening on your Hackintosh, we install some tools to monitor performance and Power Consumption of the GPU.

- Install Intel Power Gadget 
- Install HWMonitorSMC2
- Run HWMonitorSMC2
- Click on the cog wheel to open the preferences
- Enable the following options:</br>![HWMonSMC2_01](https://user-images.githubusercontent.com/76865553/178275364-aff56ce8-ef72-466d-af8d-945c90e69396.png)
- Close the settings. The HWMonitor Icon is now present in the Menubar. Click on it to show the monitored devices:</br>![HWMonSMC2](https://user-images.githubusercontent.com/76865553/178275501-2f35da79-dc90-40da-a1b1-7edb84aa47f0.png)

:bulb: Alternatively, you can monitor GPU usage via Terminal, using this command: 

```
ioreg -l |grep \"PerformanceStatistics\" | cut -d '{' -f 2 | tr '|' ',' | tr -d '}' | tr ',' '\n'|grep 'Temp\|Fan\|Power\|Clock\|Utilization'
```

### Run some Benchmark Tests
- Open Geekbench
- Click on "Compute"
- Select your GPU from the "Compute Device" dropdown menu
- Run Tests for Metal and OpenCL
- Save your results
- Open your config.plist 
- Put a `#` in front of `PP_PhmSoftPowerPlayTable` to disable the key
- Reboot macOS and perform the tests again
- Check power consumption, temps and clock speed in HWMonitorSMC2.

**NOTE**: Don't forget to re-enable `PP_PhmSoftPowerPlayTable` when you're done comparing test results.

### Test results
Here are some Geekbench scores for my Sapphire Nitro+ Radeon RX 580 (4 GB):

- **Metal** (stock): [**51211**](https://browser.geekbench.com/v5/compute/5112722) 
- **OpenCL** (stock): [**48076**](https://browser.geekbench.com/v5/compute/5112729)
- **Metal** (with PowerPlay Table): [**53023**](https://browser.geekbench.com/v5/compute/5112672)
- **OpenCL** (with PowerPlay Table): [**46030**](https://browser.geekbench.com/v5/compute/5112679)

Power consumption in idle (in Watts): 

- **Stock**: ≈ 100 W
- **Modded**: ≈ 70 W

## Example Files
Here are some example files by Jasonhacks with explanations about the sections of the PowerPlayInfo Table code. The tables are for a Sapphire Nitro+ Radeon RX 580 (8 GB). So unless you have the same model I wouldn't recommend just copying over the data 1:1. Instead, study the principle behind it. [**Download**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/11_Graphics/GPU/AMD_Radeon_Tweaks/PowerPlayInfo) 

## Credits and Thank Yous
- Original [Guide](https://www.reddit.com/r/hackintosh/comments/hg56pv/guide_polaris_rx_560_580_etc_custom_powerplay/) by Z4mp4n0
- Examples of [modded PowerPlayTables](https://forums.macrumors.com/threads/sapphire-pulse-rx580-8gb-vbios-study.2133607/)
- Jasonhacks for explanations and example files
