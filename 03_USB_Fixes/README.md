# Fixing USB issues

## Background

In macOS, the number of available USB ports is limited to 15. But since modern mainboards can have a lot more I/O ports than what Apple provides to their customers (up to 26 per controller), this can become a problem when trying to get USB pots working proplerly so interal and external USB devices are detected and work at the correct speeds (otherwise they default to USB 2.0 speeds).

Since one physical USB 3 port (the blue ones) actually supports 2 USB protocols it requires 2 ports: one called "HS" for high speed – which is USB 2.0 – and one called "SS" for "super speed", which is USB 3.0. So in reality, you can actually map 7 USB 3 Ports, supporting USB 2 and 3 protocols and that's about it – USB 3.2 is not even in the equation at this stage. So you have to decide which ports you are going to use and map them.

## Removing the USB port limit and mapping USB ports

The workaround is to lift the USB port limit and use Hackitool to map 15 ports of your choice. Before macOS Catalina you could use the XHCI portlimit quirk and you were fine. Since macOS Catalina, you need to map USB ports so your peripherals work correctly. There are two methods to achieve this:

### Method 1: Mapping USB Ports via Custom Kext (macOS 10.15 to macOS 11.2)

Up until macOS 11.3, this was usually done using tools such Hackintool or USBMap. To do so, follow the official Guide by Dortania: [USB Port Mapping with USBMap](https://dortania.github.io/OpenCore-Post-Install/usb/system-preparation.html). Personally, I prefer [Hackintool](https://github.com/headkaze/Hackintool) for mapping USB Ports.
This only works for Intel Systems 

### Method 2: Mapping USB Ports via ACPI (OS-independent. Recommended for advanced users only!)
Since macOS Big Sur 11.3, the `XHCIPortLimit` Quirk removes the USB port limit no longer works. This complicates the process of creating a `USBPorts.kext` with Tools like `Hackintool` or `USBMap`. 

So the best way to declare USB ports is via ACPI since this method is OS-agnostic (unlike USBPort kexts, which by default only work for the SMBIOS they were defined for).

Follow [**this guide**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03_USB_Fixes/ACPI_Mapping_USB_Ports) to map your USB Ports via SSDT Table. 
