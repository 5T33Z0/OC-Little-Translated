# Big Endian vs. Little Endian

When working with different sources of framebuffer data, you have to mind the byte order (or "Endianness") of Framebuffers and Device-IDs!

**Example**: For Whiskey Lake CPUs with Intel Graphics UHD 620, the OpenCore Install Guide recommends `AAPL,ig-platform-id` `00009B3E` which is for a UHD 630 along with a fake device-id since the UHD 620 is not supported by macOS natively. But if you compare this value with Whatevergreen's [**Intel HD Graphics FAQs**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#intel-hd-graphics-faqs), you will notice that the recommended platform-id is `0x3E9B0000`. What happened here?

Although it's not obvious at first glance, both values represent the same platform-id –  just in a different manner. The first is Little Endian and the second Big Endian. Big Endian is an order in which the "big end" (most significant value in the sequence) is stored first (at the lowest storage address). Little-endian is an order in which the "little end" (least significant value in the sequence) is stored first. 

If you split this sequence of digits into pairs of twos (07 00 9B 3E) and re-arrange them by moving them from the back to the left/front until the first pair has become last and vice versa, you have converted it to Big Endian (3E 9B 00 07) (we omit the leading "0x").

**In a nutshell**: just keep in mind that whenever you work with values presented as `0x87654321` it's in Big Endian so you have to convert it to Little Endian (in this case `21436587`). Luckily, Hackintool handles this conversion automatically when genereating a framebuffer patch. But for finding the correct platform-id in the Intel HD FAQs, you still have to make that Big Endian/Little conversation in your mind, to find and select the correct framebuffer. You can use the  built-in "Calcs" tab if uncertain:

![Calc](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/85ed7b18-ab22-4325-a0cc-0eab21a26acc)
