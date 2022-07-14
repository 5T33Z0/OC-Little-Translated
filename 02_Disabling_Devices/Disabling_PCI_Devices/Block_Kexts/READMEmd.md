# Disabling PCI Serial Adapter

On Hackintoshes, the Network Settings may contain a `PCI Serial Adapter` device which is not useful in terms of Network Connectivity:

![](/Users/5t33z0/Desktop/1017872403_ScreenShot2022-07-13at10_59_55.png.69f527ea26990a547ffc5bdb044fe68e.png)

Searching for "serial" in IO Registry Explorer reveals that it's related to `Apple16X50.kext` in S/L/E:

![](/Users/5t33z0/Desktop/IOreg01.png)

## Instructions

Unfortunately, this device can't be blocked via ACPI, but you can do the following to block the kext from loading:

1. Delete the PCI Serial Adapter Entry from Network Settings.
2. Say "Yes" when being asked if should add the device back to the list, next time it is connected (makes testing easier)
3. Mount your EFI folder
4. Open your config.plist
5. Add the Following Rule to Kernel/Bock:

	|Identifier   |Comment   |  Enabled |  Strategy |  Arch |
	|-------------|----------|:--------:|:---------:|:-----:|
|com.apple.driver.Apple16X50Serial| Blocks PCI Serial Adapter  |  True | Disable | Any  |

6. Save your config.plist and reboot

## Testing
Search for "serial" in IO Reg again. The `IOSerialBSDClient` should be gone:

![](/Users/5t33z0/Desktop/ioreg02.png)

And the PCI Serial Adapter will be gone from Network Settings as wel.

## Notes
If you notice any issues with the system after disabling this kext, re-enable it. So far I haven't noticed any problems.
