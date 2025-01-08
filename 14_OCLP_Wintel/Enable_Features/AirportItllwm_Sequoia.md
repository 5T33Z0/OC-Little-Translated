# Using `AirportItlwm.kext` in macOS Sequoia

![intel_spoof07](https://github.com/user-attachments/assets/255406e1-554e-4b6c-9b67-5d24b9fcb962)

## About

As you may know, Apple removed support for various system kexts and frameworks required by Broadcom WiFi cards from macOS Sequoia. Although Apple never shipped any systems with Intel WiFi/BT cards, `AirportItlwm.kext` also requires these system kexts and frameworks to function properly. So in macOS Sequoia, users with Intel WiFi/BT cards had to resort to the `Itlwm.kext` instead. 

Since `Itlwm.kext` injects the WiFi card as LAN adapter into macOS, this has some side-effects. For example, the Airport-Utility which lets you connect to WiFi hotspot can no longer be used – a separate app (`Heliport`) has to be used to join WiFi APs. Another issue is that FindMyMac also requires WiFi.

Luckily for use, we can utilize OpenCore Legacy patcher to make use of `AirportItlwm` in Sequoia again!

## Patching principle

1. Inject the Intel WiFi card as a legacy 4360 Broadcom card via `DeviceProperties` &rarr; This will allow "Modern WiFi" patches in OCLP 
2. Inject the required kexts for re-enabling legacy WiFi cards
3. Apply root patches
4. Disable the WiFi spoof again
5. Reboot to macOS Sequoia, voila, `AirportItlwm.kext` working again 

## Instructions

We need to prepare the `config.plist` and EFI folder content to make `AirportItlwm.kext` work again! You can either follow the instructions below, or [copy the settings from this plist](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/plist/AirportItlwm_Sequoia.plist) ⚠️ Make sure to adjust the PCI path of the WiFi card so that it matches the path to the WiFi card in your system!

### 1. Spoof Intel WiFi as a Broadcom card

In your `config.plist`, create an entry for a Broadcom BCM4360 device in `DeviceProperties`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>DeviceProperties</key>
	<dict>
		<key>Add</key>
		<dict>
			<key>#PciRoot(0x0)/Pci(0x1C,0x1)/Pci(0x0,0x0)</key>
			<dict>
				<key>IOName</key>
				<string>pci14e4,43a0</string>
				<key>compatible</key>
				<string>pci106b,117</string>
				<key>device-id</key>
				<data>oEMAAA==</data>
				<key>device_type</key>
				<string>Network controller</string>
				<key>model</key>
				<string>BCM4360 802.11 ac Wireless Network Adapter</string>
				<key>name</key>
				<string>pci14e4,43a0</string>
				<key>pci-aspm-default</key>
				<integer>0</integer>
				<key>subsystem-id</key>
				<data>FwEAAA==</data>
				<key>subsystem-vendor-id</key>
				<data>axAAAA==</data>
				<key>vendor-id</key>
				<data>5BQAAA==</data>
			</dict>
		</dict>
	</dict>
</dict>
</plist>
```
**Screenshot**:<br> ![devpropss](https://github.com/user-attachments/assets/ffd6c5b7-91ba-4510-a676-f31c3e8ab576)

- Get the correct PCI device path for *your* Intel WiFi card. 
- You can do this with Hackintool. Just find the entry for the Wireless Network Controler, right-click and select "Copy Device Path":<br>![intel_spoof01](https://github.com/user-attachments/assets/44f21ce0-63ca-45f4-b15c-55cbe3c98a1d)
- Adjust the PCI path to match *your* system:<br>![intel_spoof02](https://github.com/user-attachments/assets/a9b88f3c-7bdf-4de9-9a7e-10c163203dfb)
 
## 2. Block new `IOSkywalk` kext

Under `Kernel/Block`, add the following rule:

```xml
<dict>
	<key>Arch</key>
	<string>x86_64</string>
	<key>Comment</key>
	<string>Allow IOSkywalk Downgrade</string>
	<key>Enabled</key>
	<true/>
	<key>Identifier</key>
	<string>com.apple.iokit.IOSkywalkFamily</string>
	<key>MaxKernel</key>
	<string></string>
	<key>MinKernel</key>
	<string>24.0.0</string>
	<key>Strategy</key>
	<string>Exclude</string>
</dict>
```

**Screenshot**:<br> ![intel_spoof08](https://github.com/user-attachments/assets/0d5a08a1-035c-4079-8128-a8e5435bec59)

## 3. Add Kexts
- Disable `Itlwm.kext`, if present!
- Add the following [**Kexts from the OCLP repo**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Wifi) to `EFI/OC/Kexts` and your `config.plist`:
	- [`AMFIPasss.kext`](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera) 
	- `IOSkywalk.kext`
	- `IO8021FamilyLegacy.kext` (contains an additional kext as plugin)
	- [**`AirportItlwm.kext`**](https://github.com/OpenIntelWireless/itlwm/releases) (inject the one for macOS Ventura! I have renamed it to `AirportItlwm_Sequoia.kext` since I also have macOS Sonoma installed and it requires a different variant of the kext). ⚠️ Make sure it is injected ***after*** `IOSkywalk` and `IO8021FamilyLegacy` kexts!
- Adjust MinKernel and MaxKernel Settings as shown in the **Screenshot**: <br>![intel_spoof03](https://github.com/user-attachments/assets/f5edc4f2-cb0b-4124-a16b-860ccd87c48f)

## 4. Disable `SecureBootModel`

Under `Misc`, change `SecureBootModel` to `Disabled`

## 5. NVRAM Entries (optional)
- Change `csr-active-config` to `08030000`
- Enable `-lilubetaall` boot.arg if WiFi/BT is not working in macOS Sequoia
- If Bluetooth stops working after root patching, add the following entries to the NVRAM section:

```xml
<key>7C436110-AB2A-4BBB-A880-FE41995C9F82</key>
<dict>
	<key>bluetoothExternalDongleFailed</key>
	<data>AA==</data>
	<key>bluetoothInternalControllerInfo</key>
	<data>AAAAAAAAAAAAAAAAAAA=</data>
	<key>boot-args</key>
	<string>-lilubetaall</string>
	<key>csr-active-config</key>
	<data>AwgAAA==</data>
</dict>
```
**Screenshot**:<br>![nvram](https://github.com/user-attachments/assets/b322597d-98d0-4961-81d3-19ec8ecb9bf9)

- Save your `config.plist`

## 6. Download OCLP
- Since you won't have internet Access in macOS Sequoia, [download the latest release of OCLP](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) before rebooting into macOS
- Now reboot into macOS Sequoia

## 7. Apply root patches with OCLP

- Run OCLP
- Click on "Apply Root Patch" button
- "Networking: Modern WiFi" should be available:<br>![intel_spoof05](https://github.com/user-attachments/assets/8b072d05-93f5-4151-b6e1-1d8e0c6c555e)
- Click "Start Root Patching"
- It will install the necessary Frameworks required for `AirportItlwm` to work:<br> ![intel_spoof06](https://github.com/user-attachments/assets/ced653f7-0807-4aef-82cb-eabf35b08884)

## 8. Disable spoofed Broadcom card

- Once root patching is completed successfully, disable the `DeviceProperty` for the fake `Bcm 4360` card by putting a `#` in front of it!

## 9. Reboot and enjoy!

- Reboot the system
- Perform an NVRAM reset
- Boot into macOS Sequoia
- You should now be able to use the Airport-Utility in macOS Sequoia again, to connect to WiFi APs

> [!IMPORTANT]
> 
> Once root patches are applied, the security seal of the volume will be broken. And once it is broken, the complete macOS version will be downloaded every timan an OS update is available. The workaround would be to revert root patches before installing updates – but then you won't have WiFi (unless you enable `itlwm` beforehand).

## Credits and Thank Yous

- lifeknife10A who came up with this [workaround](https://github.com/OpenIntelWireless/itlwm/issues/1009#issuecomment-2370919270)
- sughero, for additional info about the order of the kexts
- stefanalmare for pointing me to this solution
