# USB port mapping via ACPI (macOS 11.3+)
>**DISCLAIMER**: I am not a programmer. Therefore, my knowledge of ACPI and ASL is rather limited. Although I try my best to communicate the required changes necessary to make USB work with macOS, I cannot guarantee that it works for everybody – and I cannot and will nor fix your SSDTs!

## Background
Since macOS Big Sur 11.3, the `XHCIPortLimit` Quirk which lifts the USB port count limit from 15 to 26 ports per controller on Apple USB kexts no longer works. This complicates the process of creating a `USBPorts.kext` with Tools like `Hackintool` or `USBMap` (besides the fact that these tools don't work for AMD chipsets). So the best way to declare USB ports is via ACPI since this method is OS-agnostic (unlike USBPort kexts, which by default only work for the SMBIOS they were defined for).

## Approach
In order to build our own USB Port map as SSDT, we will do the following:

- Dumping the original ACPI tables from BIOS
- Find the SSDT which declares USB ports
- Modify it so 15 ports are mapped for macOS without affecting other OSes
- Inject this table during boot, replacing the original one

The method presented here is a slightly modified version of a guide by "Apfelnico" and "N0b0dy" of the [**German Hackintosh Forum**](https://www.hackintosh-forum.de/forum/thread/54986-usb-mittels-ssdt-deklarieren/?postID=721415) which I used to create my own `SSDT-PORTS.aml`. I just translated and transformed it into this step by step guide. 

I broke it down in smaller sections so you won't be overwhelmed by a seemingly endless document. Open the collapsed sections to reveal their contents.

## Preparations

### Required Tools
- [**Clover Bootmanager**](https://github.com/CloverHackyColor/CloverBootloader/releases) for dumping your System's ACPI tables.
- [**maciASL**](https://github.com/acidanthera/MaciASL) or [**QtiASL**](https://github.com/ic005k/QtiASL) for editing `.aml` files.
- [**IOResgistryExplorer**](https://github.com/utopia-team/IORegistryExplorer/releases) for gathering infos about I/O on macOS. Used for probing USB Ports.
- [**OpenCore Auxiliary Tools**](https://github.com/ic005k/QtOpenCoreConfig) or a Plist Editor for editing the `config.plist`.
- [**Example Files**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/13_Mapping_USB_in_ACPI/Example_Files) (for following along)
- FAT32 formatted USB 3.0 flash drive (USB 3.0) for dumping ACPI tables and probing ports.
- USB 2.0 Flash Drive (optional, also for probing Ports).
- Your mainboard manual with a schematic listing all its ports and USB headers
- Spreadsheet for taking notes about Port names, Types and physical Location (optional)
- Patience and time (mandatory). Seriously, this is not for beginners! 

### Dumping ACPI Tables
There are various ways to dump ACPI Tables from your BIOS: 

- Using **Clover** (easiest method): Hit `F4` in the Boot Menu. You don't even need a working configuration to do this. Just download the latest [**Release**](https://github.com/CloverHackyColor/CloverBootloader/releases) as a `.zip` file, extract it, put it on a FAT32 formatted USB flash drive and boot from it. The dumped ACPI Tables will be located in: `EFI\CLOVER\ACPI\origin`
- Using **OpenCore** (requires the Debug version and a working config): enable Misc > Debug > `SysReport` Quirk. The ACPI Tables will be dumped during next boot.

## Finding the correct table
Have a look inside the "origin" Folder. In there you will find a lot of tables. We are interested in the **SSDT-xxxx.aml** files. Find the one which looks similar to this:

![SSDT_og](https://user-images.githubusercontent.com/76865553/137520366-c3c75933-ab97-4d60-b627-cc4673e4b643.png)

We can see the following:

- There are entries for `XHC` (eXtensible Host Controller) and for `XHC.RHUB` (USB Root Hub Device)
- There's should also be a list of Ports, 26 in my case: `HS01` to `HS14`, `USR1` and `USR2`, and `SS01` to `SS10`. We will come back to the meaning of these names later. 
- Take note of the "Table Signature" and the "OEM Table ID" – we will use them to create a delete rule in the OpenCore config.

**NOTE**: Just because this SSDT includes 26 port entries, it doesn't meant that they are all connected to physical devices on the mainboard. Look at it more as a template used by Devs.

### Adding a delete rule to config.plist
In order to delete (or drop) the original table during boot and replace it with our own, we need to tell OpenCore to look for the Signature ("SSDT") and the OEM Table ID (in my case "xh_cmsd4") to drop.</br>
**CAUTION**: Don't use my value for the OEM Table ID, since yours probably has a different name!

1. Open your `config.plist` (I am using OpenCore Auxiliary Tools)
2. Go to ACPI > Delete and add a new Rule (click on "+")
3. In `TableSignature`, enter `53534454` which is HEX for `SSDT`:
	![TableSig](https://user-images.githubusercontent.com/76865553/137520564-10b44f45-778b-47ad-a3ae-318ce9334aac.png)
4. In `OemTableID`, enter the name of the "OEM Table ID" (See first screenshot) stored in YOUR (NOT mine, YOUR!) SSDT-Whatever.aml without `""` as a HEX value. In OCAT, you can use ASCI to Hex converter at the bottom of the app:
	![OEMTableID](https://user-images.githubusercontent.com/76865553/137520641-97a42e24-175b-4e3a-badb-23b57fa31ac8.png)
5. Enable the rule and a comment so you know what it does.
6. Save the config.

You should have the correct rule for replacing the ACPI Table containing the USB Port declarations. Let's move on to the hard part…

## Preparing a replacement SSDT
Now that we have found the SSDT with the original usb port declarations, we can start modifying them. Almost. We still need more details, though…

### Modifying the orginal USB Table
In general, two methods are relevant for declaring USB ports:
 
1. `_UPC` ([**USB Port Capabilities**](https://uefi.org/specs/ACPI/6.4/09_ACPI-Defined_Devices_and_Device-Specific_Objects/ACPIdefined_Devices_and_DeviceSpecificObjects.html#upc-usb-port-capabilities)): defines the type of port and it's state (enabled/disabled)
2. `_PLD` ([**Physical Location of Device**](https://uefi.org/specs/ACPI/6.4/06_Device_Configuration/Device_Configuration.html#pld-physical-location-of-device)): defines the location of the pysical port and its properties. 

Both values are handed over to (`GUPC` and `GPLD`) inside the Root Hub (RHUB).

#### Adding `Arg1` to `GUPC`
First, take a look at the routine `GUPC`inside of the `RHUB` (Root Hub):

![GUPC](https://user-images.githubusercontent.com/76865553/137520755-8406844d-b16a-4f58-8e84-95e5122d5c06.png)
	
In this case, it includes a Package (`PCKG`) with four values that are handed over to every USB port in the method `_UPC`. But as is, we currently only have control over the first value of the package (via `Arg0`), which describes the availability of the port. But we also need control over the 2nd value in the package which declares the USB port type. Therefore, we need to modify the method `GUPC`:

- In the Header, we change the `GUPC, 1,` to `GUPC, 2,` (since we want to control 2 values of this package)
- Next, we add `PCKG [One] = Arg1`, so it hands over the 2nd package value to `_UPC` as well.
- In the Package, we change the first value of to `0xFF` to set the port "enabled" 
- Finally, we set the second package to `0x03`, which changes the port type to USB 2.0 and 3.0 with a Type A connector (the blue connectors).

Now we have control over a port's status (on/off or available/unavailable) and what type it is. We get this code snippet:

```swift
Method (GUPC, 2, Serialized)
{
	Name (PCKG, Package (0x04)
	{
        	0xFF,
        	0x03,
        	Zero, 
    		Zero
   	})
	PCKG [Zero] = Arg0
	PCKG [One] = Arg1
	Return (PCKG) /* \GUPC.PCKG */
}
```
`Arg0`= represents the first value of the package. This sets the prot active (`0xff`) or inactive/disabled (`Zero`)</br>
`Arg1`= declares the USB port type mentioned earlier (`0x00` for USB2, `0x03` for USB, etc.)

#### Deleting existing `_UPC` method
After changing these values, you will get a lot of compiler errors:

![GUPC_errors](https://user-images.githubusercontent.com/76865553/137520833-8f5ae018-aa7e-4e34-8b2f-73f0c8061d1a.png)

That's because the 2nd value (Arg1) is not part of the corresponding method `_UPC` in each of the USB Port entries:

![_UPC_errors](https://user-images.githubusercontent.com/76865553/137520865-0c51e4a2-a905-42f8-8805-f00c3276e98a.png)

To fix this, we will delete the methods `_UPC` from all the Ports. Select the method:

![Highlight](https://user-images.githubusercontent.com/76865553/137520903-86832ac4-e60f-413b-84c5-e23887833897.png)

And hit delete. The method should be gone from the ports

![Deleted](https://user-images.githubusercontent.com/76865553/137521280-012baf78-2d94-4be2-ba5e-c0aafc679e3b.png)

Repeat this 23 more times. For `USR1` and `USR2` we can write this to deactivate them, since macOS doesn't support them:

![USR](https://user-images.githubusercontent.com/76865553/137521318-60b2a97f-8e7a-4489-80cb-fa040631a947.png)

Once all `_UPC` Methods are deleted from all the ports are deleted (besides `USR1` and `USR2`), the errors are gone:

![No_errors](https://user-images.githubusercontent.com/76865553/137521582-8b901345-ade2-47eb-9388-321b7cc46df1.png)

#### Adding new `_UPC` method

In each Port (except for USR1 and USR2), add this method:

```swift
Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
	{
		Return (GUPC (0xFF, 0x03))
	}
```
Which looks like this:

![New_UPC](https://user-images.githubusercontent.com/76865553/137521717-b747a017-f9d1-4189-a6cd-0e77a7475d9d.png)

Now we have a USB Port SSDT Template with 24 enabled ports defined as USB 2.0/USB 3.0 Type A. Let's save it as `SSDT-PORTS_start.aml`. But we are not done yet, sorry.

## Mapping the ports (finally)
Next, we need to find out which physical ports actually map to which ports in the system.

### How USB is structured in ACPI
When it comes to USB, there is a Root Hub (RHUB) which defines ports. But a port can also function as Hub itself (Integrated Hub), as you can see in this illustration:

![](https://uefi.org/specs/ACPI/6.4/_images/ACPIdefined_Devices_and_DeviceSpecificObjects-5.png)

This is an example of port characteristics object implemented for a USB host controller’s root hub where:

- Three Ports are implemented; Port 1 is not user visible/not connectable and Ports 2 and 3 are user visible and connectable.
- Port 2 is located on the back panel
- Port 3 has an integrated 2 port hub. Note that because this port hosts an integrated hub, it is therefore not sharable with another host controller (e.g. If the integrated hub is a USB2.0 hub, the port can never be shared with a USB1.1 companion controller). The ports available through the embedded hub are located on the front panel and are adjacent to one another.

**SOURCE**: [UEFI.org](https://uefi.org/specs/ACPI/6.4/09_ACPI-Defined_Devices_and_Device-Specific_Objects/ACPIdefined_Devices_and_DeviceSpecificObjects.html#upc-usb-port-capabilities)

### USB Port Types
According to the ACPI Specifications about [USB Port Capabilities](https://uefi.org/specs/ACPI/6.4/09_ACPI-Defined_Devices_and_Device-Specific_Objects/ACPIdefined_Devices_and_DeviceSpecificObjects.html#upc-return-package-values), the USB Types are declared by different bytes. Here are some common ones found on current mainboards:

| Type   | Info                           | Comment |
|:------:|--------------------------------|---------|
|**0x00**| Type-A connector, USB 2.0 only | This is what macOS will default all ports to when no map is present. The physical connector is usually colored black|
|**0x03**| Type-A connector, USB 2.0 and USB 3.0 combined | USB 3.0, 3.1 and 3.2 ports share the same Type. Usually colored blue (USB 2.0/3.0) or red (USB 3.2)|
|**0x08**| Type C connector, USB 2.0 only | Mainly used in phones|
|**0x09**| Type C connector, USB 2.0 and USB 3.0 with Switch | Flipping the device does not change the ACPI port |
|**0x0A**| Type C connector, USB 2.0 and USB 3.0 w/o Switch |Flipping the device does change the ACPI port. generally seen on USB 3.1/3.2 mainboard headers|
|**0xFF**| Proprietary Connector | For Internal USB 2.0 ports like Bluetooth|

We will use these "Type" bytes to declare the USB Port types.

### USB Port Names
As seen earlier, the ports listed in the SSDT have different names.

| Name          | Description            | Protocol          | Speed            |
|:-------------:|------------------------|:------------------|-----------------:|
| **HS01…HS14** | HS = High Speed Ports  | USB 2.0 only      | 480 mbit/s       |
| **SS01…SS10** | SS = Super Speed Ports | USB 3.0, 3.1, 3.2 | 5 to 20 Gbit/s   |
| **USR1/2**    | Not supported by macOS. Deactivate them.   | Intel AMT        | 

**IMPORTANT**: A physical USB 3.0 Connector (the blue one, you know?!) actually connects to 2 USB Ports: one for USB 2.0 and one for USB 3.0. So having 15 Ports available for mapping doesn't mean that you can assign them to 15 physical connectors. Actually, you can only assign them to 7 USB 3.x and 1 USB 2.0-only connectors.

**EXAMPLE**: if you plug in a USB 3.0 flash drive, you can see in IORestryExplorer, that it connects to `SS07` for example. If you take it out and put a USB 2.0 drive in the same connector, it will most likely be connected to `HS07` now. So 1 Connector, 2 Ports with the same counter (usually) – in this example HS07 and SS07.

### Port mapping Options
At this stage, there are two options for mapping your USB ports.

- Option A: you already know which ports connect to which physical connectors.
- Option B: you don't know which Ports connect to which physical connector so you need to probe them

#### Option A: Mapping ports based on a known configuration
This is for people who already created a USBPorts.kext in Hackintool or similar and still have the mapping. In my case, I have a Spreadsheet, which looks like this:

![Ports_List](https://user-images.githubusercontent.com/76865553/137521950-e354ec4f-aa9c-4a4e-a146-7d9204387c80.png)
	
As you can see, `HS01` is not used in my case, so we deactivate it. But to keep compatibility with other Operating Systems, we turn it off for macOS only. To achieve this, we use a conditional rule with an "if/else" statement, the method `_OSI` (Operating System Interfaces): `If (_OSI ("Darwin"))`. It tells the system: "If the Darwin Kernel (aka macOS) is loaded, `HS01` does not exist, everybody else can have it". This is a super elegant and non-invasive way of declaring USB Ports without messing up the port mapping for other OSes. This is the code snippet (adjust the scope accordingly):

![IFOSI](https://user-images.githubusercontent.com/76865553/137521985-96a3620d-b6b3-40ee-b554-ce86078b05d7.png)

This is the Code snippet. As you can see, it is applies to `_UPC` and `_PLD` in this case

```swift
Scope (\_SB.PCI0.XHC.RHUB.HS01)
{
	Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
	{
		If (_OSI ("Darwin"))
		{	
			Return (GUPC (Zero, Zero)) // ZERO = Port unavailable
		}
     		Else
		{
			Return (GUPC (0xFF, 0x03))
     		}
 	}
 	Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
   	{
   		If (_OSI ("Darwin"))
   		{
			Return (GPLD (Zero, Zero)) // ZERO = Port unavailable
		}    
		Else
		{
			Return // For `Else`, use whatever is already declared in your ACPI for `GPLD`
  		}
	}   
```
**Example 3**: Port `HS03` deactivated for macOS Only. This utilizes the `If (_OSI ("Darwin"))` switch. This basically tells the system: "If the Darwin Kernel (aka macOS) is running, `HS03` does not exist, everybody else can have it". This is a super elegant and non-invasive way of declaring USB Ports without messing up the port mapping for Windows.

```swift
Scope (HS03)
{
	Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
  	{
   		If (_OSI ("Darwin"))
		{
      			Return (GUPC (Zero, Zero)) // If macOS is running, HS03 doesn't exist, for every other OS it does
		}
		Else
		{
       			Return (GUPC (0xFF, 0x03))
		}
  	}
	Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
	{
		If (_OSI ("Darwin"))
		{
			Return (GPLD (Zero, Zero)) // If macOS is running, HS03 doesn't exist, for every other OS it does
		}
		Else
		{
			Return (GPLD (DerefOf (UHSD [0x02]), 0x03))
		}
	}
}
```

Continue mapping your ports this way: for those which you do use, declare the port type in the packets. For those that you don't use, deactivate them but add an `If (_OSI ("Darwin"))` argument (as shown above). 

**Remember**: This SSDT contains 26 ports in total, so you need to deactivate at least 11 in total to stay within the Port limit of 15 for macOS!

Once you reach `USR1` and `USR2`, change `GUPC` to `Zero`, `Zero`. This to deactivates them (if you need these port in Windows, add the `If (_OSI ("Darwin"))` switch.

```swift
Scope (USR1)
{
	Method (_UPC, 0, NotSerialized)	// _UPC: USB Port Capabilities
	{
   		Return (GUPC (Zero, Zero)	// Zero, Zero = Port disabled, Type not defined
   	}
	
	Method (_PLD, 0, NotSerialized)	// _PLD: Physical Location of Device
	{
		Return (GPLD (Zero, Zero))
   	}
}
```
#### OPTION B: Mapping Ports of an unknown configuration
Option B is for user who don't alread know which internal USB ports connect to which physical port on the front and back I/O panel of their computer and internally. Basically, this works the same as Option A. The only difference is that you need to find out which physical connects to which internal USB Port of your machine.

##### Gathering information about USB Ports
The first step is to monitor the Ports, while connecting USB 2 and USB 3 Sticks to them. Take notes of which physical USB port connect to which port internally. You can monitor the Ports use IORegistryExploer for this too, but [Hackintool](https://github.com/headkaze/Hackintool) or Corpnewt's [USBMap](https://github.com/corpnewt/USBMap) are a lot simpler to use:

- Run the python script `USBMap.command` 
- Press "d" on the Keyboard to detect ports:</br>
![USBmap](https://user-images.githubusercontent.com/76865553/142078666-1a96ee4e-dc82-4658-91d6-ac370614b2a8.png)</br>
In this example, the system has more than one USB Controller. For the sake of the Example, we focus on the `XHC` Controller ("HSXX" and "SSXX").
- Leave the Window open and put in your USB 2 Stick into a port and check which entry turns blue in the list and take notes.
- Next, put a USB 3.0 stick in the same port and see what turns blue next. Usually, if a physical USB port is blue, it supports USB 2 and 3 Ports. An as far as its routing is concerned, only the Prefix changes when switching between USB 2 and USB3. In other words: if a USB 2 stick is mapped to "HS01", the corresponding USB 3 Port will most likely be "SS01".
- Continue probing all ports with USB 2/3/C flash drives or devices und you're done.
- Once you collected all the neccessary data return to "Option A" of the guide to map the ports in ACPI.

### Assigning Physical Location of Device (`_PLD`) 
This method provides a lot of details about the pysical location of the USB ports themselves. Such as: location, shape, color and a lot of rather uninteresting details for PC users. Here's a long list of some of the available parameters:

```swift
Name (_PLD, Package (0x01)  // _PLD: Physical Location of Device
{
    ToPLD (
        PLD_Revision           = 0x1,
        PLD_IgnoreColor        = 0x1,
        PLD_Red                = 0x0,
        PLD_Green              = 0x0,
        PLD_Blue               = 0x0,
        PLD_Width              = 0x0,
        PLD_Height             = 0x0,
        PLD_UserVisible        = 0x1,
        PLD_Dock               = 0x0,
        PLD_Lid                = 0x0,
        PLD_Panel              = "UNKNOWN",
        PLD_VerticalPosition   = "UPPER",
        PLD_HorizontalPosition = "LEFT",
        PLD_Shape              = "UNKNOWN",
        PLD_GroupOrientation   = 0x0,
        PLD_GroupToken         = 0x0,
        PLD_GroupPosition      = 0x0,
        PLD_Bay                = 0x0,
        PLD_Ejectable          = 0x0,
        PLD_EjectRequired      = 0x0,
        PLD_CabinetNumber      = 0x0,
        PLD_CardCageNumber     = 0x0,
        PLD_Reference          = 0x0,
        PLD_Rotation           = 0x0,
        PLD_Order              = 0x0,
        PLD_VerticalOffset     = 0x0,
        PLD_HorizontalOffset   = 0x0)
})
```
Among all these rather unnecessary properties, "Ejectable" might be useable. You want to make sure that internally connected USB ports, for Bluetooth for example are not ejectable. Otherwise you have to power cycle (aka reboot) your system. Since modifying `_PLD` won't be covered in this guide, please refer to to the ACPI specifications for [**`_PLD`**](https://uefi.org/specs/ACPI/6.4/06_Device_Configuration/Device_Configuration.html#pld-physical-location-of-device)

## Wrapping up and testing
Once you are done with your port mapping activities, do the following:

- Save the SSDT as something plausible like `SSDT-XHCI.aml` or `SSDT-PORTS.aml` (keep it short!)
- Mount your EFI partition
- Copy the EFI folder to a FAT32 formatted USB flash drive (for testing)
- Open your OpenCore `config.plist` (the one on the flash drive)
- Add the .aml file to the `EFI\OC\ACPI` folder on your flash driver.
- Add the file to the `ACPI > Add` Section and enable it.
- Save your `config.plist`
- Reboot from USB flash drive. 
- Test the ports with macOS and your other Operating systems.
- If it works, Congrats! 
- Copy the .aml and your config.plist back to the EFI folder on the hard disk.

**Good Luck!**
