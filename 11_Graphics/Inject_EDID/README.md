# Injecting `EDID` to fix display issues

## About `EDID`
EDID stands for **Extended Display Identification Data**. It's a 128 byte value which describes a displays properties and features. It can be utilized as a last resort measure to fix display issues in macOS if all other attempts of fixing the issue (modifying the Framebuffer, using Whatevergreen boot arguments, etc.) fail.

### Possible applications

- Fixing Black Screen on Wake
- Fixing 8 Apples Glitch
- Issues when a second Monitor is connected

## Patching Principle
- Dump EDID
- Open/modify EDID
- Export EDID
- Get EDID Hex Value
- Inject it via `DeviceProperties`

## Instructions

### Obtaining EDID dump
- Download and unzip [**DarwinDumper**](https://bitbucket.org/blackosx/darwindumper/downloads/)
- Run the App
- In "Save Path", select a path like "Documents"
- Click on "Deselect All Sumps"
- Select "EDID":</br>![](/Users/5t33z0/Desktop/EDID_01.png)
- Click on "Run"
- Once the process is completed, a Finder Window will open and show the dumped files:</br>:![](/Users/5t33z0/Desktop/EDID_02.png)

### Extracting the EDID value from `EDID.bin`
- Download [**FixEDID**](https://github.com/andyvand/FixEDID) (click on "Code" and select "Download ZIP")
- Unzip the file
- Run the FixEDID App (It's located under `FixEDID-master/Release_10.7 and +`)
- Click on "Open EDID binary file":</br>![](/Users/5t33z0/Desktop/EDID_03.png)
- Navigate to the dumped `EDID.bin` file and open it
- Select "Apple iMac Retina Display (16:9)" if your display supports HD and High DPI, otherwise use whatever is appropriate for your display.
- Optional: click on "Add/Fix the monitor ranges" (if your EDID doesn't have them or they are bad)
- Optional: add scaled resolutions by entering the resolution and clicking add. For adding them to the list click the "Add Resolution" button.
- Finally, click on "Make":</br>![](/Users/5t33z0/Desktop/EDID_05.png)
- This will output 3 files on the desktop:
	- A modified `EDID.bin`
	- `DisplayMergeNub.kext`
	- `DisplayVendorID-XXX` folder, containing a display override file (without extension)
- Enter the `DisplayVendorID-XXX`
- Open the `DisplayProductID-…` file with a Plist Editor like ProperTree
- Copy the value under `IODisplayEDID` to the clipboard:</br>![](/Users/5t33z0/Desktop/EDID_06.png)

### Adding the `EDID` to `config.plist`
- Open your `config.plist`
- Go to `DeviceProperties/Add` 
- Locate the Framebuffer Patch for your iGPU: `PciRoot(0x0)/Pci(0x2,0x0)`
- Add Key `AAPL00,override-no-connect`, Type: `Data`
- Press CMD+V to enter the EDID as hex in the `Value` field:</br>![](/Users/5t33z0/Desktop/EDID_07.png)
- Save your `config.plist` and reboot
- Verify that the EDID has been applied. Open Terminal and enter:</br> `ioreg -lw0 | grep -i "IODisplayEDID" | sed -e 's/.*<//' -e 's/>//'`. The output should be identical to the value in your config.

Hopefully this will resolve the issue!
 
**NOTE**: If you added additional resolutions, you need to install either the display override in `/System/Library/Displays/Overrides` or install `DisplayMergeNub.kext` in `/System/Library/Extensions`.

## Credits
- Acidanthera for OpenCore and Whatevergreen
- Blackosx for DarwinDumper
- andyvand for FixEDID
- Daliansky for [original guide](https://blog-daliansky-net.translate.goog/Use-HIDPI-to-solve-sleep-wake-up-black-screen,-Huaping-and-connect-the-external-monitor-the-correct-posture.html?_x_tr_sl=auto&_x_tr_tl=en&_x_tr_hl=de&_x_tr_pto=wapp)
