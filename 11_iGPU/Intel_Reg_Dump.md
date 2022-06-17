# Obtaining an Intel Register Dump in Linux
You can use this to obtain Display Connection Data for your Intel on-board graphics. Requires working Internet connection to install the necessary tool. 

## 1. Prepare a USB stick for running Linux from an ISO:
You can skip to step 2 if you already have Linux installed

- Use a USB 3.0 flash drive (at least 8 GB or more).
- In Windows, download [**Ventoy**](https://www.ventoy.net/en/download.html) and follow the [Instructions](https://www.ventoy.net/en/doc_start.html) to prepare the flash drive. 
- Next, download an ISO of a Linux distribution of your choice, e.g. [**Ubuntu**](https://ubuntu.com/download/desktop), [Zorin](https://zorin.com/os/download/) or whatever distro you prefer – they all work fine.
- Copy the ISO to your newly created Ventoy stick
- Reboot from the flash drive
- In the Ventoy menu, select the Linux ISO and hit enter
- From the GNU Grub, select "Try or Install Linux"
- Once Ubuntu has reached the Desktop environment, select your language (affects Keyboard Layout as well) and click on "Try Ubuntu" (or whatever the distro of your choice prompts).

## 2. Create an Intel Register Dump
1. Open Terminal
2. Install [Intel-Reg-Dumper](https://01.org/linuxgraphics/documentation/using-intel-reg-dumper)
3. Enter `tools/intel_reg dump --all > intel_reg_dump.txt`
4. Save the file on a USB flash drive or send it to yourself via mail or store it in the cloud

## Credits
RampageDev for Intel [HD Graphics Guide](https://web.archive.org/web/20180313040641/http://www.rampagedev.com:80/guides/intel-hd-graphics-guide/)
