# Kext Loading Sequence Examples

This Chapter contains a collection of `config.plist` examples to demonstrate the loading sequences of certain kexts and family of kexts. In contrast to Clover, where you just have to add the required kexts to `Clover\kexts\other` and you're done, OpenCore loads Kexts in the exact same order they are listed in the "Kernel > Add" Section of the `config.plist`.  

Basically, Kexts which provide additional functionality other kexts rely on, have to be loaded first. Config 1 contains the loading sequence for the most essential Kexts that are required by almost every Hackintosh to boot. These are:

1. Lilu
2. VirtualSMC (+ Sensor Plugins)
3. Whatevergreen

The rest of the config examples show the loading sequences for `Bluetooth`, `Wifi`, `Keyboards` and `Trackpad` kexts because theses contain additional kexts nested inside of them which have to be loaded in the correct order to work correctly. Not having them in the correct order may cause Kernel Panics. So does having a Kext in the list which isn't present in the "OC > Kexts" Folder but is enabled in the config.plist. So it's of utmost importance that the Kexts are loaded in the correct order and that the content of the config.plist reflects what's inside the OC Folder 1:1. The examples provided should provide you a good guideline. 

## Screenshots
### Example 1: Essential Kexts
![](/Users/5t33z0/Desktop/config1.png)
### Example 2: VooodoPS2 + TouchPad (Laptop)
![](/Users/5t33z0/Desktop/Config2.png)
### Example 3: VoodooPS2 + TrackPad (Laptop)
![](/Users/5t33z0/Desktop/config3.png)
### Example 4: VoodooPS2 + I2C (Laptop)
![](/Users/5t33z0/Desktop/config4.png)
### Example 5: VoodooPS2 + VoodooRMI (Laptop)
![](/Users/5t33z0/Desktop/Config 5.png)
### Example 6: VoodooPS2 + VoodooRMI + I2C (Laptop)
![](/Users/5t33z0/Desktop/Config6.png)
### Example 7: Broadcom WiFi and Bluetooth 
![](/Users/5t33z0/Desktop/config7.png)
Explanation followig soon…
### Example 8: Intel WiFi and Bluetooth 
![](/Users/5t33z0/Desktop/config8.png)

## Notes
- :warning: The configs included in this section ARE NOT configured for us with any system. It's only about the order of the Kexts listed in "Kernel > Add" section.
- Ignore the red dots in the screenshots. 
- The kexts listed in Config 2 and 5 are both for PS2 Controllers (Keyboards, Mice, Trackpads). Don't use both at the same time. We recommend to use `config-2-PS2-Controller`list.
