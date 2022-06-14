#!/bin/sh

#  Codec-Info.command
#  
#
#  Created by Rodion Shingarev on 03/03/15.
#
# User Defined
Native="0x11d4198b"

# if HDEF
HDEF=$(ioreg -rw 0 -p IODeviceTree -n HDEF | grep -o "HDEF@")
if [ ${HDEF:0:5} == "HDEF@" ]
then
HDEF=$(ioreg -rw 0 -p IODeviceTree -n HDEF | awk '{ print $2 }' )
echo $HDEF
else
echo "ERROR: No HDEF Device found in DSDT"
exit 1
fi

VendorID=($(ioreg -rxn IOHDACodecDevice | grep VendorID | awk '{ print $4 }' ))
RevisionID=($(ioreg -rxn IOHDACodecDevice | grep RevisionID | awk '{ print $4 }'))
CodecAddress=($(ioreg -rxn IOHDACodecDevice | grep IOHDACodecAddress | awk '{ print $4 }'))
PinConfigurations=$(ioreg -rw 0 -p IODeviceTree -n HDEF | grep PinConfigurations | awk '{ print $3 }' | sed -e 's/.*<//' -e 's/>//')
layout_id=$(ioreg -rw 0 -p IODeviceTree -n HDEF | grep layout-id | sed -e 's/.*<//' -e 's/>//')
layout_id="0x${layout_id:6:2}${layout_id:4:2}${layout_id:2:2}${layout_id:0:2}"
let Layout=$layout_id
echo "Layout, hex:" $layout_id ", dec:" $Layout
echo
echo "PinConfigurations:"
#$PinConfigurations=0000004010401101f0111141f01111412090a091219081022f3081011f402102f011114103c64540f0111141
N=${#VendorID[@]}
echo
echo "Codecs Found:" $N
N=$(($N-1))
for i in $(seq 0 $N)
do
if [[ ${VendorID[$i]} == *"1002"* ]] || [[ ${VendorID[$i]} == *"10de"* ]] || [[ ${VendorID[$i]} == *"8086"* ]]
then
echo "HDMI:"
HDAU=$i
let CodecID=${VendorID[$HDAU]}
echo $HDAU "CodecAddress:"${CodecAddress[$HDAU]}
echo "VendorID:" ${VendorID[$HDAU]}
echo "RevisionID:" ${RevisionID[$HDAU]}
echo "CodecID:" $CodecID
echo
else
echo "HDA:"
HDEF=$i
let CodecID=${VendorID[$HDEF]}
echo $HDEF "CodecAddress:"${CodecAddress[$HDEF]}
echo "VendorID:" ${VendorID[$HDEF]}
echo "RevisionID:" ${RevisionID[$HDEF]}
echo "CodecID:" $CodecID
var1=${VendorID[$HDEF]}
let Revisiond=${RevisionID[$HDEF]}
echo "Revision(dec):"=$Revisiond
id="0x${var1:6:4}"
ven="0x${var1:2:4}"
echo "Id="$id
let idd=${id}
echo "Id(dec)="$idd
echo "Vendor="$ven
let vend=${ven}
echo "Vendor(dec)="$vend
echo

rm -rf ~/Desktop/Info.plist
rm -rf Patch.plist

Patch=${VendorID[$HDEF]}
PathMapID=${VendorID[$HDEF]}
PathMapID=${PathMapID:6:4}
PathMapID=$(echo $PathMapID | sed 's/^0*//')
PathMapID="${PathMapID/198b/1988}"
PathMapID="${PathMapID/989b/1989}"

/usr/libexec/PlistBuddy -c "Add :Author string  $(whoami)"  ~/Desktop/Info.plist
#/usr/libexec/PlistBuddy -c "Set :Author $(whoami)"  ~/Desktop/Info.plist
/usr/libexec/PlistBuddy -c "Add :CodecName string ${VendorID[$HDEF]} Rev:${RevisionID[$HDEF]}"  ~/Desktop/Info.plist
#/usr/libexec/PlistBuddy -c "Set :CodecName ${VendorID[$HDEF]} Rev:${RevisionID[$HDEF]}"  ~/Desktop/Info.plist
/usr/libexec/PlistBuddy -c "Add :CodecID integer $idd"  ~/Desktop/Info.plist
#/usr/libexec/PlistBuddy -c "Set :CodecID $idd"  ~/Desktop/Info.plist
/usr/libexec/PlistBuddy -c "Add :Files dict"  ~/Desktop/Info.plist
/usr/libexec/PlistBuddy -c "Add :Files:Layouts array"  ~/Desktop/Info.plist
/usr/libexec/PlistBuddy -c "Add :Files:Layouts:0 dict"  ~/Desktop/Info.plist
/usr/libexec/PlistBuddy -c "Add :Files:Layouts:0:Id integer $Layout"  ~/Desktop/Info.plist
#/usr/libexec/PlistBuddy -c "Set :Files:Layouts:0:Id $Layout"  ~/Desktop/Info.plist
/usr/libexec/PlistBuddy -c "Add :Files:Layouts:0:Path string layout$Layout.xml.zlib"  ~/Desktop/Info.plist
#/usr/libexec/PlistBuddy -c "Set :Files:Layouts:0:Path layout$Layout.xml.zlib"  ~/Desktop/Info.plist
/usr/libexec/PlistBuddy -c "Add :Files:Platforms array"  ~/Desktop/Info.plist
/usr/libexec/PlistBuddy -c "Add :Files:Platforms:0 dict"  ~/Desktop/Info.plist
/usr/libexec/PlistBuddy -c "Add :Files:Platforms:0:Id integer $Layout"  ~/Desktop/Info.plist
#/usr/libexec/PlistBuddy -c "Set :Files:Platforms:0:Id $Layout"  ~/Desktop/Info.plist
/usr/libexec/PlistBuddy -c "Add :Files:Platforms:0:Path string Platforms.xml.zlib"  ~/Desktop/Info.plist
#/usr/libexec/PlistBuddy -c "Set :Files:Platforms:0:Path Platforms.xml.zlib"  ~/Desktop/Info.plist
/usr/libexec/PlistBuddy -c "Add :Revisions array"  ~/Desktop/Info.plist
/usr/libexec/PlistBuddy -c "Add :Revisions:0 integer $Revisiond"  ~/Desktop/Info.plist
#/usr/libexec/PlistBuddy -c "Set :Revisions:0 $Revisiond"  ~/Desktop/Info.plist
/usr/libexec/PlistBuddy -c "Add :Patches array"  ~/Desktop/Info.plist
#/usr/libexec/PlistBuddy -c "Add :PinConfigurations string $PinConfigurations"  ~/Desktop/PinConfig.plist

N=0

/usr/libexec/PlistBuddy -c "Add :Patches:$N dict"  ~/Desktop/Info.plist
defaults write ~/Patch.plist Find -data 8319D411
defaults write ~/Patch.plist Replace -data 00000000
defaults write ~/Patch.plist Name -string "AppleHDA"
defaults write ~/Patch.plist MinKernel -int 15
defaults write ~/Patch.plist Count -int 2
/usr/libexec/PlistBuddy -c "Merge Patch.plist :Patches:$N" ~/Desktop/Info.plist

if [ $Patch != "0x10ec0885" ] && [ $Patch != "0x11d4198b" ] && [ $Patch != "0x11d41984" ] && [ $Patch != $Native ]
then
N=$N+1
Patch=${Patch:8:2}${Patch:6:2}${Patch:4:2}${Patch:2:2}
Native=${Native:8:2}${Native:6:2}${Native:4:2}${Native:2:2}
defaults write ~/Patch.plist Find -data $Native
defaults write ~/Patch.plist Replace -data $Patch
defaults write ~/Patch.plist MinKernel -int 13
/usr/libexec/PlistBuddy -c "Add :Patches:$N dict"  ~/Desktop/Info.plist
/usr/libexec/PlistBuddy -c "Merge Patch.plist :Patches:$N" ~/Desktop/Info.plist
fi

if  (( $PathMapID < 885 ))
then
N=$N+1
defaults write ~/Patch.plist Find -data 8408ec10
defaults write ~/Patch.plist Replace -data 00000000
defaults write ~/Patch.plist MinKernel -int 13
/usr/libexec/PlistBuddy -c "Add :Patches:$N dict"  ~/Desktop/Info.plist
/usr/libexec/PlistBuddy -c "Merge Patch.plist :Patches:$N" ~/Desktop/Info.plist
N=$N+1
defaults write ~/Patch.plist Find -data 8508ec10
defaults write ~/Patch.plist Replace -data 00000000
defaults write ~/Patch.plist MinKernel -int 13
/usr/libexec/PlistBuddy -c "Add :Patches:$N dict"  ~/Desktop/Info.plist
/usr/libexec/PlistBuddy -c "Merge Patch.plist :Patches:$N" ~/Desktop/Info.plist
fi

N=$N+1
defaults write ~/Patch.plist Find -data 41c6864301000000
defaults write ~/Patch.plist Replace -data 41c6864301000001
defaults write ~/Patch.plist MinKernel -int 13
defaults write ~/Patch.plist Count -int 1
/usr/libexec/PlistBuddy -c "Add :Patches:$N dict"  ~/Desktop/Info.plist
/usr/libexec/PlistBuddy -c "Merge Patch.plist :Patches:$N" ~/Desktop/Info.plist
N=$N+1
defaults write ~/Patch.plist Find -data 41c60600488bbb68
defaults write ~/Patch.plist Replace -data 41c60601488bbb68
defaults write ~/Patch.plist MinKernel -int 14
defaults write ~/Patch.plist Count -int 1
/usr/libexec/PlistBuddy -c "Add :Patches:$N dict"  ~/Desktop/Info.plist
/usr/libexec/PlistBuddy -c "Merge Patch.plist :Patches:$N" ~/Desktop/Info.plist
N=$N+1
defaults write ~/Patch.plist Find -data 41c60600498bbc24
defaults write ~/Patch.plist Replace -data 41c60601498bbc24
defaults write ~/Patch.plist MinKernel -int 13
defaults write ~/Patch.plist MaxKernel -int 13
defaults write ~/Patch.plist Count -int 1
/usr/libexec/PlistBuddy -c "Add :Patches:$N dict"  ~/Desktop/Info.plist
/usr/libexec/PlistBuddy -c "Merge Patch.plist :Patches:$N" ~/Desktop/Info.plist

rm -rf Patch.plist

/usr/libexec/PlistBuddy -c "Add :Vendor string"  ~/Desktop/Info.plist
/usr/libexec/PlistBuddy -c "Set :Vendor Unknown"  ~/Desktop/Info.plist
case $vend in
"4098")
/usr/libexec/PlistBuddy -c "Set :Vendor AMD"  ~/Desktop/Info.plist
;;
"4564")
/usr/libexec/PlistBuddy -c "Set :Vendor AnalogDevices"  ~/Desktop/Info.plist
;;
"4115")
/usr/libexec/PlistBuddy -c "Set :Vendor CirrusLogic"  ~/Desktop/Info.plist
;;
"5361")
/usr/libexec/PlistBuddy -c "Set :Vendor Conexant"  ~/Desktop/Info.plist
;;
"4354")
/usr/libexec/PlistBuddy -c "Set :Vendor Creative"  ~/Desktop/Info.plist
;;
"4381")
/usr/libexec/PlistBuddy -c "Set :Vendor IDT"  ~/Desktop/Info.plist
;;
"32902")
/usr/libexec/PlistBuddy -c "Set :Vendor Intel"  ~/Desktop/Info.plist
;;
"4318")
/usr/libexec/PlistBuddy -c "Set :Vendor NVIDIA"  ~/Desktop/Info.plist
;;
"4332")
/usr/libexec/PlistBuddy -c "Set :Vendor Realtek"  ~/Desktop/Info.plist
;;
"4358")
/usr/libexec/PlistBuddy -c "Set :Vendor VIA"  ~/Desktop/Info.plist
;;

esac


fi
done


m=${#PinConfigurations}
m=$((m / 8))
m=$((m - 1))

for i in $(seq 0 $m)
do
n=8*$i
Pin=${PinConfigurations:$n:8}
case ${Pin:4:1} in
"0")
Device="Line Out"
;;
"1")
Device="Speaker"
;;
"2")
Device="HP Out"
;;
"3")
Device="CD\t"
;;
"4")
Device="SPDIF Out"
;;
"5")
Device="Digital Other Out"
;;
"6")
Device="Modem Line Side"
;;
"7")
Device="Modem Handset Side"
;;
"8")
Device="Line In"
;;
"9")
Device="AUX"
;;
"a")
Device="Mic In"
;;
"b")
Device="Telephony"
;;
"c")
Device="SPDIF In"
;;
"d")
Device="Digital Other In"
;;
"e")
Device="Reserved"
;;
"f")
Device="Other"
;;
"")
Device="N.A."
;;
*)
Device="Other"
;;
esac

case ${Pin:2:1} in
"0")
Color="Unknown"
;;
"1")
Color="Black"
;;
"2")
Color="Grey"
;;
"3")
Color="Blue"
;;
"4")
Color="Green"
;;
"5")
Color="Red"
;;
"6")
Color="Orange"
;;
"7")
Color="Yellow"
;;
"8")
Color="Purple"
;;
"9")
Color="Pink"
;;
"e")
Color="White"
;;
"f")
Color="Other"
;;
*)
Color="Reserved"
;;
esac

case ${Pin:7:1} in
"0")
Location="N/A"
;;
"1")
Location="Rear"
;;
"2")
Location="Front"
;;
"3")
Location="Left"
;;
"4")
Location="Right"
;;
"5")
Location="Top"
;;
"6")
Location="Bottom"
;;
"7")
Location="Special"
;;
"8")
Location="Special"
;;
"9")
Location="Special"
;;
*)
Location="Reserved"
;;
esac

case ${Pin:5:1} in
"0")
Connector="Unknown\t"
;;
"1")
Connector="1/8\"\t "
;;
"2")
Connector="1/4\"\t "
;;
"3")
Connector="ATAPI internal"
;;
"4")
Connector="RCA\t"
;;
"5")
Connector="Optical\t"
;;
"6")
Connector="Other Digital"
;;
"7")
Connector="Other Analog"
;;
"8")
Connector="Multichannel Analog (DIN)"
;;
"9")
Connector="XLR/Professional"
;;
"a")
Connector="RJ-11 (Modem)"
;;
"b")
Connector="Combination"
;;
"f")
Connector="Other\t"
;;
esac

case ${Pin:6:1} in
"0")
Port="Jack\t"
;;
"1")
Port="No Conn."
;;
"2")
Port="Fixed Func."
;;
*)
Port="Int.& Jack"
;;
esac
case ${Pin:3:1} in
"0")
Misc="0"
;;
*)
Misc="1"
;;
esac
echo  "$Pin $Color\t$Misc $Device\t$Connector\t$Port\t$Location"
#/usr/libexec/PlistBuddy -c "Add :$Pin string $Color$Device$Location"  ~/Desktop/PinConfig.plist


#ConfigData
#Address = "0"
#Nid_Spk = "S1"
#Nid_Mic = "M1"
#Nid_LnIn = "M2"
#
#echo "S1 is speaker node (hex), ex: 14, M1 and M2 are Mic nodes ex 18 or 19"



#Rear Pink
if [[ ${Pin:7:1} == "1" ]] && [[ ${Pin:2:1} == "9" ]]
then
ConfigData=$Address$Nid_Mic"71e"${Pin:4:1}"0 "$Address$Nid_Mic"71f9"${Pin:7:1}" "$ConfigData
fi

#Front Pink
if [[ ${Pin:7:1} == "2" ]] && [[ ${Pin:2:1} == "9" ]]
then
ConfigData=$Address$Nid_LnIn"71e8"${Pin:5:1}" "$ConfigData
fi

#Rear Green >> Speaker
if [[ ${Pin:7:1} == "1" ]] && [[ ${Pin:2:1} == "4" ]]
then
ConfigData=$Address$Nid_Spk"71e1"${Pin:5:1}" "$ConfigData
fi


# Test : NoteBook Mic #25
#if  [[ ${Pin:7:1} != "2" ]]  && [[ ${Pin:4:1} == "a" ]] && [[ ${Pin:2:1} != "9" ]] # Connector Other Analog Mic >> Unknown
#then
#ConfigData=$Address$Nid_Mic"71c"${Pin:0:2}$Address$Nid_Mic"71d"${Pin:2:2}$Address$Nid_Mic"71e"${Pin:4:1}"0"$Address$Nid_Mic"71f9"${Pin:7:1}" "$ConfigData
#fi

##  Mic Right Black >> Line In #24
#if [[ ${Pin:4:1} == "a" ]] && [[ ${Pin:7:1} == "4" ]] && [[ ${Pin:2:1} == "1" ]]
#then
#ConfigData=$Address$Nid_LnIn"71c"${Pin:0:2}$Address$Nid_LnIn"71d"${Pin:2:2}$Address$Nid_LnIn"71e8"${Pin:5:1}$Address$Nid_LnIn"71f"${Pin:6:2}$ConfigData
#fi




done




