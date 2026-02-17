## Applying different ACPI patches for different versions of macOS

As you may know, the ACPI specs allow to apply different settings based on the detected Operating System by making use of the method (`_OSI`) (Operating System Interface). Hackintoshers make heavy use of the method `If (_OSI ("Darwin"))` in SSDTs to apply patches only if macOS is running.

What if you need to apply different patches for the same device depending on the macOS version—for instance, switching to a different `AAPL,ig-platform-id` and framebuffer patch to make your unsupported iGPU work in a newer macOS version? By default, this isn’t possible because the ACPI specifications don’t support such functionality. It’s essentially an all-or-nothing situation: the Darwin kernel is either running, or it isn’t.

Luckily, a relatively new kext called [**OSIEnhancer**](https://github.com/b00t0x/OSIEnhancer) addresses this issue. It enables modifications to the OSI ("Darwin") method, giving you greater control over when a patch is applied. With OSIEnhancer, you can specify the Darwin kernel and/or macOS version, effectively introducing functionality similar to the `MinKernel` and `MaxKernel` settings for kexts, but applied to ACPI tables.

Since OSIEnhancer is a relatively new kext, there aren’t many SSDT examples available for reference – some can be find on the repo, though. Its use cases tend to be highly specific and tailored to individual machines, as the patches often depend on unique hardware configurations and the macOS versions in question. This makes it more of a "per-machine" solution, requiring users to create custom SSDTs that address their particular needs. As a result, implementing OSIEnhancer may involve some trial and error, along with a solid understanding of ACPI and system-specific requirements.

[←**Back to Overview**](./README.md)

