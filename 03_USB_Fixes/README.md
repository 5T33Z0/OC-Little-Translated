# Fixing USB Issues

## Background

In macOS, the number of available USB ports is limited to 15. But since modern mainboards can have a lot more I/O ports than what Apple provides to their customers this can become a problem when trying to get everything working. Because for a port to work, it has to be mapped. So if you're having issues with USB peripherals or Bluetooth (BT connects via USB Interface, too), this is probably the reason why.

Since one physical USB 3 port (the blue one's) actually supports 2 USB protocols it requires 2 ports: one called "HS" for high speed – which is USB 2.0 – and one called "SS" for "super speed", which is USB 3.0. So in reality, you can actually map 7 USB 3 Ports, supporting USB 2 and 3 protocols and that's about it – USB 3.2 is not even in the equation at this stage. So you have to decide which ports you are going to use and map them.

## Lifting the USB port limit and mapping USB ports with USBMap/Hackintool (Intel only)

The workaround is to lift the USB port limit and use Hackitool to map 15 ports of your choice and export a custom `USBPorts.kext` and/or `SSDT` with port information. This method is for Intel Users only. AMD user have to do this manually

To do so, follow the official Guide by Dortania: [USB Port Mapping with USBMap](https://dortania.github.io/OpenCore-Post-Install/usb/system-preparation.html). Personally, I prefer [Hackintool](https://github.com/headkaze/Hackintool) for mapping USB Ports.

## About the examples

* Follow the instructions in **"Disabling EHCx"** if you cannot enable "XHCI Mode" in your BIOS.
* **"ACPI Custom USB Port"** is for mapping the USB Port manually (not recommended)
