# `csr-active-config` flags explained

## About
OSX 10.11 (El Capitan) introduced a new security feature called **System Integrity Protection** (or SIP) to improve system security. It's designed to protect the core operating system files and processes from unauthorized access and modification, even by users with administrative privileges. SIP currently provides 12 flags which can be set by calculating a bitmask which can be injected by Boot Managers such as Clover an OpenCore to control the level of SIP. Below you will find the flags and what they do. 

`csr-active-config` is a crucial setting in custom macOS boot environments like OpenCore, used to fine-tune System Integrity Protection (SIP) at boot time. It employs a 32-bit bitmask (only the least significant 12 bits are actually used for SIP configuration), where each bit corresponds to a specific SIP protection. Users can selectively disable SIP features by setting the appropriate bits. For instance, setting bit 0 (0x1) disables kext signing requirements, while bit 1 (0x2) disables filesystem protections. The bitmask is typically represented in hexadecimal format, with values combined using bitwise OR operations. For example, to disable both kext signing and filesystem protections, you'd use the value 0x3 (0x1 | 0x2), which in the full 32-bit little-endian format becomes `03000000`. This granular control allows advanced users to precisely tailor SIP to their needs, enabling activities like unsigned kext loading or system file modifications while maintaining other protections intact. 

If you want to calculate your own `csr-active-config` bitmask, [have a look here](/Content/B_OC_Calculators).

## Available Flags
Originally, the bitmask consisted of 8 bits. Since the release macOS 10.12, 4 more bits followed. Currently, the CSR bitmask consist of 12 bits providing the following flags:

Flag | Bit | macOS req.
-----|-----:|:------------:
CSR_ALLOW_UNTRUSTED_KEXTS            | 0 | 10.11+
CSR_ALLOW_UNRESTRICTED_FS            | 1 | 10.11+
CSR_ALLOW_TASK_FOR_PID               | 2 | 10.11+
CSR_ALLOW_KERNEL_DEBUGGER            | 3 | 10.11+
CSR_ALLOW_APPLE_INTERNAL             | 4 | 10.11+
CSR_ALLOW_UNRESTRICTED_DTRACE        | 5 | 10.11+
CSR_ALLOW_UNRESTRICTED_NVRAM         | 6 | 10.11+
CSR_ALLOW_DEVICE_CONFIGURATION       | 7 | 10.11+
||
CSR_ALLOW_ANY_RECOVERY_OS            | 8 | 10.12+
CSR_ALLOW_UNAPPROVED_KEXTS           | 9 | 10.13+
CSR_ALLOW_EXECUTABLE_POLICY_OVERRIDE | 10 | 10.14+
CSR_ALLOW_UNAUTHENTICATED_ROOT       | 11 | 11+

**Source**: [https://github.com/apple/darwin-xnu/blob/main/bsd/sys/csr.h](https://github.com/apple/darwin-xnu/blob/main/bsd/sys/csr.h)

> [!IMPORTANT]
> 
> Choosing a bitmask with the correct length and suited flags is really important in order for the system to boot and boot fast. A bitmask with inappropriate flags for the chosen version of macOS can cause early crashes or stalling of the boot process or prohibit loading of librariers installed with OpenCore Legacy Patcher!

## Explanation of the flags

Flag | Function
:----:|----------
**CSR_ALLOW_UNTRUSTED_KEXTS** | Allows the loading of unsigned kernel extensions (kexts) that have not been explicitly approved by Apple. By default, macOS only allows the loading of kexts that have been signed by Apple or approved by the user through a special process. This flag can be useful for developers or power users who need to use kexts that have not been signed or approved.
**CSR_ALLOW_UNRESTRICTED_FS** | Allows unrestricted file system access, including creating and deleting system files and directories. By default, macOS prevents modification of the root file system to protect the integrity of the system. This flag can be useful for developers or advanced users who need to modify system files for debugging or customization purposes.
**CSR_ALLOW_TASK_FOR_PID** | Allows tracking processes based off a provided process ID (PID). By default, macOS restricts this ability to prevent unauthorized access to sensitive system information. This flag can be useful for developers or security researchers who need to debug or analyze system processes.
**CSR_ALLOW_KERNEL_DEBUGGER** | Allows running kernel debuggers and other low-level system tools. By default, macOS restricts the use of these tools to prevent unauthorized access to sensitive system information. This flag can be useful for developers or security researchers who need to debug or analyze low-level system behavior.
**CSR_ALLOW_APPLE_INTERNAL** | Allows Apple Internal feature set (primarily for Apple development devices). For loading Apple-signed system extensions that are not part of the standard macOS installation. By default, macOS only loads extensions that are part of the standard installation to ensure system stability and security. This flag can be useful for developers or advanced users who need to use additional system extensions. Try to avoid setting this flag. Otherwise System Update notifications won't work in Big Sur and newer and you will need a workaround.
**CSR_ALLOW_UNRESTRICTED_DTRACE** | A security feature that restricts the use of [**DTrace**](http://dtrace.org/blogs/about/), a powerful diagnostic and debugging tool built into macOS. By default, macOS restricts the use of DTrace to prevent unauthorized access to sensitive system information. This flag can be useful for developers or advanced users who need to use DTrace for debugging or performance analysis purposes. DTrace allows users to trace and debug system activities, but it also has the potential to be used for malicious purposes, such as monitoring keystrokes or accessing sensitive information. To prevent this, Apple implemented the CSR_ALLOW_UNRESTRICTED_DTRACE feature in macOS 10.12 Sierra and later versions. When CSR_ALLOW_UNRESTRICTED_DTRACE is disabled, only authorized system components and privileged users are allowed to use DTrace. This provides an additional layer of security to the system, preventing unauthorized access to sensitive data. It is important to note that enabling this feature can potentially compromise system security, so it should only be done when absolutely necessary and by users with the appropriate knowledge and permissions. 
**CSR_ALLOW_UNRESTRICTED_NVRAM** | Allows modifying the non-volatile RAM (NVRAM) settings, which can affect system behavior and performance. By default, macOS restricts modification of the NVRAM to prevent unauthorized changes to system settings. This flag can be useful for advanced users who need to modify system settings for testing or performance optimization purposes.
**CSR_ALLOW_DEVICE_CONFIGURATION** | Allows loading of device drivers that are not signed by Apple. By default, macOS only loads device drivers that have been signed by Apple to ensure system stability and security. This flag can be useful for developers or advanced users who need to use custom or experimental device drivers.
**CSR_ALLOW_ANY_RECOVERY_OS** | Allows booting into any macOS recovery mode, even if it has not been signed by Apple. By default, macOS only allows booting into recovery modes that have been signed by Apple to prevent unauthorized modifications to the system. This flag can be useful for advanced users who need to use custom recovery modes for testing or recovery purposes.
**CSR_ALLOW_UNAPPROVED_KEXTS** | Allows loading of unsigned kernel extensions (kexts) that have not been explicitly approved by the user. By default, macOS only allows the loading of kexts that have been signed by Apple or approved by the user through a special process. This flag can be useful for advanced users who need to use kexts that have not been signed or approved.
**CSR_ALLOW_EXECUTABLE_POLICY_OVERRIDE** | Allows running of executable files that have been blocked by macOS's Gatekeeper. Setting this flag is required when using OCLP or other Post Install patchers which reinstall legacy drivers for video cards that have been removed from macOS Monterey and newer. Once this flag is enabled, you won't be able to download incremental (or delta) system updates. Only the full installer will be avaialable.
**CSR_ALLOW_UNAUTHENTICATED_ROOT** | Allows custom APFS snapshots to be booted (primarily for modified root volumes). The flag is not a publicly documented or officially supported feature of SIP. It was discovered by some users and developers during the testing phase of macOS. 

## Furter Resources

- [System Integrity Protection: The misunderstood setting](https://khronokernel.github.io/macos/2022/12/09/SIP.html) by Mykola Grymalyuk (khronokernel)
- [Risks of bypassing SIP](https://book.hacktricks.xyz/macos-hardening/macos-security-and-privilege-escalation/macos-security-protections/macos-sip#sip-bypasses) by HackTricks
