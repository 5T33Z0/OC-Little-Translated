[![macOS](https://img.shields.io/badge/Supported_macOS:-≤13.0_beta-white.svg)](https://www.apple.com/macos/macos-ventura-preview/)
# How to create/modify a Layout-ID for AppleALC

- [I. Summary](#i-summary)
- [II. Preparations](#ii-preparations)
- [III. Extracting data from the Codec dump](#iii-extracting-data-from-the-codec-dump)
- [IV. Understanding the Codec schematic and signal flow](#iv-understanding-the-codec-schematic-and-signal-flow)
- [V. Creating a PathMap](#v-creating-a-pathmap)
- [VI. Creating a PlatformsXX.xml](#vi-creating-a-platformsxxxml)
- [VII. Transferring the PathMap to PlatformsXX.xml](#vii-transferring-the-pathmap-to-platformsxxxml)
- [VIII. Adding/Modifying layoutXX.xml](#viii-addingmodifying-layoutxxxml)
- [IX. Creating a PinConfig](#ix-creating-a-pinconfig)
- [X. Integrating the PinConfig into the AppleALC source code](#x-integrating-the-pinconfig-into-the-applealc-source-code)
- [XI. Add Platforms.xml and layout.xml to info.plist](#xi-add-platformsxml-and-layoutxml-to-infoplist)
- [XII. Compiling the AppleALC.kext](#xii-compiling-the-applealckext)
- [XIII. Testing and Troubleshooting](#xiii-testing-and-troubleshooting)
- [XIV. Adding your Layout-ID to the AppleALC Repo](#xiv-adding-your-layout-id-to-the-applealc-repo)

## I. Summary
### About
This is my attempt to provide an up-to-date guide for creating/modifying Layout-IDs for the AppleALC kext to make audio work on a Hackintosh in 2022 (and beyond). It covers the following topics:

- Installing and configuring the necessary tools
- Creating a Codec dump in Linux
- Converting the Data
- Creating a PinConfig, Layout.xml and Platforms.xml files
- Integrating the data into the AppleALC Source Code 
- Compiling a AppleALC.kext
- Adding the newly created Layout-ID to the AppleALC repo

### Who this guide is for
This guide is aimed at users who want to create a new or modify an existing Layout-ID for different reasons. Maybe the one in use was created for the same Codec but a different system/mainboard and causes issues or they want to add inputs or outputs missing from the current Layout-ID in use.

<details>
<summary><strong>Why another guide?</strong> (click to reveal)</summary>

### Why another guide?
Although the AppleALC kext comes with about 600 pre-configured Layout-IDs for more than 100 Audio Codecs, the process of *creating* or *modifying* a Layout-ID and integrating the data into the source code for compiling the kext is not documented on the AppleALC repo.

The hand full of guides I could find stem from an era before AppleALC even existed, when patching AppleHDA was still a thing. Most of them are either outdated (I had to use Wayback Machine for some), over-complicated or only parts of them are applicable today. And most importantly: ***none*** of them actually explain how to integrate the data into the AppleALC source code to compile the kext!

The most convincing guide I did find is written in German by MacPeet. He has created over 50 (!) Layout-IDs for AppleALC over the years. It's from 2015 so it predates AppleALC as well. Although not all of its instructions are applicable today, his guide introduced a new, partly automated workflow, using tools to visualize the Codec dump and scripts to extract required data from it which previously had to be extracted manually.

My guide is an adaptation of MacPeet's work but updates and enhances it, where possible. It introduces new tools and workflows and utilizes all the nice features markdown has to offer to present the instruction in the best way possible, such as: headings, syntax highlighting, tables and mermaid integration for flowcharts, etc.

So all in all, there is a justification for having new guide for this to enable and empower users to create their own ALC Layout-IDs if they have to.</details>

### Are you *sure*, you want to do this?
From a user's perspective, making audio work in hackintosh is a no-brainer: add AppleALC to the kext folder of your Boot Manager, enter the correct ALC Layout-ID to the config and reboot. And voilà: Sound! 

But once you are on the other end, trying to actually *create* your own ALC Layout-ID this becomes a completely different story quickly and it's almost a give that your Layout-ID won't work at all the first time around. So, are you still sure you *want* to do this?

### 💡 Tips

- Click on the little Header icon next to `README.md` to navigate in the document quickly
- [Backup files you change](https://github.com/5T33Z0/OC-Little-Translated/blob/main/L_ALC_Layout-ID/AppleALC_Settings_Management.md) in the Source Code and document configuration changed! Otherwise you will completely lose track of PinConfig and PathMap combinations you have tried already! I prepared a [table for taking notes](https://github.com/5T33Z0/OC-Little-Translated/blob/main/L_ALC_Layout-ID/Testing_Notes.md) which might help. You can open it in a Markdown Editor such as Macdown or use Visual Studio Code.

## II. Preparations
Creating a Layout-ID for AppleALC is one of the more challenging tasks for "regular" hackintosh users who are not programmers (me included). It's not only challenging and time consuming, it's also confusing and requires a lot of tools and prep work. So let's get it out the way right away.

### Obtaining an Audio CODEC dump in Linux
Unfortunately, Codec dumps obtained with Clover/OpenCore can't be processed by the tools required to convert and visualize the data inside of them. Codec dumps created in Linux, however, can be processed by these tools just fine.[^1]

Therefore, we need to use (a live version of) Linux to create the codec dump without having to actually install Linux. We can use Ventoy for this. It prepares a USB flash drive which can run almost any ISO directly without having to create a USB installer.

**NOTES**: If you can live without a schematic of the Codec dump, you *can* use the dumps created with Clover and OpenCore as well.

- **Clover**: Hit "F8" in the boot menu. `AudioDxe.efi` has to be present in `CLOVER/drivers/UEFI`. The file(s) will be stored in `EFI/CLOVER/misc`.
- **OpenCore**: Requires the Debug version. Check the [Debugging Section](https://github.com/5T33Z0/OC-Little-Translated/tree/main/K_Debugging#using-opencores-sysreport-feature) for details.

[^1]: When I compared the dumps obtained with Clover and Linux, I noticed that the one created in Linux contained almost twice the data (293 vs 172 lines). I guess this is because Linux dynamically discovers the paths of an audio codec through a graph traversal algorithm. And in cases where the algorithm fails, it uses a huge lookup table of patches specific to each Codec. My guess is that this additional data is captured in the Codec dump as well.

#### Preparing a USB flash drive for running Linux from an ISO
Users who already have Linux installed can skip to "Dumping the Codec"!

1. Use a USB 3.0 flash drive (at least 8 GB or more).
2. In Windows, download [**Ventoy**](https://www.ventoy.net/en/download.html) and follow the [Instructions](https://www.ventoy.net/en/doc_start.html) to prepare the flash drive. 
3. Next, download an ISO of a Linux distribution of your choice, e.g. [**Ubuntu**](https://ubuntu.com/download/desktop), [Zorin](https://zorin.com/os/download/) or whatever distro you prefer – they all work fine.
4. Copy the ISO to your newly created Ventoy stick
5. Reboot from the flash drive
6. In the Ventoy menu, select the Linux ISO and hit enter
7. From the GNU Grub, select "Try or Install Linux"
8. Once Ubuntu has reached the Desktop environment, select "Try Ubuntu" (or whatever the distro of your choice prompts).

#### Dumping the Codec
1. Once Linux is up and running, open Terminal and enter:</br>
	```shell
	cd ~/Desktop && mkdir CodecDump && for c in /proc/asound/card*/codec#*; do f="${c/\/*card/card}"; cat "$c" > CodecDump/${f//\//-}.txt; done && zip -r CodecDump.zip CodecDump
	```
2. Store the generated `CodecDump.zip` on a medium which you can access later from within macOS (HDD, other USB stick, E-Mail, Cloud). You cannot store it on the Ventoy drive itself, since it's formatted in ExFat and can't be accessed by Linux without installing additional utilities.
3. Reboot into macOS.
4. Extract `CodecDump.zip` to the Desktop. It contains a folder with one or more .txt files. We are only interested in `card1-codec#0.txt`, additional dumps are usually from HDMI audio devices of GPUs.
5. ⚠️ Rename `card0-codec#0.txt` to `codec_dump.txt`. Otherwise the script we will use later to convert it will fail. 

### Required Tools and Files
💡Please follow the instructions carefully and thoroughly to avoid issues.

- Install [**Python 3**](https://www.python.org/downloads/) if you haven't already
- Install either [**MacPorts**](https://www.macports.org/install.php) or [**Homebrew**](https://brew.sh/) (may require reboot afterwards)
- Once that's done, reboot.
- Next, install [**graphviz**](https://graphviz.org/) via terminal:
	- If you are using **MacPorts**, enter `sudo port install graphviz`
	- If you are using **Homebrew**, enter `brew install graphviz` 
- Download and unzip [**Codec-Graph.zip**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/L_ALC_Layout-ID/Tools/Codec-Graph.zip?raw=true)
- Copy the `Codec-Graph` folder to the Desktop
- Move the `codec_dump.txt` into the "Codec-Graph" folder
- Download and extract [**PinConfigurator**](https://github.com/headkaze/PinConfigurator/releases)
- Download [**Hackintool**](https://github.com/headkaze/Hackintool). We may need it for Hex to Decimal conversions later.
- Download and install the [correct version](https://developer.apple.com/support/xcode/) of [**Xcode**](https://developer.apple.com/download/all/?q=xcode) supported by your macOS. The download is about 10 GB and the installed application is about 30 GB, so make sure you have enough disk space. And: make sure to move the app to the "Programs" folder – otherwise compiling fails.
- Plist Edior like [**ProperTree**](https://github.com/corpnewt/ProperTree) or PlistEditPro (Xcode and [**Viual Studio Code**](https://code.visualstudio.com/) can open plists as well)

### Preparing the AppleALC Source Code
- Clone, Fork or download (click on "Code" and "Download Zip") the [**AppleALC**](https://github.com/acidanthera/AppleALC) Source Code 
- Download the Debug Version of [**Lilu Kext**](https://github.com/acidanthera/Lilu/releases) and copy it to the "AppleALC" root folder
- In Terminal, enter: `cd`, hit space and drag and drop your AppleALC folder into the window and press enter.
- Next, enter `git clone https://github.com/acidanthera/MacKernelSDK` and hit enter. This add the MacKernelSDK in the AppleALC source folder.

The resulting folder structure should look like this:</br>![AALC_Dir](https://user-images.githubusercontent.com/76865553/173291777-9bc1285d-1ffa-479f-b7bf-b74cda6f23ae.png)

#### Files we have to work on

|File             |Location            |Parameter(s)
-----------------|--------------------|----------
`info.plist`      |AppleALC/Resources/PinConfigs.kext/Contents/Info.plists |PinConfig
`PlatformsXX.xml` |AppleALC/Resources/subfolder for your Codec | PathMap
`layoutXX.xml`    |AppleALC/Resources/subfolder for your Codec | Layout-ID and others
`info.plist`      |AppleALC/Resources/subfolder for your Codec | PlatformsXX.xml.zlib </br> layoutXX.xml.zlib 

`XX` = Number of the chosen Layout-ID.

### 💡 Tips for editing

- To avoid conflicts with the AppleALC repo when creating a Pull Request, it's best to clone the Repo locally to work on the files before integrating the data into the source code.
- When integrating data into the source code, make sure to use Visual Studio Code or TextEdit to edit the files – especially when editing the info.plist indside of the PinConfig.kext. I have noticed that PlistEditoPro and even Xcode introduce changes in places you didn't even touch just by opening and saving the file.  I've seen changes in the formatting as well as changes in ConfigData. This will intoduce conflicts in the code when creating the Pull Request and it will be rejected.
- Add entries to both info.plists at the end of the corresponding sections to append lines to the source code only and not juggles lines around. The reduces chances of conflicts and makes the reviewing and merging process easier.

### Configuring Xcode
- Start Xcode
- Open the `AppleALC.xcodeproj` file located in the AppleALC folder
- Highlight the AppleALC project
- Under "Build Settings", scroll down to "User-Defined Settings" and check if the entries `KERNEL_EXTENSION_HEADER_SEARCH_PATHS` and `KERNEL_FRAMEWORK_HEADERS` exist
- If not, press the "+" button, click on "Add User-Defined Settings" and add them:<br>![Xcodsetings01](https://user-images.githubusercontent.com/76865553/170472634-9ead337e-0ccf-46d6-9cbe-8a988cf5d14b.png)
- Make sure that both point to "(PROJECT_DIR)/MacKernelSDK/Headers":</br>![Xcode_UDS](https://user-images.githubusercontent.com/76865553/170472740-b842f8ca-0bc7-4023-acc1-c9e30b68bbfa.png)
- Next, Link to custom `libkmod.a` library by adding it under "Link Binary with Libraries": ![Xcode_link](https://user-images.githubusercontent.com/76865553/170472832-5a077289-96a6-403d-b8c7-322459ff3156.png)
- Verify that `libkmod.a` is present in /MacKernelSDK/Library/x86_64/ inside the AppleALC Folder. Once all that is done, you are prepared to compile AppleALC.kext.

Now, that we've got the prep work out of the way, we can begin!

## III. Extracting data from the Codec dump
In order to route audio inputs and outputs for macOS, we need to analyze and work with data inside the Codec dump. To make the data easier to work with, we will use codec-graph to generate a schematic of the audio codec which makes routing audio much easier than working solely with the text file.

### Converting the Codec Dump 
1. Enter the Codec-Graph folder
2. Double-click `Convert_Dump`. 
3. This will start Codec-Graph (and perform an additional hex to decimal conversion)
4. Follow the on-screen instructions to convert the Codec dump
5. This creates 3 new files inside the "output" folder:
	- **`codec_dump_dec.txt`** &rarr; Codec dump converted from Hex to Decimal. We need it since the data has to be entered in decimals in AppleAlC's .xml files.
	- **`codecdump.svg`** – Schematic of the Codec.
	- **`codecdumpdec.svg`** &rarr; Schematic of the Codec converted from hex to decimal. We will work with this primarily. You can open it in the web browser to view it in full size.
6. Next, run PinConfigurator
7. Select "File > Open…" (⌘+O) and open "codec_dump.txt"
8. This will extract the available audio sources from the Codec dump
9. Select File > Export > **`verbs.txt`**. It will will be stored on the Desktop automatically. We may need it later.

### Relevant Codec data
Amongst other things, the Codec dump text contains the following details:

- The Codec model
- Its Address (usually `0`)
- It's Vendor Id (in AppleALC it's used as `CodecID`)
- Pin Complex Nodes with Control Names (these are eligible for the `PinConfig`)
- The actual routing capabilities of the Codec:
	- Pin Complex Nodes
	- Mixer/Selector Nodes
	- Audio Output Nodes
	- Audio Input Nodes
	- Number of connections from/to a Node/Mixer/Selector/Switch

## IV. Understanding the Codec schematic and signal flow
Shown below is `codecdumpdec.svg`, a visual representation of the data inside the codec dump for the **Realtek ALC269VC** used in my Laptop. It shows the routing capabilities of the Audio Codec. Depending on the Codec used in your system, the schematic will look different![^3]

![codec_dump_dec](https://user-images.githubusercontent.com/76865553/170470041-6a872399-d75a-4145-b305-b66e242a1b47.svg)

[^3]: This repo contains some more Codec dumps with schematics you can check out.

Form/Color        | Function
------------------|-----------------------------------------------
**Triangle**      | Amplifier
**Blue Ellipse**  | Audio Output
**Red Ellipse**   | Audio Input
**Parallelogram** | Audio selector (this codec doesn't have any)
**Hexagon**       | Audio mixer (with various connections 0, 1, 2,…)
**Rectangle**     | Pin Complex Nodes representing audio sources we can select in system settings (Mic, Line-out, Headphone etc.)
**Black Lines**   | Default connection (indicated by an asterisk in the Codec_Dump.txt)
**Dotted Lines**  | Optional connection(s) a Node offers 
**Blue Lines**    | Connections to the Outputs

### How to read the schematic
⚠️ The schematic is a bit hard to comprehend and interpret because of its structure. It's also misleading: since all the arrows point to the right one might think they represent the signal flow – they don't. So ignore them! Instead, you need to take an approach which follows the signal flow.

#### Routing Input Devices
For **Input Devices**, start at the Input Node (red) and trace the route to the Pin Complex Node. 

- **Option 1**: Input &rarr; Mixer/Audio Selector &rarr; PinComplex Node:

	```mermaid
	flowchart LR
		id1(((Input))) -->|Signal flow|id2{Mixer A} -->|Signal flow|id3(Pin Complex XY)
		id4(((Input))) -->id5[/Audio Selector/]-->id6(Pin Complex XY)
	```
- **Option 2**: Input &rarr; PinComplex Node:

	```mermaid
		flowchart LR
		id1(((Input))) ------>|Direct Connection|id3(Pin Complex XY)
	```
#### Routing Output Devices
For **Output Devices**, start at the Pin Complex Node and follow the signal through Audio Mixer(s)/Selectors to the physical output.Here are some examples of possible routings.

- **Option 1**: Pin Complex Node &rarr; Mixer/Audio Selector &rarr; Output (common):

	```mermaid
	flowchart LR
       id1(Pin Complex XY) -->|Signal flow|Aid2{Mixer A} -->|Signal flow|id5(((Output X)))
       id3(Pin Complex XY)-->id2[/Audio Selector/]-->id6(((Output X)))
	 ```
- **Option 2**: Direct connection from Pin Complex Node to Output:

	```mermaid
	flowchart LR
       id1(Pin Complex XY) ---->|Direct Connection|id5(((Output X)))
	```

**NOTE**: Whether or not a signal traverses more than one Mixer Node depends on a Codec's design. What's important is to list all the "stations" a signal passes from the Pin Complex Node to the desired Output!

#### Routing Examples from ALC269

- **Internal Speakers** (Fixed):

	```mermaid
	flowchart LR
    	id1(Node 20: Speaker out) --> |Fixed path| id3{Mixer 12} --> id5(((Output 2)))
	```

- **Headphone Output**:

	```mermaid
	flowchart LR
    	id1(Node21: HP out) --> |possible path A| id3{Mixer 12} --> id5(((Output 2)))
    	id1(Node21: HP out) --> |possible path B| id4{Mixer 13} --> id6(((Output 3)))
	```
	**NOTE**: The number of possible paths depends on the number of connections a PinComplex Node provides. 
- **Internal Mic Input** (fixed/hardwired connection):

	```mermaid
	flowchart LR
    	   id1(((Input 9))) -->Aid2{Mixer 34} -->id2(Node 18: Mic Int. fixed)-.-> id3(Aux Return to Mixer 11)-.->id4(Etc.)
	```
- **Line Input**:
	
	```mermaid
		flowchart LR
   		   id1(((Input 8))) -->Aid2{Mixer 35} -->id2(Node 24: Mic Jack)-.-> id3(Aux Return to Mixer 11)-.->id4(Etc.)
	```

**💡 About Signal Flow**

The ALC 269 Codec includes an Aux Return to send (or return) the incoming signal back into the Output path for monitoring via Mixer 11 through either Mixer Nodes 12/13 or 15 (Mono). 

If you'd trust the arrows in the schematic, the existence of Mixer 11 wouldn't make any sense. That's why ***you need to follow the signal flow instead of the arrows!*** For the `PathMap`, you only need to enter the path following this formula: Input &rarr; Mixer &rarr; PinComplex Node.

#### Tracing possible paths
Since I want the Line-Out of my docking station dock to work, I need to assign some other Pin Complex Node to Mixer 13. 

We can use the .svg schematic to trace all available paths the codec provides and create a chart with it, which helps when transferring the data to a Platforms.xml fle later:

Node ID (Pin Complex)| Device Name/Type            | Path(s)               | EAPD
--------------------:|-----------------------------|-----------------------|:--------:
18 (In)              |Internal Mic                 | 9 - 34 - 18 (**FIXED**)|
20 (Out)             |Internal Speakers (S)        | 20 - 12 - 2 (**FIXED**)| YES
21 (Out)             |Headphone Output (S)         | 21 - 12 - 2 or </br>21 - 13 - 3|YES
23 (Out)             |Speaker at Ext Rear (M)      | 23 - 15 - 2 (Mono) |
24 (as Output)       |Mic/Line-In (Jack) (S)       | 24 - 12 - 2 or </br>24 - 13 - 3|
24 (as Input)        |(Jack) Mic at Ext Left       | 8 - 35 - 24 or </br> 9 - 34 - 24
25 (as Output)       |Speaker Ext. Rear (S) OUT Detect| 25 - 12 - 2 or </br>25 - 13 - 3
25 (as Input)        |Speaker Ext. Rear (S) IN Detect| 8 - 35 - 25 or </br>9 - 34 - 25
26 (as Output)       |Speaker at Ext Rear OUT HP Detect| 26 - 12 - 2 or</br>26 - 13 - 3
26 (as Input)        |Speaker at Ext Rear IN HP Detect| 8 - 35 - 26 or </br> 9 - 34 - 26 
27 (as Output)       |Speaker at Ext Rear OUT Detect| 27 - 13 - 3 or </br>27 - 12 - 2
27 (as Input)        |Speaker at Ext Rear IN Detect| 8 - 35 - 27 or </br> 9 - 34 - 27 or
29 Mono (as Input)   |Mono In                      | 8 - 35 - 29 or </br> 9 - 34 -29
30 (Digital Out)     |Speaker Ext. Rear Digital (S/PDIF)| 6 - 30|

After a many, many trials, I settled with the following routing:

Node ID (Pin Complex)| Device Name/Type            | Path(s)                | EAPD
--------------------:|-----------------------------|------------------------|:-----:
18 (In)              |Internal Mic                 | 9 - 34 - 18 (**FIXED**)|
20 (Out)             |Internal Speakers (S)        | 20 - 12 - 2 (**FIXED**)| YES
21 (Out)             |Headphone Output (S)         | 21 - 13 - 3            | YES
24 (as Input)        |(Jack) Mic at Ext Left       | 8 - 35 - 24            |
25 (as Input)        |Speaker Ext. (S) IN Detect   | 8 - 35 - 25            |
27 (as Output)       |Speaker Ext. Rear OUT Detect | 27 - 13 - 3            |

<details>
<summary><strong>Double-Checking</strong> (click to reveal)</summary>

##### Double-Checking against codec-dump_dec.txt
We can also use the codec dump to verify the routing. Here's an example for Node 21 which is the main output of the T530:

![Node21](https://user-images.githubusercontent.com/76865553/170473509-a3e96ded-c9db-4de5-9774-40b6ef094629.png)

As you can see, Node 21 has 2 possible connections (Node 12 and 13) and is currently connected to Node 13, which is one of the Audio mixers:

![Node13](https://user-images.githubusercontent.com/76865553/170470502-7c4952c7-b865-4b63-9d58-d74ec38fe278.png)

 And Node 13's final destination is Node 3, which is the HP out:

![Node3](https://user-images.githubusercontent.com/76865553/170470592-22c22176-f1f9-4aec-91b0-6b829c6bdbb1.png)
</details>

We will come back to the schematic later… 

## V. Creating a PathMap
The PathMap defines the routings of the Nodes within the Codec which are injected into macOS. Some routings are fixed (internal Speakers/Mics) while others can be routed freely. some Nodes can even be both, input and output.

### Structure of `PlatformsXX.xml`
1. The PathMap has to be entered in `PlatformXX.xml` (`XX` = chosen number of the Layout-ID). 
2. The way inputs and outputs are organized within the hierarchy of the PathMap defines whether or not the system switches between sources automatically if a device is plugged in or if the inputs/outputs have to be changed manually in System Preferences (as VoodooHDA.kext requires). For auto-switching between sources to work, they have to be in the same group/array. Usually you create a group for inputs and a group. for outputs.

#### Auto-Switching Mode
In Auto-Switching Mode, the Input/Output signal is re-routed from the current Input/Output to another one automatically, once a jack is plugged into the system. On Laptops for example, Internal Speakers are muted and the signal is automatically re-routed to the Headphone or Line Output. Once the plug is pulled from the audio jack, the output switches  back to the internal speakers. Same for Inputs: the Internal Mic is muted when an external Mic or Headset is plugged into the 1/8" audio jack.

For Auto Switching-Mode to work, certain conditions have to be met: 
- The Pin Complex Node(s) must support the "Detect" feature
- The Pin Complex Node(s) must have at least 2 possible connections to 2 different Mixer Nodes or Audio switches. Maybe switching between 2 Nodes connected to the same Mixer Node works as well but I haven't tested it yet.

Let's have a look at the output side of the schematic:</br>![SwitchMode01](https://user-images.githubusercontent.com/76865553/171393009-65312baf-77c3-41d6-96d6-18359933aad5.png)

- Nodes 20, 21, 24, 25, 26 and 27 support the Detect feature
- These Nodes can all connect to Mixers 12 (red) and 13 (green)
- Therefore, they can be operated in Auto Switching Mode

Nodes that make up the audio "circuitry" as well as the switching behavior have to be represented in the file structure of the `PathMap`. Nodes you want to switch between have to be part of that same Array (one for Inputs, one for Outputs). Here's how the structure inside the Platforms.xml file looks:

- PathMaps (Array)
	- 0 (Dict) (Codec Address)
		- PathMap (Array)
			- **0 (Array) [INPUTS]** (Sources you want to switch between)
				- 0 (Array) [Input Source 1]
					- 0 (Array) [Container for Nodes of Input Source 1]
						-  0 (Dict) Input Node 
						-  1 (Dict) Mixer Node
						-  2 (Dict) Pin Complex Node
				- 1 (Array) (Input Source 2)
					- 0 (Array) [Container for Nodes of Input Source 2]
						-  0 (Dict) Input Node 
						-  1 (Dict) Mixer Node
						-  2 (Dict) Pin Complex Node
					- etc.
			- **1 (Array) [OUTPUTS]**
				- 0 (Array) [Output Source 1]
					- 0 (Array) [Container for Nodes of Output Source 1]
						-  0 (Dict) Pin Complex Node
						-  1 (Dict) Mixer Node
						-  2 (Dict) Output Node
				- 1 (Array) (Output Source 2)
					- 0 (Array) [Container for Nodes of Output Source 2]
						-  0 (Dict) Pin Complex Node
						-  1 (Dict) Mixer Node
						-  2 (Dict) Output Node
				- etc. 

#### Manual Switching Mode
In manual switching mode, you have to switch/select Inputs/Outputs manually in the Audio Settings. In this configuration, each Array only contains the nodes for the path of one device. The structure looks as follows:

- PathMaps (Array)
	- 0 (Dict) (Codec Address)
		- PathMap (Array)
			- 0 (Array)
				- 0 (Array) (Device 1) (Input 1)
					- 0 (Dict) (Nodes of Input 1)
						- 0 (Dict) (Input Node)
						- 1 (Dict) (Mixer Node)
						- 2 (Dict) (Pin Complex Node)
			- 1 (Array)
				- 0 (Array) (Device 2) (Input 2)
					- 0 (Dict) (Nodes of Input 2)
						- 0 (Dict) (Input Node)
						- 1 (Dict) (Mixer Node)
						- 2 (Dict) (Pin Complex Node)
			- 2 (Array)
				- 0 (Array) (Device 3) (Output 1)
					- 0 (Dict) (Nodes of Device 1)
						- 0 (Dict) (Pin Complex Node)
						- 1 (Dict) (Mixer Node)
						- 2 (Dict) (Output Node)
			- etc.

Now that we know to enter the routing data into the PlatformsXX.xml file, we can begin entering the data in a new file.

⚠️ **NOTES**

- Make sure to get the hierarchy of the Platforms.xml right. Otherwise there won't be any Input/Output Sources available!
- Nodes used in the `PathMap` must exist in the `PinConfig`! You might have to go back and forth between generating a `PinConfig`, adding/updating it in the info.plist inside of `PinConfigs.kext` and adjusting the `PlatformsXX.xml` to make it all work!
- You can combine both, auto switching and manual switching. For example, you could use auto mode to switch back and forth between internal Speakers and the Headphone Out but add an extra Line-Out in manual mode if your Codec can't be configured to switch between all three sources automatically (if it lacks an Audio Switch).

## VI. Creating a `PlatformsXX.xml`
There are 2 methods for creating a `PlatformsXX.xml` file: one utilizes VoodooHDA.kext and a forgotten script called `GetDumpXML`. It generates a `Platforms.xml` file, which contains all the required Nodes for switching Inputs/Outputs manually. It works out of the box and allows you to skip Chapter IX completely which is a big time saver. Unfortunately, this method doesn't work beyond macOS Catalina, so users of Big Sur and newer need to follow the manual method instead.

### Automated method using VoodooHDA and GetDumpXML (macOS ≤ 10.15.7 only)
- Download [**GetDumpXML.zip**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/L_ALC_Layout-ID/Tools/GetDumpXML.zip?raw=true) and unpack it
- Add VoodooHDA.kext to your EFI's kext folder and config.plist.
- Disable/delete AppleALC.kext
- Reboot
- Double-click `GetDumpXML` (in GetDumpXML folder)
- This will create a "GetDumpXML_YOURCODEC" folder on the desktop, containing a `Platforms.xml` file.
- Add the # of your chosen Layout-ID to the filename (`Platforms39.xml` in my case)
- Open the File with a Plist Editor
- Expand `PathMaps` branch. As you can see, the entries are organized for manual switching:</br>![VoodooHDAXML01](https://user-images.githubusercontent.com/76865553/172041677-93a86db8-af31-4172-a68f-dffcc0888646.png)
- Compare the Nodes used in the PathMap with the Nodes present your PinConfig and adjust the PinConfig accordingly, so that it contains the same nodes as the PathMap!
- Change `PathMapID` to the number of your Layout-ID!
- Save the file
- Move PlatformsXX.xml to: "AppleALC/Resources/YOURCODEC" folder
- Disable/remove VoodooHDA.kext and re-enable AppleALC.kext again
- Reboot
- Continue in Chapter X.

**NOTE**: You can also rearrange the structure of the .xml file to introduce auto-switching, but I would do that after you've verified that everything is working.

### Manual Method
Obviously, we need to avoid changing data of existing Platforms.xml files created by other users. Because it would destroy the Layout for other users, if the Source Code would get synced with the AppleALC repo. Instead, we need to create a new one for our Layout-ID with our own routing, so do the following:

- In Finder, navigate to the "Resources" folder for your Codec. For me, it's `AppleALC/Resources/ALC269`.
- Select the `Platforms.xml` of the Layout-ID you are currently using (the number is identical). Since I am using ALC Layout-ID 18, I use Platforms18.xml.
- Duplicate the file (⌘+D)
- Change the name to the Layout-ID you chose (For me Platforms39.xml)
- Change the `PathMapID` at the bottom of list so it's identical to the number of your Layout-ID (in my case it's `39`):</br>![platforms02](https://user-images.githubusercontent.com/76865553/171393131-44cd8562-104b-4008-9a4d-43707b880327.png)

## VII. Transferring the PathMap to `PlatformsXX.xml`
Now that we traced all the possible paths to connect Pin Complex Nodes with Inputs and Outputs, we need to transfer the ones we need to a PlatformXXX.xml file. "XY" corresponds to the previously chosen Layout-ID. In my case it will be `Platforms39.xml`.

### Transferring PinComplex Nodes to PlatformsXX.xml
1. Take the chart with the possible connections you traced in Chapter IV.
2. Decide which Input/Output Device(s) you want to add to the PathMap
3. Decide if you want to add the device(s) in a switch mode configuration or if you want switch the device manually.
4. Add the Nodes to the PlatformsXX.xml accordingly

For reference, Let's have a look how Switch-Mode for Outputs is realized in ALC Layout-ID 18 inside of `Platforms18.xml`:</br>![PlatformsStructure01](https://user-images.githubusercontent.com/76865553/171393277-13b2ec45-ec83-452c-ba5d-06aaab795d74.png)

On the Input side, the structure is the same. The only difference is that the order of the nodes is reversed: instead of tracing the path from the Pin Complex Nodes to the Outputs, you start at the output and trace the path back to the Pin Complex Node:</br>![PlatformsStructure02](https://user-images.githubusercontent.com/76865553/171393394-0244592c-a961-4ab7-ae1f-1942dbd6a5d4.png)

- Enter the required Node IDs you found in chapter IV for the Inputs and Outputs you need (as explained). 
- To add more devices to the PathMap, duplicate one of the "Source" Array and change the data.
- Once, you're done, save the file.

**NOTE**: `LayoutID` and `PathMapID` **must be identical** and must use the same number you chose for your Layout-ID previously.

#### Example: Finished PathMap for Layout39
Here's how the finished `Platforms39.xml` with added Node 27 in Auto Switch Mode looks like:

![Outputs_final01](https://user-images.githubusercontent.com/76865553/173155479-1d16c43c-ffc1-47f6-9998-3e4ad3e4a9fa.png)

On the Input side, the PathMap looks like this:

![Inputs_final01](https://user-images.githubusercontent.com/76865553/173155511-e9f260fd-5c80-4f0a-a12b-8388b15960ba.png)

Array 2 (Line-In, manual mode) is an extra Line-In connection with path 8 – 35 – 24. It can be used to override the Line-In of the Headphone jack in order to attach a different mic or audio input to it. 

Since the T530 uses a Combojack which integrates the input and output into the Headphone jack, simply plugging a headset into it reserves the Line-In as long as it is physically connected because headsets have a plug with 4 poles (Mic, Ground, L and R Audio). So automatic switching to a Line-In of the dock is not possible. Therefore, you have to switch between Line-In of the dock and the Line-In of the HP jack manually in System Settings:

![Lineinswitch](https://user-images.githubusercontent.com/76865553/173165968-e4a607c7-a32b-4610-a7c3-1f44e4c40b55.png)

### Amp Capabilities
Besides entries for the Nodes that the incoming/outgoing signal traverses, the Codec dump also includes entries for Amp stage(s) which have to be reflected in the **Platforms.xml** as well.

#### Amp Node (Input side)
For Inputs, the Amp is usually part of the first entry in the chain, the Input Node: 

![Amp01](https://user-images.githubusercontent.com/76865553/171593290-792700c2-f82d-4d8e-93bd-0ce5bc22a0c6.png)

Let's have a look inside the Input Amp Array:

![Amp02](https://user-images.githubusercontent.com/76865553/171593343-ea59ec99-c65d-4a2a-be82-317734595db5.png)

The available options/features of the Amp Array are part of the PinComplex Node it belongs to (Input Node 9 in this example) as defined in the codec_dump_dec.txt. So let's see, what it says:

![Amp03](https://user-images.githubusercontent.com/76865553/171593456-b85e243a-8f65-4abc-a824-986f5c46dbc3.png)

For Node 9 (and others), there's an entry called "Amp-In Caps", which among other things contains different parameters.

#### Amp Node (Output side)
Next, let's look at Array 1 of the PathMap, which contains the Output Devices:

![Amp04](https://user-images.githubusercontent.com/76865553/171671059-bc3a8b93-fa9a-45d6-99fa-ba05ea5fc50c.png)

As you can see, for the ALC269, each Node of the Output Path has an Amp stage and the "Channels" array is part of the last Node in the chain rather than the first Node.

### Transferring Amp Capabilities to PlatformsXX.xml

Here's how "Amp Caps" translate to entries in the .xml file:

codec_dump.txt         | PlatformsXX.xml
-----------------------|----------------------------
Mono/Stereo Amp-In/Out | **Channels** Array with 1 or 2 Dictionaries: 2=Stereo, 1=Mono</br> ⚠️ The "Channels" Array is only present **once** in a path: </br> • In Input Devices it's included in the *first* node</br> • In Output Devices side it's included in the *last* Node!|
**Amp-In Caps**</br>**nsteps**= 0 or ≥1 |</br>**VolumeInputAmp** (NO/YES)
**mute**=0 or 1        | **MuteInputAmp** (NO/YES)
**nsteps**=3           | **Boost** Level (=3) on the input. Applied to the destination Node (last Node in the chain). In this example to Node 18 "Internal Mic Boost Volume". For ALC269 is also applies to Nodes 11, 24, 25, 26, and 27.||
**Amp-Out Caps**</br>**nsteps** 0 or ≥1   |</br>**PublishVolume** (NO/YES)
**mute**=0 or 1        | **PublishMute** (YES/NO)

**Explanations**: 

- `Mute` in Amp-In an Amp-Out Nodes are different functions in Platforms.xml:
	- `mute` in ***Amp-In Nodes*** = `MuteInputAmp`
	- `mute` in ***Amp-Out Nodes*** = `PublishMute`
- `Nsteps` also has different functions whether it's used in Amp-In or Amp-Out Nodes:
	- `nsteps` in ***Amp-In Nodes*** = `VolumeInputAmp`
	- `nsteps` in ***Amp-Outs Nodes*** = `PublishVolume`
	- `nsteps=3` in **Amp-In Node** = `Boost` factor 3 last Node of the Chain on the Input Device (as shown in the first screenshot)

#### Usual Amp Settings used in PlatformsXX.xml

- For **Inputs**:
	- MuteInputAmp: NO
	- PublishMute: YES
	- PublishVolume: YES
	- VolumeInputAmp: YES

- For **Outputs**:
	- MuteInputAmp: YES
	- PublishMute: YES
	- PublishVolume: YES
	- VolumeInputAmp: NO

### Example: Adding an Output device to the PlatformsXX.xml

As we figured out in Chapter IV and VII, possible paths for adding Node 27 as an Output device can be: 27 &rarr; 13 &rarr; 3 or 27 &rarr; 12  &rarr; 2. I may have to try both. 
Since I want the Output to switch from the speakers (connected via 21 &rarr; 12 &rarr; 2) to the dock when I pluck my speakers in, I first try to connect Node 27 to Mixer 12 and Output 2 as well and see if it switches between Node 21 and 27.

So, I add the path 27 - 12 - 2 to `Platforms39.xml`:

- Open PlatformsXX.xml (`XX` = number you chose for your Layout-ID)
- Navigate to the branch containing the Output Devices (expand PathMaps > 0 > PathMap > 1):</br> ![Outdevs01](https://user-images.githubusercontent.com/76865553/171813688-09bc6040-cbe8-4262-ad62-0321297df4cb.png)
- Duplicate Array 1 (Output Device 2). The Output device branch should contain 3 arrays now:</br>![Outdevs02](https://user-images.githubusercontent.com/76865553/171813707-703f1526-54da-454d-b1d3-879d34efc61e.png)
- Next, we need to correct the Nodes inside of Array 2 (Output device 3) to 27, 12, 2: </br>![Outdevs03](https://user-images.githubusercontent.com/76865553/171813717-e691b1fc-7d26-45cd-8a97-3896b1621bcf.png)
- Next, we need to take care of the Amp section of Node 27. Since we are configuring as an output, we can use the default settings for testing:
	- **MuteInputAmp**: YES
	- **PublishMute**: YES
	- **PublishVolume**: YES
	- **VolumeInputAmp**: NO 
- For Inputs, you also have to check the `nsteps` value of the Amp-In Caps and add an entry for "Boost" to the last Node of a path. If `nsteep=3`. Take For example 
- Repeat for other devices you want to add to the PathMap
- Save the file

### Example: Adding an Input device to the PlatformsXX.xml
- Open PlatformsXX.xml (`XX` = number you chose for your Layout-ID)
- Navigate to the branch containing the Input Devices (expand PathMaps > 0 > PathMap > 0):</br>![InputsArray0](https://user-images.githubusercontent.com/76865553/173223277-d471a722-bf75-47ba-bea5-a84c6c313689.png)
- Duplicate an existing Device Array
- Adjust the following:
	- Node IDs (according the the path of the source you want to add), 
	- Amp Settings
	- Boost Settings (If `Amp-In Caps` of destination Node contain `nsteps=3`, add `Boost` entry to the last Node in the path (here NID 25)
- Let's look inside Device 2. It contains the following Nodes and settings:</br>![Input01Nodes](https://user-images.githubusercontent.com/76865553/173223291-53c78f9e-976e-4044-9eb8-812b709dee86.png)
- Repeat for other devices you want to add to the PathMap
- Save the file.

## VIII. Adding/Modifying `layoutXX.xml`
The layoutXX.aml file defines for which Codec the Layout is for (`CodecID` = `Vendor Id` in codec_dump_dec.txt) and describes the types of Inputs and Outputs that are available. It also contains the reference to the PathMap which should be applied to the Codec (`PathMapID`) for the chosen `LayoutID` (ID 39 in this example).

### Modifying an existing `layoutXX.xml`
- Navigate to `AppleALC/Resources/YOUR_CODEC` (in my case ALC269)
- Duplicate the `LayoutXX.xml` you want to modify (in my case layout18.xml)
- Change the number of the filename an unused one (between 11 to 99). In my case: layout39.xml
- Open it with a Plist Editor 
- Change the `LayoutID` &rarr; must be identical with # used in the filename
- Expand `PathMapRef`
- Adjust the following settings:
	- `Inputs`: Add Type of Inputs (if missing)
	- `Output`: Add Type of Output (if missing). I have to add `LineOut` for my Docking Station.
	- `PathMapID` (# must match that of the filename):</br>![layoutxml](https://user-images.githubusercontent.com/76865553/172024303-0485b52c-1f2f-4615-bcac-bdd056ea745b.png)
- Save the file.

### Calculating MuteGPIO
`MuteGPIO` is responsible for enabling/disabling Mic and LineIn Amps. It has to be entered in the layout.xml in decimal (if it is not present already):

![](https://user-images.githubusercontent.com/76865553/172787254-f5fe21fb-5466-49a6-afcc-87c16391aa71.png)

`MuteGPIO` is calculated based on the following formula:  

`Vref hex + 0100 + Node ID hex` &rarr; Converted to Dec. 💡 Use the Calculator  inside of Hackinool to convert the value.

Let's have a look at the "Vref caps" of Node 24 ("Mic Boost Volume") inside of the Codec dump: 

"Vref caps: HIZ 50 GRD 80 100" &rarr; GRD 80 is the value which pulls the connection to the ground (disables it). 

A bit further down we find this line: 

"Pin-ctls: 36: **IN VREF_80**" &rarr; this is the confirmation that this Node uses a VREF of 80 %, as most Codecs do.

If we use 80% as a reference for Node 24 and apply the formula from the beginning, we get:

0x50 (80 in hex) + 0100 + 0x18 (Node 24 in hex) = 0x50010018 (Hex) &rarr; **1342242840** (Dec). This is the value which has to be added for this Node.

#### MuteGPIO Table
With the table below, you only have to copy the **decimal** value for your Node(s) based on the "IN VREF_" method your Codec uses (50 or 80) and add the `MuteGPIO` value to the layout.xml file.

NodeID | GPIO VREF = 50%</br>Dec | GPIO VREF = 50% </br>Hex| GPIO VREF = 80%</br>Dec |GPIO VREF = 80% </br>Hex|GPIO VREF = ?%</br>Dec |GPIO VREF = ?% </br>Hex|
:-:|:-------------:|:----------:|:--------------:|:----------:|:--------------:|:----------:
20 | **838926356** | 0x32010014 | **1342242836** | 0x50010014 | **1677787156** | 0x64010014
21 | **838926357** | 0x32010015 | **1342242837** | 0x50010015 | **1677787157** | 0x64010015
22 | **838926358** | 0x32010016 | **1342242838** | 0x50010016 | **1677787158** | 0x64010016
23 | **838926359** | 0x32010017 | **1342242839** | 0x50010017 | **1677787159** | 0x64010017
24 | **838926360** | 0x32010018 | **1342242840** | 0x50010018 | **1677787160** | 0x64010018
25 | **838926361** | 0x32010019 | **1342242841** | 0x50010019 | **1677787161** | 0x64010019
26 | **838926362** | 0x3201001A | **1342242842** | 0x5001001A | **1677787162** | 0x6401001A
27 | **838926363** | 0x3201001B | **1342242843** | 0x5001001B | **1677787163** | 0x6401001B
28 | **838926364** | 0x3201001C | **1342242844** | 0x5001001C | **1677787164** | 0x6401001C
29 | **838926365** | 0x3201001D | **1342242845** | 0x5001001D | **1677787165** | 0x6401001D
30 | **838926366** | 0x3201001E | **1342242846** | 0x5001001E | **1677787166** | 0x6401001E
31 | **838926367** | 0x3201001F | **1342242847** | 0x5001001F | **1677787167** | 0x6401001F
…  |

### Creating a new `LayoutXX.xml` from scratch
TODO…

## IX. Creating a PinConfig 
Audio Codecs support various Inputs and Outputs: Internal speakers and a mic (usually on Laptops) as well as Line-Ins and Outs (both analog and digital). These audio sources are injected into macOS by AppleALC as a long sequence of code (or "verbs") which form the so-called `PinConfig`. It's the single most important parameter to get Audio Inputs and Outputs working properly.

"Verbs" consist of a combination of 4 components: the Codec's address, Pin Complex Nodes with Control Names, Verb Commands and Verb Data which has to be extracted from the Codec dump, corrected and injected into macOS via AppleALC kext. Here's a color-coded example showing all the paramaters (and their positions in the bitmask) that form the PinDefault value of a Pin Complex Node:

![PinComplexNodeStructure](https://user-images.githubusercontent.com/76865553/174908462-07db8885-9337-4e34-b620-54619c38db06.png)

If you're interested in the tedious process of extracting verbs from a Codec dump *manually*, please refer to Parts 2 and 3 of [EMlyDinEsH's guide](https://osxlatitude.com/forums/topic/1946-complete-applehda-patching-guide/).

Luckily for us, we can use **PinConfigurator** to extract Verbs from the Codec dump automatically insteas and also apply corrections to them easily.

⚠️ Make sure that your `PinConfig` contains ***all*** the Input and Output Nodes (Mixers/Switches are irrelevant) you are referring to in the `PathMap` so the routing is coherent. If you are referencing a node in a path which doesn't exist (in the PinConfig) then there will be no sound for this path. On the other hand, you can have more Nodes in the PinConfig than you are actually assigning in the PathMap – they just won't be available/visible in System Preferences as Input/Output sources.

### Using PinConfigurator to create a PinConfig

#### Default Method (keeps connected Nodes only)
Preferred method if you just want to inject the default Input/Output sources into macOS (Double-check against Nodes used in the Platforms.xml and if necessary, adjust them accordingly).

1. Open **PinConfigurator**
2. Click on "File > Open…" (⌘+O) and select "codec_dump.txt"
3. This will extract and import all the available audio sources from the Codec dump:</br>![PCnu01](https://user-images.githubusercontent.com/76865553/171392638-7a72f44b-8e13-4ff4-ae9e-9e24d11accda.png)
4. Next, click on "Patch > Remove Disabled". This will remove all Nodes which are not connected except ATAPI Internal (= Optical Drive):</br>![PCnu02](https://user-images.githubusercontent.com/76865553/171389936-1931ef51-b2ae-4f5b-889e-d02acc057710.png)
5. Click on "Options > Verb Sanitize" and enable all the options:</br>![Verbfixes](https://user-images.githubusercontent.com/76865553/171390150-65fb7777-666d-4385-8798-ed2288bfd6e5.png)
6. Select "Patch > Verb Sanitize". This will apply [various fixes](https://github.com/headkaze/PinConfigurator#what-patch-apply-verbit-fix-does-now) to the PinDefault values and Verb Data so that the `PinConfig` will work in macOS.
7. Next, click on "Get ConfigData":</br>![PCnu04](https://user-images.githubusercontent.com/76865553/171390411-5335a259-2aae-4e27-82fa-cb00f3799ecf.png)
8. Copy the `ConfigData` into the clipboard
9. Select "File > Export > verbs.txt". It will be stored on the Desktop.
10. Open verbs.txt.
11. Paste the ConfigDate in an empty line and save the file. We'll need it later.
12. Continue in **Chapter X.**

#### Modifying an existing PinConfig (adding Outputs/Inputs)
In case you already have a somewhat working Layout-ID that you want/need to modify, you can import its PinConfig into PinConfigurator for editing. There are 2 methods to do it:

##### Method 1: Importing PinConfig from IO Registry
If `AppleALC.kext` is loaded, you can import the `PinConfig` directly from the I/O Registry:

1. Open PinConfigurator
2. From the menubar, select "File > Import > IO Registry"
3. Select the Audio Codec (not the HDMI port)
4. Check `codecdumpdec.svg` to find the Pin Complex Nodes you want to add to the current PinConfig and modify it as explained in the next section

##### Method 2 Importing PinConfig from PinConfigs.kext
If AppleALC is not loaded or you want to import a different PinConfig for your Codec, do the following:

1. Open the `info.plist` inside the `PinConfig.kext` (in AppleALC/Resources)
2. Use the search function to to find the Layout-ID you want to modify:
	- Search by `CodecID` (look it up in `codec_dump_dec.txt`) and skip through the results until you find it, or
	- Search by the description the author added to the `Codec` string – like the Codec name, Laptop or Mainboard model for example.
3. Select the data inside the `ConfigData` field (⌘+A) and copy it (⌘+C):</br>![Modpinconf](https://user-images.githubusercontent.com/76865553/171391426-5b518d5d-f0f4-464c-89e5-9eb65b7437fe.png)
4. Start the PinConfigurator App
5. From the menubar, select "File > Import > Clipboard"
6. This is how it looks:</br>![pincfgimprtd](https://user-images.githubusercontent.com/76865553/171391513-9cf5d5a7-b83f-4641-a11f-87603092306b.png)
7. Check `codecdumpdec.svg` to find the Pin Complex Nodes you want to add to the current PinConfig.[^2]

[^2]: In my case, the PinConfig lacks a second Output to get sound out of the docking station's jack when I plug in external speakers. The Layout-ID I am currently using (ID 18 for ALC269) was created for the Lenovo X230 which is very similar to the T530 in terms of features. It uses the same Codec revision and works fine besides the missing Line-Out for the dock. Since Node 27 has a Headphone Playback switch as well, I will add it to the current PinConfig. For your configuring your Codec, you will have to refer to the Codec schematic and the codec dump text file to find appropriate nodes. In some cases you might even have to inspect the block diagram which is part of the documentation provided by the Codec manufacturer. 

There are 2 methods to do add a Node to the PinConfig: you can either add one in PinConfigurator and configure it manually or combine verb data inside the `verbs.txt` to "craft" one, copy it into memory and import it.

#### Adding Nodes, Method 1: Using `verbs.txt`

1. Open `verbs.txt`
2. Place the cursor at the end of the document 
3. Paste (⌘+V) the ConfigDate (green). It should still be stored in the Clipboard.
4. Next, add the Verb Data of the Node(s) you want to add (cyan) to the existing PinConfig:</br>![Modpfcg18](https://user-images.githubusercontent.com/76865553/171391880-12628a54-8cde-4a66-bf3b-7bd810f09bd7.png)
5. Copy the resulting PinConfig (pink) into the clipboard
6. Switch back to PinConfigurator
7. From the menubar, select File > Import > Clipboard. In this example, Node 27 has been added:</br>![modpinpc](https://user-images.githubusercontent.com/76865553/171392147-c6b4df49-8f51-46a5-a707-c2e0fc40a557.png)
8. Select "Patch > Verb Sanitize" to correct the Verb data.
9. Export the data. There are 2 ways to do so: 
	- Either copy/paste the ConfigData to a text file and save it for later, or 
	- Select "File > Export > "PinConfigs.kext" (it's located under /AppleALC/Resources/) to write the data to the info.plist of the kext directly.

#### Adding Nodes, Method 2: Using PinConfigurator's `Add` feature

1. In PinConfigurator, click "Add"
2. This opens a dialog with a bunch of options to configure the new Node:</br>![AddNode01](https://user-images.githubusercontent.com/76865553/172112636-1f207237-bb45-48a7-9b21-b20a72927e0a.png)
3. Use `verbs.txt` or `codec_dump.txt` to configure the Node (see "Config Notes")
4. Press "Save" when you're done. In my case, Node 27 will be added.
5. Select "Patch > Verb Sanitize". This will apply [fixes](https://github.com/headkaze/PinConfigurator#what-patch-apply-verbit-fix-does-now) to the PinDefault values and Verb Data so that the `PinConfig` will work in macOS.
6. Back in the main Window, click on "Get ConfigData"
7. The new/modified PinConfig will be listed in the text field below it:</br>![GetConfig02](https://user-images.githubusercontent.com/76865553/171392396-5dea072e-f57b-492f-b44e-d2819e2a74d7.png)
8. Export the data. There are 2 ways to do so: 
	- Either copy/paste the ConfigData to a text file and save it for later, or 
	- Select "File > Export > "PinConfigs.kext" (it's located under /AppleALC/Resources/) to write the data to the info.plist of the kext directly.

#### PinConfigurator's "Edit Node" window explained
PinConfigurator's "Edit Node" dialog window lets you configure the `PinDefault` value of a Node. Since the App is mostly undocumented, some of the settings are obvious while others are not (like "Misc", "Group" or "Position"). Luckily, chapter `7.3.3.31 Configuration Default` of the [Intel HDA specs](https://www.intel.com/content/www/us/en/standards/high-definition-audio-specification.html) provides the necessary explanations:

Parameter        | Description
-----------------|------------
**NodeID** (NID) | Add the Node number in decimal (get it from `codec_dump_dec.txt`). Only PinComplex Nodes with a Control Name are eligible! **Example**:</br>![PCNID](https://user-images.githubusercontent.com/76865553/173185594-cf4757df-47c0-4ae7-aaec-003e72ecaf73.png)
**PinDefault** | = **Configuration Default**. A 32-bit register required in each Pin Widget. It is used by software as an aid in determining the configuration of jacks and devices attached to the codec. At the time the codec is first powered on, this register is internally loaded with default values indicating the typical system use of this particular pin/jack. Get the `PinDefault` value (in Hex) from `codec_dump.txt`
**Device** | = **Default Device.** Indicates the intended use of the jack or device. This can indicate either the label on the jack or the device that is hardwired to the port, as with integrated speakers and the like.
**Connector** | = **Connection Type.** Indicates the type of physical connection, such as a 1/8-inch stereo jack or an optical digital connector, etc. Software can use this information to provide helpful user interface descriptions to the user or to modify reported codec capabilities based on the capabilities of the physical transport external to the codec.
**Port** | = **Port Connectivity**. Indicates the external connectivity of the Pin Complex. Software can use this value to know what Pin Complexes are connected to jacks, internal devices, or not connected at all. If a Node contains "fixed" in the Codec Schematic (usually for Laptop Speakers and Internal Mics) it should be set to fixed here as well.
**Gross Location** | Upper bits of the Location field describing the gross location, such as “External” (on the primary system chassis, accessible to the user), “Internal” (on the motherboard, not accessible without opening the box), on a separate chassis (such as a mobile box), or other. For Internal Speakers/Mics, set it to "Internal" (mostly Laptops), for things you connect to it by a plug, select "External".
**Geo Location** | Lower bits of the Location field. Provide a geometric location, such as “Front,” “Left,” etc., or provide special encodings to indicate locations such as mobile lid mounted microphones.
**Color** | Indicates the color of the physical jack for use by software.</br>- For internal devices: select "[0] Unknown" </br> - For external devices like Headphones etc.: select "[1] Black".
**Misc.** |Bit field used to indicate other information about the jack. Currently, only bit `0` is defined. If bit `0` is set, it indicates that the jack has no presence detect capability, so even if a Pin Complex indicates that the codec hardware supports the presence detect functionality on the jack, the external circuitry is not capable of supporting the functionality.
**Group** | = **Default Association**. Default Association and Sequence are used together by software to **group** Pin Complexes (and therefore jacks) together into functional blocks to support multichannel operation. Software may assume that all jacks with the same association number are intended to be grouped together, for instance to provide six channel analog output. The Default Association can also be used by software to prioritize resource allocation in constrained situations. Lower Default Association values would be higher in priority for resources such as processing nodes or Input and Output Converters.
**Position** | = **Sequence**. Indicates the **order** of the jacks in the association group. The lowest numbered jack in the association group should be assigned the lowest numbered channels in the stream, etc. The numbers need not be sequential within the group, only the order matters. Sequence numbers within a set of Default Associations must be unique.
**EAPD** | = **EAPD/BTL Enable, L/R Swap**. Controls the EAPD pin and configures Pin Widgets into balanced output mode, when these features are supported. It also configures any widget to swap L and R channels when this feature is supported. Check if the Node supports EAPD and adjust the setting accordingly. Read chapter 7.3.3.16 of the HDA Specs for more details.

#### Example: Final PinConfig for ALC269 for Lenovo T530 with Docking station 4337 an 4338

![PCfgFnl01](https://user-images.githubusercontent.com/76865553/173185501-f06f390b-819b-4859-9796-6cbac3487618.png)

## X. Integrating the `PinConfig` into the AppleALC source code
Now that we (finally) have our `PinConfig`, we have to integrate it into the AppleALC source code. Depending on your use case, the workflow differs. So pick a scenario which best suits your use case.

### Finding an unused Layout-ID number
In order to find a yet unused Layout-ID for your Codec, you have to check which Layout-IDs exist already and chose a different one in the range from 11 to 99:

- Visit [this repo](https://github.com/dreamwhite/ChonkyAppleALC-Build)
- Click on the folder of your Codec manufacturer (in my case it's "Realtek")
- Next, click on the .md file representing your Codec (in my case: [ALC269](https://github.com/dreamwhite/ChonkyAppleALC-Build/blob/master/Realtek/ALC269.md))
- As you can see, ALC269 has a lot of Layout-IDs already.
- Pick a Layout-ID which is not used already (make a mental note or write it down somewhere)

I am picking Layout-ID 39 because a) it's available and b) followed by by the Lenovo W530 which is the workstation version of the T530.

**IMPORTANT**: Layout-IDs 1 to 10 are reserved but Layouts 11 to 99 are user-assignable. 

#### Scenario 1: Modifying data of an existing Layout-ID

1. Open "codec_dump_dec.txt"
2. Copy the "Vendor-Id" in decimal (= `CodecID` in AppleALC)
3. Locate the `PinConfigs.kext` inside AppleALC/Resources
4. Right-click it and select "Show Package Contents"
5. Inside the Contents folder, you'll find the "info.plist"
6. Open it with a Plist editor. I am using PlistEdit Pro because it automatically converts `<data>` fields to base64 which we need.
7. All PinConfigs and the Layout-ID they are associated with are stored under:
	- IOKitPersonalities
		- as.vit9696.AppleALC
			- HDAConfigDefault
8. Use the search function (⌘+F) and paste the "Vendor Id". In my case it's "283902569". This will show all existing Layout-IDs your Codec.
9. For my test, Im am using entry number 162 as a base, since it's for the same Codec and was created for the the Lenovo X230 which is very similar to the T530 and works for my system:</br>![infoplist](https://user-images.githubusercontent.com/76865553/170472084-0dc4d888-1987-4185-a5b9-153e6fb2225c.png)
10. Highlight the dictionary and press ⌘+D. This will duplicate the entry.
11. Add/change the following data to the new entry:
	- In the `Codec` String: Author name (Yours) and description
	- In `ConfigData`, enter the PinConfig data we created in PinConfigurator (and saved in "verbs.txt")
	- Add `WakeConfigData`. It's part of the "verbs.txt":</br>![verbspcfg](https://user-images.githubusercontent.com/76865553/171962726-acbb19cd-e231-43f1-9499-6025f6f1898a.png)
	- Change the `LayoutID` the PinConfig Data should be associated with. 
12. This is the resulting entry:</br>![PCfginfopl](https://user-images.githubusercontent.com/76865553/171962769-834652b6-96e3-462e-bc39-3ed7e9c258af.png)
13. Highlight the raw text of this entry, exactly as shown below (whitespace included):
![01CopyPinCfgPlist](https://user-images.githubusercontent.com/76865553/173181910-77013179-0a5c-43b1-b2b6-1040d334e20b.png)
14. Copy the raw text to the Clipboard
15. Close the Plist Editor but **DON'T SAVE THE FILE!!!**

:warning: **IMPORTANT**: I've noticed that PlistEdit Pro and Xcode tend to mess up huge plist files and change formatting and data which shouldn't be changed and which you didn't even touch. This will result in your Pull Request being rejected. There have also been reports about Xcode changing `<integer>` to `<real>` which is a nightmare. Because if this slips into the source code unnoticed it will cause kernel panics during boot on the target system, which happened with the release of AppleALC 1.7.3.

To avoid this, use Visual Studio Code or TextEdit to paste the entry instead:

1. Open the `info.plist` again in Visual Studio Code (or TextEdit)
2. Scroll all the way to the end of the `HDAConfigDefault` array containing the entries for the PinConfigs and paste your entry right before the end of the `</array>` (you can use the vertical lines as a visual guide):</br>![PasteLayout01](https://user-images.githubusercontent.com/76865553/177260440-96c56b62-ef75-4354-a3f8-b757116e32cf.png)
3. Ensure that all keys in the dictionary consist of 1 line only: `<key>AAAAAA</key>`. Fix any line breaks that may be in raw text.
4. Save the file.
5. Open it again in Xcode or a Plist Editor and verify that the entry is in the correct location (at the end):</br>![02Verify](https://user-images.githubusercontent.com/76865553/173181933-5dff03a6-fbd0-46d1-bd99-40d9ee2e5b29.png)

Now that we got the PinConfig out of the way, we can continue integrating the rest of the files into the AppleALC Source Code…

## XI. Add `Platforms.xml` and `layout.xml` to `info.plist`

Now the we have edited all the files we need, we have to integrate them into the AppleALC Source Code. As mentioned [earlier](README.md#important-files-we-have-to-work-on), there are 2 info.plists which have to be edited in the AppleALC Source Code. In this case, I am referring to the second one, located inside the ALCXXX folder. In my case the one in `AppleALC/Resources/ALC269`.

- Open the `info.plist`
- Look for the `Files` Dictionary:</br>![Info01](https://user-images.githubusercontent.com/76865553/171393791-6c8f90ab-e860-42e0-940a-1b2fa26a1fc6.png)
- Open the `Layouts` Dictionary
- Duplicate one of the Dictionaries inside it, doesn't matter which one
- Move the Dictionary to the end of the list (makes it easier when committing the file for a Pull Request).
- Expand it:</br>![Info02](https://user-images.githubusercontent.com/76865553/171393919-0797081d-3296-4588-be78-7213e819a36a.png)
- Change the following details:
	- **Comment**: Author and Codec/Device
	- **Id**: Enter the Layout-ID you are using
	- **Path**: layoutXX.xlm.zlib (XX = the chosen layout-id number. During compilation, the .xml file will be compressed to .zlib so the path has to point to the compressed version)
- Do the same in the "Platforms" section but use "PlatformsXX.xml.zlib" as "Path" instead:</br>![Info03](https://user-images.githubusercontent.com/76865553/171394021-c85dbda3-e248-4445-85b1-8c5d7c15cf9c.png)

**IMPORTANT**: If these entries don't exist, the AppleALC.kext will be compiled but your Layout-ID entry won't be included, aka no Sound!

## XII. Compiling the AppleALC.kext
Now that we finally prepared all the required files, we can finally compile the kext.

- Open Terminal
- Type `cd`, hit space, drag your AppleALC Folder into the Terminal window and hit enter. This is now your working directory.
- Enter `xcodebuild` and hit Enter. Compiling should begin and a lot of text will scroll on screen during the process.
- Once the kext is compiled, there should be as prompt: "BUILD SUCCEEDED". 
- The kext will present in `/AppleALC/build/Release`.

## XIII. Testing and Troubleshooting
### Testing the new Layout
- Add your newly compiled AppleALC.kext to your `EFI/OC/Kexts` folder
- Open the config.plist and change the Layout-ID to the one you chose for your Layout-ID
- Save the config and reboot
- Check if sound is working (Internal, Inputs, Outputs, Headphones)
- If it's working: congrats!

**NOTE**: For testing verbs and `WakeConfigData` you can use `alc-verb` (it's in the Build folder) and Terminal to inject verbs into the Codec during runtime. This way, you don't have to edit the PinConfig, the .xml files and recompile the kext every time you want to test something. But I have yet to figure out how it works. Requires boot-arg `alcverbs=1` or `alc-verbs` device property for the Codec to be present in the `config.plist`.

### Troubleshooting
Follow the [AppleALC Troubleshooting Guide](https://github.com/dortania/OpenCore-Install-Guide/blob/e08ee8ebe6fa030393c153b055225f721edafab2/post-install/audio.md#troubleshooting) by Dortania
- Check and adjust/correct:
	- Pin-Config (maybe calculate it manually)
	- PathMap inside of PlatformsXX.xml
	- LayoutXX.xml 
	- Info.plist &rarr; check if you added your layoutXX.xml and PlatformsXX.xml 
	- Take notes. You can use my [Template](https://github.com/5T33Z0/OC-Little-Translated/blob/main/L_ALC_Layout-ID/Testing_Notes.md) for this
- Re-compile the kext, replace it in the EFI, reboot, test, repeat.
- Ask for help on a Forum.

## XIV. Adding your Layout-ID to the AppleALC Repo
Once your custom Layout-ID is working, you can submit it to the AppleALC GitHub repo via Pull Request. Otherwise you would lose your custom made routing every time you update the AppleALC.kext since this overwrites the info.plist and the .xml support files.

In order to add your Layout-ID to AppleALC's database, you have to do the following:

- Create a fork of the AppleALC Repo
- Include the changes you made into the files 4 files mentioned in the "[Files we have to work on](https://github.com/5T33Z0/OC-Little-Translated/tree/main/L_ALC_Layout-ID#files-we-have-to-work-on)" section. Read the official [Instructions](https://github.com/acidanthera/AppleALC/wiki/Adding-codec-support) for more details. 
- Push the changes you made to your Fork
- Create a pull request on GiHub
- :warning: Make sure it has no conflicts, otherwise it will be rejected.
- Wait for approval

Once your Layout is approved it will be part of the main AppleALC repo and you can update AppleALC without having to compile your own version every time the source code is updated. 

## CREDITS and RESOURCES
- **Guides**:
	- MacPeet for [Anleitung patch AppleHDA](https://www.root86.com/blog/40/entry-51-guide-anleitung-patch-applehda-bedingt-auch-f%C3%BCr-codec-erstellung-in-applealc/) (German)
	- EMlyDinEsH for [Complete Apple HDA Patching Guide](https://osxlatitude.com/forums/topic/1946-complete-applehda-patching-guide/)
	- F0x1c for [AppleALC_Instructions](https://github.com/F0x1c/AppleALC_Instructions)
	- The King for [[HOW TO] Patch AppleHDA - Knowledge Base, Guide for how to fix/use original AppleHDA](http://web.archive.org/web/20150105004602/http://www.projectosx.com/forum/index.php?showtopic=465&st=0)
	- Master Chief for [[How To] PinConfig for Linux users](https://www.insanelymac.com/forum/topic/149128-how-to-pinconfig-for-linux-users-%EF%BF%BD-realtek-alc883-example/)
	- Daliansky for [AppleALC Guide](https://blog-daliansky-net.translate.goog/Use-AppleALC-sound-card-to-drive-the-correct-posture-of-AppleHDA.html?_x_tr_sl=auto&_x_tr_tl=en&_x_tr_hl=de&_x_tr_pto=wapp)
	- Applelife.ru for [GetDumpXML-Auto build Platforms.xml](https://applelife-ru.translate.goog/threads/getdumpxml-applehda-zvuk-avtomaticheskoe-postroenie-fajla-platforms-xml.2942828/?_x_tr_sl=ru&_x_tr_tl=en&_x_tr_hl=de&_x_tr_pto=wapp)
	- Daliansky for [Using VoodooHDA for finding valid Nodes](https://blog-daliansky-net.translate.goog/With-VoodooHDA-comes-getdump-find-valid-nodes-and-paths.html?_x_tr_sl=auto&_x_tr_tl=en&_x_tr_hl=de&_x_tr_pto=wapp)
- **About Intel High Definition Audio**:
	- Intel for [HDA Specs](https://www.intel.com/content/www/us/en/standards/high-definition-audio-specification.html), esp. Chapter 7: "Codec Features and Requirements".
 	- HaC Mini Hackintosh for additional info about the [HDA Codec and Codec-Graph](https://osy.gitbook.io/hac-mini-guide/details/hda-fix#hda-codec)
 	- Daliansky for [List of HDA Verb Parameters](https://blog-daliansky-net.translate.goog/hda-verb-parameter-detail-table.html?_x_tr_sl=auto&_x_tr_tl=en&_x_tr_hl=de&_x_tr_pto=wapp)
- **Tools**:
	- Apple for [XCode](https://developer.apple.com/xcode/)
	- Acidanthera for [AppleALC](https://github.com/acidanthera/AppleALC), [Lilu](https://github.com/acidanthera/Lilu) and [MacKernelSDK](https://github.com/acidanthera/MacKernelSDK)
	- cmatsuoka for [codecgraph](https://github.com/cmatsuoka/codecgraph)
	- Core-i99 for the Python 3 Port of [Codec-Graph](https://github.com/Core-i99/Codec-Graph)
	- Headkaze for [Hackintool](https://github.com/headkaze/Hackintool) and porting [PinConfigurator](https://github.com/headkaze/PinConfigurator) to 64 bit 
	- Pixelglow for [graphviz](http://www.pixelglow.com/graphviz/)
- **Other**:
	- [Mermaid](https://mermaid-js.github.io/mermaid/#/README) script for creating flowcharts and diagrams in Markdown
	- Core-i99 for PinConfigurator tips
	- Hardwaresecrets – [How on-board Audio works](https://hardwaresecrets.com/how-on-board-audio-works/)
