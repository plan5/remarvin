#!/bin/bash
LOCAL="/home/root/.local"
CONFIG="/home/root/.config/remarkable"


chattr -R -i $LOCAL/share/remarkable $LOCAL/share/remarvin

if [[ -f $LOCAL/share/remarvin ]];
  rm -r $LOCAL/share/remarkable $LOCAL/share/remarvin
else
  echo "Remarvin doesn't seem to be set up."
fi
