#!/bin/bash

#export LD_PRELOAD=/opt/lib/librm2fb_client.so.1.0.1
CIPHER=/home/root/.local/share/remarkable-cipher
GOCRYPTFS=$(which gocryptfs)
LAUNCHER=xochitl
PATH=/home/root/go/bin:/opt/bin/go/bin:/opt/bin:/opt/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
PLAIN=/home/root/.local/share/remarkable
LOCAL="/home/root/.local"
CONFIG="/home/root/.config/remarkable"
PAGECOUNT=0
export LAUNCHER=xochitl
export MESSAGEA=" "
export MESSAGEB=" "
set -o noglob

# Simple Application Script Functions
reset(){
  SCENE=("@fontsize 40")
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

# Auxiliary Functions
function buttonpress(){
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
       scene_addprofile
       ;;
    "Quit")
       exit 0
       ;;
    "Unmount")
       clean_environment
       ;;
    "More Profiles")
        [[ $PAGECOUNT < $(( $PAGECOUNT / 4 + 1)) ]] &&\
               PAGECOUNT=$(( $PAGECOUNT + 1 )) ||\
               PAGECOUNT=0
       ;;
    *)
       echo Any key pressed
       return true
       ;;
  esac
  set -f
}
function ui_scroller(){
        argnum = $#
        print_profiles $@
        for i in ${@:$PAGECOUNT:4}
          do
            ui button 150 next 800 150 $(basename $i)
          done
        if [[ $argnum > 4 ]]
        then
            ui button 150 next 800 150 More Profiles
        fi
}

# Scenes
function scene_addprofile(){
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
  set +f
  ui_scroller $LOCAL/Profile-*
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
function scene_warning(){
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
function scene_decrypt(){
        reset
        add justify left

        # Add Input field
        ui label 50 160 1300 100 Enter password above, then press \'done\'
        ui label 50 next 1300 100 $MESSAGEA
        ui textinput 50 50 1300 100

        display
        password_decrypt
}

# Initial Setup functions and scenes
function scene_setup(){
  reset
  add justify left 
  ui label  150 150  800 150 reMarvin
  ui label 150 next 800 150 
  ui label 150 next 800 150  "Welcome!"
  ui label 150 next 800 150 
  ui label 150 next 800 150  "reMarvin has not been set up yet.
  ui label 150 next 800 150 
  ui label 150 next 800 150  "ATTENTION: This Code is not well tested."
  ui label 150 next 800 150 
  ui label 150 next 800 150  "It should work but make sure to have a backup of"
  ui label 150 next 800 150  "/home/root outside the device, e.g. using scp."
  ui label 150 next 800 150  
  ui label 150 next 800 150  "DO NOT USE THIS IF YOU ARE REGISTERED TO THE CLOUD!"
  ui label 150 next 800 150  "Currently, the user configuration remains the same across"
  ui label 150 next 800 150  "profiles. This will mess with cloud synchronization."
  ui label 150 next 800 150 
  ui label 150 next 800 150  "This will restructure your home directory."
  ui label 150 next 800 150  "Run remarvin_remove.sh to undo."
  ui label 150 next 800 150 
  ui label 150 next 800 150  "Do you want to run the setup"?
  ui label 150 next 800 150 
  ui button 150 next 800 150  "Yes"
  ui label 150 next 800 150 
  ui button 150 next 800 150  "No"

  display
  buttonpress
  [[ ${RESULT} == "Yes" ]] && confirm_prepare || exit 0
}
function confirm_prepare(){
  reset
  add justify left
  ui label  150 150  800 150 reMarvin
  ui label 150 next 800 150 "Do you understand that you are about to make changes to your"
  ui label 150 next 800 150 "system that may lead to data loss or other unforeseen behavior and that"
  ui label 150 next 800 150 "you are doing this on your own responsibility?"
  ui label 150 next 800 150 
  ui button 150 next 800 150  "Yes"
  ui label 150 next 800 150 
  ui button 150 next 800 150  "No, abort!"
  display
  buttonpress
  [[ ${RESULT} == "Yes" ]] && setup_profiles || exit 0
}
function prepare_abort(){
	echo "Goodbye."
}
function setup_profiles(){
    systemctl stop xochitl
    pgrep xochitl|xargs kill -9
    
    cd "$LOCAL"

    # In the future, the config file will be per-profile
    # This needs to be thoroughly tested first.
    #mv "$CONFIG/xochitl.conf" "share/"
    #ln "$LOCAL/share/xochitl.conf" "$CONFIG/xochitl.conf"
    
    mkdir Profile-Main && mv share/remarkable Profile-Main||exit 1
    mkdir -p share/remarkable/xochitl

    # This should add a warning file but isn't working right now.
    #touch ./share/xochitl/readonly.metadata
    #echo '{\
    #"deleted": false,\
    #"lastModified": "1657376536026",\
    #"lastOpened": "1657376049165",\
    #"lastOpenedPage": 0,\
    #"metadatamodified": false,\
    #"modified": true,\
    #"parent": "",\
    #"pinned": false,\
    #"synced": false,\
    #"type": "DocumentType",\
    #"version": 0,\
    #"visibleName": "Warning: Read Only"\
    #}' > ./share/xochitl/readonly.metadata

    echo "This directory was set up for multiple profiles using remarvin.\n\
    Run remarvin_remove.sh to undo" > share/remarvin

    # Set immutable attribute to placeholder files in mountpoint
    chattr -R +i share/remarkable share/remarvin
    
}

# Mounting and decryption functions
function clean_environment(){
        #Stop xochitl and unmount share
        systemctl stop xochitl
	pgrep xochitl|xargs kill -9
        umount /home/root/.local/share/remarkable
        umount /home/root/.local/share
}
function check_mountpoint(){
	pgrep xochitl ||\
        mount | grep /home/root/.local/share 
}
function run_gocryptfs_checks(){
  # Check if gocryptfs is in PATH
  which $GOCRYPTFS||return 1
  # Check if fusermount in PATH 
  which fusermount||return 1
  # Check if the mountpoint is empty
  [[ -z $(ls $MOUNTPOINT) ]]||return 1 
  # All good? Return 0
  return 0
}
function password_decrypt(){
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


# Delay start a little to avoid display glitch
echo ""|simple
sleep 1

# If reMarvin is not yet set up, run setup function.
[[ -f /home/root/.local/share/remarvin ]] || scene_setup

# If profile is already mounted, ask to unmount
check_mountpoint && scene_ask_reset && clean_environment 

# Check if marker file exists to know everything is right, then run main loop. Else print out warning.
if [[ -f /home/root/.local/share/remarvin ]];
	then 
		scene_main
	else
		scene_warning
fi
