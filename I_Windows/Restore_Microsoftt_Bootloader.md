# Restoring `Microsoft` Bootloader folder

If you accidently deleted the `Microsoft` folder from your EFI partition, you can't start Windows anymore. But with the help of an app called "Windows Install" that you can run from within macOS, you can restore the Bootloader folder which saves you from the trouble of re-installing Windows or fiddling with recovery tools.

## Instructions

1. Run Disk Utility
2. Under "View", select "All Devices"
3. From the sidebar on the left, select the disk Windows is installed on. In this example, it's installed on `disk0s4`:<br>![restore01](https://github.com/user-attachments/assets/af9b0fce-31b3-4867-8391-52f0922746ca)
4. Next, download [Windows_Install.zip](https://sourceforge.net/projects/windows-install/) from sourceforge and unpack it
5. Run the app
6. Click on the button under the "Windows" logo and select: "Restore EFI Bootloader":<br>![restore02](https://github.com/user-attachments/assets/338de2aa-4139-4564-8635-8cbc209c3554)
7. Change the `disk` and `s` values according to the path to your Windows installation, enter your macOS Admin Password and click the "Restore" button:<br>![restore03](https://github.com/user-attachments/assets/cb820baf-43db-4fbc-913a-69ddc4caae1b)
8. Once the process is completed, the Microsoft folder will be back:<br>![restore04](https://github.com/user-attachments/assets/603a08ef-71ce-43df-860a-b7d6c4e8f870)
