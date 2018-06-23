YT Silent Subscription
=======================

The purpose of this mini toy project is to check a list of YouTube channels for new videos,
 and alert the user if any videos have been posted since the last check.   
This is useful if you want to frequently monitor a channel without logging into youtube and without telling youtube you subscribed to it.

Requirements
--------------

 - This software only works on GNU/Linux running a GNOME desktop. e.g. Ubuntu or Linux Mint.
 - The "playnow" option assumes you have Firefox installed.

Installing
----------

 1. Download the two script files and put them somewhere, eg in your user's Documents folder. Make sure you have changed their permissions to be executable.

 2. Create a new watch list folder which will contain your favourite channels list and some temporary files.
     e.g. I made mine called `~/Documents/ytwatch`

 3. In the watch list folder, create a text file which lists the youtube channel names that you want to monitor, one per line.
    The file *must* be called `silentsubscription.txt` .   
    Each text line is just the channel name, not the URL. You can see the channel name in the YouTube url of your web browser.    
    For example, if you click a Videos link on a channel and the address is `https://www.youtube.com/user/thang010146/videos`
    that means the channel name is thang010146

 4. You can now run the command `silentroundup.sh <watchlistfolder>` and all your channels of interest will be checked.    
    e.g. : `silentroundup.sh ~/Documents/ytwatch`   
    You will immediately receive a desktop notification message if there are new videos, and it contains a hyperlink to youtube to watch the latest video. You will have to browse the videos list to find any more videos if there is more than one new video.  

 5. You can then run that file automatically after a short delay when you log on by adding it to your desktop managers startup commands. For example in Ubuntu and Linux Mint you can go to the Startup Applications menu and add a new item which runs the above command line with the right parameters after a 60 second delay.

Now you are silently subscribed!

Of course if you want the channel owner to get more revenue, you will have to log in to YouTube and subscribe to their channel properly.

Optionally, for slightly extra convenience you can create a shell script which runs silentroundup with your custom folder 
    as the only parameter. For example it might look like this:
    `#!/bin/sh`
    `# Check all my silent subscriptions.` 
    `./silentroundup.sh ~/Documents/ytwatch`    
    You could call this "myroundup.sh" and this file can go anywhere. Remember to make it executable.

If you want the latest video to be played automatically in firefox as soon as it is detected, you have to edit the `silentroundup.sh` and add the "-playnow" option to the end of the `$exefolder/ytusernews.sh` command. The script does not do this automatically because for any more than one or two channels it would become quite annoying to have them all open up at a rapid fire pace. This feature is best used on a single channel of interest with the ytusernews.sh script.

That's all, folks.
