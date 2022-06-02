# Fixing the battery status indicator on Laptops
Before applying any of these battery patches available here, you should test the new [**ECEnabler.kext**](https://github.com/1Revenger1/ECEnabler) first, which "allows reading Embedded Controller fields over 1 byte long, vastly reducing the amount of ACPI modification needed (if any) for working battery status". It works on a lot of ThinkPads without additional renames and Battery SSDTs.

## Battery Hotfixes included
This project includes some of the OpenCore battery hotfixes for Notebooks (such as ThinkPads). For more battery hotfixes, refer to [GZXiaoBai's Github Repo](https://github.com/GZXiaoBai/Hackintosh-Battery-Hotpatch) (written in Chinese unfortunately).

## Battery Hotfix Tutorials
If you want to understand and learn how to make your own battery hotfix, you can go to XStarDev's tutorial site and ask questions on the `Issues` page (please don't ask too low-level questions, otherwise it will be considered as invalid).

- Tutorials pages (translated with google translate):
  - [Guide for Battery Hotpatch](https://translate.google.com/translate?sl=auto&tl=en&u=https://xstar-dev.github.io/hackintosh_advanced/Guide_For_Battery_Hotpatch.html)
  - [The road to Battery Patch](https://translate.google.com/translate?sl=auto&tl=en&u=http://yqp7js.coding-pages.com/2020/05/16/%25E8%25BF%259B%25E9%2598%25B6%25EF%25BC%259A%25E7%2594%25B5%25E6%25B1%25A0%25E7%2583%25AD%25E8%25A1%25A5%25E4%25B8%2581%25EF%25BC%2588Battery-Hotpatch%25EF%25BC%2589%25E4%25B9%258B%25E8%25B7%25AF/)

## Thanks
- [1Revender1](https://github.com/1Revenger1) for ECEnabler.kext
- Rehabman (wrote the early battery patch tutorial and developed the ACPIBatteryManager project)
- Xianwu (example of battery patch for ThinkPad series laptops)
- GZ White (battery hotfix inclusion, battery hotfix tutorial)
- XStarDev (battery hotfix tutorial)
