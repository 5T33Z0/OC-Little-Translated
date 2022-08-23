# OpenCore Calculators

This section calculator to generate correct values for `csr-active-config`, `PickerAttributes`, `ScanPolicy`, `ExposeSensitiveData` and `Target` based on the data provided by OpenCore's `Documentation.pdf`.

## Spreadsheet

This is my clumsy approach, using an Apple Numbers [Spreadsheet](OpenCoreCalcs.numbers). Not fancy but you get a good understanding of how these bitmasks are actually calculated.

<details>

<summary><strong>Screenshots</strong> (click to reveal)</summary>

<img src="https://user-images.githubusercontent.com/76865553/180944112-a6fbbf86-f613-4bf6-8076-a3845dc911e3.png" alt="CSROC" data-size="original">

<img src="https://user-images.githubusercontent.com/76865553/134348928-ee19f359-c8fd-4e16-a99e-2cd652c9c64b.png" alt="Bildschirmfoto 1" data-size="original">

<img src="https://user-images.githubusercontent.com/76865553/134348939-d3eac5b2-02d3-4b98-9652-4ef52bde0c0d.png" alt="Bildschirmfoto 2" data-size="original">

<img src="https://user-images.githubusercontent.com/76865553/134348951-c113b897-74aa-4bd1-8b46-0973119ed5e2.png" alt="Bildschirmfoto 3" data-size="original">

<img src="https://user-images.githubusercontent.com/76865553/134348958-481e2632-d417-416f-ad0b-14158137149f.png" alt="Bildschirmfoto 4" data-size="original">

<img src="https://user-images.githubusercontent.com/76865553/137449526-2d6ef0e4-f4da-47d1-b12a-18f03b3fc29e.png" alt="Darkwake" data-size="original">

</details>

## Web Applications

Some of these calculators are also available as web applications:

* **ScanPolicy Generator**: https://oc-scanpolicy.vercel.app
* **ExposeSensitiveData Generator**: https://dreamwhite-oc-esd.vercel.app/

## Tools

If you are looking for an actual tool to calculate these things, check the following:

* **BitmaskDecode**: https://github.com/corpnewt/BitmaskDecode
  * Can generate all of the mentioned bitmasks.
* **OCAuxiliaryTools**: https://github.com/ic005k/OCAuxiliaryTools
  * Generates: ScanPolicy, PickerAttributes and ExposeSensitiveData
