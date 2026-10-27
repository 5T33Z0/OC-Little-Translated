
# Force-enabling graphics with a fake Platform-ID
⚠️ This is for users who don't have graphics output at all. It's only a temporary solution to force-enable software rendering of graphics in macOS, so you can at least  follow the instructions on-screen to generate a proper framebuffer patch. If your display is working already, skip this step!

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
	
	The entry should look like this:</br>
![OC_fakeid](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/b9b77d6f-1caf-46d3-9616-0debc83f855d)

#### Enabling fake Platform-ID in Clover
- Open your config.plist in Clover Configurator
- Click on "Graphics"
- Enable `Inject Intel`
- In ig-platforrm-id, enter `0x12345678` (you can omit the `0x`)

	This is how it should look in Clover Configurator:</br>
![FakeID](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/6ee45bfd-7d20-4d09-a61e-8bc165eb0a93)

**NOTE**: Make sure to delete/disable the fake Platform-ID once you have generated your Framebuffer patch!
