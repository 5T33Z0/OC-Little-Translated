## Creating Custom PowerPlay Tables for AMD Polaris Cards
> **DISCLAIMER**: Playing around with the parameters of your vBIOS can cause irreparable damage to your GPU if you don't know what you are doing. Use this guide on your own risk! Since I don't know which GPU you are using and I don't know what you want to change/optimize, I am only showing you ***how*** to change them but ***not*** which settings to use specifically. It's up to you to figure that our or research it.

## About
Guide for creating a `PP_PhmSoftPowerPlayTable` Device Property for Radeon Polaris cards to inject into macOS. This way you can modify things like Clock Speeds, Fan Curves and Power Consumption to optimize performance while reducing power consumption at the same time. In Windows you can use 

which wouldn't be possible otherwise. And on top of that you don't have to flash a modified BIOS on your GPU.

This reduces Power Consumption and improves Perfor

## Requirements

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
	- [**Intel Power Gadget**](https://www.intel.com/content/www/us/en/developer/articles/tool/power-gadget.html) &rarr; installs `EnergyDriver.kext` into S/L/E which can be utilized by HWMonitorSMC2 for monitoring (select "Intel Power Gadget" in options).

## Instructions

### Dumping the vBIOS
1. Boot Windows
2. Run `amdvbflashWin.exe` as Admin:</br>![](/Users/5t33z0/Desktop/Pics_2/ATIWinFlash.PNG)
3. Press "Save" to dump the vBIOS ROM
4. Give it a reasonable name like "BIOS_stock" and save it.

:bulb: **NOTE**: If your GPU has a BIOS switch (the Sapphire Nitro+ RX580 has one), shutdown your Computer, change the position of the switch and repeat steps 1 to 4, so you have backups of both BIOS files.

### Modifying the vBIOS
1. Open `PolarisBiosEditor`
2. Click on "Open BIOS" and open the BIOS dumped previously:</br>![](/Users/5t33z0/Desktop/Pics_2/RX580 mod.PNG)
3. Select the parameter you want to change and enter its new value
4. Once you done editing click on "SAVE AS"
5. Save the file as "BIOS_Mod". Don't override the original vBIOS file

:bulb: For suggestions on which parameters to modify, you can check out the BIOS mods presented in this [thread](https://forums.macrumors.com/threads/sapphire-pulse-rx580-8gb-vbios-study.2133607/). But don't flash the actual modified ROM(s) as suggested  in that guide – this is only necessary on real Macs, not Hackintoshes! We will inject `DeviceProperties` instead.

### Locating the `PowerPlayInfo` inside the modded .rom file
1. Run `ATOMBIOSReader.exe`</br>:![](/Users/5t33z0/Desktop/Pics_2/AtomBIOS01.png)
2. Open you `BIOS_Mod.rom` file &rarr; this will generate a .txt file. It contains a list of all the Command Tables of the ROM ass well as the addresses they are located at in memory.
3. Open the `BIOS_Mod.rom.txt` file and search for "PowerPlayInfo":</br>![](/Users/5t33z0/Desktop/Pics_2/txtfile.png)
4. It says **9bba  Len 0341** in my case.

This means the `PowerPlayInfo` starts at position `9bba` (hex) of the ROM and has a length of `341`. So we have to copy the code starting at position `9bba` for the length of 341.

### Extracting `PowerPlayInfo` from the modded vBIOS .rom
1. Run HxD Hex Editor 
2. Open your patched "BIOS_MOD.rom" file
3. In the lower lef corner, double-click on "Offset(h)".
4. Paste the offset you gathered from the text file (in Hex) into the dialog Window and click "OK":</br>![](/Users/5t33z0/Desktop/Pics_2/HxD003.png)
5. This puts the cursor to the correct location
6. Select the code starting from the Offset for the length you found previously. In my case 341:</br>![](/Users/5t33z0/Desktop/Pics_2/HxD04.png)
7. Copy the value to memory (CTRL+C)
8. Open Editor, paste in the value and save the file as `PPT01.txt` or similar at a location which you can access from within macOS:</br>![](/Users/5t33z0/Desktop/Pics_2/PPT01.png)
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
- The resulting entry should look similar to this:</br>![](/Users/5t33z0/Desktop/Pics_2/propertree01.png)
- Save your config.plist and reboot

## Testing
### Enable Monitoring
To get a bit more insight on what's happening on your Hackintosh, we install some tools to monitor performance and Power Consumption of the GPU.

- Install Intel Power Gadget 
- Install HWMonitorSMC2
- Run HWMonitorSMC2
- Click on the cog wheel to open the preferences 
- Enable the following options:</br>![](/Users/5t33z0/Desktop/Pics_2/HWMonSMC2_01.png)
- Close the settings. The HWMonitor Icon is now present in the Menubar. Click on it to show the monitored devices:</br>![](/Users/5t33z0/Desktop/Pics_2/HWMonSMC2.png)

:bulb: Alternatively, you can monitor GPU useage via Terminal, using this command: 

`ioreg -l |grep \"PerformanceStatistics\" | cut -d '{' -f 2 | tr '|' ',' | tr -d '}' | tr ',' '\n'|grep 'Temp\|Fan\|Power\|Clock\|Utilization'`

### Run some Benchmark Tests
- Open Geekbench
- Click on "Compute"
- Select your GPU from the "Compute Device" dropdown menu
- Run Tests for Metal and OpenCL
- Save your results
- Open your config.plist 
- Put a `#` in front of `PP_PhmSoftPowerPlayTable` to disable the key
- Reboot macOS and perform the tests again
- Also check in HWMonitorSMC2 for Power Consumption of the GPU.

## Credits and Resources
- Original [Guide](https://www.reddit.com/r/hackintosh/comments/hg56pv/guide_polaris_rx_560_580_etc_custom_powerplay/) by Z4mp4n0
- Examples of [modded PowerPlayTables](https://forums.macrumors.com/threads/sapphire-pulse-rx580-8gb-vbios-study.2133607/)
