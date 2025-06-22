# Injecting `EDID` to fix display issues

## About `EDID`
EDID stands for **Extended Display Identification Data**. It's a 128 byte value which describes a displays properties and features. It can be utilized as a last resort measure to fix display issues in macOS if all other attempts of fixing the issue (modifying the Framebuffer, using Whatevergreen boot arguments, etc.) fail.

### Possible applications

- Fixing Black Screen on Wake
- Fixing 8 Apples Glitch and scrambled screen
- Issues when a second Monitor is connected
- Unlocking additional resolutions and refresh rates

## Patching Principle
- Dump EDID
- Open/modify EDID
- Export EDID
- Get EDID Hex Value
- Inject it via `DeviceProperties`

## Instructions

### Getting the tools

- Download the [tools](https://github.com/5T33Z0/OC-Little-Translated/raw/refs/heads/main/11_Graphics/Inject_EDID/Tools_backup.7z) and extract them
- It contains 2 apps: DarwinDumper and FixEDID
- Continue with the guide

### Obtaining EDID dump
- Run DarwinDumper
- In "Save Path", select a path like "Documents"
- Click on "Deselect All Dumps"
- Select "EDID":</br>![EDID_01](https://user-images.githubusercontent.com/76865553/184684084-f64b2f07-fa05-4718-9ee9-cec5940d355c.png)
- Click on "Run"
- Once the process is completed, a Finder Window will open and show the dumped files:</br>:![EDID_02](https://user-images.githubusercontent.com/76865553/184684157-5c54c023-15e7-411b-a8f8-154a94676a5f.png)

### Extracting the EDID value from `EDID.bin`
- Run **FixEDID** App
- Click on "Open EDID binary file":</br>![EDID_03](https://user-images.githubusercontent.com/76865553/184684202-9aa99568-a179-42d4-8672-38448990948d.png)
- Navigate to the dumped `EDID.bin` file and open it
- Select "Apple iMac Retina Display (16:9)" if your display supports HD and High DPI, otherwise use whatever is appropriate for your display.
- Optional: click on "Add/Fix the monitor ranges" (if your EDID doesn't have them or they are bad)
- Optional: add scaled resolutions by entering the resolution and clicking add. For adding them to the list click the "Add Resolution" button.
- Finally, click on "Make":</br>![EDID_05](https://user-images.githubusercontent.com/76865553/184684286-e531b425-664e-4d4e-b99a-a0abe61c32d7.png)
- This will output 3 files on the desktop:
	- A modified `EDID.bin`
	- `DisplayMergeNub.kext`
	- `DisplayVendorID-XXX` folder, containing a display override file (without extension)
- Enter the `DisplayVendorID-XXX` folder
- Open the `DisplayProductID-…` file with a Plist Editor like ProperTree
- Copy the value under `IODisplayEDID` to the clipboard:</br>![EDID_06](https://user-images.githubusercontent.com/76865553/184684366-b1e575ee-6727-4fe8-88b5-4a6632b1f630.png)

### Adding the `EDID` to `config.plist`
- Open your `config.plist`
- Go to `DeviceProperties/Add` 
- Locate the Framebuffer Patch for your iGPU in `DeviceProperties`: `PciRoot(0x0)/Pci(0x2,0x0)`
- Add Key `AAPL00,override-no-connect`, Type: `Data`
- Press CMD+V to enter the EDID as hex in the `Value` field:</br>![EDID_07](https://user-images.githubusercontent.com/76865553/184684433-a53ba979-a0e1-4e91-b95b-4a0411f8e3ae.png)
- Save your `config.plist` and reboot
- Verify that the EDID has been applied. Open Terminal and enter:</br> `ioreg -lw0 | grep -i "IODisplayEDID" | sed -e 's/.*<//' -e 's/>//'`
- The output should be identical to the value in your config.

Hopefully this will resolve the issue!
 
> [!IMPORTANT]
> 
> If you added additional/custom resolutions, you also need to copy the `DisplayVendorID-XXX` folder containing the display override to `/System/Library/Displays/Overrides` or install the `DisplayMergeNub.kext` in `/System/Library/Extensions`. Since `S/L/E` is write-protected in macOS 10.15 and newer by default, doing this is not recommended.

## Example

- Default resolutions for my laptop's display (before injecting EDID):<br>![noEDID](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/80291495-8685-4dc9-935e-dd77ad24ed8b)
- After injecting EDID (with "Add/Fix the monitor ranges" option enabled):<br> ![WithEDID](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/5cb29091-0a4e-4ae6-b986-92d00cb794ee)

> [!NOTE]
>
> Injecting the EDID only makes sense, if you need a specific resolution and/or display refresh rate (higher or lower) that is supported by the display panel but is not available in the display settings menu!

# Alternatives for fixing black screen issues
If the above method doesn't work to fix black screen issues after wake, try [**`HibernationFixup.kext`**](https://github.com/acidanthera/HibernationFixup) in combination with boot-arg `-hbfx-disable-patch-pci` instead.

## Credits and Resources
- Acidanthera for OpenCore, Whatevergreen and HibernationFixup
- Blackosx for [**DarwinDumper**](https://bitbucket.org/blackosx/darwindumper/downloads/)
- andyvand for [**FixEDID**](https://github.com/andyvand/FixEDID)
- Daliansky for [**original guide**](https://blog-daliansky-net.translate.goog/Use-HIDPI-to-solve-sleep-wake-up-black-screen,-Huaping-and-connect-the-external-monitor-the-correct-posture.html?_x_tr_sl=auto&_x_tr_tl=en&_x_tr_hl=de&_x_tr_pto=wapp)
- For fixing purple/magenta screen issues, try [this fix](https://github.com/dreamwhite/patch_edid)

