# Restoring `Microsoft` Bootloader folder

If you accidently deleted the `Microsoft` folder from your EFI partition, you can't start Windows anymore. But with the help of an app called "Windows Install" that you can run from within macOS, you can restore the Bootloader folder which saves you from the trouble of re-installing Windows or fiddling with recovery tools.

## Instructions

1. Run Disk Utility
2. Under "View", select "All Devices"
3. From the sidebar on the left, select the disk Windows is installed on. In this example, it's installed on `disk0s4`:<br>![](/Users/5t33y0/Desktop/restore01.png)
4. Next, download [Windows_Install.zip](https://sourceforge.net/projects/windows-install/) from sourceforge and unpack it
5. Run the app
6. Click on the button under the "Windows" logo and select: "Restore EFI Bootloader":<br>![](/Users/5t33y0/Desktop/restore02.png)
7. Change the `disk` and `s` values according to the path to your Windows installation, enter your macOS Admin Password and click the "Restore" button:<br>![](/Users/5t33y0/Desktop/restore03.png)
8. Once the process is completed, the Microsoft folder will be back:<br>![](/Users/5t33y0/Desktop/restore04.png)
