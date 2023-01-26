# Disabling audio over HDMI/DP for Intel iGPUs

If you don't use digital audio over HDMI or DisplayPort on your Intel iGPU, you can disable HDA-GFX by adding a property to your Audio Codec.

## Instructions

1. Check presence of digital audio device of your iGPU:
	- Run Hackintool
	- In the "System" tab, click on "Peripherals"
	- There should be an additional audio device associated to your iGPU (Intel HD4000 in this example):</br>![Before](https://user-images.githubusercontent.com/76865553/189597956-afb3c778-5d73-4712-89a3-1435c88c0891.png)
2. Open your `config.plist`
3. In `DeviceProperties`, find the entry for your Audio Codec. On Intel Systems it's located at `PciRoot(0x0)/Pci(0x1b,0x0)`
4. Add key `No-hda-gfx`, Data Type = `String`, Value = `onboard-1` (as shown below):</br>![iGPUHDAGFX](https://user-images.githubusercontent.com/76865553/189598015-9631e3b3-3aa4-436b-9d9c-5e8d9f12f771.png)
5. Save and reboot

## Verify
1. Run Hackintool again and check if the device is gone:</br>![After](https://user-images.githubusercontent.com/76865553/189598154-57a6b20a-f0fc-4fa3-9edc-6157ef89ee8c.png)
