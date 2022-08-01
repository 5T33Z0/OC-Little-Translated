# Enabling Trackpad/Touchpad Support on Laptops

## Introduction
PC-based Notebook Trackpads are not supported natively by macOS, so you have to inject additional kexts and/or SSDTs to get them working properly.

Depending on the type of Laptop and TrackPad/TouchPad you are using, you might need to incorporate a combinations of various kexts, additional SSDT-Hotpacthes and/or binary renames to enables it in macOS.

Getting trackpads working smoothly can be a tedious task. The wrong combination of kexts, renames and SSDTs can cause Kernel Panics if they are not loaded in the correct order or if binary renames or device paths in SSDT samples are incorrect. You can check examples of possible combination of kexts in Chapter 10 of this repo.

## Trackpad Types and Protocols
There are two main protocols used to communicate with the trackpad: PS/2 and I2C. Some trackpads even support both I2C and PS2 (mostly Synaptics), in this case you should switch to I2C. There should be an option to do this in the BIOS. 

**Note**: most laptops that come with I2C trackpads also have a PS/2 Controller for the Keyboard, so you have to use both VoodooI2C for the trackpad and VoodooPS2Controller for the keyboard!

### About PS/2 Trackpads (old)
PS/2 trackpads are obsolete. They may support multitouch, but not as good as I2C due to limited bandwidth. 

- Neccessary base kext: [**VoodooPS2Controller**](https://github.com/acidanthera/VoodooPS2/releases)

### About I2C Trackpads (new)
I2C trackpads are found on newer laptops, since they have better multitouch gesture support. I2C Trackpads support multitouch gestures pretty well and will improve in the future, thanks to spoofing Apple's Magic Trackpad 2 to enable native multitouch support under macOS.

- Neccessary base kext: [**VoodooI2C**](https://github.com/VoodooI2C)
- VoodooI2C Plugins:
	|Connection type|Plugin|Notes|
	|---------------|------|-----|
	|Atmel Multitouch Protocol|VoodooI2CAtmelMXT|Included in VoodooI2C Package.|
	|ELAN Proprietary|VoodooI2CElan|ELAN1200+ require VoodooI2CHID instead. Both Included in VoodooI2C Package. Some ELAN Trackpads require force-enabling polling to work. To do so, either add `force-polling` to the DeviceProperties of the TouchPad or use boot-arg `-vi2c-force-polling`|
	|FTE1001 touchpad|VoodooI2CFTE|Included in VoodooI2C Package.|
	|Multitouch HID|VoodooI2CHID|Can be used with I2C/USB Touchscreens and Trackpads. Included in VoodooI2C Package.|
	|Synaptics HID|[**VoodooRMI**](https://github.com/VoodooSMBus/VoodooRMI)|I2C Synaptic Trackpads (Requires VoodooI2C ONLY for I2C mode)|
	|Alps HID|[**AlpsHID**](https://github.com/blankmac/AlpsHID/releases) (I2C) or</br>[**VoodooPS2-ALPS**](https://github.com/SkyrilHD/VoodooPS2-ALPS) (PS2) |Can be used with USB and I2C/PS2 Alps trackpads. Mostly seen on Dell laptops|
	**Source**: [Dortania](https://dortania.github.io/OpenCore-Install-Guide/ktext.html#i2c-usb-hid-devices)

## Possible workflow
1. Boot into Windows
2. Run Device Manager 
3. Check for Humand Interface Devices (HID)
4. Check which method/protocol is used for controlling your Touchpad. If it is cotrolled by the PS2 Controller you need a different combination of kexts than if it's controlled via I2C or SMBus. This can be evaluated in Windows Device Manager as well.
5. Check the BIOS Device Path.
6. Determine the APIC Pin (you can also do this in macOS using IO Registry Explorer enterimg the device name mentioned in the BIOS device path)
7. Check the included Folders ("I2C TrackPad Patches" and "ThinkPad ClickPad and TrackPad Patches") listed above
8. Check other resources like existing EFI folders for your device or Dortania's OpenCore Install Guide or Forums.

## Resources
### Documentation
* Official VoodooI2C Documentation: **https://voodooi2c.github.io/**
* VoodooI2C Official Forum Post: **https://www.tonymacx86.com/threads/voodooi2c-help-and-support.243378/**
* Additional TouchPad Patches: **https://github.com/GZXiaoBai/Hackintosh-TouchPad-Hotpatch**
* Fixing Trackpads Guide by Dortania: **https://github.com/dortania/Getting-Started-With-ACPI/blob/master/Laptops/trackpad-methods/manual.md**

### Kexts for PS/2, I2C and ELAN Touchpads
- [**VoodooPS2Controller**](https://github.com/acidanthera/VoodooPS2): Magic Trackpad II emulation
- [**VoodooI2C**](https://github.com/VoodooI2C): Primary kext for I2C Trackpads
- [**VoodooRMI**](https://github.com/VoodooSMBus/VoodooRMI): Synaptic Trackpad driver over SMBus/I2C for macOS 
- [**VoodooSMBUS**](https://github.com/VoodooSMBus/VoodooSMBus): I2C-I801 driver port for macOS X + ELAN SMBus for Thinkpad T480s, L380, P52 
- [**VoodooElan**](https://github.com/VoodooSMBus/VoodooElan): ELAN Touchpad/Trackpoint driver for macOS over SMBus 
- [**VoodooTrackpoint**](https://github.com/VoodooSMBus/VoodooTrackpoint): Generic Trackpoint/Pointer device handler kext for macOS (now merged into [**VoodooInput**](https://github.com/acidanthera/VoodooInput))
- [**VoodooPS2-ALPS**](https://github.com/SkyrilHD/VoodooPS2-ALPS): New VoodooPS2 kext for ALPS touchpads. Adds support for Magic Trackpad 2 emulation in order to use macOS native driver instead of handling all gestures itself.
