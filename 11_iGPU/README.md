# Intel iGPU Fixes

## Force-enabling graphics with a fake Platform-ID
⚠️ This is only for users who don't have graphics output at all. It's only a temporary solution to force-enable software rendering of graphics in macOS, so you can at least  follow the instructions on-screen to generate a proper framebuffer patch. If your display is working already, skip this step!

First try adding `-igfxvesa` boot-arg to the config.plist and reboot. This will enable VESA mode for graphics which bypasses any GPU and uses software rendering instead.

If this doesn't work, we can inject a non-existing `AAPL,ig-platform-id` via `DeviceProperties` into macOS, which in return will fall back to using the software renderer for displaying graphics since it can't find the Platform-ID.

Booting with this hack will take much longer (up to 2 minutes), only about 5 MB of VRAM will be available and everything will be running slow and sluggish – but at least you have a video signal. 

#### Enabling a fake Platform-ID in OpenCore
- Open your config.plist
- Under `DeviceProperties/Add`, create the Dictionary `PciRoot(0x0)/Pci(0x2,0x0)`
- Add the following Keys as children:</br>
	|Key Name                |Value     | Type
	-------------------------|----------|:---:
	AAPL,ig-platform-id      | 78563412 |Data
	framebuffer-patch-enable | 01000000 |Data

The entry should look like this:</br>![OC_fakeid](https://user-images.githubusercontent.com/76865553/174105739-517dc1da-58f3-45f1-976a-0e3e91afdaa5.png)

**NOTE**: Make sure to delete/disable the fake Platform-ID once you have generated your Framebuffer patch!

## Enabling Intel HD 530 support in macOS 13 (Desktop)
With the release of macOS 13 beta, support for 4th to 6th Gen CPUs was [dropped](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/998) – on-board graphics included. In order to enable integrated grpahics you need to spoof Kabylake Framebuffers. The example is from an i7 6700K.

Do the following to enabled Intel HD 530 in macOS 13: 

- Download the latest version of [Lilu](https://dortania.github.io/builds/?product=Lilu&viewall=true) and this special build of [Whatevergren](https://github.com/acidanthera/WhateverGreen/actions/runs/2495481119) and add them to your EFI/OC/Kexts folder and config.plist.
- Change the SMBIOS to `iMac18,1`
- Under `DeviceProperties/Add`, create the Dictionary `PciRoot(0x0)/Pci(0x2,0x0)`
- Add the following Keys as children:
	|Key Name                |Value     | Type
	-------------------------|----------|:----:
	AAPL,ig-platform-id      | 00001259 | Data
	device-id                | 12590000 | Data

The entry should look like this:</br>![hd530plist](https://user-images.githubusercontent.com/76865553/174105880-d3261daa-cfa4-4732-acaf-5adbc85018a9.png)

<details>
<summary><strong>Raw Text</strong> (click to reveal)</summary>
	
```swift
<dict>
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
- Save your config and reboot.

### Verifying
Run either [VDADecoderChecker](https://i.applelife.ru/2019/05/451893_10.12_VDADecoderChecker.zip) or VideoProc. In this case, iGPU Acceleration is working fine:

![videoproc_HD530](https://user-images.githubusercontent.com/76865553/174106261-050c342d-66f9-4f98-b63c-c4bbea3f7f28.png)


