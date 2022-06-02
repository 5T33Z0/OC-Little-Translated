# Codec Dumps

## About
In this section you'll find Audio CODEC dumps including verbs.xt and visualizations (schematics) generated with graphviz and codecgraph.

## Fixing possible conversion errors

### Manual fixing
In some cases, the verbit.sh script introduces errors where the data is not converted correctly and the formatting is messed up as well, as in this example from an **Realtek ALC269**:

![verbsfail](https://user-images.githubusercontent.com/76865553/171467770-db9f1681-e4d3-4fb1-abdf-5a656b8ca1c5.png)

The values highlighted in red (Nodes) should be decimals and the pink values (PinDefault values) should be in Hex. In cases like these, you have to either look into the `codec_dump.txt` and `codec_dump_dec.txt` and correct the data or use the Calc Tool inside of Hackintool for example.

Once the errors are fixed, it should look like this:

![versbfixed](https://user-images.githubusercontent.com/76865553/171467793-af3d36c1-af92-45d2-acc2-e5d425c8450f.png)

### Automated fixing using PinConfigurator (recommended)

To get more accurate results, do the following:

- Run PinConfigurator
- Select "File > Open"
- Open the `codec_dump.text`
- Select "File > Export > verbs.txt"

The `verbs.txt` will be stored on the desktop and contains no errors:

![verbsreallyfixed](https://user-images.githubusercontent.com/76865553/171468008-cb04fa6b-e9d3-4cf3-a4b5-3fab0f48f553.png)

**NOTE**: You will still have to sanitize the verbs so macOS can handle the data and soud will work.
