# Disabling `AppleGFXHDA` on AMD GPUs

## About
SSDT for disabling the audio device of AMD GPUs, so it no longer attaches to the `AppleGFXHDA.kext`, thus effectivley disabling audio output over HDMI/DisplayPort.

Unfortunately, macOS is not very clever when it comes to remembering the last used audio output. After a restart (or returning from sleep), the HDMI/DisplayPort audio device is auto-selected again, even though you've set the default output to "Line-Out" for example. This is really annoying since you have to change it back manually every time.

This SSDT disabled the `HDAU` audio device inside of AMD GPUs in macOS, so that it can no longer be selected. But you probably have to adjust the `External` reference, `Scope` and device name to your requirements.

> [!CAUTION]
> 
>  In cases where the GPU is not deteced by macOS because it sits behind an intermediate PCI bridge without an ACPI path assigned to it, you need to add a bridge device via [**`SSDT-BRG0`**](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/AcpiSamples/Source/SSDT-BRG0.dsl)!

## Adjusting the SSDT
- Open `SSDT-RADEON_HDAU-disable.aml`. You may have to adjust the `External` reference and `Scope` entries:</br>![RDNpci](https://user-images.githubusercontent.com/76865553/189613476-eea3b5d7-21ac-4ec1-be16-68526a70ad03.png)
- Find the name and path of your Graphics card in **IORegistry Explorer**:</br>![pasted-from-clipboard3](https://user-images.githubusercontent.com/76865553/139533202-9f11d658-07c0-4ab1-8e52-531475ca9f9c.png)
- Or use Terminal to find the correct path (if the first query doesn't return anything, try the second):
	```terminal
	ioreg -p IODeviceTree -n GFX0 -r |grep "acpi-path"
	ioreg -p IODeviceTree -n HDAU -r |grep "acpi-path"
	```
- In this example the name differs from the one in the SSDT: it's `GFX0@0` instead of `PEGP@0`.
- Adjust the path and name accordingly:</br>![Adjust](https://user-images.githubusercontent.com/76865553/189613414-2e2776b7-168a-4e98-935f-32a0909b3dc9.png)
- Scroll down to `Device (GFX0)` and enter the name of your GPU model. Delete the value in the brackets for the Buffer `()`:</br>
	![model](https://user-images.githubusercontent.com/76865553/139533226-0ae045b0-695d-4394-9ebb-946578985a16.png)
- Save the file as .aml (ACPI Machine Language Binary)
- Add it to the ACPI Folder and `config.plist`
- Save and reboot

## Verifying that the device is disabled
- Run Hackintool
- In the "System" tab, click on "Peripherals"
- The `GFX0` audio device of your GPU should no longer be listed.
- Alternative you can just try sending audio over your `HDMI`/`DP` cable

## Alternative method: using `DeviceProperties`

Alternatively, you can inject bogus data for the GPU's audio device via `DeviceProperties`, if the SSDT-method does not work for you.

**INSTRUCTIONS**:

- Run **Hackintool** 
- Select the **PCIe** tab
- Locate the audio device associated with the GPU, for example "Navi 21/23 HDMI/DP Audio Controller" (Device Name) / Multimedia Controller (Class) / Audio Device (Subclass)
- Right-click the entry and select "Copy Device Path", e.g. `PciRoot(0x0)/Pci(0x1,0x0)/Pci(0x0,0x0)/Pci(0x0,0x0)/Pci(0x0,0x1)` (your system's PCIe device path will be different)
- Open your `config.plist` 
- Navigate tp `DeviceProperties/Add` 
- Add the device path and these addtional properties:
	```xml
	<key>DeviceProperties</key>
	<dict>
		<key>Add</key>
		<dict>
			<key>PciRoot(0x0)/Pci(0x1,0x0)/Pci(0x0,0x0)/Pci(0x0,0x0)/Pci(0x0,0x1)</key>
			<dict>
				<key>class-code</key>
				<data>/////w==</data>
				<key>device-id</key>
				<data>//8AAA==</data>
				<key>vendor-id</key>
				<data>//8AAA==</data>
			</dict>
	```
- **Screenshot**:<br><img width="626" alt="audidev" src="https://github.com/user-attachments/assets/4d7a4343-c815-4751-b1e4-ad63820b5257" />

## Credits
- Apfelnico for the [**SSDT Sample**](https://www.hackintosh-forum.de/forum/thread/55014-hdmi-audio-mittels-ssdt-entfernen-radeon-vii/?postID=721986#post721986)
- Verdazil and Miliuco for the `DeviceProperty` method
