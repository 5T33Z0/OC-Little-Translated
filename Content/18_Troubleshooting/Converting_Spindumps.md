# Converting spindups from binary format to readable text for further analysis and troubleshooting

## About

Whenever something goes wrong during runtime, macOS generates „Diagnostic Repors“ and stores them, in `Library/Logs/DignosticReports` as Spindumps.

These are stored in binary format represented by hex values not readable by humans:<br>![](/Users/5t33z0/Desktop/spindump.png)

In this example it was related to the shutown stalling for whatever reason and I wanted to know what was causing this. In order to do so, you have to convert the file into text and save it.

## How to convert spindumps

1. Navigate `Library/Logs/DiagnosticReports`
2. Rightclick the report of your choice, hold ALT/Option
3. Select „Copy File path“ from the menu
4. Open a text edior
5. Paste in the filepath, for example: `/Library/Logs/DiagnosticReports/shutdown_stall_2026-01-30-011710_T490-von-5T33Z0.shutdownStall`
6. Next, open Terminal and enter:
	
	```
	sudo spindump -i <path to your file> -o ~/Desktop/shutdown_stall_report.txt
	```

	**Example**: 
	
	```
	sudo spindump -i /Library/Logs/DiagnosticReports/shutdown_stall_2026-01-30-011710_T490-von-5T33Z0.shutdownStall -o ~/Desktop/shutdown_stall_report.txt
	```
7. Once the file is converted, you have it on your desktop in text format:<b>![](/Users/5t33z0/Desktop/spindum_txt.png)

You can now use this for further analysis and troubleshooting either by yourself or by your favorite LLM like ChatGPT or Claude – they are really good at this.
