## Converting `.dsl` files to `.aml`
The Hotfixes in this section are provided as disassembled ASL Files (`.dsl`) so that they can be viewed in webbrowser. In order to use them in Bootloaders, they need to be converted to ASL Machine Language (`.aml`) first. Here's how to do this:

1. Click on the link to a `.dsl` file of your choice. This will display the code contained in the file
2. Download the file (there's a download button on the top right; "Download raw file").
3. Open it in [**maciASL**](https://github.com/acidanthera/MaciASL).
4. Edit the file (if necessary).
5. Click on "File" > "Save As…".
6. From the "File Format" dropdown menu, select "ACPI Machine Language Binary"
7. Save it as "SSDT–…" (whatever the original file name was).
8. Add the `.aml` file to `EFI/OC/ACPI` and your `config.plist` (under `ACPI/Add`).
9. Save and reboot to test it.

[←**Back to Overview**](./README.md) | [**Next: Applying different ACPI patches for different versions of macOS →**](06_OSI-ACPI.md)
