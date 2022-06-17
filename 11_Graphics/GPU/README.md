# GPU Support in macOS

In general, please refer to Dortania's [GPU Buyer's Guide ](https://dortania.github.io/GPU-Buyers-Guide/)if you want to know if your GPU is compatible or if you want/need to buy one for hackintoshing.

## AMD GPU Cards Support

- For current AMD GPUs see &rarr; Chapter [AMD Radeon Tweaks](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/AMD_Radeon_Tweaks)
- For vintage AMD Cards and macOS &rarr; - Check Rampage Dev's excellent [AMD Graphics Guide](https://web.archive.org/web/20170814210930/http://www.rampagedev.com/guides/graphic-cards-injection/)

## NVIDIA GPU Support (†)
It's complicated… well, actually it isn't: just don't buy them! ;)

Although NVIDIA Cards ***were*** officially supported up to macOS High Sierra, you can no longer install Nvidia Web Drivers since [Nvidia revoked the certificates](https://twitter.com/khronokernel/status/1532545973372588033) shortly after Khronokernel figured out how to enable Nvidia Web Drivers in macOS Monterey. I don't know if this also affects previously installed Web Drivers (I guess you have to stay offline to not lose the Certs), but at this stage my advice would be to just move on and switch to AMD.

Even though Kepler Cards are supported up to macOS Big Sur, it's not worth investing in them simply because these old NVIDIA cards start dying. This year alone, my GTX 760 which I had for 4 years died basically doing nothing. The replacement GTX 760 died a month later (while the prices for these $hitty old cards are still increasing). So do yourself a favor and don't even bother buying one of these old cards.

And before someone asks: no, current NVIDIA Cards don't work for Hackintoshes – so no need to flex with your RTX 3090! ;) 

## Intel on-board Graphics

For fixing current issues, see Chapter &rarr; [Intel iGPU Fixes](https://github.com/5T33Z0/OC-Little-Translated/tree/main/11_Graphics/iGPU)
