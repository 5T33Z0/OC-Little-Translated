# Enabling Skylake Graphics in macOS 13
With the release of macOS 13 beta, support for 4th to 6th Gen CPUs was [dropped](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/998) – on-board graphics included. In order to enable integrated graphics, you need to spoof Kaby Lake Framebuffers. The example below is from an i7 6700K.

Do the following to enabled Intel HD 530 in macOS 13: 

- Download the latest version of [Lilu](https://dortania.github.io/builds/?product=Lilu&viewall=true) and this special build of [Whatevergreen](https://github.com/acidanthera/WhateverGreen/actions/runs/2495481119) 
- Download and unzip [SKLAsKBLGraphicsInfo.kext](https://github.com/Lorys89/OC-Little-Translated/raw/main/11_Graphics/iGPU/SKLAsKBLGraphicsInfo.kext.zip)
- Add them to your EFI/OC/Kexts folder and config.plist.
- Change the SMBIOS to `iMac18,1`
- Under `DeviceProperties/Add`, create the Dictionary `PciRoot(0x0)/Pci(0x2,0x0)` if it doesn't exist already.
- Add or modify the following Keys:
	
	|Key Name                |Value     | Type
	-------------------------|----------|:----:
	AAPL,ig-platform-id      | 00001259 | Data
	device-id                | 12590000 | Data
	
	The entry should look like this:</br>![hd530plist](https://user-images.githubusercontent.com/76865553/174105880-d3261daa-cfa4-4732-acaf-5adbc85018a9.png)
	<details>
	<summary><strong>Raw Text</strong> (click to reveal)</summary>
	
	```swift
	<key>Add</key>
	<dict>
		<key>PciRoot(0x0)/Pci(0x2,0x0)</key>
		<dict>
			<key>AAPL,ig-platform-id</key>
			<data>
			AAASWQ==
			</data>
			<key>device-id</key>
			<data>
			ElkAAA==
			</data>
		</dict>
	...
	```	
	</details>
- Save and reboot

## Verifying
Run either [VDADecoderChecker](https://i.applelife.ru/2019/05/451893_10.12_VDADecoderChecker.zip) or VideoProc. In this case, iGPU Acceleration is working fine:

![videoproc_HD530](https://user-images.githubusercontent.com/76865553/174106261-050c342d-66f9-4f98-b63c-c4bbea3f7f28.png)

## CREDITS
- Acidanthera for OpenCore and kexts
- Cyberdevs for the [settings](https://www.insanelymac.com/forum/topic/351969-pre-release-macos-ventura/?do=findComment&comment=2785675)
