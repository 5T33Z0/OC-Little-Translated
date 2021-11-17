# Enabling Trackpad Support on Laptops

## Introduction
PC-based Notebook Trackpads are not supported natively by macOS, so you have to inject additional kexts and/or SSDTs to get them working correctly.

Depending on the type of Laptop and TrackPad/TouchPad you are using, you might need to incorporate a combinations of various kexts, additional SSDT-Hotpacthes and/or binary renames to get it working.

Getting trackpads working smoothly can be a tedious task. The wrong combination of kexts, renames and SSDTs can cause Kernel Panics if kexts are not loaded in the correct sequence or the renames or device paths in the SSDT samples are incorrect. You can check examples of possible combination of kexts in Chapter 10 of this repo.

## Trackpad Types and Protocols
There are two main protocols used to communicate with the trackpad: PS/2 and I2C. Some trackpads even support both I2C and PS2 (mostly Synaptics), in this case you should switch to I2C. There should be an option to do this in the BIOS. 

**Note**: most laptops that come with I2C trackpads also have a PS/2 Controller for the Keyboard, so you have to use both VoodooI2C for the trackpad and VoodooPS2Controller for the keyboard!

### About PS/2 Trackpads (old)
PS/2 trackpads are obsolete. They may support multitouch, but not as good as I2C due to limited bandwidth. 

- Neccessary base kext: [**VoodooPS2Controller**](https://github.com/acidanthera/VoodooPS2/releases)

### About I2C Trackpads (new)
I2C trackpads are found on newer laptops, since they have better multitouch gesture support. I2C Trackpads support multitouch gestures pretty well and will improve in the future, thanks to spoofing Apple's Magic Trackpad 2 to enable native multitouch support under macOS.

- Necessary base kext: [**VoodooI2C**](https://github.com/VoodooI2C)

## Possible workflow
1. Find out which TrackPad/TouchPad you are using (Vendor, Technology, etc.) You can do this in Windows by using the Device Manager. It can display the vendor, it's PCI device patch, the controller protocol, etc.
2. Find out how which method is used for controlling it. If it is cotrolled by the PS2 Controller you need a different combination of kexts than when it's controlled via I2C or  SMBus. This can be evaluated in Windows Device Manager as well.
3. Check the included Folders for TrackPads in this repo
4. Check other resources like existing EFI folders for your device or Dortania's OpenCore Install Guide or Forums.

## Resources
### Documentation
* Official VoodooI2C Documentation: **https://voodooi2c.github.io/**
* VoodooI2C Official Forum Post: **https://www.tonymacx86.com/threads/voodooi2c-help-and-support.243378/**

### Kexts for PS/2, I2C and ELAN Touchpads
- [**VoodooPS2Controller**](https://github.com/acidanthera/VoodooPS2): Magic Trackpad II emulation
- [**VoodooI2C**](https://github.com/VoodooI2C): Primary kext for I2C Trackpads
- [**VoodooRMI**](https://github.com/VoodooSMBus/VoodooRMI): Synaptic Trackpad driver over SMBus/I2C for macOS 
- [**VoodooSMBUS**](https://github.com/VoodooSMBus/VoodooSMBus): I2C-I801 driver port for macOS X + ELAN SMBus for Thinkpad T480s, L380, P52 
- [**VoodooElan**](https://github.com/VoodooSMBus/VoodooElan): ELAN Touchpad/Trackpoint driver for macOS over SMBus 
- [**VoodooTrackpoint**](https://github.com/VoodooSMBus/VoodooTrackpoint): Generic Trackpoint/Pointer device handler kext for macOS (now merged into [**VoodooInput**](https://github.com/acidanthera/VoodooInput))

