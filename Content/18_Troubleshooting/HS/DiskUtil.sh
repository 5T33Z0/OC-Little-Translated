#!/bin/bash
# by joevt May 10, 2023

directblesscmd="/Volumes/Work/Programming/XcodeProjects/bless/bless-204.40.27 joevt/DerivedData/bless/Build/Products/Debug/bless"
usedirectbless=0
if [[ -d /System/Library/PrivateFrameworks/APFS.framework/Versions/A ]]; then
	if [[ ! -f "$directblesscmd" ]]; then
		echo "# Download and build bless from https://github.com/joevt/bless , then update the path of directbless defined in DiskUtil.sh"
	else
		usedirectbless=1
	fi
fi
if ((usedirectbless)); then
	directbless=$directblesscmd
	alias directbless='"$directbless"'
else
	directbless=bless
	alias directbless=bless
fi

# Set this to 1 since some macOS versions will modify disk labels without user action.
# But you need to run unlockapfsbooter before doing OS updates.
dolockdisklabels=1

# dump disk_label file
dump_label () { local contents; contents=$(xxd -p -c99999 "$1"); echo "${contents:10}" | perl -pe "s/(..)/\1 /g;s/00/../g;s/ //g;s/(.{$((0x${contents:2:4}*2))})/\1\n/g" ; }

# convert 4 byte number to little-endian
le () { local n; n=$(printf "%08x" $(($1))); printf "%s" "${n:6:2}${n:4:2}${n:2:2}${n:0:2}"; }

#convert disk_lbel to tiff file
convert_label () {
	local thelabel="$1"
	local thedest="$2"
	if [[ ! -f $thelabel ]]; then
		printf '# Disk label "%s" does not exist.\n' "$thelabel"
		return 1
	fi
	if [[ -z $thedest ]]; then
		thedest="$thelabel.tiff"
	fi

	local contents=""
	contents=$(xxd -p "$thelabel")
	local width=$((0x${contents:2:4}))
	local height=$((0x${contents:6:4}))
	echo "
	4949 2a00 1800 0000 d002 0000 0a00 0000 d002 0000 0a00 0000 0d00 fe00 0400 0100
	0000 0000 0000 0001 0400 0100 0000 $(le width) 0101 0400 0100 0000 $(le height) 0201
	0300 0100 0000 0800 0000 0301 0300 0100 0000 0100 0000 0601 0300 0100 0000 0000
	0000 1101 0400 0100 0000 ba00 0000 1501 0300 0100 0000 0100 0000 1601 0400 0100
	0000 $(le width) 1701 0400 0100 0000 $(le $((width * height))) 1a01 0500 0100 0000 0800 0000 1b01
	0500 0100 0000 1000 0000 2801 0300 0100 0000 0200 0000 0000 0000
	$(echo "${contents:10}" | xxd -p -r | LANG=C tr -C \
	'\0\366\367\52\370\371\125\372\373\200\374\375\253\376\377\326' '\0' | LANG=C tr \
	'\0\366\367\52\370\371\125\372\373\200\374\375\253\376\377\326' \
	'\0\021\042\63\104\125\146\167\210\231\252\273\314\335\356\377' | xxd -p)
	" | xxd -p -r > "$thedest"
}


# mount a partition
mountpartition() {
	local mounttype=$1
	local slice=$2
	local volume=$3
	local mountpoint=""
	mountpoint=$(mount | sed -n -E "/\/dev\/$slice on (.*) \(.*/s//\1/p")
	if [[ -n "$mountpoint" ]]; then
		echo -n "$mountpoint"
		return 0
	fi
	local i=0
	local startmountpoint="/Volumes/$volume"
	mountpoint="$startmountpoint"
	while ((1)); do
		sudo mkdir "$mountpoint" 2> /dev/null && break
		if ((i++ > 1000)); then
			echo "Could not create mountpoint" 1>&2
			return 1
		fi
		mountpoint="$startmountpoint$i"
	done
	sudo "mount$mounttype" "/dev/$slice" "$mountpoint" && echo -n "$mountpoint"
	return $?
}


makemultilinedisklabel () {
	if (( $# != 2 )); then
		echo "# error: not enough arguments" 1>&2
		echo "# usage: makemultilinedisklabel destinationpath disklabellines" 1>&2
		return 1
	fi
	local folder="$1"
	if [[ ! -d $folder ]]; then
		echo '# error: "'"$folder"' is not a folder' 1>&2
		echo "# usage: makemultilinedisklabel destinationpath disklabellines" 1>&2
		return 1
	fi
	local lines="$2"
	local alllines=""
	local alllines2x=""
	local tempfolder0=""
	local tempfolder=""
	tempfolder0="$(mktemp -d /tmp/makemultilinedisklabel.XXX)"
	# do the blessing on a temporary disk image so it doesn't do apfs stuff like copy the disk label to preboot of the current system
	tempfolder="$(hdiutil create -volname disklabeltmp -size 600k -fs HFS+ -attach "$tempfolder0/tmp.dmg" | perl -nE 'if (/\/dev\/disk[0-9]+s[0-9]+[^\t]*\tApple_HFS[^\t]*\t(.*)/) { print $1 }')"
	if [[ -z $tempfolder ]]; then
		echo "# error creating temporary disk image" 1>&2
		return 1
	fi
	if [[ ! -d $tempfolder ]]; then
		echo "# error getting temporary disk image mount point: $tempfolder" 1>&2
		return 1
	fi

	IFS=$'\n'
	local linenum=0
	local theline=""
	local theoneline=""
	for theline in $(echo "$lines"); do
		sudo bless --folder "$tempfolder" --label "$theline" 2> /dev/null
		if (( linenum )); then
			alllines+="$(dump_label "$tempfolder/.disk_label" | sed '1,/[^.]/ {/^[.]*$/d; }')"$'\n'
			alllines2x+="$(dump_label "$tempfolder/.disk_label_2x" | sed '1,/[^.]/ {/^[.]*$/d; }')"$'\n'
			theoneline+=" $theline"
		else
			alllines+="$(dump_label "$tempfolder/.disk_label")"$'\n'
			alllines2x+="$(dump_label "$tempfolder/.disk_label_2x")"$'\n'
			theoneline="$theline"
		fi
		((linenum++))
	done

	local suffix=""
	local thelines=""
	for suffix in "" "_2x"; do
		[[ -z $suffix ]] && thelines="$alllines" || thelines="$alllines2x"

		local linewidths=""
		local maxlinewidth=""
		linewidths="$(echo "${thelines}" | tr '0-9a-f' '.' | sort -ur)"
		maxlinewidth=$(echo "$linewidths" | sed -n '1p')
		linewidths=$(echo "$linewidths" | sed '1d')

		local centercommands=""
		local linewidth=""
		for linewidth in $(echo "$linewidths"); do
			local left=${maxlinewidth:0:(${#maxlinewidth}-${#linewidth})/4*2}
			local right=${maxlinewidth:0:(${#maxlinewidth}-${#linewidth}-${#left})}
			centercommands+="s/^(${linewidth})$/$left\1$right/; "
		done
		thelines=$(echo "$thelines" | sed -E "$centercommands s/\./0/g")
		printf "01%04x%04x$thelines" $((${#maxlinewidth} / 2)) "$(echo "$thelines" | wc -l)" | xxd -p -r > "$tempfolder/disk_label$suffix"
		
		# EFI file system converts schg flag to uchg flag, so we set both to no
		[[ -f "$folder/.disk_label$suffix" ]] && {
			sudo chflags noschg,nouchg "$folder/.disk_label$suffix"
		}
		sudo cp "$tempfolder/disk_label$suffix" "$folder/.disk_label$suffix"
		((dolockdisklabels)) && sudo chflags schg "$folder/.disk_label$suffix"
	done

	[[ -f "$folder/.disk_label.contentDetails" ]] && { 
		sudo chflags noschg,nouchg "$folder/.disk_label.contentDetails"
	}
	theoneline="${theoneline/🄳/ [D]}"
	theoneline="${theoneline/🄿/ [P]}"
	theoneline="${theoneline/🅁/ [R]}"
	theoneline="${theoneline/🄱/ [B]}"
	theoneline="${theoneline//  / }"
	printf "%s" "$theoneline" > "$tempfolder/disk_label.contentDetails"
	sudo cp "$tempfolder/disk_label.contentDetails" "$folder/.disk_label.contentDetails"
	((dolockdisklabels)) && sudo chflags schg "$folder/.disk_label.contentDetails"
	hdiutil detach -quiet "${tempfolder}"
}


unsetall () {
	local thevarprefix="$1" # prefix for variable names
	if [[ -n $thevarprefix ]]; then
		eval "$(set | LANG=C sed -nE '/^('"$1"'[^=]*)=.*/s//unset \1/p')"
	fi
}

patmatch () {
	# substitute for [[ =~ ]] for Mac OS X 10.4
	perl -0777 -ne '<>; exit !( $_ =~ /'"$1"'/ )'
}

fixapfsbooter () {
	# Use Catalina for best results.

	theoneapfsmountpoint="$1"
	theline1="$2"
	
	if [[ -z $theoneapfsmountpoint ]]; then
		echo "#Error: missing parameters"
		return 1
	fi

	if [[ -z $theline1 ]]; then
		echo "#Error: missing second parameter"
		return 1
	fi

	local diskutil_fab1_Error=""
	local diskutil_fab1_APFSContainerReference=""
	local diskutil_fab1_APFSVolumeGroupID=""
	local diskutil_fab1_MountPoint=""
	local diskutil_fab1_VolumeUUID=""
	getdiskinfo "$theoneapfsmountpoint" "diskutil_fab1_"
	if [[ -n $diskutil_fab1_Error ]]; then
		echo "# Error: $diskutil_fab1_Error"
		return 1
	fi
	
	mkdir -p /tmp/disklabeltemp

	local iconsource="$theoneapfsmountpoint/.VolumeIcon.icns"
	if [[ -f "$iconsource" ]]; then
		echo "# Got icon at $iconsource"
		if [[ -L "$iconsource" ]]; then
			echo "# Making icon not a sym link"
			cp -p "$iconsource" /tmp/disklabeltemp
			sudo rm "$iconsource"
			sudo cp -p /tmp/disklabeltemp/.VolumeIcon.icns "$iconsource"
		fi
	else
		echo "# Did not find icon at $iconsource"
	fi

	local Recovery_MountPoint=""
	
	local patAll="^(_|${diskutil_fab1_APFSVolumeGroupID}_System|${diskutil_fab1_APFSVolumeGroupID}_Data|_Preboot|_Recovery)="
	local patSys="^_="
	local patSys2="^${diskutil_fab1_APFSVolumeGroupID}_System="
	local patData="^${diskutil_fab1_APFSVolumeGroupID}_Data="
	local patPreboot="^_Preboot="
	local patRecovery="^_Recovery="

	local roles=""
	roles=$(getapfsroles "$diskutil_fab1_APFSContainerReference")

	local System_UUID=""
	if [[ -n $diskutil_fab1_APFSVolumeGroupID ]]; then
		echo "# APFS Volume Group is $diskutil_fab1_APFSVolumeGroupID"
		IFS=$'\n'
		for thedisk in $(echo "$roles"); do
			if patmatch "$patSys2" <<< "$thedisk"; then
				local thedevice="${thedisk#*=}"
				local diskutil_fabsys_VolumeUUID=""
				getdiskinfo "$thedevice" "diskutil_fabsys_"
				System_UUID="$diskutil_fabsys_VolumeUUID"
				echo "# System Volume UUID is $System_UUID"
			fi
		done
	else
		echo "# No APFS Volume Group"
	fi
	if [[ -z $System_UUID ]]; then
		System_UUID="$diskutil_fab1_VolumeUUID"
		echo "# Assuming System Volume UUID is $System_UUID"
	fi

	for thepass in 0 1; do
		IFS=$'\n'
		for thedisk in $(echo "$roles"); do
			if patmatch "$patAll" <<< "$thedisk" ; then
				echo "#================"
				echo "# Doing $thedisk, pass $(( thepass+1 ))"
		
				local thedevice="${thedisk#*=}"
				diskutil mount "$thedevice" > /dev/null 2>&1
				getdiskinfo "$thedevice" "diskutil_fab2_"
				if [[ -z "$diskutil_fab2_MountPoint" ]]; then
					echo "# Could not mount"
				else
					local issource=0
				
					if [[ "$diskutil_fab2_MountPoint" == "$diskutil_fab1_MountPoint" ]]; then
						issource=1
					fi
				
					local theletter=""
					local thedest=""

					if patmatch "$patSys" <<< "$thedisk"; then
						if ((issource)); then
							thedest="$diskutil_fab2_MountPoint/System/Library/CoreServices"
						fi
					elif patmatch "$patSys2" <<< "$thedisk"; then
						thedest="$diskutil_fab2_MountPoint/System/Library/CoreServices"
					elif patmatch "$patData" <<< "$thedisk"; then
						theletter="🄳"
						thedest="$diskutil_fab2_MountPoint/System/Library/CoreServices"
					elif patmatch "$patPreboot" <<< "$thedisk"; then
						theletter="🄿"
						thedest="$diskutil_fab2_MountPoint/$System_UUID/System/Library/CoreServices"
						if [[ ! -d $thedest ]]; then
							thedest="$diskutil_fab2_MountPoint/$diskutil_fab1_VolumeUUID/System/Library/CoreServices"
						fi
					elif patmatch "$patRecovery" <<< "$thedisk"; then
						theletter="🅁"
						thedest="$diskutil_fab2_MountPoint/$System_UUID"
						if [[ ! -d $thedest ]]; then
							thedest="$diskutil_fab2_MountPoint/$diskutil_fab1_VolumeUUID"
						fi
						Recovery_MountPoint="$diskutil_fab2_MountPoint"
					fi

					if ((thepass == 0)); then
						if ((issource)); then
							echo "# Skipping icon copy"
						elif [[ -f "$iconsource" ]]; then
							if [[ -L "$diskutil_fab2_MountPoint/.VolumeIcon.icns" ]]; then
								echo "# Removing icon sym link"
								sudo rm "$diskutil_fab2_MountPoint/.VolumeIcon.icns"
							fi
							echo "# Doing icon copy"
							sudo cp -p "$iconsource" "$diskutil_fab2_MountPoint" || echo "# Error copying icon"
						else
							echo "# No icon to copy"
						fi
					fi

					if [[ -d $thedest ]]; then
						echo "# Destination at $thedest"

						if ((thepass == 0)); then
							local version=""
							local theversionfile="$thedest/SystemVersion.plist"
							if [[ -f "$theversionfile" ]]; then
								version=$(/usr/libexec/PlistBuddy -c 'Print :ProductVersion' "$theversionfile")
							fi
	
							local theline2=""
							if [[ -n "$version" ]]; then
								theline2="${version}${theletter}"
							else
								theline2="${theletter}"
							fi
					
							makemultilinedisklabel "/tmp/disklabeltemp" "${theline1}"$'\n'"${theline2}"

							echo "# Setting the label to: [${theline1}][${theline2}]"
							sudo find "$thedest" -name '.disk_label*' -exec chflags noschg,nouchg {} \;
							sudo cp /tmp/disklabeltemp/.disk_label* "$thedest"
							((dolockdisklabels)) && sudo find "$thedest" -name '.disk_label*' -exec chflags schg {} \;
						else
							if [[ -f "$thedest/boot.efi" ]]; then
								echo "# Blessing $thedest/boot.efi"
								if ((usedirectbless)); then
									sudo "$directbless" --folder "$thedest" --file "$thedest/boot.efi"
								else
									if [[ -z $theletter ]]; then
										# Blessing the system volume will bless Preboot, so temporarily change it to Recovery
										# but first must change Recovery to none. This only works in Catalina
										diskutil apfs changeVolumeRole "$Recovery_MountPoint" clear || echo "# ERROR: Unexpected error attempting to change role of Recovery volume"
										diskutil apfs changeVolumeRole "$diskutil_fab2_MountPoint" R || echo "# ERROR: Retry this from a different macOS Catalina system"
									fi
									sudo bless --folder "$thedest" --file "$thedest/boot.efi"
									if [[ -z $theletter ]]; then
										diskutil apfs changeVolumeRole "$diskutil_fab2_MountPoint" clear || echo "# ERROR: Retry this from a different macOS Catalina system"
										diskutil apfs changeVolumeRole "$Recovery_MountPoint" R || echo "# ERROR: Unexpected error attempting to change role of Recovery volume"
									fi
								fi
							fi
						fi
					else
						echo "# Destination does not exist $thedest"
					fi
				fi # if mount
			fi # if the disk
		done # for thedisk
	done # for thepass
	echo "#================"
	echo "# Done!"
}

unlockapfsbooter () {
	# If you use fixapfsbooter to create disk labels for an APFS system, you should probably
	# use this to unlock the disk label files in case the installer doesn't like them.

	theoneapfsmountpoint="$1"
	
	if [[ -z $theoneapfsmountpoint ]]; then
		echo "#Error: missing parameters"
		return 1
	fi

	local diskutil_fab1_Error=""
	local diskutil_fab1_APFSContainerReference=""
	local diskutil_fab1_APFSVolumeGroupID=""
	local diskutil_fab1_MountPoint=""
	local diskutil_fab1_VolumeUUID=""
	getdiskinfo "$theoneapfsmountpoint" "diskutil_fab1_"
	if [[ -n $diskutil_fab1_Error ]]; then
		echo "# Error: $diskutil_fab1_Error"
		return 1
	fi
	
	local patAll="^(_|${diskutil_fab1_APFSVolumeGroupID}_System|${diskutil_fab1_APFSVolumeGroupID}_Data|_Preboot|_Recovery)="
	local patSys="^_="
	local patSys2="^${diskutil_fab1_APFSVolumeGroupID}_System="
	local patData="^${diskutil_fab1_APFSVolumeGroupID}_Data="
	local patPreboot="^_Preboot="
	local patRecovery="^_Recovery="
	
	local roles=""
	roles=$(getapfsroles "$diskutil_fab1_APFSContainerReference")

	local System_UUID=""
	if [[ -n $diskutil_fab1_APFSVolumeGroupID ]]; then
		echo "# APFS Volume Group is $diskutil_fab1_APFSVolumeGroupID"
		IFS=$'\n'
		for thedisk in $(echo "$roles"); do
			if patmatch "$patSys2" <<< "$thedisk"; then
				local thedevice="${thedisk#*=}"
				local diskutil_fabsys_VolumeUUID=""
				getdiskinfo "$thedevice" "diskutil_fabsys_"
				System_UUID="$diskutil_fabsys_VolumeUUID"
				echo "# System Volume UUID is $System_UUID"
			fi
		done
	else
		echo "# No APFS Volume Group"
	fi
	if [[ -z $System_UUID ]]; then
		System_UUID="$diskutil_fab1_VolumeUUID"
		echo "# Assuming System Volume UUID is $System_UUID"
	fi

	IFS=$'\n'
	for thedisk in $(echo "$roles"); do
		if patmatch "$patAll" <<< "$thedisk" ; then
			echo "#================"
			echo "# Doing $thedisk"
	
			local thedevice="${thedisk#*=}"
			diskutil mount "$thedevice" > /dev/null 2>&1
			getdiskinfo "$thedevice" "diskutil_fab2_"
			if [[ -z "$diskutil_fab2_MountPoint" ]]; then
				echo "# Could not mount"
			else
				local issource=0
			
				if [[ "$diskutil_fab2_MountPoint" == "$diskutil_fab1_MountPoint" ]]; then
					issource=1
				fi
			
				local thedest=""

				if patmatch "$patSys" <<< "$thedisk"; then
					if ((issource)); then
						thedest="$diskutil_fab2_MountPoint/System/Library/CoreServices"
					fi
				elif patmatch "$patSys2" <<< "$thedisk"; then
					thedest="$diskutil_fab2_MountPoint/System/Library/CoreServices"
				elif patmatch "$patData" <<< "$thedisk"; then
					thedest="$diskutil_fab2_MountPoint/System/Library/CoreServices"
				elif patmatch "$patPreboot" <<< "$thedisk"; then
					thedest="$diskutil_fab2_MountPoint/$System_UUID/System/Library/CoreServices"
					if [[ ! -d $thedest ]]; then
						thedest="$diskutil_fab2_MountPoint/$diskutil_fab1_VolumeUUID/System/Library/CoreServices"
					fi
				elif patmatch "$patRecovery" <<< "$thedisk"; then
					thedest="$diskutil_fab2_MountPoint/$System_UUID"
					if [[ ! -d $thedest ]]; then
						thedest="$diskutil_fab2_MountPoint/$diskutil_fab1_VolumeUUID"
					fi
				fi

				if [[ -d $thedest ]]; then
					echo "# Unlocking these files:"
					find "$thedest" -name '.disk_label*'
					sudo find "$thedest" -name '.disk_label*' -exec chflags noschg,nouchg {} \;
				else
					echo "# Destination does not exist $thedest"
				fi
			fi # if mount
		fi # if the disk
	done # for thedisk

	echo "#================"
	echo "# Done!"
}

getvolumeproperty () {
	local slice="$1"
	local property="$2"
	local duinfo=""
	duinfo="$(diskutil info -plist "$slice" 2> /dev/null)"
	eval "$(
		{
			for (( i=0 ; i < 2 ; i++ )); do
				if patmatch "Disk Utility Tool" <<< "$duinfo"; then
					diskutil info "$slice" | perl -ne 'while (<>) { if (/ +([^:]+): +"?(.*?)"?$/) { $name = $1; $value = $2; $name =~ s/ //g; print "\"" . $name . "\" => \"" . $value . "\"\n" } }'
					break
				else
					printf "%s" "$duinfo" | plutil -p - 2> /dev/null && break || duinfo="Disk Utility Tool"
				fi
			done 
		} | sed -nE '/^ *"'"$property"'" => (.*)/s//echo \1/p'
	)"
}


getvolumename () {
	getvolumeproperty "$1" "VolumeName"
}


mountEFIpartitions () {
	IFS=$'\n'
	local diskinfo=""
	for diskinfo in $(diskutil list | LANG=C sed -nE $'/^ *[0-9]+: +EFI (\xe2\x81\xa8)?(.*[^ \xa9])?(\xe2\x81\xa9)? +[0-9.]+ [^ ]?[Bi] +(disk[0-9]+s[0-9]+)$/''s//\2_\4/p'); do
		local slice="${diskinfo##*_}"
		local volume=""
		volume="$(getvolumename "$slice")"
		if [[ -z $volume ]]; then
			volume="EFI" # Mac OS X 10.4.11 doesn't load EFI volume name
		fi
		#echo mountpartition "_msdos" "$slice" "$volume"
		mountpartition "_msdos" "$slice" "$volume" > /dev/null
	done
}


mountRecoveryHDpartitions() {
	IFS=$'\n'
	for diskinfo in $(diskutil list | LANG=C sed -nE $'/^ *[0-9]+: +Apple_Boot (\xe2\x81\xa8)?(Recovery HD)(\xe2\x81\xa9)? +[0-9.]+ [^ ]?[Bi] +(disk[0-9]+s[0-9]+)$/''s//\2_\4/p'); do
		local slice="${diskinfo##*_}"
		local volume=""
		volume="$(getvolumename "$slice")"
		mountpartition "_hfs" "$slice" "$volume" > /dev/null
	done
}


mountRecoveryPartitions() {
	IFS=$'\n'
	for diskinfo in $(diskutil list | LANG=C sed -nE $'/^ *[0-9]+: +APFS Volume (\xe2\x81\xa8)?(Recovery)(\xe2\x81\xa9)? +[0-9.]+ [^ ]?[Bi] +(disk[0-9]+s[0-9]+)$/''s//\2_\4/p'); do
		local slice="${diskinfo##*_}"
		local volume=""
		volume="$(getvolumename "$slice")"
		mountpartition "_apfs" "$slice" "$volume" > /dev/null
	done
}


mountPrebootPartitions() {
	IFS=$'\n'
	for diskinfo in $(diskutil list | LANG=C sed -nE $'/^ *[0-9]+: +APFS Volume (\xe2\x81\xa8)?(Preboot)(\xe2\x81\xa9)? +[0-9.]+ [^ ]?[Bi] +(disk[0-9]+s[0-9]+)$/''s//\2_\4/p'); do
		local slice="${diskinfo##*_}"
		local volume=""
		volume="$(getvolumename "$slice")"
		mountpartition "_apfs" "$slice" "$volume" > /dev/null
	done
}


mounthfsimage () {
	# macOS doesn't support mounting HFS anymore. To get around that,
	# this command uses https://github.com/joevt/fusehfs.
	# Useful for mounting SheepShaver.app disk image.
	local theimage="$1"

	theresult=$(hdiutil attach "$theimage" -readonly -nomount -noverify -noautofsck -plist)
	if [[ -n $theresult ]]; then
		local device=""
		local volume_kind=""
		eval "$(
			plutil -convert json -o - - <<< "$theresult" | perl -e '
				use JSON::PP; my $f = decode_json (<>)->{"system-entities"};
				printf("device=\"%s\"\nvolume_kind=\"%s\"\n", $f->[0]->{"dev-entry"}, $f->[0]->{"volume-kind"})
			'
		)"
		if [[ -z $volume_kind ]] || [[ $volume_kind = "hfs" ]]; then
			local volume=""
			local slice="${device/\/dev\//}"
			volume="$(getvolumename "$slice")"
			mountpartition "_fusefs_hfs" "$slice" "$volume" # > /dev/null
		else
			echo "# unexpected volume kind '$volume_kind'"
		fi
	fi
}


getblessinfo () {
	local mountpoint="$1"
	local thevarprefix="$2"
	unsetall "$thevarprefix"
	eval "$(
		directbless -plist --info "$mountpoint" 2> /dev/null | plutil -convert json -o - - | perl -e '
			use JSON::PP; my $f = decode_json (<>)->{"Finder Info"};
			printf("'"$thevarprefix"'theblessfolder=\"%s\"\n'"$thevarprefix"'theblessfile=\"%s\"\n'"$thevarprefix"'theblessopen=\"%s\"\n", $f->[0]->{"Path"}, $f->[1]->{"Path"}, $f->[2]->{"Path"})
		' 2> /dev/null
	)"
}


dumpAllDiskLabels () {
	IFS=$'\n'
	for theslice in $(diskutil list | sed -nE '/.*(disk[0-9]+s[0-9]+)$/s//\1/p'); do
		#echo "$theslice"
		sudo diskutil mount "$theslice" > /dev/null 2>&1
		local diskutil_dadl_DeviceIdentifier=""
		getdiskinfo "$theslice" "diskutil_dadl_"
		if [[ -n "$diskutil_dadl_MountPoint" ]]; then
			echo "#==========="
			echo "$diskutil_dadl_DeviceIdentifier $diskutil_dadl_MountPoint"
			local theblessfolder=""
			local theblessfile=""
			local theblessopen=""
			getblessinfo "$diskutil_dadl_MountPoint"
			if [[ -n $theblessfile ]]; then
				theblessfolder="$(dirname "$theblessfile")"
			fi
		
			for thefolder in $( {
				find "$diskutil_dadl_MountPoint" -maxdepth 2 -name "boot.efi*" 2> /dev/null | sed -E '/\/boot.efi.*/s///'
				ls -d "$diskutil_dadl_MountPoint/System/Library/CoreServices"
				ls -d "$diskutil_dadl_MountPoint/"*"/System/Library/CoreServices"
				ls -d "$theblessfolder" "$diskutil_dadl_MountPoint/System/Library/CoreServices" "$diskutil_dadl_MountPoint/EFI/BOOT"
			} 2> /dev/null | sort -u ); do
				local version=""
				local theversionfile="$thefolder/SystemVersion.plist"
				if [[ -f "$theversionfile" ]]; then
					version=$(/usr/libexec/PlistBuddy -c 'Print :ProductVersion' "$theversionfile")
				fi
				echo "${thefolder} ($version)"
				[[ -f $thefolder/.disk_label.contentDetails ]] && echo "contentDetails: $(cat "$thefolder/.disk_label.contentDetails")" || echo "    missing .disk_label.contentDetails"
				[[ -f $thefolder/.disk_label_2x ]] && dump_label "$thefolder/.disk_label_2x" || echo "    missing .disk_label_2x"
				[[ -f $thefolder/.disk_label ]] && dump_label "$thefolder/.disk_label" || echo "    missing .disk_label"
			done
		fi
	done
}


makeLabelCommands () {
	# Partitions need to be mounted first.

	# Only includes Apple_HFS and Apple_Boot partitions.
	IFS=$'\n'
	local thefolder=""
	for diskinfo in $(diskutil list | LANG=C sed -nE $'/^ *[0-9]+: +Apple_[HFSBoot]* (\xe2\x81\xa8)?([^ ].*[^ \xa9])(\xe2\x81\xa9)? +[0-9.]+ [^ ]?[Bi] +(disk[0-9]+s[0-9]+)$/''s//\2_\4/p'); do
		local slice="${diskinfo##*_}"
		local volume=""
		volume="$(getvolumename "$slice")"
		local version=""
		local mountpoint=""
		mountpoint=$(mountpartition "_hfs" "$slice" "$volume")
		local theblessfolder=""
		local theblessfile=""
		local theblessopen=""
		getblessinfo "$mountpoint"
		if [[ -n $theblessfile ]]; then
			thefolder="$(dirname "$theblessfile")"
			if [[ "$thefolder" != /Volumes/*/System/Library/CoreServices ]]; then
				local theversionfile="$thefolder/SystemVersion.plist"
				if [[ -f "$theversionfile" ]]; then
					version=$(/usr/libexec/PlistBuddy -c 'Print :ProductVersion' "$theversionfile")
				fi
				printf 'makemultilinedisklabel "%s" "%s"$%c\\n%c"%s"\n' "$thefolder" "${volume/Recovery HD/Recovery}" "'" "'" "$version"
			fi
		fi
	done

	# Scan the usual places first
	IFS=$'\n'
	for thefolder in $({ find /Volumes/*/System/Library/CoreServices -maxdepth 0 || true ; find /Volumes/*/EFI/BOOT -maxdepth 0 || true ; } 2> /dev/null); do
		local volume=""
		local version=""
		volume="${thefolder/\/System\/Library\/CoreServices/}"
		volume="${volume/\/EFI\/BOOT/}"
		volume="$(getvolumename "$volume")"
		local theversionfile="$thefolder/SystemVersion.plist"
		if [[ -f "$theversionfile" ]]; then
			version=$(/usr/libexec/PlistBuddy -c 'Print :ProductVersion' "$theversionfile")
		fi
		printf 'makemultilinedisklabel "%s" "%s"$%c\\n%c"%s"\n' "$thefolder" "${volume/Recovery HD/Recovery}" "'" "'" "$version"
	done
}


clearOpenFoldersAll () {
	# Clear open folder list of hfs partitions (finderinfo[2] in bless --info).
	# If you have an HFS+ disk that has folders that open when you mount them (such as an installer), then this will stop that from happening.
	IFS=$'\n'
	clearOpenFolders $(getallhfsdisks)
}
	

clearOpenFolders () {
	while (($#)); do
		local slice="$1"
		shift
		local volume=""
		volume="$(getvolumename "$slice")"
		local mountpoint=""
		mountpoint=$(mountpartition "_hfs" "$slice" "$volume")
		echo "#$slice=$mountpoint,$volume ($version)"
		local theblessfolder=""
		local theblessfile=""
		local theblessopen=""
		getblessinfo "$mountpoint"
		if [[ -n $theblessopen ]]; then
			echo "Clearing open folder list"
			if [[ -n $theblessfolder ]]; then
				if [[ -n $theblessfile ]]; then
					sudo "$directbless" --folder "$theblessfolder" --file "$theblessfile"
				else
					sudo "$directbless" --folder "$theblessfolder"
				fi
			else
				if [[ -n $theblessfile ]]; then
					sudo "$directbless" --mount "$mountpoint" --file "$theblessfile" --openfolder ""
				else
					sudo "$directbless" --unbless "$mountpoint"
				fi
			fi
		fi
	done
}


getdiskinfo () {
	local thedisk="$1" # the disk you want info for (either a mountpoint like "/" or a device "disk0s1")
	local thevarprefix="$2" # prefix for variable names
	# note: if thevarprefix is empty then you should clear any variables you want to use from this result beforehand
	unsetall "$thevarprefix"
	eval "$(showdiskinfo "$thedisk" "$thevarprefix")"
}


showdiskinfo () {
	local thedisk="$1" # the disk you want info for (either a mountpoint like "/" or a device "disk0s1")
	local thevarprefix="$2" # prefix for variable names
	diskutil info -plist "$thedisk" 2> /dev/null | plutil -p - | perl -nE 'if (s/ *"([^"]+)" => "?(.*?)"?$/'"$thevarprefix"'\1=\2/) { s/"/\\"/g; s/([^=]+=)(.*)/\1"\2"/; print $_ }'
}


getapfsroles () {
	# $1 = the apfs container
	local patVolumeGroup="^(Data|System)="
	for theapfsvolume in $(
			diskutil apfs list -plist "$1" | plutil -convert json -o - - | perl -e '
				use JSON::PP; my $apfs = decode_json (<>);
				foreach my $volume (@{$apfs->{Containers}[0]{Volumes}}) {print $volume->{Roles}[0] . "=" . $volume->{DeviceIdentifier} . "\n";}
			'
		); do
		diskutil_role_APFSVolumeGroupID=""
		if patmatch "$patVolumeGroup" <<< "$theapfsvolume"; then
			getdiskinfo "${theapfsvolume#*=}" "diskutil_role_"
		fi
		echo "${diskutil_role_APFSVolumeGroupID}_${theapfsvolume}"
	done
}


setbootername () {
	local thedisk="$1"
	local NewBooterName="$2"

	local diskutil_sbn_Root_BooterDeviceIdentifier=""
	getdiskinfo "$thedisk" diskutil_sbn_Root_
	if [[ -n $diskutil_sbn_Root_BooterDeviceIdentifier ]]; then
		diskutil mount "$diskutil_sbn_Root_BooterDeviceIdentifier"
		local diskutil_sbn_Root_VolumeUUID=""
		local diskutil_sbn_Root_APFSVolumeGroupID=""
		getdiskinfo "$diskutil_sbn_Root_BooterDeviceIdentifier" "diskutil_sbn_Preboot_"
		if [[ -n $diskutil_sbn_Preboot_MountPoint ]]; then
			local theUUID=""
			if [[ -d $diskutil_sbn_Preboot_MountPoint/$diskutil_sbn_Root_VolumeUUID ]]; then
				theUUID=$diskutil_sbn_Root_VolumeUUID
				echo "using VolumeUUID"
			elif [[ -d $diskutil_sbn_Preboot_MountPoint/$diskutil_sbn_Root_APFSVolumeGroupID ]]; then
				theUUID=$diskutil_sbn_Root_APFSVolumeGroupID
				echo "using APFSVolumeGroupID"
			else
				echo "unknown UUID in booter"
				ls -l "$diskutil_sbn_Preboot_MountPoint"
				return 1
			fi
			local thefile="$diskutil_sbn_Preboot_MountPoint/$theUUID/System/Library/CoreServices/.disk_label.contentDetails"
			if [[ -f "$thefile" ]]; then
				echo "$thefile already exists: $(cat "$thefile")"
			else
				sudo bash -c "echo \"$NewBooterName\" > \"$thefile\""
				echo "$thefile is created"
			fi
		else
			echo "$diskutil_sbn_Root_BooterDeviceIdentifier is not mounted"
		fi
	else
		echo "No booter device"
	fi
}


doperlondisks () {
	local thefilter="$1"
	local theperl="$2"
	{
		if [[ -z $thefilter ]]; then
			diskutil list -plist
		else
			diskutil list -plist "$thefilter"
		fi
	} | plutil -convert json -o - - | perl -e '
		use JSON::PP; my $disks = decode_json (<>)->{AllDisksAndPartitions};
		foreach my $disk (@$disks) {
			foreach my $type ("APFSVolumes","Partitions") {
				foreach my $part (@{$disk->{$type}}) {
					'"$theperl"'
				}
			}
		}
	'
}


doperlonmounteddisks () {
	doperlondisks "$1" '
		if (exists $part->{MountPoint}) {
			'"$2"'
		}
	'
}


getallmounteddisks () {
	# not all disks are mounted at /Volumes so use diskutil to find them
	if [[ "$1" == "-d" ]]; then
		doperlonmounteddisks "" 'print $part->{DeviceIdentifier} . ":" . $part->{MountPoint} . "\n";'
	else
		doperlonmounteddisks "" 'print $part->{MountPoint} . "\n";'
	fi
}


getalldisks () {
	doperlondisks "$1" 'print $part->{DeviceIdentifier} . "\n";'
}


getallhfsdisks () {
	doperlondisks "$1" '
		if ($part->{Content} eq "Apple_HFS") {
			print $part->{DeviceIdentifier} . "\n";
		}
	'
}


getallefidisks () {
	doperlondisks "$1" '
		if ($part->{Content} eq "EFI") {
			print $part->{DeviceIdentifier} . "\n";
		}
	'
}


setfinderinfoflag () {
	local thepath="$1"
	local thechar="$2"
	local thebit="$3"
	local thevalue="$4"
	local thefinderinfo=""
	local newfinderinfo=""
	local thedescription=""
	thefinderinfo=$(xattr -px com.apple.FinderInfo "$thepath" 2> /dev/null | xxd -p -r | xxd -p -c 32)
	if [[ -z "$thefinderinfo" ]]; then
		thefinderinfo="0000000000000000000000000000000000000000000000000000000000000000"
		thedescription="nonexistant "
	fi
	newfinderinfo=${thefinderinfo:0:$thechar}$( printf "%x" $(( ${thefinderinfo:$thechar:1} & (~(1<<(thebit))) | (thevalue<<(thebit)) )) )${thefinderinfo:$((thechar+1))}
	if [[ "$newfinderinfo" != "$thefinderinfo" ]]; then
		echo "# modifying ${thedescription}FinderInfo $newfinderinfo $thepath"
		sudo xattr -wx com.apple.FinderInfo "$newfinderinfo" "$thepath"
	else
		echo "# unchanged ${thedescription}FinderInfo $newfinderinfo $thepath"
	fi	
}

getfinderinfoflag () {
	local thepath="$1"
	local thechar="$2"
	local thebit="$3"
	local thefinderinfo=""
	thefinderinfo=$(xattr -px com.apple.FinderInfo "$thepath" 2> /dev/null | xxd -p -r | xxd -p -c 32)
	echo $(( ( 0x0${thefinderinfo:$thechar:1} >> thebit ) & 1 ))
}

setfoldercustomicon () {
	# if the folder is a mount point then the icon should be in datafork of ".VolumeIcon.icns"
	# otherwise the icon should be in a icns resource in "Icon\n"
	setfinderinfoflag "$1" 17 2 1
}

isfileinvisible () {
	getfinderinfoflag "$1" 16 2
}

setfilevisible () {
	setfinderinfoflag "$1" 16 2 0
}

setfileinvisible () {
	setfinderinfoflag "$1" 16 2 1
}

fixcustomiconflagofallvolumes () {
	IFS=$'\n'
	for themount in $(getallmounteddisks); do
		if [[ -f "$themount/.VolumeIcon.icns" ]]; then
			setfoldercustomicon "$themount"
		fi
	done
}
