# Adding and configuring `.contentFlavour` and `.contentVisibility`

## About
OpenCore 0.8.8 introduced two new hidden files: `.contentFlavour` and `.contentVisibility` to further control the behavior of the BootPicker. If you have been using OpenCore prior to 0.8.8 and use OCAT to update it, these files are most likely missing from your EFI/OC/BOOT folder.

## How to add `.contentFlavour` and `.contentVisibility` 

- Mount your EFI
- Download OpenCore Package
- Extract it
- Navigate to Downloads/OpenCore-0.9.X-RELEASE/X64/EFI/BOOT
- Press <kbd>CMD</kbd>+<kbd>.</kbd> to show hidden files
- Copy `.contentFlavour` and `.contentVisibility` to EFI/OC/Boot
- Press <kbd>CMD</kbd>+<kbd>.</kbd> to hide the folders and files again

## What are these files for?
- **`.contentFlavour`** is related to the `PickerAttributes` used by OpenCanopy, more specifically, the `OC_ATTR_USE_FLAVOUR_ICON` flag
- **`.contentVisibility`** can be used to hide and/or disable boot entries in the BootPicker. For example, if you have two physical disks in your systems with two different versions of macOS which require two different configs to boot, you can hide their EFI folders from one another.

## How to configure?
- You can open and edit these files in TextEdit (switch "Format" to "RAW text"), Visual Studio Code or Xcode.

**To be continued…**
