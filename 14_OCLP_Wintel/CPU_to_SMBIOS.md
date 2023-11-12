# CPU Family to SMBIOS Conversion

Listed below are all the Intel-based Mac models supported by OpenCore Legacy Patcher (plus additional SMBIOSes for 8th to 10 Gen) grouped by CPU Family. This should make it easier to research which settings, kexts and patches can be carried over to Wintel configs.

CPU Family | Mac Model / SMBIOS | Intel Core <br>Gen.
:---------:|--------------------|:-------------------:
**Harpertown** | <ul><li>MacPro3,1 <li> Xserve2,1 | 1st
**Blomfield**, <br> **Nehalem EP** | <ul><li>MacPro4,1 <li>Xserve3,1 | 1st
**Bloomfield**, <br>**Westmere EP** | <ul><li>MacPro5,1 | 1st
**Merom** | <ul><li> iMac7,1 | 1st
**Penryn** | <ul><li>MacBook5,x <li>MacBook6,1 <li>MacBook7,1 <li> MacBookAir2,1 <li>MacBookAir3,x <li> MacBookPro4,1 <li> MacBookPro5,x <li> MacBookPro7,x <li> Macmini3,1 <li> Macmini4,1 <li> iMac8,1 <li> iMac9,1 | 1st
**Wolfdale** | <ul><li> iMac10,1 | 1st
**Arrandale** | <ul><li> MacBookPro6,x <li>iMac11,x |1st
**Sandy Bridge** | <ul><li>MacBookAir4,x <li> MacBookPro8,x <li> Macmini5,x <li> iMac12,x | 2nd
**Ivy Bridge**   | <ul><li>MacBookAir5,x <li>MacBookPro9,x <li> MacBookPro10,x <li> Macmini6,x <li> iMac13,x | 3rd
**Ivy Bridge EP** | <ul><li> MacPro6,1 | 3rd
**Haswell** | <ul><li>MacBookAir6,x <li> MacBookPro11,x <li> Macmini7,1 <li>iMac14,x <li>iMac15,1 | 4th
**Broadwell** | <ul><li>MacBook8,1 <li>MacBookAir7,x <li>MacBookPro12,x <li> iMac16,x | 5th
**Skylake**      | <ul><li>MacBook9,1 <li>MacBookPro13,x <li> iMac17,1 | 6th
**Kaby Lake**    | <ul><li>MacBook10,1 <li>MacBookPro14,x <li> iMac18,x | 7th
**Coffee Lake**,<br> **Whiskey Lake**  | <ul><li>MacBookPro15,x <li>MacBookPro16,1 <li> Macmini8,1<li> iMac19,x | 8th/9th
**Comet Lake**, <br> **Ice Lake** |  <ul><li> iMac20,x <li> MacBookPro16,2 | 10th

## Usage example
Backup your existing EFI folder on a FAT32 formatted USB flash drive before fiddling with OCLP!

- Check which Intel CPU you have and which CPU Family it belongs to
- Find the SMBIOS best suited for your CPU and system from the table above
- Run OCLP and click on "Settings"
- From the "Target" dropdown menu, select the SMBIOS of your choice, the click "Return"
- Back in the main window, select "Build and Install OpenCore" 
- This will generate the EFI for the selected Mac model in a temporary location
- Once that's done, there will be a Pop-up:<br> ![EFI_build](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/71b8579b-924e-4697-addc-06bd88242e21)
- :warning: **DON'T click on "Install to Disk"!** This will replace your EFI folder by the one for the corresponding Mac model!
- Instead, click on "View Build Log" 
- Copy the path to the EFI listed at the end of the log
- Bring up Finder 
- Press CMD+SHIFT+G, paste the address and hit Enter
- Copy the build folder to the desktop because it will be deleted once you quit OCLP
- Check the EFI folder and config for settings and required kexts missing from your config. Cross-reference with [existing config guides](https://github.com/5T33Z0/OC-Little-Translated/tree/main/14_OCLP_Wintel#configuration-guides) and adjust your EFI accordingly
- Try installing/booting macOS Sonoma with your adjusted EFI and config.
