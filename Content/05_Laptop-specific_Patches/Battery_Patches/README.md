# Fixing the battery status indicator on Laptops

## Try `ECEnabler.kext` first!
Before applying any of these battery patches available here, you should test the new [**ECEnabler.kext**](https://github.com/1Revenger1/ECEnabler) first, which "allows reading Embedded Controller fields over 1 byte long, vastly reducing the amount of ACPI modification needed (if any) for working battery status". It works on a lot of ThinkPads and other Laptops without additional ACPI patches and Battery SSDTs.

## Battery Hotfixes
This section contains battery hotfixes for notebooks from various vendors (check the folders above). 

- [ThinkPad Battery Fixes](/Content/05_Laptop-specific_Patches/Battery_Patches/i_ThinkPad/README.md)
- [Intel NUC](/Content/05_Laptop-specific_Patches/Battery_Patches/v_NUC/README.md)
- [Various](/Content/05_Laptop-specific_Patches/Battery_Patches/ii_Other_brands)
- [Battery Information Patch](/Content/05_Laptop-specific_Patches/Battery_Patches/iii_Battery_Information_Assist_Patch/README.md)

For more battery patches, check [**GZXiaoBai's Github Repo**](https://github.com/GZXiaoBai/Hackintosh-Battery-Hotpatch) (writen in Chinese).

## Battery Hotfix Tutorials
Below you'll find some links to battery patching guides. If you want to understand and learn how to make your own battery hotfix, you can go to XStarDev's tutorial site and ask questions on the `Issues` page (please don't ask too low-level questions, otherwise it will be considered invalid).

- [**ACPI Battery Patching Guide**](https://github.com/dreamwhite/acpi-battery-patching-guide) by Dreamwhite (English)
- [**Guide for Battery Hotpatch**](https://translate.google.com/translate?sl=auto&tl=en&u=https://xstar-dev.github.io/hackintosh_advanced/Guide_For_Battery_Hotpatch.html) by XstarDev (Translated from Chinese with google translate)
- [**The road to Battery Patch**](https://translate.google.com/translate?sl=auto&tl=en&u=http://yqp7js.coding-pages.com/2020/05/16/%25E8%25BF%259B%25E9%2598%25B6%25EF%25BC%259A%25E7%2594%25B5%25E6%25B1%25A0%25E7%2583%25AD%25E8%25A1%25A5%25E4%25B8%2581%25EF%25BC%2588Battery-Hotpatch%25EF%25BC%2589%25E4%25B9%258B%25E8%25B7%25AF/) (Translated from Chinese with google translate)

## Credits
- 1Revenger1 for [**ECEnabler.kext**](https://github.com/1Revenger1/ECEnabler)
- Rehabman for DSDT battery status patching [**guide**](https://www.tonymacx86.com/threads/guide-how-to-patch-dsdt-for-working-battery-status.116102/) and [**ACPIBatteryManager.kext**](https://bitbucket.org/RehabMan/os-x-acpi-battery-driver/src/master/)
- Xianwu (example of battery patch for ThinkPad series laptops)
- GZ White (battery hotfix inclusion, battery hotfix tutorial)
- XStarDev (battery hotfix tutorial)
- Dreamwhite for the English version
