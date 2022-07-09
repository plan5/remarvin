#!/bin/bash

#export LD_PRELOAD=/opt/lib/librm2fb_client.so.1.0.1
CIPHER=/home/root/.local/share/remarkable-cipher
GOCRYPTFS=$(which gocryptfs)
LAUNCHER=xochitl
PATH=/home/root/go/bin:/opt/bin/go/bin:/opt/bin:/opt/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
PLAIN=/home/root/.local/share/remarkable
export LAUNCHER=xochitl
export MESSAGEA=" "
export MESSAGEB=" "
set -o noglob

reset(){
  SCENE=("@fontsize 58")
}

add(){
  SCENE+=("@$*")
}

ui(){
  SCENE+=("$*")
}

display(){
  IFS=$(echo -en "\n\b")
  script=$(for line in ${SCENE[@]}; do echo $line; done)
  IFS=" "
  RESULT=$(echo ${script} | /opt/bin/simple)
}

run_checks(){
  # Check if gocryptfs is in PATH
  which $GOCRYPTFS||return 1
  # Check if fusermount in PATH 
  which fusermount||return 1
  # Check if the mountpoint is empty
  [[ -z $(ls $MOUNTPOINT) ]]||return 1 
  # All good? Return 0
  return 0
}

buttonpress(){
  echo button pressed
  button="$(echo "${RESULT}" | sed 's/^selected:\s*//; s/\s* -.*$//' | xargs)"
  set +f
  case $button in
    "Profile-"*)
       echo Profile Button pressed
       umount /home/root/.local/share; mount --bind /home/root/.local/$button /home/root/.local/share
       if [[ -e /home/root/.local/share/remarkable-cipher ]] 
		then
			#systemctl start gocryptfs-gui.service
			#/opt/bin/gocryptfs-gui.sh
			echo "Profile appears to be encrypted"
			export MESSAGEA="Profile appears to be encrypted."
			export MESSAGEB="You should decrypt before\nstarting xochitl."
		else
			echo "Profile appears not to be encrypted."
			export MESSAGEA="Profile appears not to be encrypted."
			export MESSAGEB="You may launch xochitl now."
       fi
       ;;
    "$LAUNCHER")
       systemctl start $LAUNCHER;
       exit 0
       ;;
    "Decrypt")
       scene_decrypt
       ;;
    "Add Profile")
       add_profile
       ;;
    "Quit")
       exit 0
       ;;
    "Unmount")
       clean_environment
       ;;
    *)
       echo Any key pressed
       return true
       ;;
  esac
  set -f
}

function add_profile(){
  reset
  add justify left
  ui label  150 150  800 150 reMarvin - Add Profile
  ui label  150 next  800 150 Please enter Name for new Profile
  ui textinput  150 next  800 150 
  display
  buttonpress
  NEWNAME="$(echo "${RESULT}" | awk -F ": " '{print $3}')"
  mkdir /home/root/.local/Profile-$NEWNAME
}

function scene_main(){
while :;do
  reset
  add justify left

  ui label  150 150  800 150 reMarvin
  # Enable globs (Wildcards)
  set +f
  for i in /home/root/.local/Profile-*
    do
      ui button 150 next 800 150 $(basename $i)
    done
  # Disable globs (Wildcards)
  set -f
  #ui button 150 next 800 150 $LAUNCHER
  ui button 150 next 800 150 "Add Profile"
  ui button 150 next 800 150 $([ -d /home/root/.local/share/remarkable-cipher ] && echo -n Decrypt)
  ui button 150 next 800 150 Quit
  ui label 150 next 800 150 $MESSAGEA
  ui label 150 next 800 150 $MESSAGEB

  display
  buttonpress
done
}

function warning(){
  reset
  add justify left

  ui label 50 150 800 150 reMarvin has not been set up properly
  ui label 50 next 800 150 or you have already mounted a profile.  
  ui label 50 next 800 150 Please refer to 
  ui label 50 next 800 150 https://github.com/plan5/remarvin/README.md 
  ui button 150 next 800 150 Quit

  display
  buttonpress
}

function clean_environment(){
        #Stop xochitl and unmount share
        systemctl stop xochitl
	pgrep xochitl|xargs kill -9
        umount /home/root/.local/share/remarkable
        umount /home/root/.local/share
}

function scene_ask_reset(){
        reset
        add justify left

        ui label  150 150  800 150 reMarvin
        ui label 150 next 800 150 "A profile is already mounted"
        ui label 150 next 800 150 "or xochitl might be running."
        ui label 150 next 800 150 "Shall we unmount all profiles and end"
        ui label 150 next 800 150 "all xochitl instances?"
        ui button 150 next 800 150 "Unmount"
        ui button 150 next 800 150 "Ignore"
        ui button 150 next 800 150 "Quit"

        display
        buttonpress
}

function check_mountpoint(){
	pgrep xochitl ||\
        mount | grep /home/root/.local/share 
}

evaluate(){
  #id="$(echo "${RESULT}" | awk -F ": " '{print $2}')"
  message="$(echo "${RESULT}" | awk -F ": " '{print $3}')"
  export password="${message}"
  decrypt && return 0 || return 1
}

function decrypt(){
	echo "$password"|nohup $GOCRYPTFS $CIPHER $PLAIN && export MESSAGEA="Successfully decrypted!"&&return 0
	export MESSAGEA="Error decrypting!"
	return 1
}

function scene_decrypt(){
        reset
        add justify left

        # Add Input field
        ui label 50 160 1300 100 Enter password above, then press \'done\'
        ui label 50 next 1300 100 $MESSAGEA
        ui textinput 50 50 1300 100

        display
        evaluate
}

# Delay start a little to avoid display glitch
echo ""|simple
sleep 1

# If profile is already mounted, ask to unmount
check_mountpoint && scene_ask_reset && clean_environment 

# Check if marker file exists to know everything is right, then run main loop. Else print out warning.
if [[ -f /home/root/.local/share/remarvin ]];
	then 
		scene_main
	else
		warning
fi
