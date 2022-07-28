# The undocumented super power of ProperTree

## The issue
You probably have come across posts like these on Forums or Reddit:

```xml
<dict>
	<key>Base</key>
	<string>\_SB.PCI0.LPCB.HPET</string>
	<key>BaseSkip</key>
	<integer>0</integer>
	<key>Comment</key>
	<string>HPET _CRS to XCRS</string>
	<key>Count</key>
	<integer>1</integer>
	<key>Enabled</key>
	<false/>
	<key>Find</key>
	<data>X0NSUw==</data>
	<key>Limit</key>
	<integer>0</integer>
	<key>Mask</key>
	<data></data>
	<key>OemTableId</key>
	<data></data>
	<key>Replace</key>
	<data>WENSUw==</data>
	<key>ReplaceMask</key>
	<data></data>
	<key>Skip</key>
	<integer>0</integer>
	<key>TableLength</key>
	<integer>0</integer>
	<key>TableSignature</key>
	<data></data>
</dict>
```
Isolated patches for your config in raw text format instead of a ready-made .plist. I hate if patches are posted this way for several reasons:

- In this form, it's a drag to integrate them into an existing `config.plist`
- It's hard to "convert" the patch if you want to add it to your config manually. 
- There's always a chance to mess up the structure of the plist file if you have to do it in text mode. 
- Some plist editors don't even offer/allow pasting of raw text.
- If you would paste this patch into PlistEdit Pro for example, it wouldn't even convert it into a plist item because the rest of tree structure is missing. 

## ProperTree for the win

In steps ProperTree to save the day! With ProperTree, you just copy the raw text with `[⌘]+[c]` run the App, hit `[⌘]+[v]` and boom, the `<Dict>` will be created:

![singlepatch](https://user-images.githubusercontent.com/76865553/181589762-0e30ea62-d792-4af5-8418-7c8f875d032b.png)

Then you can right-click the dictionary entry, copy it and paste it into your config in the correct location as a child and you're done.

**Another example**: somebody posts his config as raw text on Pastebin or wherever, like [this](https://www.toptal.com/developers/hastebin/raw/gizonijaru)

Just highlight the whole raw text, copy it into memory. Open ProperTree, paste it – boom, the config has been imported successfully:

![config](https://user-images.githubusercontent.com/76865553/181589787-a5643b48-a331-4d11-be5c-4357abc2a0e7.png)

## Credits
corpnewt for [**ProperTree**](https://github.com/corpnewt/ProperTree)
