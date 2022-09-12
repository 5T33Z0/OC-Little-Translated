# Disabling audio over HDMI/DP for Intel iGPUs

If you don't use digital audio over HDMI or DisplayPort on your Intel iGPU, you can disable HDA-GFX by adding a property to your Audio Codec.

## Instructions

1. Check presence of digital audio device of your iGPU:
	- Run Hackintool
	- In the "System" tab, click on "Peripherals"
	- There should be an additional audio device associated to your iGPU (Intel HD4000 in this example):</br>![](/Users/5t33z0/Desktop/Before.png)
2. Open your `config.plist`
3. In `DeviceProperties`, find the entry for your Audio Codec. On Intel Systems it's located at `PciRoot(0x0)/Pci(0x1b,0x0)`
4. Add key `No-hda-gfx`, Data Type = String, Value = `onboard-1`</br>![](/Users/5t33z0/Desktop/iGPUGFX.png)
5. Save and reboot

## Verify
1. Run Hackintool again and check if the device is gone:</br>![](/Users/5t33z0/Desktop/After.png)
