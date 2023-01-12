# Fixing Window features after installing macOS
You can use Hackintool to create some registry keys which you can import in Windows to fix some issues. 

## Correct time in Windows clock

After installing macOS, the time displayed in the Windows clock is always runs an hour earlier or later than the actual time. That's because Windows uses GMT (Greenwich Mean Time) while macOS uses UTC (Coordinated Universal Time). 

And every time the other OS boots, it tries to "fix" the time in the BIOS/Firmware that the other OS changed previously. And since both OSes use different time references that's where the discrepancies come from. The solution is to change the Windows Clock to UTC using a registry key entry:
 
1. Run Hackintool
2. Click on "Utilies"
3. Click on this icon to Generate Windows UTC Registry Files:</br>![UTC](https://user-images.githubusercontent.com/76865553/150509659-a2837405-2f9a-4aed-a1c3-134b62efeb83.png)</br>This will create 2 .reg files, `WinUTCOn.reg` and `WinUTCOff.reg` on your desktop.
5. Copy these files to a location which you can access from within Windows.
6. Reboot into Windows
7. Double-click `WinUTCOn.reg` to import it into your registry.
8. Reboot.

The displayed time should now be correct.

## Sharing Bluetooth Credentials between macOS and Windows

In order to use the same Bluetooth credentials in macOS and Windows, you can do this:

1. Run Hackintool
2. Click on "Utilies"
3. Click on the Bluetooth Icon to Generate Windows Bluetooth Registry File
4. Copy the file to a location which you can access from within Windows.
5. Reboot into Windows
6. Double-click `Bluetooth.reg` to import it into your registry.
7. Reboot.

You should now be able to connect peripherals without having to re-couple your devices if you switch between macOS and Windows.
