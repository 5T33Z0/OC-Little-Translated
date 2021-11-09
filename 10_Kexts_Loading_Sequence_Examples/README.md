# Kext Loading Sequence Examples

This Chapter contains a collection of `config.plist` examples to demonstrate the loading sequences of certain kexts and family of kexts. In contrast to Clover, where you can just drop required kexts to `Clover\kexts\other` and you're good, OpenCore loads Kexts in the exact same order they are listed in the "Kernel > Add" Section of the `config.plist`. And if this order is not correct, your system either won't boot or will crash during boot!

Basically, Kexts which provide additional functionality for other kexts have to be loaded first. Config 1 contains the loading sequence for the most essential Kexts that are required by almost every Hackintosh to boot. These are:

1. **Lilu.kext**
2. **VirtualSMC.kext** (+ Sensor Plugins)
3. **Whatevergreen.kext**

The rest of the config examples show the loading sequences for `Bluetooth`, `Wifi`, `Keyboards` and `Trackpad` kexts because theses contain additional kexts nested inside of them which have to be loaded in the correct order to work correctly. Not having them in the correct order may cause Kernel Panics. So does having a Kext in the list which isn't present in the "OC > Kexts" Folder but is enabled in the config.plist. So it's of utmost importance that the Kexts are loaded in the correct order and that the content of the config.plist reflects what's inside the OC Folder 1:1. The examples provided should provide you a good guideline.

For additional information about available Kexts the [**Kext documentation**](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Kexts.md) on the OpenCore Github.

## Screenshots
### Example 1: Essential Kexts
![config1](https://user-images.githubusercontent.com/76865553/140813724-08801e20-01db-497f-945b-acd33168e814.png)
### Example 2: VooodoPS2 + TouchPad (Laptop)
![Config2](https://user-images.githubusercontent.com/76865553/140813746-3d3ab6aa-949a-4b91-8c9b-c3dcd0fef77d.png)
### Example 3: VoodooPS2 + TrackPad (Laptop)
![config3](https://user-images.githubusercontent.com/76865553/140813775-eb6ff60f-9ec3-4c9b-a768-f5e5a9e6868e.png)
### Example 4: VoodooPS2 + I2C (Laptop)
![config4](https://user-images.githubusercontent.com/76865553/140813798-a403f299-e85d-4fed-90f7-bea045384db5.png)
### Example 5: VoodooPS2 + VoodooRMI (Laptop)
![Config 5](https://user-images.githubusercontent.com/76865553/140813835-d9cd3e9c-ee55-43f1-b33f-2ae292b53b17.png)
### Example 6: VoodooPS2 + VoodooRMI + I2C (Laptop)
![Config6](https://user-images.githubusercontent.com/76865553/140813861-4ffce7a5-d636-4bec-a496-cefe85b2a9a0.png)
### Example 7: Broadcom WiFi and Bluetooth 
![config7](https://user-images.githubusercontent.com/76865553/140813883-d497ae3c-88a4-4a79-8c98-68909d0b40a3.png)
Explanation followig soon…
### Example 8: Intel WiFi and Bluetooth 
![config8](https://user-images.githubusercontent.com/76865553/140813902-8f5cedb0-4fd6-4736-ab69-c5e6f3a63fdb.png)
### Example 9a: Basic Kexts (Desktop)
![config9](https://user-images.githubusercontent.com/76865553/140826181-073a2204-aacb-435e-970c-1823cd2786d1.png)
### Example 9b: Possible Laptop Kext Sequence
![config9b](https://user-images.githubusercontent.com/76865553/140829571-525840b9-f7e5-4abb-8cd9-3aa0e31867a9.png)

## Notes
- :warning: The configs included in this section ARE NOT configured for use with any system. It's only about the order of the Kexts listed in "Kernel > Add" section!
- Ignore the red dots in the screenshots. 
- The kexts listed in Config 2 to 6 are for PS2 Controllers (Keyboards, Mice, Trackpads). We recommend to use `config-2-PS2-Controller`list as a starting point.