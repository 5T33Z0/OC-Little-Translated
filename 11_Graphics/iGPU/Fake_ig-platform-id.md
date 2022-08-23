# Force-enabling graphics with a fake ig-platform-id
⚠️ This is only for users who don't have graphics output at all. It's only a temporary solution to force-enable software rendering of graphics in macOS, so you get a picture output at all. This way, you can at least connect a monitor and generate a proper framebuffer patch with Hackintool for example.

First try adding `-igfxvesa` boot-arg to the config.plist and reboot. This will enable VESA mode for graphics which bypasses any GPU and uses software rendering instead.

If this doesn't work, we can inject a non-existing `AAPL,ig-platform-id` via `DeviceProperties` into macOS, which in return will fall back to using the software renderer for displaying graphics since it can't find the Platform-ID.

Booting with this hack will take much longer (up to 2 minutes), only about 5 MB of VRAM will be available and everything will be running slow and sluggish – but at least you have a video signal. 

### Enabling a fake Platform-ID in OpenCore
- Open your config.plist
- Under `DeviceProperties/Add`, create the Dictionary `PciRoot(0x0)/Pci(0x2,0x0)`
- Add the following Keys as children:</br>
	
	|Key Name                |Value     | Type
	-------------------------|----------|:---:
	AAPL,ig-platform-id      | 78563412 |Data
	framebuffer-patch-enable | 01000000 |Data

	The entry should look like this:</br>![OC_fakeid](https://user-images.githubusercontent.com/76865553/174105739-517dc1da-58f3-45f1-976a-0e3e91afdaa5.png)
- Save the config.plist and boot into macOS.

**NOTE**: Make sure to delete/disable the fake Platform-ID once you have generated your Framebuffer patch!
