#!/bin/bash
if [[ $# -lt 2 ]] || [[ "$1" == '--help' ]]
then
  echo "Command syntax: ytusernews.sh <UserId> <backupdir> [-playnow]"
  exit
fi
exitStatus=0
ytuser=$1
userfolder=$2
playnow=0
if [[ "$3" == '-playnow' ]]
then
  playnow=1
fi

ytsite='https://www.youtube.com'
vidsURL=${ytsite}'/user/'${ytuser}'/videos'

# Set paths for working files.
newvidlinks=${userfolder}/new_to_view.html
vidsRecentNow=${userfolder}/${ytuser}-now.html
vidsRecentPre=${userfolder}/${ytuser}-previous.html
vidsNewNow=${userfolder}/${ytuser}-new.html
statusFile=${userfolder}/${ytuser}-status.txt

#get recent videos
curl "${vidsURL}" | grep -P -o '<h3.+<a class="yt-uix-sessionlink.+</h3>' | sed -r -e 's/^.*(title="[^"]+").*(href="[^"]+").*accessible-description.+>([^<]+).+$/<a \2 > \1 <\/a> \3 <br>/' >"${vidsRecentNow}"

# find 'watch' links which are new.
if [[ -f "${vidsRecentPre}" ]] && [[ -s "${vidsRecentNow}" ]]
then
	rm -f "${vidsNewNow}"
	diff "${vidsRecentPre}" "${vidsRecentNow}" | grep -P -o --regexp='^> .+' | grep -P -o --regexp='<[ha].+' >"${vidsNewNow}"

	# Only do more work if there was a new link detected.
	if [[ -s "${vidsNewNow}" ]]
	then
		exitStatus=1
		latestNewURL=${ytsite}$(cat "${vidsNewNow}" | grep -P -o --regexp='/watch[^"]+' | head -1 )
		latestNewTitle=$(cat "${vidsNewNow}" | grep -P -o --regexp='title="[^"]+"' | sed -r -e 's/^.*(title=")([^"]+)".*$/\2/' | head -1 )
		echo $latestNewURL ":"  ${latestNewTitle}
		echo $(date) "New videos found." >"$statusFile"

		# Log new links to common file.
		echo '--DIFF--' ${ytuser} $(date) '<br/>' >>${newvidlinks}
		# Make relative watch links into absolute URL.
		ytrep=$(echo $ytsite | sed -r -e 's/\//\\\//g' )
		cat "${vidsNewNow}" | sed -r -e "s/\"\/watch/\""${ytrep}"\/watch/"  >>${newvidlinks}

		# Store current video list as previous list for comparison at next check.
		rm -f "${vidsRecentPre}"
		mv "${vidsRecentNow}" "${vidsRecentPre}"
		
		#Notify user with a GNOME desktop utility.
		notify-send -u low "New videos by ${ytuser}" "Latest: '${latestNewTitle}' \n ${latestNewURL}"

		if [[ $playnow -gt 0 ]]
		then
			firefox --new-window "${latestNewURL}"
		fi
	else
		rm -f "${vidsNewNow}"
		echo $(date) "No change detected." >"$statusFile"
	fi
else
	echo $(date) "Could not download." >"$statusFile"
fi
# cleanup
rm -f "${vidsRecentNow}"
exit $exitStatus
