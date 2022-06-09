# Audio Codec Dumps

## About
In this section you'll find Audio CODEC dumps including `verbs.xt` created with PinConfigurator as well as .svg schematics generated with Codecgraph and graphviz. 

You can follow the instructions below if you want to create your own Codec Dumps. In order to create the Schematics, the Codec Dump has to be obtained in Linux! Dumps created with Clover and OpenCore don't work for this. 

## Dumping the Audio Codec in Linux

### Prepearing a USB flash drive for running Linux from an .iso
Users who already have Linux installed can skip to "Dumping the Audio Codec"!

1. Use a USB 3.0 flash drive (at least 8 GB or more).
2. In Windows, download [**Ventoy**](https://www.ventoy.net/en/download.html) and follow the [Instructions](https://www.ventoy.net/en/doc_start.html) to prepare the flash drive. 
3. Next, download an ISO of a Linux distribution of your choice, e.g. [**Ubuntu**](https://ubuntu.com/download/desktop), [Zorin](https://zorin.com/os/download/) or whatever distro you prefer – they all work fine.
4. Copy the ISO to your newly created Ventoy stick
5. Reboot from the flash drive
6. In the Ventoy menu, select the Linux ISO and hit enter
7. From the GNU Grub, select "Try or Install Linux"
8. Once Ubuntu has reached the Desktop environment, select "Try Ubuntu" (or whatever the distro of your choice prompts).

### Dumping the Audio Codec
1. Once Linux is up and running, open Terminal and enter:</br>
	```shell
	cd ~/Desktop && mkdir CodecDump && for c in /proc/asound/card*/codec#*; do f="${c/\/*card/card}"; cat "$c" > CodecDump/${f//\//-}.txt; done && zip -r CodecDump.zip CodecDump
	```
2. Store the generated `CodecDump.zip` on a medium which you can access later from within macOS (HDD, other USB stick, E-Mail, Cloud). You cannot store it on the Ventoy drive itself, since it's formatted in ExFat and can't be accessed by Linux without installing additional utilities.
3. Reboot into macOS.
4. Extract `CodecDump.zip` to the Desktop. It contains a folder with one or more .txt files. We are only interested in `card1-codec#0.txt`, additional dumps are usually from HDMI audio devices of GPUs.
5. ⚠️ Rename `card0-codec#0.txt` to `codec_dump.txt`. Otherwise the script convert it will fail. 

## Creating Codec dump Schematics
- Install [**graphviz**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/L_ALC_Layout-ID/graphviz-2.40.1.pkg?raw=true) 
- Next, download and unzip [**Codec-Graph.zip**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/L_ALC_Layout-ID/Codec-Graph.zip?raw=true)
- Copy the `Codec-Graph` folder to the Desktop
- Move the `codec_dump.txt` into the "Codec-Graph" folder 
- Double-Click on "Convert_Dump" and follow the instructions
- This creates 3 new files inside the "output" folder:
	- **`codec_dump_dec.txt`** &rarr; Codec dump converted from Hex to Decimal. We need it since the data has to be entered in decimals in AppleAlC's .xml files.
	- **`codecdump.svg`** – Schematic of the Codec.
	- **`codecdumpdec.svg`** &rarr; Schematic of the Codec converted from hex to decimal. We will work with this primarily. You can open it in the web browser to view it in full size.

## Creating `Verbs.txt` with PinConfigurator

- Run PinConfigurator
- Select "File > Open"
- Open the `codec_dump.text`
- Select "File > Export > verbs.txt"

The **`verbs.txt`** will be stored on the desktop:

![verbsreallyfixed](https://user-images.githubusercontent.com/76865553/171468008-cb04fa6b-e9d3-4cf3-a4b5-3fab0f48f553.png)

**NOTE**: You may have to sanitize the verbs so macOS can handle the data and sound will work.


