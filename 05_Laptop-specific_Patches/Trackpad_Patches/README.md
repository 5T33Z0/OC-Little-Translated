# Enabling Touchpad Support on Laptops

## Introduction
PC-based Notebook Touchpads (the name is used synonymously are not supported natively by macOS, so you have to inject additional kexts and/or SSDTs to get them working properly.

Depending on the type of Laptop and Touchpad you are using, you may need to combine kexts, binary renames as well as SSDT-Hotpatches to enabble it in macOS.

Getting Touchpads to work *smoothly* though, can be a tedious task. The wrong combination of kexts, renames and SSDTs can cause Kernel Panics if they are not loaded in the correct order or if binary renames or device paths in SSDTs are incorrect.

## Touchpad Types and Protocols
There are two main protocols used to communicate with a Touchpad: **PS/2** and **I2C**. Some Touchpads even support both protocols (mostly by Synaptics). In this case, you should switch to **I2C**. There should be an option in the BIOS to switch the mode.

**Note**: most Laptops that come with **I2C** Touchpads use a **PS/2** Controller for the **Keyboard**, so you have to use *both*, VoodooI2C for the Touchpads and VoodooPS2Controller for the keyboard!

## General approach to enabling Track/Touchpads

### PS/2 Touchpads (old)
PS/2 TouchPads are pretty much obsolete nowadays. They may support multitouch, but the implementation is not as refined as with I2C due to the limited bandwidth of PS/2. PS/2 Touchpads are usually used on Ivy Bridge and older CPU families.

- Necessary base kext: [**VoodooPS2Controller**](https://github.com/acidanthera/VoodooPS2)

### I2C Touchpads (new)
I2C (Inter-Integrated Circuit or eye-squared-C) Touchpads are found on current Laptops since they have better multitouch gesture support. I2C Touchpads support multitouch gestures pretty well and will improve in the future, thanks to spoofing Apple's Magic Touchpad 2 to enable native multitouch support under macOS. Usually used by Haswell and newer CPU families.

- Necessary base kext: [**VoodooI2C**](https://github.com/VoodooI2C)
- Addition VoodooI2C Plugins:

	|Connection type|Plugin|Notes|
	|---------------|------|-----|
	|Atmel Multitouch Protocol|VoodooI2CAtmelMXT|Included in VoodooI2C Package.|
	|ELAN Proprietary|VoodooI2CElan|ELAN1200+ require VoodooI2CHID instead. Both Included in VoodooI2C Package. Some ELAN Touchpads require force-enabling polling to work. To do so, either add `force-polling` to the DeviceProperties of the Touchpad or use boot-arg `-vi2c-force-polling`|
	|FTE1001 Touchpad|VoodooI2CFTE|Included in VoodooI2C Package.|
	|Multitouch HID|VoodooI2CHID|Can be used with I2C/USB Touchscreens and Touchpads. Included in VoodooI2C Package.|
	|Synaptics HID|[**VoodooRMI**](https://github.com/VoodooSMBus/VoodooRMI)|I2C Synaptic Touchpads (Requires VoodooI2C ONLY for I2C mode)|
	|Alps HID|[**AlpsHID**](https://github.com/blankmac/AlpsHID/releases) (I2C) or</br> [**VoodooPS2Controller**](https://github.com/acidanthera/VoodooPS2/releases) (PS2) |Can be used with USB and I2C/PS2 Alps Touchpads. Often seen on Dell Laptops|
	
	**Source**: [Dortania](https://dortania.github.io/OpenCore-Install-Guide/ktext.html#i2c-usb-hid-devices)

## Possible workflow
1. Determine which protocol the Touchpad uses (**PS/2**, **I2C** or **SMBUS**):
	- Boot into Windows
	- Run Device Manager
	- Find your device:
		- **I2C** Touchpads can be found in the **Humand Interface Devices** (HID) section as "**I2C Device**".
 		- **PS/2** and **SMBUS** Touchpads are usually listed under "**Mice and other pointing devices**".
	- Double-click the device to open its Device Properties
	- From the "Property" dropdown menu, select "BIOS device name". This shows the ACPI path and name of the device. Take a screenshot or take a note.
2. Reboot back into macOS, find the APIC Pin of your Touchpad:
	- Open **IORegistry Explorer**
	- Find your Touchpad based on its ACPI name (the one from "BIOS device name" in Windows)
	- Click on the device and look for `IOInterruptSpecifiers`. It's value is displayed in Hex. Convert it to decimal (use Hackintool):
	- If the number is equal or less than `47`, you can continue with step 3. 
	- If the number is greater than 37 (or `0x2f`), it's getting complicated and you have to assign an APIC Pin manually (not covered here). 
3. Based on the results, do follow the following:
	- For I2C Touchpads, follow the &rarr; [I2C Touchpad Instructions](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05_Laptop-specific_Patches/Touchpad_Patches/I2C_Touchpad_Patches). This section also contains additional patches for Notebooks from various vendors (Acer, Asus, Dell, HP, Huawei, Lenovo).
	- If it's a PS/2 Touchpad, install **VoodooPS2Controller.kext**
	- There's some additional info about &rarr; [Lenovo ThinkPad Click and Touchpads](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05_Laptop-specific_Patches/Touchpad_Patches/ThinkPad_Click_and_Touchpad_Patches) available.
	
4. Check other resources like existing EFI folders for your device or Dortania's OpenCore Install Guide or Forums.

## Resources
### Documentation
* Official VoodooI2C Documentation: **https://voodooi2c.github.io/**
* VoodooI2C Official Forum Post: **https://www.tonymacx86.com/threads/voodooi2c-help-and-support.243378/**
* Additional Touchpad Patches: **https://github.com/GZXiaoBai/Hackintosh-Touchpad-Hotpatch**
* Fixing Touchpads Guide by Dortania: **https://github.com/dortania/Getting-Started-With-ACPI/blob/master/Laptops/Touchpad-methods/manual.md**

### Kexts for PS/2, I2C and ELAN Touchpads
- [**VoodooPS2Controller**](https://github.com/acidanthera/VoodooPS2): Magic Touchpad II emulation
- [**VoodooI2C**](https://github.com/VoodooI2C): Primary kext for I2C Touchpads
- [**VoodooRMI**](https://github.com/VoodooSMBus/VoodooRMI): Synaptic Touchpad driver over SMBus/I2C for macOS 
- [**VoodooSMBUS**](https://github.com/VoodooSMBus/VoodooSMBus): I2C-I801 driver port for macOS X + ELAN SMBus for Thinkpad T480s, L380, P52 
- [**VoodooElan**](https://github.com/VoodooSMBus/VoodooElan): ELAN Touchpad/Trackpoint driver for macOS over SMBus 
- [**VoodooTrackpoint**](https://github.com/VoodooSMBus/VoodooTrackpoint): Generic Trackpoint/Pointer device handler kext for macOS (now merged into [**VoodooInput**](https://github.com/acidanthera/VoodooInput))
- [**VoodooPS2-ALPS**](https://github.com/SkyrilHD/VoodooPS2-ALPS): New VoodooPS2 kext for ALPS Touchpads. Adds support for Magic Touchpad 2 emulation in order to use macOS native driver instead of handling all gestures itself. **NOTE**: This kext is now obsolete since its functionality has been integrated into VoodooPS2Controller.kext!
