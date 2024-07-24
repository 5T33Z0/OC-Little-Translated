# How to create a multi macOS USB Installer

## Preface 

As you may or may not know, it is impossible to install previous versions of macOS while the system is running. Therefore you need to create a USB Installer, boot from it and insall the older version of macOS on a new volume or partion. 

By default, the USB installer you create via Terminal or OCLP only contains *one* macOS Installer.

So what if you could have something similar to Ventoy, but for macOS, containing multiple installers? With a combination of clever partitoning and a tool called [**TINU**](https://github.com/ITzTravelInTime/TINU) you can create something like this:

![](/Users/5t33z0/Desktop/screenshots/MultimacOSinstaller.png)

## Preperations

### Preparing the USB flash drive

- Get a USB 3 flash drive with a capacitiy of at least 32 GB or more – anything smaller is insufficant for creating a multi macOS Installer. I am using a 64 GB SanDisk Ultra Fit USB 3.2Gen1 Flash-drive in this example.
- Run Disk Utility
- Change the View to "Show all Devices" (or press CMD+2)
- Format the USB Flash drive as Mac OS Extended (Journaled), GUID Partion Table:<br>![](/Users/5t33z0/Desktop/screenshots/Format_USB.png)
- Download [**TINU**](https://github.com/ITzTravelInTime/TINU) and unzip it

## Creating the USB Installer

1. Run TINU
2. Select the option "Create a bootable macOS installer":<br>![](/Users/5t33z0/Desktop/TINU_01.png)
3. Select the "macOS Install" partiton from the menu and press "Next":<br>![](/Users/5t33z0/Desktop/TINU_02.png)
4. Press "Open" and navigate to the location of your macOS Installer App to add it and press "Next":<br>![](/Users/5t33z0/Desktop/TINU_03.png)
5. In the next Window, you get a summery:<br>![](/Users/5t33z0/Desktop/TINU_04.png)
6. Click on "Options" and unselect the following and click on "Done":<br>![](/Users/5t33z0/Desktop/TINU_05.png)
7. Press "I Understand" to start the process

Depending on size of the macOS DMG and the speed of your USB flash drive this can take about 15 Minutes.

### Adding additional macOS Installers

Before we can add more installers, we need to repartition the USB flash drive. 

1. Open Disk Utility
2. Change the view to "Show all Devices" (or press <kbd>CMD</kbd>+<kbd>2</kbd>), if you haven't already
3. Highlight the USB Flash Drive in the sidebar on the left, then click on "Partition Disk" on the toolbar at the top:<br>![](/Users/5t33z0/Desktop/screenshots/any_03.png)
4. This brings up the Partitioning menu. The dashed lines represent the space used by the macOS Installer created previously
5. Select the biggest available "slice" of the "cake" and press the "+" button to add a new Partition:q<br>![](/Users/5t33z0/Desktop/screenshots/any_04.png)
6. Move the handle on the edge of the circle counter clockwise.
7. The size of the Partition needs to be the size of the Installer app you want to put on it plus a little bit of leeway.
8. In this example, I've created a 15 GB partition for macOS Sonoma:<br>![](/Users/5t33z0/Desktop/screenshots/any_05.png)<br> **NOTE**: I found out later that 15 GB wasn't enough so I had to change it to 17 GB!
9. Open TINU again to create another USB installer. This time, select the new partition you created
10. Once the process is finished, repeat the process for additional installers

### Required partion sizes

You can take the values for the required partition sizes for the desired macOS installer from the following table:

Installer | Partition Size <br>(minimum)
----------|:-------------------------:
macOS Sequoia | 17 GB
macOS Sonoma | 17 GB
macOS Ventura | 15 GB
macOS Monterey | 13 GB
macOS Big Sur | 13 GB
macOS Catalina | 9 GB
macOS Mojave | 7 GB 
macOS High Sierra |6 GB

**My final USB Installer looks like this**:

![](/Users/5t33z0/Desktop/Finished.png)

Maybe it's possible to optimize the size of the partitions more so you could maybe squeeze one more installer in there but for now I am satisfied with the outcome.

## Links

- [How to download and install macOS](https://support.apple.com/en-us/102662)
