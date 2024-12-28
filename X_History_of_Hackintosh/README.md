# A brief history of hackintoshing

If we take the definition of a "Hackintosh" (or "Black Apple", as it's called in Asia) – a computer without the Apple logo running an operating system developed by Apple – then the world's first "Hackintosh" would have been born around 1996 – almost 30 years ago. 

In 1996, Apple switched its Macintosh computers to IBM's PowerPC architecture. Gil Amelio, then Apple CEO, took the opportunity to sign up some of the same CPU and motherboard manufacturers as the Macintosh, such as Motorola, to license their PCs with Apple's Macintosh System 7 (known as Classic Mac OS 7).

However, two things happened in July 1997. One was the return of Steve Jobs to Apple and his official appointment as Apple's CEO, and the other was the official release of Mac OS 8 on July 26.

Mac OS 8 didn't bring a revolutionary update – initially it was supposed to be called Mac OS 7.7. But the former Apple CEO's system license agreement with a third-party vendor was based on Macintosh System 7. Steve Jobs chose to release Mac OS 8.0, cleverly taking advantage of the difference in naming and version numbering to discontinue subsequent services and agreements directly.

>![](https://img10.360buyimg.com/ddimg/jfs/t1/98099/31/19892/76135/62579d59Ebcfe4e01/4287ff5a034227cd.png)</br>
> StarMax compatible machine made by Motorola, which can directly install System 7.

Another powerful Mac clone of this era was the [DayStar Genesis MP](https://www.youtube.com/watch?v=RX_LqLhL-YI), which came with 4 PPC 604 CPUs – Multi-Processor Computing that was unheard of in the home PC market in 1996.

## From PowerPC to x86

It's a bit tricky to interpret the Macintosh System 7 license agreement as a Hackintosh. To talk about the modern Black Apple, you can't ignore Apple's path to x86, so let's go back five years.

On February 14, 1992, Apple launched **Star Trek,** a secret project to migrate Macintosh System 7 (Classic Mac OS 7) with its applications to Intel architecture-compatible PCs (with Intel 486 processors), and required the first prototype to be available on December 1. Apple's engineers worked around the clock to refactor and complete the System 7 and QuickTime port before Deadline. But Star Trek was cancelled when Apple's then-CEO John Sculley left the company and his successor, Michael Spindler, preferred the PowerPC architecture.

>![](https://img10.360buyimg.com/ddimg/jfs/t1/119151/34/24274/27904/62579d59Ebf4ff7a6/7139f6c2e2b1775e.png)</br>
>Screenshot of the Macintosh System 7 interface

Despite the cancellation of Star Trek, some Apple engineers continued to work on porting Mac OS to the x86 platform, most notably engineer John Kullman, who successfully ported OSX to the x86 Quora PC in December 2001. Bertrand Serlet, known as the "father of OSX" (who would go on to lead 10.4 Tiger, 10.5 Leopard and 10.6 Snow Leopard), learned of this and met with John Kullman to port OSX to a Sony VAIO laptop. Kullman was done before dinner that day. The next day, Jobs flew to Tokyo with the VAIO to meet with Sony's then president, Kuniway Ando, to discuss running OSX on Sony's VAIO, but the negotiations ended without a hitch.

Even though Steve Jobs failed to reach an agreement with Sony, a new secret project called **"Marklar"** was launched in 2002 to maintain the compatibility of OSX with x86. It wasn't until June 6, 2005, when Apple held **WWDC 2005** at the Moscone Expo Center in San Francisco, that Jobs officially [announced](https://www.youtube.com/watch?v=ghdTqnYnFyg&t=8s) that they would change their PC product line from [PowerPC architecture to Intel architecture](https://www.apple.com/newsroom/2005/06/06Apple-to-Use-Intel-Microprocessors-Beginning-in-2006/). At the same convention, Jobs also revealed that all versions of OSX have been secretely compiled for *both* PowerPC *and* Intel X86 simultaneously for the last 5 years.

On January 10, 2006, Apple announced the first MacBook Pro with Intel Core, replacing the previous product line, the PowerBook. On April 5, 2007, Apple introduced Boot Camp, on April 24, Apple introduced the 17-inch MacBook Pro, on May 16, Apple introduced the 12-inch MacBook to replace the iBook line, on July 5, Apple introduced the iMac to replace the eMac line, and on August 7, Apple introduced the iMac to replace the eMac line. In August 2009, Apple introduced OSX 10.6 Snow Leopard, the first x86-only OSX, announcing that Apple had officially abandoned support for PowerPC.

## First light of things to come
Back at **WWDC 2005**, Apple introduced the Intel processor-powered **DTK** (Dev Transition Kit) to developers with the Intel-compatible OSX 10.4.1.

>![](https://img10.360buyimg.com/ddimg/jfs/t1/180764/25/23716/64734/62579d5aE81009096/b0951f5b084ee1f7.png)</br>
>OSX 10.4.1 Tiger Development Edition runs on a DTK with an Intel processor.

Soon, attempts were made to run a development version of OSX on non-Apple hardware, but the system refused to run on a regular PC. When trying to install a development version of OSX Tiger 10.4.1 on a non-Mac platform you will be greeted by the following message:

![](https://img10.360buyimg.com/ddimg/jfs/t1/114645/37/23798/613/62579d5aE48e17ebd/cefe59b7ef6d9187.png)

At the time, there were three major obstacles to running OSX Tiger 10.4.1 on a regular PC: 

- Firstly, none of the common PCs CPUs around 2004 supported the **SSE-3** instruction set that DTK's built-in Intel [Pentium 4 660 CPU](https://ark.intel.com/content/www/us/en/ark/products/27484/intel-pentium-4-processor-660-supporting-ht-technology-2m-cache-3-60-ghz-800-mhz-fsb.html) used. 
- Secondly, the OSX development version only supports the **Intel 915G/ICH6** chipset.
- And finally, Apple's DTK at that time used an **Infineon TPM** security chip. 

So Ironically, the most difficult obstacle to overcome was not the hardware or the security chip, but the instruction set!

The first known Hackintosh of the X86 era was documented on August 10, 2005, the day the [HardMac website](https://web.archive.org/web/20051018182314/http://hardmac.com/news/2005-08-10/) received two videos from an anonymous developer, which showed OSX 10.4.1 Tiger running on a Pentium M 735-powered Mitac 8050D laptop. It is worth mentioning that Apple released the MacBook Pro on January 10, 2006, which uses UEFI boot method instead of the x86 motherboards of that era that used BIOS boot (Legacy).

On February 14, 2006, Maxxuss (crg92), a member of "The Guru" team, released the first patch. It patches the XNU kernel and removes boot and install restrictions, runs OSX 10.4.4 on any Intel processor with SSE-2 support. The post is still available on InsanelyMac and is simply titled [**10.4.4 Security Broken**](https://www.insanelymac.com/forum/topic/9071-1044-security-broken/?page=1). A few hours later Apple released version 10.4.5 of OSX, and another two weeks later crg92 released a new patch for it.

Apple released **OSX 10.4.6** and 10.4.7 in the following months, and members of the OSx86 community managed to replace the new versions of the kernel in these systems with the older kernel from 10.4.4 and 10.4.5, enabling installation of these new versions on PCs. However, starting with 10.4.8, Apple began to use the **SSE-3** instruction set more extensively, meaning that it was no longer compatible with processors that only supported the SSE-2 instruction set (such as the earlier Pentium 4) by simply patching the XNU kernel. New Zealand-based macOS and iOS developer and reverse engineer [**Mfiki**](http://mifki.com/) (Vitaly Pronkin) released a new, more streamlined patch to make the XNU kernel compatible with SSE2 on December 24, 2006; and developer Semthex made an instruction set simulator that emulates SSE-3 through SSE-2.

**OSX 10.5 Leopard** was officially released in **2007**, and BrazilMac released a generic patch. Users could purchase the installation CD for the retail version of OSX, apply the patch, and have the XNU kernel run on a regular Intel PC. Since then, several hackers and developers (such as Lorem, SynthetiX, ToH, and the StageXNU Team) have released kernel patches. At the same time, OSX "distributions" based on these patches began to appear, such as iATKOS, [**KALYWAY**](https://www.insanelymac.com/forum/topic/77069-kalyway-1051-dvd-release-the-official/ ) and [**iPC**](http://ipcosx86.wikidot.com/). Later, as the EFI boot method became more popular, these distributions gradually switched to having either Boot-132 or Chameleon built into the system.

## Halftime: A Glimpse into U.S. Courts

In **April 2008,** a company called **Psystar** was registered in Florida, USA. The company planned to publicly sell Intel PCs with OSX 10.5 Leopard pre-installed with BrazilMac patches, which were initially called "OpenMac" and soon renamed "Open Computers".

>![](https://img10.360buyimg.com/ddimg/jfs/t1/115556/8/26616/11727/62579d5bE31e11ee3/ee9b90ca05d7bccc.jpg)</br>
>Pystar's "OpenMac"

- On **July 3, 2008**, Apple sued Pystar in the District Court of California, alleging that Pystar infringed Apple's copyrights and violated the Digital Millennium Copyright Act (DMCA) by "circumventing, bypassing, removing, unscrambling, decrypting, deactivating, and defeating Apple's protection mechanisms.
- On August 28, 2008, Pystar sued Apple in Florida District Court, alleging monopolization and other unfair competition, and on November 18, 2008, Pystar's suit was dismissed.
- On **February 5, 2009,** [Pystar won the first round of Apple's copyright lawsuit](http://www.computerworld.com/s/article/9127579/Mac_clone_maker_wins_legal_round_against_Apple). This case means that Apple's EULA clause "prohibiting the operation of an operating system developed by Apple on a computer without the Apple logo" may not be legally valid.
- In **April 2009,** an Apple spokesperson stated that Pystar did not disclose any financial information (profits, assets, liabilities) as required by law; Pystar's CEO and founder declined to comment and still refuses to disclose any financial information.
- On May **26, 2009,** Pystar filed for bankruptcy protection in an attempt to delay Apple's lawsuit through the Chapter 11 bankruptcy. On August 12, 2009, Pystar's Chapter 11 petition was dismissed by the Florida District Court.
- On **November 13, 2009,** the California District Court ruled that Pystar violated the DMCA and infringed Apple's copyrights, and set a hearing for December 14, 2009. on December 15, 2009, the California court issued a permanent injunction prohibiting Pystar from manufacturing, distributing, or assisting anyone to install any version (including future versions) of OSX. On January 16, 2010, Pystar filed an appeal. 
- Finally, on **May 14, 2012**, the Supreme Court denied Pystar's appeal and Apple won the final lawsuit.

## Moving onwards: Chameleon

Back at **WWDC 2005**, the Intel DTK was released with a built-in UEFI bootloader called **Boot-132** to load the XNU kernel. At the time, Intel's UEFI implementation was still new and almost all PCs were still using BIOS boot (now known as Legacy BIOS). So in **2007**, David Elliott developed a rudimentary bootloader based on Linux's GRUB bootloader and Apple's Boot-132 source code that provides an **"emulated UEFI"** environment for loading the XNU kernel on PCs booted with Legacy BIOS.

In addition to Boot-dfe, David Elliott's work includes a preliminary version of [**NullCPUPowerManagement**](https://web.archive.org/web/20180724143621/http://www.tgwbd.org/darwin/extensions.html) for Apple-compatible CPU power Management (`AppleIntelCPUPowerManagement`).

In **2008**, the Voodoo team (formerly the StageXNU team, which you may remember from the preivious paragraph) combined the "emulated UEFI" implementation developed by David Elliott with Apple's original Boot-132 to create the **Chameleon project**. As the development of Chameleon progressed, many features were implemented, such as: 

- injecting Device Properties, 
- loading Kernel Extensions (kexts), 
- patching ACPI, 
- emulating SMBIOS models, and 
- GUI boot menus 

The Voodoo team also developed several kext such as `VoodooPower`, `VoodooSDHCI`, and the familiar `VoodooHDA` and `VoodooPS2Controller`.

>![](https://img10.360buyimg.com/ddimg/jfs/t1/90896/37/23405/7330/62579d5aEae4a64a6/4c26f564d20e3fca.png)</br>
>Boot PureDarwin in a QEMU virtual machine with Chameleon 2.1.0, which already had a GUI.
    
Due to the emergence of **Chameleon**, fewer and fewer people choose to decompile and modify the XNU kernel, but to **replace DSDT** through the Bootloader, injecting device properties and kexts. 

Considering that the **Digital Millennium Copyright Act (DMCA)** prohibits modification and distribution of operating system code in non-open source parts of macOS, using the Bootloader to start the systems does not require direct modification of the operating system or the XNU kernel itself, thus successfully circumventing this law.

In **2009**, OSX 10.6 **Snow Leopard** was released, the first version of OSX to completely abandon the PowerPC architecture. [**Netkas**](http://netkas.org/) from Russia was the first to release a modified version of the Chameleon EFI that could be used to boot OSX 10.6. The Voodoo team followed suit with an official 10.6 compatible update.

In addition to being the first to make Chameleon compatible with OSX 10.6, Netkas also developed **FakeSMC** and **HWSensors**. Netkas is now working on extending AMD graphics card compatibility (like enabling Metal support for Raedon RX560 on macOS 10.14 Mojave, preventing Raedon W5700 from causing Kernel Panic on macOS 10.15.5, etc.).

In **2011**, OSX 10.7 Lion was released. This is Apple's **first OSX version that no longer provides installation discs**, and the first OSX version to support **SSD TRIM**. Michael Belyaev (usr-sse2) from Russia was the first to find the installation method, write the modified installation image to a USB storage device, and start the XNU kernel through the **XPC EFI Bootloader** (a DUET-based emulated EFI bootloader). **Usr-sse2** is now an active member of the **acidanthera** team, involved in the development of **OpenCore** and **VirtualSMC**, among others. As of this writing, usr-sse2 is working on Apple's **IO80211Family**.

In the same year, **MacMan** from **tonymacx86** developed [**Chimera**](https://tonymacx86.blogspot.com/2011/04/chimera-unified-chameleon-bootloader.html), which is a branch of **Chameleon**. The tonymacx86 community provided the tool **UniBeast** (and later **MultiBeast**) with Chimera built in, greatly simplifying the installation of macOS on Wintel systems.

## The Clover era begins

Both David Elliott's Boot-dfe and Chameleon are based on a simulated EFI environment which has serious downsides:

- Wintel systems cannot install BootCamp to switch between Windows and OSX
- They cannot enter Recovery Mode because Chameleon can't boot the Recovery HD partition
- They cannot use GUID partition tables (GPT) because Chameleon only supports MBR

Microsoft started providing initial support for UEFI boot from Windows 7, and mainstream PC and laptop manufacturers are gradually replacing Legacy BIOS with EFI; at the same time, with the emergence of hard drives larger than 2TB, GPT is becoming more and more popular, and Hackintosh scene is becoming more and more vocal about a true UEFI bootloader that supports GPT.

The rise of Clover in 2006 goes back to the emergence of **TrueOS**, a FreeBSD distribution in. Christoph Pfisterer of the TrueOS community developed a UEFI bootloader with a graphical interface called "rEFIt".

![](https://img10.360buyimg.com/ddimg/jfs/t1/88415/26/27193/17896/62579d5bE7a0a4980/eb1ef8998338fcab.png)

In **2011** Christoph Pfisterer discontinued the development of rEFIt. The following year, developer Roderick W. Smith Forked **rEFIt** and founded the rEFInd project. In the same year, **Slice** and the **OSx86** community discussed the development of a **UEFI bootloader**: in addition to supporting an EFI environment like Chameleon, it needed to be compatible with a real UEFI environment; it needed to be able to read HFS+ partitions correctly; it needed to be able to patch ACPI, load kexts, SMBIOS, have Quirk built in to boot macOS on a PC. The community decided that the bootloader should be based on rEFInd. **2012** saw the release of OS X 10.8 Mountain Lion, and the same year the first version of Clover was released:

![](https://img10.360buyimg.com/ddimg/jfs/t1/95165/1/27008/5694/62579d5bE96877840/93e868dcab41c679.png)

OSX 10.10 **Yosemite** was released on October 16, 2014, and the following day the Voodoo team released the last official version of Chameleon, 2.2, which provides boot support for it. From OSX 10.10 Yosemite onwards the Hackintohs scene began to favor using the original OS X system images released by Apple, using as few kext and patches as possible to ensure system stability.

On September 30, **2015**, OS X 10.11 El Capitan was released and **UniBeast**, the installation tool from tonymacx86, replaced the previously included Chimera bootloader by **Clover**, officially marking the end of Chameleon.

## Epilogue: What will the furture hold?

As of this writing, macOS 11.0 Big Sur is in Public Beta 5, and Apple has announced that future Macs will switch from Intel to the **ARM architecture** of Apple Silicon. Quite a few users are worried about the future of hackintoshing. This article will conclude with a few question about the future of hackintoshing based on its history so far.

### How long did it take for Clover to replace Chameleon?

- Early 2008 Chameleon released its first version
- Clover released its first version in 2012
- October 17, 2014 Chameleon released the last version

It took only 2 years for Clover to go from releasing the first version to replacing Chameleon…

### How long did it take Apple to switch from PowerPC to Intel?

- On June 6, 2005, Apple held WWDC 2005 and announced that Apple would switch from PowerPC to Intel
- January 10, 2006 Apple released the first MacBook Pro with Intel
- On August 28, 2009, Apple released OSX 10.6 Snow Leopard, which officially stopped supporting PowerPC.

That said, it took 4 years for Apple to go from *announcing* the switch to Intel to OSX dropping PowerPC support completely.

## When will OpenCore replace Clover?

**OpenCore 0.0.1** was released on **May 4, 2019**. If it only took two years for Clover to go from release to replacing Chameleon, then OpenCore will completely replace Clover next year. 

In the previous sections we saw the many flaws of Chameleon so that its replacement by Clover was inevitable. But as of today, Clover has no significant drawbacks, OpenCore has no significant advantages over Clover that would make it obsolete. So both Clover and OpenCore will still co-exist for the foreseeable future. [The views about OpenCore shared in this paragraph are not those of 5T33Z0.]

## When will Apple abandon Intel's x86 architecture?

This is probably the biggest concern for Hackintoshers. Applying Apple's timeline for switching from PowerPC to Intel, Apple would switch all Macs to ARM (no more Intel-powered Macs) the year after WWDC (2021), and macOS would drop support for Intel processors three years later (**2024**).

But there are still major differences between Apple's strategy now and 15 years ago – after WWDC 2005, Apple didn't release any new Macs in the second half of 2005, mainly due to the release of performance upgrades to existing PowerPC-based Macs. After **WWDC 2020**, Apple released a 27-inch iMac 2020 with a 10th generation Intel processor. Apple may not even release a Mac with Intel's 11th generation processors until 2021.

### A different look on the macOS timeline:

- OS X 10.10 Yosemite released October 16, 2014, compatible with iMac and MacBook Pro 2007 and later, last updated August 15, 2015.
- OS X 10.11 El Caption released September 30, 2015, compatible with iMac and MacBook Pro 2007 and later, last updated July 9, 2018.
- macOS 10.12 Sierra released September 20, 2016, compatible with iMacs and MacBooks released in the second half of 2009, last updated September 26, 2019
- macOS 10.13 High Sierra released September 25, 2017, compatible with iMacs and MacBooks released in the second half of 2009, last updated December 10, 2019
- macOS 10.14 Mojave released September 24, 2018, compatible with the 2010 iMac Pro and all Macs released in the second half of 2012, last updated December 10, 2019
- macOS 10.15 Catalina was released on October 7, 2019, is compatible with the 2010 iMac Pro and all Macs released in the second half of 2012, and is still being maintained as of this writing.
- macOS 11.0 Big Sur started beta testing on June 22, 2020, compatible with the MacBook Air released in the first half of 2013, and is still in public beta as of this writing.

This timeline shows that every major version of macOS in the past 6 years will be compatible with devices released at least 7 years ago. So even if Apple does not release Macs with Intel processors starting in 2021, macOS may not end support for Intel processors until **2025**.

## Credits
Original Blog Post published by [Sukka](https://blog.skk.moe/post/history-osx86/), 03-09-2020. Translated from Chinese using DeepL and Google Translate. Some sections were redacted/rephrased for better legibility.
