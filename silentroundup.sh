#!/bin/bash
if [[ $# -lt 1 ]] || [[ "$1" == '--help' ]]
then
	echo "silentroundup.sh <usersfolder>"
fi
exefolder=$(dirname $0)
userfolder=$1

subscriptions=$userfolder/silentsubscription.txt
declare -a subs
subs=( $(cat "$subscriptions") )
total=0
changeCount=0
for x in ${subs[@]}
do	echo Checking $x
	$exefolder/ytusernews.sh "$x" "$userfolder"
	if [[ $? -gt 0 ]]
	then
	  changeCount=$(( changeCount + 1 ))
	fi
	total=$(( $total + 1 ))
done

report="Checked $total user subscriptions.\n Found ${changeCount} users had new videos."
notify-send -u low "Silent subscription roundup." "${report}"

