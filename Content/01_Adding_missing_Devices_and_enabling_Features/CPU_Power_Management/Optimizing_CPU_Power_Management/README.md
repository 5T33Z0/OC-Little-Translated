# Optimizing CPU Power Management with CPUFriendFriend

>**Compatibility**: 4th Gen Intel Core and newer supporting XCPM (Plugin-Type: 1)

## About
This guide is for optimizing CPU Power Management of Intel CPUs supporting XCPM. It can be used to reduce the lowest frequency of the CPU and change the overall bias of the system in terms of performance and power consumption by generating a helper kext for CPUFriend which injects Frequency Vectors into macOS.

Doing this is recommended for all systems where the CPU is different model than the one used in the real Mac. For example, the iMac20,2 comes in 2 variants: with an i7-10700K or an i9-10910. So if you are using and i9-10850K with the iMac20,2 SMBIOS, the frequency vectors stored in the SMBIOS don't match 100% with your CPU model which is not ideal. Therefore, using Python Script **CPUFriendFriend** is a great way to improve CPU compatibility and Power Management.

### SMBIOSes supporting XCPM

- MacBook8,1 and newer
- MacBookAir6,x and newer
- MacBookPro11,x and newer
- Macmini7,1 and newer
- iMac14,x and newer
- iMacPro1,1
- MacPro7,1

If you run CPUFriendFriend on a system with any other SMBIOS than the ones listed above, you will get an error similar to this:

>FrequencyVectors not found in Mac-C3EC7CD22292981F.plist!

### How it works
Basically, the CPUFriendFriend script extracts the Frequency Vectors stored inside a plist file associated with the board-id of currently set SMBIOS and lets you modify them. CPUFriendFriend then generates a helper kext containing the modified Frequency Vectors and other settings. These are handed over to CPUFriend.kext which injects them into macOS on boot.
 
## Generating a `CpuFriendDataProvider.kext` with CPUFriendFriend

:bulb: The example is from my i9-10850K. The available data/options for your CPU model might differ!

1. Download [**CPUFriendFriend**](https://github.com/corpnewt/CPUFriendFriend) (click on "Code" > "Download zip") and unpack it
2. Double-click `CPUFriendFriend.command` to run it. You should see the following prompt:</br>
	![LFM](https://user-images.githubusercontent.com/76865553/151773085-f181f1d2-e8f3-4f97-8b29-5c8e741b2765.png)
3. Enter a *hex* value for the `Low Frequency Mode`. It's the lowest possible frequency the CPU should clock down to without crashing. I am using `08` for 800 MHz. Add your desired value and hit `Enter`.
4. Next, adjust the `Energy Performance Preference (EPP)`:</br>
	![EPP](https://user-images.githubusercontent.com/76865553/151773160-38aa587d-93e7-414d-9fbe-50c0eee1c437.png)</br>
This This describes how fast the CPU scales from the lowest to the highest Turbo frequency, which has an impact on the overall power consumption. I use `00`.
5. Next, you have to specify the `Performance Bias Range`, which is used to set the general bias of the system between performance and energy efficiency. The scale ranges from `00` (maximum performance) to `15` (maximum power saving). Since this is more relevant for notebooks than an i9 workstation, I am using `01`:</br>
	![BIAS](https://user-images.githubusercontent.com/76865553/151773244-f1bd7d7c-182e-468d-86ec-5702283dad13.png)</br>
6. Next, you can apply additional energy saving Options taken from the MacBook Air SMBIOS (optional):</br>![mba](https://user-images.githubusercontent.com/76865553/151773342-8ac88574-9926-4efb-af9d-7e4599f57e40.png)</br>Make your choice and hit `Enter`
7. Finally, the `CPUFriendDataProver.kext` and additional Files are created:</br>![files](https://user-images.githubusercontent.com/76865553/151773395-212d209b-0e6b-43ca-b105-ccf0172f90e7.png)
8. Copy **`CPUFriendDataProver.kext`** followed by [**`CPUFriend.kext`**](https://github.com/acidanthera/CPUFriend/releases) into the kext folder and add them to your `config.plist`
9. Save and reboot

## Testing

- Download, install and run [**Intel Power Gadget**](https://www.insanelymac.com/forum/files/file/1056-intel-power-gadget/).
- Observe the frequency graph:</br>![](https://raw.githubusercontent.com/5T33Z0/Gigabyte-Z490-Vision-G-Hackintosh-OpenCore/main/Pics/CPU_PM.png)

### Explanation 
Both, `CoreMax` (top line) and `CoreAvg` (jagged blue line) should drop if the computer is idling, whereby the upper line can only drop as low as the solid straight line (= base frequency – in my case 3.6 GHz), which means that the CPU is not boosting. 

At the lower end of the scale, `CoreMin` should be below 1 gHz, since we entered 800 MHz as the LFM value. In this case it is even lower – 700 MHz. Thus, the CPU power management is working fine.

If the frequency is never below the base frequency or permanently above it, something is wrong with the CPU power management – unless you’ve modified the CPU parameters in the BIOS by disabling speed step or overclocking all cores, etc.

> [!WARNING]
> 
> 1. Don't use Intel Power Gadget on macOS Sonoma 14.2 beta 3 or newer! The `EnergyDriver.kext` it installs causes all cores to run at 100 %! Use the included Uninstaller prior to upgrading to get rid of it!
> 2. Don't use Intel Power Gadget on 11th Gen Intel and newer CPUs.

## CREDITS
- Acidanthera for CPUFriend
- CorpNewt for CPUFriendFriend
- Intel for Intel power Gadget
