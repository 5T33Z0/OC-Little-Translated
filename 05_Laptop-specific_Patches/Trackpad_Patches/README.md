# Enabling Touchpad Support on Laptops

## Introduction
PC-based Notebook Touchpads (the name is used synonymously are not supported natively by macOS, so you have to inject additional kexts and/or SSDTs to get them working properly.

Depending on the type of Laptop and Touchpad you are using, you may need to combine kexts, binary renames as well as SSDT-Hotpatches to enable it in macOS.

Getting Touchpads to work *smoothly* though, can be a tedious task. The wrong combination of kexts, renames and SSDTs can cause Kernel Panics if they are not loaded in the correct order or if binary renames or device paths in SSDTs are incorrect.

## Touchpad Types and Protocols
There are two main protocols used to communicate with a Touchpad: **PS/2** and **I2C**. Some Touchpads even support both protocols (mostly by Synaptics). In this case, you should switch to **I2C**. There should be an option in the BIOS to switch the mode.

**Note**: most Laptops that come with **I2C** Touchpads also use a **PS/2** Controller for the **Keyboard**, so you have to use *both*, VoodooI2C for the Touchpads and VoodooPS2Controller for the keyboard!

### About PS/2 Touchpads (old)
PS/2 TouchPads are pretty much obsolete nowadays. They may support multitouch, but the implementation is not as refined as with I2C due to the limited bandwidth of PS/2. PS/2 Touchpads are usually used on Ivy Bridge and older CPU families.

- Necessary base kext: [**VoodooPS2Controller**](https://github.com/acidanthera/VoodooPS2)

So, if your Laptop uses a PS/2 Touchpad, you only have to add VoodooPS2Controller Kext to enable it in macOS and you're done. With I2C touchpads, the process is more complicated.

### About I2C Touchpads (new)
I2C (Inter-Integrated Circuit or eye-squared-C) Touchpads are found on current Laptops since they have better multitouch gesture support. I2C Touchpads support multitouch gestures pretty well and will improve in the future, thanks to spoofing Apple's Magic Touchpad 2 to enable native multitouch support under macOS. Usually used by Haswell and newer CPU families.

- Necessary base kext: [**VoodooI2C**](https://github.com/VoodooI2C)
- Additional VoodooI2C Plugins (**Source**: [Dortania](https://dortania.github.io/OpenCore-Install-Guide/ktext.html#laptop-input)
	
	|Connection type|Plugin|Notes|
	|---------------|------|-----|
	|Atmel Multitouch Protocol|VoodooI2CAtmelMXT|Included in VoodooI2C Package.|
	|ELAN Proprietary|VoodooI2CElan|ELAN1200+ require VoodooI2CHID instead. Both Included in VoodooI2C Package. Some ELAN Touchpads require force-enabling polling to work. To do so, either add `force-polling` to the DeviceProperties of the Touchpad or use boot-arg `-vi2c-force-polling`|
	|FTE1001 Touchpad|VoodooI2CFTE|Included in VoodooI2C Package.|
	|Multitouch HID|VoodooI2CHID|Can be used with I2C/USB Touchscreens and Touchpads. Included in VoodooI2C Package.|
	|Synaptics HID|[**VoodooRMI**](https://github.com/VoodooSMBus/VoodooRMI)|I2C Synaptic Touchpads (Requires VoodooI2C ONLY for I2C mode)|
	|Alps HID|[**AlpsHID**](https://github.com/blankmac/AlpsHID/releases) (I2C) or</br> [**VoodooPS2Controller**](https://github.com/acidanthera/VoodooPS2/releases) (PS2) |Can be used with USB and I2C/PS2 Alps Touchpads. Often seen on Dell Laptops|</br>

## About VoodooI2C
**VoodooI2C** supports three operating modes: 

1. **APIC** interrupt mode, 
2. **GPIO** interrupt mode and 
3. **Polling** mode 

These three modes have their own characteristics: 

- **APIC** interrupt mode basically does not need to be modified, the function is perfect, but only a few devices support it. Whether or not your Toucpad supports depends on the APIC Pin (not to be confused wit ACPI) of your Touchpad. More on that later.
- **GPIO** interrupt mode support is relatively complete, but the amount of modification is usually relatively large, and there may be buggy and requires more resources.
- **Polling Mode** is a very inefficient mode, the support of the function may be less complete, but the polling mode is more applicable than the interrupt mode.

Which of these modes ban be used depends on the method defined in the `DSDT` and the driver is used. At present, `VoodooI2CHID` is the only driver that supports GPIO and Polling modes at the same time.

## General approach to enabling Touchpads

1. Determine which protocol the Touchpad uses (**PS/2**, **I2C** or **SMBUS**):
	- Boot into Windows
	- Run Device Manager
	- Find your device:
		- **I2C** Touchpads are located in the **Humand Interface Devices** (HID) section as "**I2C Device**".
 		- **PS/2** and **SMBUS** Touchpads can be found under "**Mice and other pointing devices**".
	- Double-click the device to open its Device Properties
	- From the "Property" dropdown menu, select "BIOS device name". This shows its ACPI path and device name used in the `DSDT`. Take a screenshot or take a note.</br></br>
	**NOTE**: If your Touchpad uses the PS/2 protocol, you can reboot into macOS and continue at step 3.
2. Reboot back into macOS, find the **APIC** Pin of your Touchpad:
	- Open **IORegistryExplorer**
	- Find your Touchpad based on its ACPI name (the "BIOS device name" we figured out in Windows)
	- Click on the device and look for `IOInterruptSpecifiers`. Its value is displayed in Hex. Convert it to decimal (use Hackintool).
	- If the number is equal or less than `47`, your Touchpad supports the APIC Interrupt mode. In this case, you don't need additional patches and can skip to step 3. 
	- If the number is greater than 47 (so anything larger than `0x2f`), you need to use either **GPIO** or **Polling** mode. In both cases, you need addtional SSDT horfixes.
3. Based on your previous findings, do the following:
	- If it's a **PS/2** Touchpad: install **VoodooPS2Controller.kext**. For Lenovo Notebooks, there are some additional [**ThinkPad Click- and TrackPad Patches**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05_Laptop-specific_Patches/Trackpad_Patches/ThinkPad_Click_and_TrackPad_Patches) available.
	- If it's an **I2C** Touchpad, there are 2 options:
		- Supports **APIC Interrupt mode**: install VoodooI2C.kext (and additional plugin kexts, as needed) and you'r done.
		- Support **GPIO** and/or **Polling mode:** follow the &rarr; [**I2C Touchpad Instructions**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05_Laptop-specific_Patches/Trackpad_Patches/I2C_TrackPad_Patches). This section also contains additional patches for Notebooks from various vendors (Acer, Asus, Dell, HP, Huawei, Lenovo).

:bulb: **TIPS**: Check the **Resources** section for additional patching guides. If you are still facing issues getting your I2C Touchpad to work, look for existing EFI folders for your machine and check which combination of kexts, SSDT Hotfixes and/or binary renames have been used to get the Touchpad working and test them in your build.

## Resources
### Documentation and Guides
* [**Official VoodooI2C Documentation**](https://voodooi2c.github.io/)
* [**Official VoodooI2C Support Thread**](https://www.tonymacx86.com/threads/voodooi2c-help-and-support.243378/)
* [**Fixing Touchpads Guide**](https://github.com/dortania/Getting-Started-With-ACPI/blob/master/Laptops/Touchpad-methods/manual.md) by Dortania
* [**VoodoI2C Touchpad Driver Tutorial**](https://www-penghubingzhou-cn.translate.goog/2019/01/06/VoodooI2C%20DSDT%20Edit/?_x_tr_sl=auto&_x_tr_tl=en&_x_tr_hl=de&_x_tr_pto=wapp) and [Supplement](https://www-penghubingzhou-cn.translate.goog/2019/07/24/VoodooI2C%20DSDT%20Edit%20FAQ/?_x_tr_sl=auto&_x_tr_tl=en&_x_tr_hl=de&_x_tr_pto=wapp) by Penghu Bingzhou
* [**Additional Touchpad Patches**](https://github.com/GZXiaoBai/Hackintosh-Touchpad-Hotpatc) by GZXiaoBai

### Kexts for PS/2, I2C and ELAN Touchpads
- [**VoodooPS2Controller**](https://github.com/acidanthera/VoodooPS2): Magic Touchpad 2 emulation
- [**VoodooI2C**](https://github.com/VoodooI2C): Primary kext for I2C Touchpads
- [**VoodooRMI**](https://github.com/VoodooSMBus/VoodooRMI): Synaptic Touchpad driver over SMBus/I2C for macOS 
- [**VoodooSMBUS**](https://github.com/VoodooSMBus/VoodooSMBus): I2C-I801 driver port for macOS X + ELAN SMBus for Thinkpad T480s, L380, P52 
- [**VoodooElan**](https://github.com/VoodooSMBus/VoodooElan): ELAN Touchpad/Trackpoint driver for macOS over SMBus 
- [**VoodooTrackpoint**](https://github.com/VoodooSMBus/VoodooTrackpoint): Generic Trackpoint/Pointer device handler kext for macOS (now merged into [**VoodooInput**](https://github.com/acidanthera/VoodooInput))
- [**VoodooPS2-ALPS**](https://github.com/SkyrilHD/VoodooPS2-ALPS): New VoodooPS2 kext for ALPS Touchpads. Adds support for Magic Touchpad 2 emulation in order to use macOS native driver instead of handling all gestures itself. **NOTE**: This kext is now obsolete since its functionality has been integrated into VoodooPS2Controller.kext!
