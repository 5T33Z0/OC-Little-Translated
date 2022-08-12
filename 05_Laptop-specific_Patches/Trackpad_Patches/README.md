# Enabling Trackpad/Touchpad Support on Laptops

## Introduction
PC-based Notebook Track- and TouchPads are not supported natively by macOS, so you have to inject additional kexts and/or SSDTs to get them working properly.

Depending on the type of Laptop and TrackPad/TouchPad you are using, you might need to incorporate a combinations of various kexts, additional SSDT-Hotpatches and/or binary renames to enables it in macOS.

Getting TouchPads to work smoothly can be a tedious task. The wrong combination of kexts, renames and SSDTs can cause Kernel Panics if they are not loaded in the correct order or if binary renames or device paths in SSDTs are incorrect.

## Trackpad Types and Protocols
There are two main protocols used to communicate with the TouchPad: **PS/2** and **I2C**. Some TrackPads even support both, **I2C** and **PS2** protocols (mostly by Synaptics), in this case you should switch to I2C. There should be an option to do this in the BIOS. 

**Note**: most laptops that come with I2C TrackPads also have a PS/2 Controller for the Keyboard, so you have to use both VoodooI2C for the TrackPads and VoodooPS2Controller for the keyboard!

## General approach to enabling Track/Touchpads

### PS/2 Trackpads (old)
PS/2 TouchPaads are obsolete. They may support multitouch, but the implementation is not as refined as with I2C due to the limited bandwidth. Usually used on Ivy Bridge and older CPU families.

- Neccessary base kext: [**VoodooPS2Controller**](https://github.com/acidanthera/VoodooPS2)

### I2C Trackpads (new)
I2C (Inter-Integrated Circuit or eye-squared-C) TouchPads are found on current Laptops since they have better multitouch gesture support. I2C TrackPads support multitouch gestures pretty well and will improve in the future, thanks to spoofing Apple's Magic Trackpad 2 to enable native multitouch support under macOS. Usually used by Haswell and newer CPU families.

- Necessary base kext: [**VoodooI2C**](https://github.com/VoodooI2C)
- Addition VoodooI2C Plugins:

	|Connection type|Plugin|Notes|
	|---------------|------|-----|
	|Atmel Multitouch Protocol|VoodooI2CAtmelMXT|Included in VoodooI2C Package.|
	|ELAN Proprietary|VoodooI2CElan|ELAN1200+ require VoodooI2CHID instead. Both Included in VoodooI2C Package. Some ELAN Trackpads require force-enabling polling to work. To do so, either add `force-polling` to the DeviceProperties of the TouchPad or use boot-arg `-vi2c-force-polling`|
	|FTE1001 Touchpad|VoodooI2CFTE|Included in VoodooI2C Package.|
	|Multitouch HID|VoodooI2CHID|Can be used with I2C/USB Touchscreens and Trackpads. Included in VoodooI2C Package.|
	|Synaptics HID|[**VoodooRMI**](https://github.com/VoodooSMBus/VoodooRMI)|I2C Synaptic Trackpads (Requires VoodooI2C ONLY for I2C mode)|
	|Alps HID|[**AlpsHID**](https://github.com/blankmac/AlpsHID/releases) (I2C) or</br> [**VoodooPS2Controller**](https://github.com/acidanthera/VoodooPS2/releases) (PS2) |Can be used with USB and I2C/PS2 Alps Trackpads. Often seen on Dell Laptops|
	
	**Source**: [Dortania](https://dortania.github.io/OpenCore-Install-Guide/ktext.html#i2c-usb-hid-devices)

## Possible workflow
1. Determin which protocol the Trackpad uses (**PS/2**, **I2C** or **SMBUS**):
	- Boot into Windows
	- Run Device Manager
	- Find your device:
		- **I2C** TouchPads can be found in the **Humand Interface Devices** (HID) section as "**I2C Device**".
 		- **PS/2** and **SMBUS** TouchPads are usually listed under "**Mice and other pointing devices**".
	- Double-click the device to open its Device Properties
	- From the "Property" dropdown menu, select "BIOS device name". This shows the ACPI path and name of the device. Take a screenshot or take a note.
2. Reboot back into macOS, find the APIC Pin of your TouchPad:
	- Open **IORegistry Explorer**
	- Find your TouchPad based on its ACPI name (the one from "BIOS device name" in Windows)
	- Click on the device and look for `IOInterruptSpecifiers`. It's value is displayed in Hex. Convert it to decimal (use Hackintool):
	- If the number is equal or less than `47`, you can continue with step 3. 
	- If the number is greater than 37 (or `0x2f`), it's getting complicated and you have to assign an APIC Pin manually (not covered here). 
3. Based on the results, do follow the following:
	- For I2C Trackpads, follow the [I2C TrackPad Instructions](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05_Laptop-specific_Patches/Trackpad_Patches/I2C_TrackPad_Patches). This section also contains additional patches for Notebooks from various vendors (Acer, Asus, Dell, HP, Huawei, Lenovo).
	- If it's a PS/2 TrackPad, install **VoodooPS2Controller.kext**
	- There's some additional info about [Lenovo ThinkPad Click and TrackPads](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05_Laptop-specific_Patches/Trackpad_Patches/ThinkPad_Click_and_TrackPad_Patches) available.
	
4. Check other resources like existing EFI folders for your device or Dortania's OpenCore Install Guide or Forums.

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
- [**VoodooElan**](https://github.com/VoodooSMBus/VoodooElan): ELAN TouchPad/Trackpoint driver for macOS over SMBus 
- [**VoodooTrackpoint**](https://github.com/VoodooSMBus/VoodooTrackpoint): Generic Trackpoint/Pointer device handler kext for macOS (now merged into [**VoodooInput**](https://github.com/acidanthera/VoodooInput))
- [**VoodooPS2-ALPS**](https://github.com/SkyrilHD/VoodooPS2-ALPS): New VoodooPS2 kext for ALPS TouchPads. Adds support for Magic Trackpad 2 emulation in order to use macOS native driver instead of handling all gestures itself. **NOTE**: This kext is now obsolete since its functionality has been integrated into VoodooPS2Controller.kext!
