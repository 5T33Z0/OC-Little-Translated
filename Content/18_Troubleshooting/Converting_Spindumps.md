# Converting Spindumps from Binary to Readable Text for Analysis

## About

When macOS encounters issues during runtime, it generates **Diagnostic Reports**, which are stored in:

```
/Library/Logs/DiagnosticReports
```

These reports often include **spindumps**, which are saved in a binary format represented by hexadecimal values. This format is not human-readable.

**For example**:

![](https://github.com/user-attachments/assets/148da737-bb78-463d-b92c-30509c1b0c02)

In the case shown above, the spindump was related to a shutdown stall. To investigate the cause, the spindump must first be converted to a readable text format.

## How to Convert Spindumps

1. Navigate to `Library/Logs/DiagnosticReports`.
2. Right-click the spindump you want to analyze while holding **Option/ALT**.
3. Select **Copy File Path** from the menu.
4. Open a text editor.
5. Paste the file path. **Example**:

	```
	/Library/Logs/DiagnosticReports/shutdown_stall_2026-01-30-011710_T490-von-5T33Z0.shutdownStall
	```

6. Open **Terminal** and run the following command (insert the path to the spindum at `<path_to_your_file>`):

	```
	sudo spindump -i <path_to_your_file> -o ~/Desktop/shutdown_stall_report.txt
	```

**Example of a complete command:**

```
sudo spindump -i /Library/Logs/DiagnosticReports/shutdown_stall_2026-01-30-011710_T490-von-5T33Z0.shutdownStall -o ~/Desktop/shutdown_stall_report.txt
```

7. After running the command, the converted text file will appear on your Desktop:<br>![](https://github.com/user-attachments/assets/43359cf5-0fad-43d3-a1d3-5861c402a25d)

You can now use this text file for **further analysis and troubleshooting**, either manually or with your favorite LLM such as ChatGPT or Claude, which handle this kind of structured log analysis very well.

