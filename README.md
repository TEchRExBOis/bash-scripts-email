# bash-scripts-email
This repo consist of scripts that will run ./watcher as nohup ./watcher.sh &
this will keep an eye on email folder ~/Maildir/new whenever new file is created it will trigger script.sh
script.sh will check if that file name exist in ../processfile if yes then it will proceed further else not thats function help not to repeat and read email again fro same file
this script.sh triggers post_command.sh it will get the whole email dir and then get attachement and context from that dir created new dir for attachement and body html encode them and forward it to another script filechecker.sh script
that filechecker.sh script will check all png and pdf files inside dir and if present it willl get all files encode them and push to post request.

We have one more function in watcher.sh that will lock the file state and cannot run the script again if its already been running so to unlock you might need to remove /tmp/temp_lock.


PRE-REQ: install

jq
postfix
s-nail
ripmime
