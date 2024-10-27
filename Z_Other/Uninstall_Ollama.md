# Uninstalling Ollama (Mac)

## Deleting Ollama and LLMs
- Quit Ollama (from Menubar)
- Delete the Ollama App using [AppCleaner](https://freemacsoft.net/appcleaner/). This gets rid of Support files and plists, etc
- Run the following commands in Terminal to delete LLMs, etc.:
	
	```shell
	rm /usr/local/bin/ollama 
	rm -rf ~/Library/Application\ Support/Ollama
	rm -rf ~/.ollama
	```

## Deleting Docker Desktop and Containers
- Stop and Delete Containers
- Delete Images
- Quit App
- Delete App using [AppCleaner](https://freemacsoft.net/appcleaner/))
- Delete `/Library/LaunchDaemons/com.docker.socket.plist`
- Delete `/Library/PrivilegedHelperTools/com.docker.socket`
- Run in Terminal:
	
	```shell
	rm -rf ~/Library/Containers/com.docker.docker
	```

## Check Disk Usage (optional)
- Run [**Grand Perspective**](https://sourceforge.net/projects/grandperspectiv/) (or [**SquirrelDisk**](https://www.squirreldisk.com/)) to visualize disk storage usage.
- Check for leftover files related to Ollama and Docker (should be large blocks with several gigabytes of storage) and delete them.
