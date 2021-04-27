#!/bin/bash

LOCAL="/home/root/.local"
CONFIG="/home/root/.config/remarkable"

echo "This will restructure your home directory."
echo "You will have to rename $LOCAL/share-1 into $LOCAL/share"
echo "if you want to use bare xochitl again."
echo "Also your $CONFIG/xochitl.conf will be replaced by a symlink to $LOCAL/share"
echo "To revert to the original state, move $LOCAL/share/xochitl.conf to $CONFIG, replacing the symlink."

read -p "Do you understand that you are about to make changes to your system that may lead to data loss or other unforeseen behavior and that you are doing this on your own responsibility? (y/N)" response
read -p "Do you wish to install this program?" yn
    case $response in
        [Yy]* ) dont_wreak_havoc(); break;;
        * ) echo "Please answer yes or no.";;
    esac

function dont_wreak_havoc(){
    echo "This script is still under revision. Adapt line 15 to make it run."
    echo "Especially, it will cause separate xochitl.conf files to be created, potentially locking you out from ssh because a new root password will be generated."
}

function wreak_havoc(){
    systemctl stop xochitl
    
    cd "$LOCAL"
    mv "$CONFIG/xochitl.conf" "share/"
    ln "$LOCAL/share/xochitl.conf" "$CONFIG/xochitl.conf"
    
    mv "share" "share-1"
    mkdir "share" "share-2" "share-3"
    chattr +i share
    
    systemctl enable remarvin.service --now
}
