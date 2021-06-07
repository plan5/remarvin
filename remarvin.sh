#!/bin/bash

#export LD_PRELOAD=/opt/lib/librm2fb_client.so.1.0.1

export LAUNCHER=xochitl

set -o noglob

reset(){
  SCENE=("@fontsize 64")
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

buttonpress(){
  echo button pressed
  button="$(echo "${RESULT}" | sed 's/^selected:\s*//; s/\s* -.*$//' | xargs)"
  set +f
  case $button in
    "Profile-"*)
       echo Profile Button pressed
       umount /home/root/.local/share; mount --bind /home/root/.local/$button /home/root/.local/share
       ;;
    "$LAUNCHER")
       systemctl start $LAUNCHER;
       exit 0
       ;;
    "Decrypt")
       systemctl start gocryptfs-gui.service;
       #/home/root/simple-scripts/gocryptfs.sh
       exit 0
       ;;
    *)
       echo Any key pressed
       return true
       ;;
  esac
  set -f
}

run_checks(){
return true
}


function decrypt(){
	echo "$password"|nohup $GOCRYPTFS $CIPHER $PLAIN||password="Mount failed!"
}

function mainloop(){
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
  ui button 150 next 800 150 $LAUNCHER
  ui button 150 next 800 150 Decrypt

  display
  buttonpress
done
}

#Delay start a little to avoid display glitch
echo ""|simple
sleep 1

mainloop

