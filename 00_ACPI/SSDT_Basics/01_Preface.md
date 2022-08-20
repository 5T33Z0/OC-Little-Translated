# Introduction to writing SSDT Hotpatches

## Preface
This assists you in writing your own SSDT Hotfixes from scratch. The aim is to reduce the use of binary renames to a minimum while maximizing ACPI conformity as well as compatibility with other Operating Systems. 

***But why?***, you might ask.

Since ACPI is OS-agnostice and since OpenCore injects ACPI changes system-wide, the idea is to use SSDT patches that only affect macOS and leave the `DSDT` unchanged otherwise.

So, avoid binary patches like `HDAS` to `HDEF`, `EC0` to `EC`, `SSDT-OC-XOSI`, etc. whenever possible. Especially renaming of methods (`MethodObj`) such as `_STA`, `_OSI`, etc. should be performed with caution. Nowadays, a lot of renames are handled by kexts like **AppleALC** and **WhateverGreen** anyway.

### Why to prefer SSDTs over a patched DSDT

A common problem with Hackintoshes is missing ACPI functionality when trying to run macOS on X86-based Intel and AMD systems, such as: Networking not working, USB Ports not working, CPU Power Management not working correctly, screens not turning off when the lid is closed, Sleep and Wake not working, Brightness controls not working and so on.

These issues stem from DSDTs made with Windows support in mind on one hand and Apple not sticking to ACPI tables which conform to the ACPI specs 100 % for their hardware on the other. These issues can be addressed by dumping, patching and injecting a patched DSDT during boot, replacing the original.

Since a DSDT can change when updating the BIOS, injecting an older DSDT on top of a newer one can cause conflicts and break macOS functionalities. But there are more fundamental reasons why to avoid using patched DSDTs. A word from the one of the OpenCore Devs (mhaeuser):

> Changes to DSDT are inherently unsafe and anyone who tells you otherwise demonstrates nothing but their cluelessness about firmware internals. This does not mean this never works, but the point is you unlikely verified your systems behaviour for all edge cases (resuming from all sleep states, resetting CMOS, potential recovery procedures from failed boots, etc etc). There are way too many variables, really. You also restrain yourself from updating your firmware or performing any configuration changes (hardware or software) without risking having to re-do your DSDT. 

[…]

> ACPI tables can be and are patched dynamically during firmware execution. Changing various factors, hardware and software, thus may yield a DSDT different from the one you used as your template, and thus your patched DSDT will "rollback" exactly those differences. There is no amount of "knowledge" and "language comfortability" you can gain to make this safe, this is inherently unsafe. 

**Source**: [Waybackmachine](https://web.archive.org/web/20220807100310/https://www.insanelymac.com/forum/topic/352881-when-is-rebaseregions-necessary/) – Actually, this post is from August 2022 and was released on insanelymac.com. But MaLd0n didn't like what he read and decided to lock the post. And after he saw that I was referencing it, he even deleted the whole thread. Unfortunatly for him, it was already archived.

Therefore, dynamic patching with SSDTs is highly recommended over using a patched DSDT. Plus the whole process is much more efficient, transparent and elegant. And that’s why you should avoid patched DSDTs – especially those from MaLDon/Olarila!

Anyway, [**back to the regular scheduled program…**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/00_ACPI/SSDT_Basics/02_OC_ACPI_Handling.md)
