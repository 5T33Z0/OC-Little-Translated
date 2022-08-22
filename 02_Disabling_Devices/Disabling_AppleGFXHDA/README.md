# Disabling AppleGFXHDA on AMD GPUs

## About
SSDT for disabling the audio output over HDMI/DisplayPort on AMD graphics cards.

Unfortunately, macOS is not very clever when it comes to remembering the last used audio output by default. After a restart (or returning from sleep), the HDMI/DisplayPort audio device is auto-selected again, even though you had set it to "Line-Out" before for example, which can be annoying since you have to change it back manually every time.

This SSDT turns off the GFXHD audio device for macOS completely, so that it can no longer be selected. But you probably have to adjust the External reference, Scope and device path to your needs.

## Adjusting the SSDT
- Open `SSDT-RDN-HDAU-disable.aml`. You may have to adjust the following entries:</br>
	![pasted-from-clipboard](https://user-images.githubusercontent.com/76865553/139533192-c23d384b-89b6-428e-a73d-f889df903930.png)
- Find the name and path of your Graphics card in IORegistry Explorer:</br>
	![pasted-from-clipboard3](https://user-images.githubusercontent.com/76865553/139533202-9f11d658-07c0-4ab1-8e52-531475ca9f9c.png)
- You can also use Terminal: `ioreg -p IODeviceTree -n HDAU -r |grep "acpi-path"`
- In this example the name differs from the one in the SSDT: it's `GFX0@0` instead of `PEGP@0`.
- Adjust the path and name accordingly:</br>
	![pasted-from-clipboard4](https://user-images.githubusercontent.com/76865553/139533216-157b1461-94e8-4957-b5a6-551d54719f7a.png)
- Scroll down to `Device (GFX0)` and enter the name of your GPU model. Delete the value in the brackets for the Buffer `()`:</br>
	![model](https://user-images.githubusercontent.com/76865553/139533226-0ae045b0-695d-4394-9ebb-946578985a16.png)
- Save the file as .aml (ACPI Machine Language Binary)
- Add it to the ACPI Folder and config.plist
- Save, reboot and test

## Credits:
- Apfelnico for the [**SSDT Sample**](https://www.hackintosh-forum.de/forum/thread/55014-hdmi-audio-mittels-ssdt-entfernen-radeon-vii/?postID=721986#post721986)
