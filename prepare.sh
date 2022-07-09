#!/bin/bash

LOCAL="/home/root/.local"
CONFIG="/home/root/.config/remarkable"

function abort(){
	echo "Goodbye."
}

function setup(){
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

echo "ATTENTION: This Code is not well tested."
echo
echo "It should work but make sure to have a backup of"
echo "/home/root outside the device, e.g. using scp."
echo 
echo "DO NOT USE THIS IF YOU ARE REGISTERED TO THE CLOUD!"
echo "Currently, the user configuration remains the same across"
echo "profiles. This will mess with cloud synchronization."
echo
echo "This will restructure your home directory."
echo "Run remarvin_remove.sh to undo."
#echo "Also your $CONFIG/xochitl.conf will be replaced by a symlink to $LOCAL/share"
#echo "To revert to the original state, move $LOCAL/share/xochitl.conf to $CONFIG, replacing the symlink."

read -p "Do you understand that you are about to make changes to your system that may lead to data loss or other unforeseen behavior and that you are doing this on your own responsibility? (y/N)" response
    case $response in
        [Yy]* ) setup;;
        * ) abort; exit 0;;
    esac



