# Adding and configuring `.contentFlavour` and `.contentVisibility`

- [About](#about)
- [How to add `.contentFlavour` and `.contentVisibility`](#how-to-add-contentflavour-and-contentvisibility)
- [About `.contentVisibility`](#about-contentvisibility)
  - [Usage](#usage)
  - [InstanceIdentifier](#instanceidentifier)
- [About `.contentFlavour`](#about-contentflavour)
  - [Configuration](#configuration)
- [Resources](#resources)

---

## About
OpenCore 0.8.8 introduced two new hidden files: `.contentFlavour` and `.contentVisibility` to further control the behavior of the BootPicker. If you have been using OpenCore prior to 0.8.8 and use OCAT to update it, these files are most likely missing from your `EFI/OC/BOOT` folder.

## How to add `.contentFlavour` and `.contentVisibility` 

- Mount your EFI
- Download OpenCore Package
- Extract it
- Navigate to Downloads/OpenCore-0.9.X-RELEASE/X64/EFI/BOOT
- Press <kbd>CMD</kbd>+<kbd>.</kbd> to show hidden files
- Copy `.contentFlavour` and `.contentVisibility` to EFI/OC/Boot
- Press <kbd>CMD</kbd>+<kbd>.</kbd> to hide the folders and files again

## About `.contentVisibility`
**`.contentVisibility`** is used to hide boot entries from OpenCore's Boot Menu. This makes it a lot easier to hide entries then in previous versions where you had to calculate a `ScanPolicy` and in some cases combine it with `CustomEntries` to make it work.

### Usage
Simply place the `.contentVisibility` file in the folder containing the bootloader of the Operating System you want to hide from the BootPicker.

The `.contentVisibility` file can be opened and edited with TextEdit, Visual Studio Code and Xcode, of course. It basically contains one word (ASCII): `Disabled`:

![visibility](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/101f23b6-06b2-4938-b741-468e27ffe6ac)

**Options** – You can change its behaviour by using these words:

- `Disabled` &rarr; Hides the entry from OpenCore's BootPicker.
- `Enabled` &rarr; Shows the entry.
- `Auxiliary` &rarr; Treats the entry as Auxiliary, so it's only revealed after pressing the space bar. I am using this option for my USB flash drive that is permanently attached to my system as a plug and stay device that contains a working backup of my EFI folder.

**Placement** – You can place the file in the following locations:

- `/System/Volumes/Preboot/{GUID}/.contentVisibility`
- `/System/Volumes/Preboot/.contentVisibility`
- `/Volumes/{ESP}/.contentVisibility` (not recommended)
- `/EFI/Boot` folder on USB flash drives (set it to `Auxiliary`, not `Disabled`!)

**Examples**:

- To hide the EFI folder, put in `EFI/OC/BOOT`
- To hide Windows, put it in the EFI containing the `Microsoft/Boot` folder
- For any other OS, the same principle applies.

### InstanceIdentifier
OpenCore 0.9.4 added a new feature called `IntanceIdentifier`. This allows adding an `InstanceIdentifier` to the config, which describes the used OpenCore instance. If you have 2 different instances of OpenCore (using different identifiers), you can then modify the `.contentVisibilty` file to hide instances.

For more details, refer to the OpenCore Documentation, chapter 8.1.1: Boot Algorithm 

## About `.contentFlavour`

**`.contentFlavour`** is used to modify the look and feel of entries in OpenCore's BootPicker (Audio Assist included). In order to enable it, the `OC_ATTR_USE_FLAVOUR_ICON` flag has to be added to the `PickerAtributes` bitmask. Check out the [OpenCore Calculators](https://github.com/5T33Z0/OC-Little-Translated/tree/main/B_OC_Calculators) section to figure out how to generate it.

### Configuration
To configure the `.contentFlavour` file, please follow the extensive [OpenCore Content Flavor](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Flavours.md) guide provided by Acidanthera.

## Resources
OpenCorePkg [Pull Request #446](https://github.com/acidanthera/OpenCorePkg/pull/446): Add Optional .contentVisibility Qualification 
