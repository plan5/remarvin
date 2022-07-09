#!/bin/bash
LOCAL="/home/root/.local"
CONFIG="/home/root/.config/remarkable"

function uninstall(){
chattr -R -i $LOCAL/share/remarkable $LOCAL/share/remarvin

if [[ -f $LOCAL/share/remarvin ]];
then
  rm -r $LOCAL/share/remarkable $LOCAL/share/remarvin
  mv $LOCAL/Profile-Main/* $LOCAL/share/ && \
  rm -r $LOCAL/Profile-Main
else
  echo "Remarvin doesn't seem to be set up."
fi
}

echo "This removal script is still to be tested properly. You may also run chattr -i on the share directory in $HOME/.local and remove it and move Profile-Main in its place."
read -p "Do you understand that you are about to make changes to your system that may lead to data loss or other unforeseen behavior and that you are doing this on your own responsibility? (y/N)" response
    case $response in
        [Yy]* ) uninstall break;;
        * ) echo "Goodbye.";exit 0;;
    esac

