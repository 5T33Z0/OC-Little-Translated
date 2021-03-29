# Kext Loading Sequence Examples

This Chapter contains a collection of `config.plist` examples to demonstrate the loading sequences of certain kexts and family of kexts. In contrast to Clover, where you just have to add the required kexts to `Clover\kexts\other` and you're done, OpenCore loads Kexts in the exact same order they are listed in the "Kernel > Add" Section of the `config.plist`.  

Basically, Kexts which provide additional functionality other kexts rely on in order to work correctly, have to be loaded first. Config 1 contains the loading sequence for all the essential Kexts that are required by almost every Hackintosh to boot are:

1. Lilu
2. VirtualSMC (+ Sensor Plugins)
3. Whatevergreen

The rest of the config examples show the loading sequences for `Bluetooth`, `Wifi`, `Keyboards` and `Trackpad` kexts because theses kexts have nested kexts inside of them which are needed and have to be loaded in the correct order to work. Not having them in the right order may cause Kernel Panics. So does having a Kext in the list which is not present in the "OC > Kexts" Folder but is enabled.So it's of utmost importance that the Kexts load in the correct order. The examples provided should guide you. 

## Note
The kexts listed in Config 2 and 5 are both for PS2 Controllers (Keyboards, Mice, Trackpads). Don't use both at the same time. We recommend to use `config-2-PS2-Controller`list.