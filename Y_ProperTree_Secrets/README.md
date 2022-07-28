# The undocumented super power of ProperTree

Do you know these posts on Forums or Reddit, when people post isolated patches for your plist without context as RAW text instead of a ready-made .plist? You know, things like this:

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
I hate if patches are posted this way for several reasons:

1. It's a drag to integrate it into an existing `config.plist` and there's always a chance to mess up the structure of it. Some plist editors don't even support pasting raw text.
2. It's also hard to read if you want to create the entries/keys manually. 
3. If you paste this into an empty Plist using Plist Edit Pro it won't work, because the rest of tree structure is missing. 

In steps ProperTree to save the day… With ProperTree, you just copy the raw text with `[⌘]+[c]` run the App, hit `[⌘]+[v]` and boom, the `<Dict>` will be created:

![singlepatch](https://user-images.githubusercontent.com/76865553/181589762-0e30ea62-d792-4af5-8418-7c8f875d032b.png)

Then you can right-click the dictionary, copy it and paste it into your config in the correct location as a child.

**Another example**: somebody posts his config as raw text on Pastebin or wherever, like [this](https://www.toptal.com/developers/hastebin/raw/gizonijaru)

Just highlight the whole raw text, copy it into memory. Open ProperTree, paste it – boom, the config has been imported successfully:

![config](https://user-images.githubusercontent.com/76865553/181589787-a5643b48-a331-4d11-be5c-4357abc2a0e7.png)

## Credits
corpnewt for [**ProperTree**](https://github.com/corpnewt/ProperTree)
