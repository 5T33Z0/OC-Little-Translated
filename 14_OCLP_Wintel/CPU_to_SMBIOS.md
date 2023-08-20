# CPU Family to SMBIOS Conversion

Listed below are all the Mac models supported by OpenCore Legacy Patcher, grouped by CPU Family. This should make it easier to research which settings, kexts and patches can be carried over to Wintel configs.

CPU Family | Mac Model / SMBIOS   
:---------:|-------------------
**Harpertown** | <ul><li>MacPro3,1 <li> Xserve2,1
**Blomfield**, <br> **Nehalem EP** | <ul><li>MacPro4,1 <li>Xserve3,1
**Bloomfield**, <br>**Westmere EP** | MacPro5,1
**Merom** | iMac7,1
**Penryn** | <ul><li>MacBook5,x <li>MacBook6,1 <li>MacBook7,1 <li> MacBookAir2,1 <li>MacBookAir3,x <li> MacBookPro4,1 <li> MacBookPro5,x <li> MacBookPro7,x <li> Macmini3,1 <li> Macmini4,1 <li> iMac8,1 <li> iMac9,1
**Wolfdale** | iMac10,1
**Arrandale** | <ul><li> MacBookPro6,x <li>iMac11,x
**Sandy Bridge** | <ul><li>MacBookAir4,x <li> MacBookPro8,x <li> Macmini5,x <li> iMac12,x
**Ivy Bridge**   | <ul><li>MacBookAir5,x <li>MacBookPro9,x <li> MacBookPro10,x <li> Macmini6,x <li> iMac13,x
**Ivy Bridge EP** | MacPro6,1  
**Haswell** | <ul><li>MacBookAir6,x <li> MacBookPro11,x <li> Macmini7,1 <li>iMac14,x <li>iMac15,1
**Broadwell**    | <ul><li>MacBook8,1 <li>MacBookAir7,x <li>MacBookPro12,x <li> iMac16,x
**Skylake**      | <ul><li>MacBook9,1 <li>MacBookPro13,x <li> iMac17,1  
**Kaby Lake**    | <ul><li>MacBook10,1 <li>MacBookPro14,x <iMac18,x>

## Usage example

- Check which Intel CPU you have and which CPU Family it belongs to
- Then check which SMBIOS is best suited for your system in the table
- Run OCLP and click on "Settings"
- Select the SMBIOS of choice from the "Target" dropdown menu and click on the "Return" button
- Back in the main window, click on "Build and Install OpenCore" 
- This will generate the EFI in a temporary location
- Once that's finished, there will be a Pop-up:<br> ![EFI_build](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/71b8579b-924e-4697-addc-06bd88242e21)
- :warning: **DON'T click on "Install to Disk"!** This will replace your EFI folder by the one for the corresponding Mac model!
- Instead, click on "View Build Log" 
- Copy the path to the EFI listed at the end of the log
- Bring up Finder 
- Press CMD+SHIFT+G, paste the address and hit Enter
- Copy the build folder to the desktop because it will be deleted once you quit OCLP
- Check the EFI folder and config for clues
