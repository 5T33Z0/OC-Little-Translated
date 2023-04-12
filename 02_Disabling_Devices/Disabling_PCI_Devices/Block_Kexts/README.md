# Disabling PCI Serial Adapter

On Hackintoshes, the Network Settings may contain a `PCI Serial Adapter` device which is not useful in terms of Network Connectivity:

![PCI Serial](https://user-images.githubusercontent.com/76865553/179019541-b728d169-1675-4313-91a1-4288d6693ca1.png)

Searching for "serial" in IO Registry Explorer reveals that it's related to `Apple16X50.kext` in S/L/E:

![IOreg01](https://user-images.githubusercontent.com/76865553/178971557-01f0158d-7ab8-41e8-b3fe-5193e2058670.png)

Judging from the [source code](https://github.com/apple-oss-distributions/Apple16X50Serial), Apple16X50 appears to be a driver for serial ports, likely a leftover from the PPC days. Possibly left in for serial ports in internal devkits and unpopulated headers on production Macs. Looks like it only depends on the kernel and seemingly has no other dependents.

## Instructions

Unfortunately, this device can't be blocked via ACPI, but you can do the following to block the kext from loading:

1. Delete the PCI Serial Adapter Entry from Network Settings.
2. Say "Yes" when being asked if should add the device back to the list, next time it is connected (makes testing easier)
3. Mount your EFI folder
4. Open your config.plist
5. Add the Following Rule to Kernel/Bock:
	|Identifier   |Comment   |  Enabled |  Strategy |  Arch |
	|-------------|----------|:--------:|:---------:|:-----:|
	|com.apple.driver.Apple16X50Serial| Blocks PCI Serial Adapter | True | Disable | Any  
6. Save your config.plist and reboot

## Testing

Search for "serial" in IO Reg again. The `IOSerialBSDClient` should be gone:

![IOreg02](https://user-images.githubusercontent.com/76865553/178971604-4446dffe-27d4-4524-8734-0d1078f25d99.png)

And the PCI Serial Adapter will be gone from Network Settings as wel.

## Notes

- I couldn't find much info about this kext but the `IOSerialBSDClient` seems to be related to to the [serial modem detection](https://developer.apple.com/forums/thread/116061).
- If you notice any issues with the system after disabling this kext, re-enable it. So far I haven't noticed any problems.
- In Big Sur this does no longer work for me. The kext is loaded anyway.
