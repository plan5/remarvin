#!/bin/bash

export LD_PRELOAD=/opt/lib/librm2fb_client.so.1.0.1

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
  button="$(echo "${RESULT}" | sed 's/^selected:\s*//; s/\s* -.*$//' | xargs)"
  case $button in
    "Profile 1")
       umount /home/root/.local/share; mount --bind /home/root/.local/share-1 /home/root/.local/share
       ;;
    "Profile 2")
       umount /home/root/.local/share; mount --bind /home/root/.local/share-2 /home/root/.local/share
       ;;
    "xochitl")
       systemctl start xochitl;
       exit 0
       ;;
    "Decrypt")
       nohup /home/root/simple-scripts/gocryptfs.sh;
       ;;
    "*")
       return true
       ;;
  esac
}

run_checks(){
return true
}


function decrypt(){
	echo "$password"|nohup $GOCRYPTFS $CIPHER $PLAIN||password="Mount failed!"
}


while :;do
  reset
  add justify left

  ui button 150 150  800 150 Profile 1
  ui button 150 next 800 150 Profile 2
  ui button 150 next 800 150 xochitl
  ui button 150 next 800 150 Decrypt

  display
  buttonpress
done
