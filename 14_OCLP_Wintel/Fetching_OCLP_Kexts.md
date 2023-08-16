# Fetching kext upates from OpenCore Legacy Patcher with OCAT automatically

## About
As you may or my not know, you can add kexts to check for updates in OpenCore Auxiliary Tools. Usually, you do this in the app: just add the name of the kext and the corresponding repo URL to OCAT's "Kext Upgrade URL" list accessible from the "Sync" window and the next time you check for kext it can fetch it. If it doesn't know a kext's URL it's marked grey.

But adding every single kext from OpenCore Legacy Patcher's Repo to OCAT can feth it is quite a pain. So instead of adding the kexts via the app, we can edit the textfile that contains the URLs directly and just paste in the list of kexts that don't have their own repo. 
## Adding kext URLs in batch 

1. Go to your Home Folder
2. Press <kbd>CMD</kbd> + <kbd>.</kbd> (dot) to show hidden files and folders
3. Navigate to:
	- `/.ocat/Database/preset/KextUrl.txt` (if OCAT is running in regular Release Mode)
4. Open it with TextEdit
5. Add the following Lines to the list and save it:
	```
	AMFIPass.kext | https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera
	AutoPkgInstaller.kext | https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera
	CSLVFixup.kext | https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera
	RSRHelper.kext | https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera
	AppleEthernetAbuantiaAqtion.kext | https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Ethernet
	AppleIntel8254XEthernet.kext | https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Ethernet
	CatalinaBCM5701Ethernet.kext | https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Ethernet
	CatalinaIntelI210Ethernet.kext | https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Ethernet
	Intel82574L.kext | https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Ethernet
	MarvelYukonEthernet.kext | https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Ethernet
	nForceEthernet.kext | https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Ethernet
	IOFireWireFamily.kext | https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/FireWire
	IOFireWireSBP2.kext | https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/FireWire
	IOFireWireSerialBusProtocolTransport.kext | https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/FireWire
	IO80211ElCap.kext | https://github.com/dortania/OpenCore-Legacy-Patcher/tree/sonoma-development/payloads/Kexts/Wifi
	IO80211FamilyLegacy.kext | https://github.com/dortania/OpenCore-Legacy-Patcher/tree/sonoma-development/payloads/Kexts/Wifi
	IOSkywalkFamily.kext https://github.com/dortania/OpenCore-Legacy-Patcher/tree/sonoma-development/payloads/Kexts/Wifi
	corecaptureElCap.kext | https://github.com/dortania/OpenCore-Legacy-Patcher/tree/sonoma-development/payloads/Kexts/Wifi
	```
6. Save the file
7. Press <kbd>CMD</kbd> + <kbd>.</kbd> (dot) to show hide files and folders again
8. Run OCAT and check for kext Updates 

## Notes
- Fetching kext updates might not work when using OCAT in DEV mode. I can't find the location of `KextUrl.txt` in the `DevDatabase`.
- I only included kexts from the following categories: "Acidanthera", "Ethernet", "Firewire" and "Wifi". Omitted are: kexts already present in OCAT as well as Mac-specific ones ("Misc", "SSE", "USB"). 
- Currently, the kexts required for re-enabling Wi-Fi in macOS Sonoma are hosted on an extra branch called "Sonoma-Development". Once these are merged into the "Main" branch the URLs need to be adjusted.
