# SSDT-EC Counterfeit patch

## Description

Although OpenCore does not require renaming of the Embedded Controller (EC), in order to load USB Power Management, it may be necessary to impersonate another EC.

## Instructions for use

Search for `PNP0C09` in DSDT and check the name of the device it belongs to. If the name is not `EC`, use this patch; if it is `EC`, ignore this patch.

## Note

- If multiple `PNP0C09`s are searched, you should confirm the real and valid `PNP0C09` device.
- The patch uses `LPCB`, if it is not `LPCB`, please modify the patch content by yourself.