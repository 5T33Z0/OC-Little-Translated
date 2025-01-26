# Fixing Preboot partitions of APFS containers modified by macOS High Sierra  

## Symptom

On a multi-boot macOS system, High Sierra can interfere with booting newer macOS versions by modifying Preboot partitions. Specifically, it changes the `ProductVersion` in the `SystemVersion.plist` file on the Preboot volume.

In my case with a Comet Lake workstation, after using High Sierra and attempting to boot Big Sur, I encountered the "forbidden" symbol. Adding `-no_compat_check` to boot-args resolved the issue temporarily.

Initial solutions included:

- Using `-no_compat_check` boot argument
- Reinstalling the newer macOS version
- Manually fixing via Terminal

This compatibility issue was uncommon and took until late 2024 to be fully resolved, despite early reports in hackintosh forums.

## Fix

- Download MacSchrauber's ROM Dump tool from his [**Github repo**](https://github.com/Macschrauber/Macschrauber-s-Rom-Dump/releases), specifically the `Download.the.Dumper.from.github.zip`
- Extract the .zip
- Run the "Download the Dumper from github" applet
- Select "Download"
- This will download `Macschrauber's Rom Dump.dmg` file (the applet also servers as a key to unlock this password protected diskimage so it can be mounted)
- Once the .dmg is downloaded and mounted, navigate to `/Volumes/Macschrauber's CMP Rom Dump/Readme & other tools/Preboot fixer and renamer` to find the "PrebootFixer and Renamer"
- Follow the [**MacSchrauber's Instructions**](https://github.com/Macschrauber/Macschrauber-s-Rom-Dump/blob/main/Rename_and_repair_preboot.md)

>[!IMPORTANT]
>
> Don't delete the "Download the Dumper from github" applet afterwards. Because otherwise you cannot mount the .dmg containing the ROM dump tools, since it's password protected

## Best Practice

- Simply don't install macOS High Sierra alongside newer versions of macOS!
