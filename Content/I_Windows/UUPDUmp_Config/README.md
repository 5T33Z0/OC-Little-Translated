# UUP Dump Configuration Files
This folder contains my custom **UUP Dump** configuration files for creating a clean and minimal **Windows 10 and Windows 11** installation ISO as explained here: [Creating a bloatfree Windows 10/11 ISO](../Bloatfree_Win.md)

The goal is to remove unnecessary pre-installed applications while preserving system stability, compatibility, Windows Update functionality, and essential administrative tools.

## Included Files

### `ConvertConfig.ini`

Main UUP Dump conversion configuration.

Key settings:

* Automatic conversion enabled
* Latest cumulative updates integrated
* Temporary files cleaned up after the conversion process
* `.NET Framework 3.5` integrated
* ISO creation enabled
* `install.wim` preserved (no ESD compression)
* Custom Microsoft Store app selection enabled
* No additional drivers integrated

---

### `CustomAppsList.txt`

Defines which Microsoft Store applications are included in the generated Windows image.

The default configuration keeps only essential components, such as:

* **Windows Security UI** (`Microsoft.SecHealthUI`)

  * Required interface for Microsoft Defender and Windows Security settings

* **App Installer** (`Microsoft.DesktopAppInstaller`)

  * Enables installation of `.appx` and `.msix` packages and provides `winget` support

Optional applications can be enabled by removing the `#` character in front of their package names.

Examples include:

* Windows Terminal
* Notepad
* Calculator
* Snipping Tool

Applications intentionally excluded by default include:

* Xbox apps and overlays
* Microsoft Teams
* Outlook for Windows
* Clipchamp
* News and Weather
* Maps
* People
* Microsoft To Do
* Sticky Notes
* Feedback Hub
* Get Help
* Get Started
* Other consumer-focused applications
* Photos
* Camera

---

## Philosophy

This configuration is **not intended to create a heavily stripped "Tiny Windows" build**.

The objective is to provide a Windows installation that is:

* Clean
* Lightweight
* Free from unnecessary pre-installed applications
* Compatible with Windows Update
* Suitable for everyday use, gaming, development, and professional environments

Core Windows components, security features, and system functionality remain intact.

---

## Usage

1. Download a UUP Dump package from https://uupdump.net/ for the desired Windows 10 or Windows 11 build.
2. Replace the original `ConvertConfig.ini` and `CustomAppsList.txt` files with the versions from this repository.
3. Run the UUP Dump conversion script (`uup_download_windows.cmd` or the appropriate script for your platform).
4. Wait for the download, conversion, and ISO creation process to complete.

---

## Notes

* `CustomAppsList.txt` is supported on Windows builds **22563 and newer**.
* Some applications depend on the Microsoft Store. If the Store is removed, those applications may need to be installed or updated manually.
* Keeping **App Installer** allows the use of `winget` even without the Microsoft Store.
* The exact list of available applications may differ between Windows 10 and Windows 11 builds.

---

## Legality

These configuration files do **not** contain any Microsoft Windows files, binaries, or proprietary content. They only provide configuration settings for the **UUP Dump** conversion process and define which optional Microsoft Store applications are included in the generated installation image.

Using these files is generally legal to share and modify, as they are plain text configuration files.

However:

* The resulting Windows ISO contains Microsoft software and is subject to the **Microsoft Software License Terms**.
* A valid Windows license may be required to activate and use Windows legally.
* Redistribution of a generated Windows ISO may be restricted by Microsoft's licensing terms.
* Users are responsible for ensuring they comply with all applicable Microsoft licenses and local laws.

This repository is **not affiliated with, endorsed by, or supported by Microsoft or UUP Dump**.

---

A simple rule of thumb:

* ✅ Sharing `ConvertConfig.ini` and `CustomAppsList.txt` → generally fine
* ✅ Building a personal Windows ISO from Microsoft-provided update packages → generally accepted for personal use
* ⚠️ Sharing the generated ISO publicly → may violate Microsoft's licensing terms


---

## Disclaimer

These configuration files modify the default application selection during the UUP conversion process. They do **not** remove core Windows components or apply unsupported system modifications.

Always test custom Windows images in a virtual machine before deploying them on production systems.
