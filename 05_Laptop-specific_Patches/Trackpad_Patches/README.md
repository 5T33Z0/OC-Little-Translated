# Enabling TrackPad Support on Laptops

## Introduction
Depending on the type of Laptop and TrackPad/TouchPad you are using, you might need to incorporate various kexts and combinations of kexts as well as additional SSDT-Hotpacthes and/or binary renames to get it working.

So getting these Human Interface Devices working can be a tedious task. The wrong combination of kexts, renames and SSDTs can also cause Kernel Panics if the Kexts you are using are not loaded in the correct sequence or the renames or device paths in the SSDT samples are incorrect. You can check examples of possible combination of kexts in Chapter 10 of the repo.

## Possible workflow
1. Find out which TrackPad/TouchPad you are using (Vendor, Technology, etc.) You can do this in Windows by using the Device Manager. It can display the vendor, it's PCI device patch, the controller, etc.
2. Find out how which method is used for controlling it. If it is cotrolled by the PS2 Controller you need a different combination of kexts than when it's controlled via the SMBus. Can be done in Windows Device Manager as well.
3. Check the included Folders for TrackPads in this repo
4. Check other resources like existing EFI folders for your device or Dortania's OpenCore Install Guide or Forums.