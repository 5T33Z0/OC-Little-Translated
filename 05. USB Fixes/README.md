# Fixing USB Issues

## Background

In macOS, the number of available USB ports is limited to 15. And since modern mainboards often offer a lot more I/O than what Apple iis offering to their customers this can become a problem when trying to get everything working, because for a port to work, it has to be mapped. So if you're having issues with USB peripherals or Bluetooth (the connect via USB Interface, too), this is probably the reason why.

Since one physical USB 3 port (the blue one's) actually supports 2 protocols and requires 2 ports: one called "HS" for high speed – which is USB 2.0 – and one called "SS" for super speed, which is actually USB 3.0 

So in reality, you can actually map 7 USB 3 Ports, supporting USB 2 and 3 protocols and that's about it – USB C is not even in the equation at this stage. So you have to decide which ports you are going to use.

## Lifting the USB port limit and mapping USB ports with Hackintool (Intel only) (recommended)
 
The workaround is to lift the USB port limit, use Hackitool to map 15 ports of your choice and export a custom `USBPorts.kext` and/or `SSDT` with port information. 

To do so fFollow the officiial Guide by Dortani: [USB Port Mapping with Hackintool](https://dortania.github.io/OpenCore-Post-Install/usb/system-preparation.html)

## About the examples

* Follow **"Disabling EHCx"** if you cannot enable "XHCI" Mode in your BIOS
* **"ACPI Custom USB Port"** is for mapping the USB Port manually. AMD users only!
