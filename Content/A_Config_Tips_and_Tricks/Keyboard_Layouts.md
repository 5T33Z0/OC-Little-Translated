# Keyboard Layouts

The selected keyboard layout determines the language used during macOS installation. It also sets the language used for audio localization. So unless you want to use Russian as your default language, you should change the `prev-lang:kbd` setting in the config.plist beforehand. Both `String` and `Data` are supported data formats.

:bulb: When working with beta releases of macOS, you should use the American English layout to avoid grey screen issues. Grey screens are empty windows with a grey background caused by selecting a localization which hasn't been implemented so [there's no text to display](https://www.hackintosh-forum.de/attachment/154356-fehler-png/) and you can't continue with the installation.

**Location in OC Config**: 

```
NVRAM/Add/7C436110-AB2A-4BBB-A880-FE41995C9F82/
```

**Key**: 

```
prev-lang:kbd
```

**Selected Layouts**

Layout | String | Data (HEX)
-------|--------|------
Russian (default)| ru-RU:252 |72752D52553A323532
English (American)| en-US:0| 656e2d55533a30
Spanish (ISO)| es:87 | 65733A3837
German (De)| de-DE:3 | 64652D44453A33
French (PC)| fr:60 | 66723A3630
Italian | it:4 | 69743A34

**More Layouts**: [AppleKeyboardLayouts.txt](https://github.com/acidanthera/OpenCorePkg/blob/master/Utilities/AppleKeyboardLayouts/AppleKeyboardLayouts.txt) (need to be converted to HEX)
